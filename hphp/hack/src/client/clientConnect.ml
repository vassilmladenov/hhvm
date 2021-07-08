(*
 * Copyright (c) 2015, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

open Hh_prelude

let log ?tracker ?connection_log_id s =
  let id =
    match tracker with
    | Some tracker -> Some (Connection_tracker.log_id tracker)
    | None -> connection_log_id
  in
  match id with
  | Some id -> Hh_logger.log ("[%s] [client-connect] " ^^ s) id
  | None -> Hh_logger.log ("[client-connect] " ^^ s)

type env = {
  root: Path.t;
  from: string;
  local_config: ServerLocalConfig.t;
  autostart: bool;
  force_dormant_start: bool;
  deadline: float option;
  no_load: bool;
  watchman_debug_logging: bool;
  log_inference_constraints: bool;
  profile_log: bool;
  remote: bool;
  ai_mode: string option;
  progress_callback: (string option -> unit) option;
  do_post_handoff_handshake: bool;
  ignore_hh_version: bool;
  save_64bit: string option;
  saved_state_ignore_hhconfig: bool;
  mini_state: string option;
  use_priority_pipe: bool;
  prechecked: bool option;
  config: (string * string) list;
  custom_telemetry_data: (string * string) list;
  allow_non_opt_build: bool;
}

type conn = {
  connection_log_id: string;
  t_connected_to_monitor: float;
  t_received_hello: float;
  t_sent_connection_type: float;
  channels: Timeout.in_channel * Out_channel.t;
  server_specific_files: ServerCommandTypes.server_specific_files;
  conn_progress_callback: (string option -> unit) option;
  conn_root: Path.t;
  conn_deadline: float option;
  from: string;
}

let get_finale_data (server_finale_file : string) : Exit.finale_data option =
  try
    let ic = Stdlib.open_in_bin server_finale_file in
    let contents : Exit.finale_data = Marshal.from_channel ic in
    Stdlib.close_in ic;
    Some contents
  with _ -> None

let tty_progress_reporter () =
  let angery_reaccs_only =
    Tty.supports_emoji () && ClientMessages.angery_reaccs_only ()
  in
  fun (status : string option) ->
    ( if Tty.spinner_used () then Tty.print_clear_line stderr;
      match status with
      | None -> ()
      | Some s ->
        Tty.eprintf
          "hh_server is busy: %s %s%!"
          s
          (Tty.spinner ~angery_reaccs_only ())
      : unit )

(** What is the latest progress message written by the server into a file?
We store this in a mutable variable, so we can know whether it's changed and hence whether
to display the warning banner. *)
let latest_server_progress : ServerCommandTypes.server_progress ref =
  ref
    ServerCommandTypes.
      {
        server_progress = "connecting";
        server_warning = None;
        server_timestamp = 0.;
      }

(** This reads from the progress file and assigns into mutable variable "latest_status_progress",
and returns whether there was new status. *)
let check_progress ~(server_progress_file : string) : bool =
  let open ServerCommandTypes in
  let server_progress =
    ServerCommandTypesUtils.read_progress_file ~server_progress_file
  in
  if
    not
      (Float.equal
         server_progress.server_timestamp
         !latest_server_progress.server_timestamp)
  then begin
    log
      "check_progress: [%s] %s / %s"
      (Utils.timestring server_progress.server_timestamp)
      server_progress.server_progress
      (Option.value server_progress.server_warning ~default:"[none]");
    latest_server_progress := server_progress;
    true
  end else
    false

let show_progress
    (progress_callback : string option -> unit) ~(server_progress_file : string)
    : unit =
  let open ServerCommandTypes in
  let had_warning = Option.is_some !latest_server_progress.server_warning in
  let (_any_changes : bool) = check_progress ~server_progress_file in
  if not had_warning then
    Option.iter
      !latest_server_progress.server_warning
      ~f:(Printf.eprintf "\n%s\n%!");
  let progress = !latest_server_progress.server_progress in
  let final_suffix =
    if Option.is_some !latest_server_progress.server_warning then
      " - this can take a long time, see warning above]"
    else
      "]"
  in
  (* We always show progress, even if there were no changes, just so the user
  can see the spinner keep turning around. It looks better that way for things
  like "loading saved-state" which would otherwise look stuck for 30s. *)
  progress_callback (Some ("[" ^ progress ^ final_suffix));
  ()

let check_for_deadline deadline_opt =
  let now = Unix.time () in
  match deadline_opt with
  | Some deadline when Float.(now > deadline) ->
    log
      "check_for_deadline expired: %s > %s"
      (Utils.timestring now)
      (Utils.timestring deadline);
    Printf.eprintf "\nError: hh_client hit timeout, giving up!\n%!";
    raise Exit_status.(Exit_with Out_of_time)
  | _ -> ()

(** Sleeps until the server sends a message. While waiting, prints out spinner
    and progress information using the argument callback. *)
let rec wait_for_server_message
    ~(connection_log_id : string)
    ~(expected_message : 'a ServerCommandTypes.message_type option)
    ~(ic : Timeout.in_channel)
    ~(deadline : float option)
    ~(server_specific_files : ServerCommandTypes.server_specific_files)
    ~(progress_callback : (string option -> unit) option)
    ~(root : Path.t) : _ ServerCommandTypes.message_type Lwt.t =
  let server_progress_file =
    server_specific_files.ServerCommandTypes.server_progress_file
  in
  check_for_deadline deadline;
  let%lwt (readable, _, _) =
    Lwt_utils.select
      [Timeout.descr_of_in_channel ic]
      []
      [Timeout.descr_of_in_channel ic]
      1.0
  in
  if List.is_empty readable then (
    Option.iter progress_callback ~f:(show_progress ~server_progress_file);
    wait_for_server_message
      ~connection_log_id
      ~expected_message
      ~ic
      ~deadline
      ~server_specific_files
      ~progress_callback
      ~root
  ) else
    (* an inline module to define this exception type, used internally in the function *)
    let module M = struct
      exception Monitor_failed_to_handoff
    end in
    try%lwt
      let fd = Timeout.descr_of_in_channel ic in
      let msg : 'a ServerCommandTypes.message_type =
        Marshal_tools.from_fd_with_preamble fd
      in
      let (is_ping, is_handoff_failed) =
        match msg with
        | ServerCommandTypes.Ping -> (true, false)
        | ServerCommandTypes.Monitor_failed_to_handoff -> (false, true)
        | _ -> (false, false)
      in
      let matches_expected =
        Option.value_map ~default:true ~f:(Poly.( = ) msg) expected_message
      in
      if is_handoff_failed then
        raise M.Monitor_failed_to_handoff
      else if matches_expected && not is_ping then (
        log
          ~connection_log_id
          "wait_for_server_message: got expected %s"
          (ServerCommandTypesUtils.debug_describe_message_type msg);
        Option.iter progress_callback ~f:(fun callback -> callback None);
        Lwt.return msg
      ) else (
        log
          ~connection_log_id
          "wait_for_server_message: didn't want %s"
          (ServerCommandTypesUtils.debug_describe_message_type msg);
        if not is_ping then
          Option.iter progress_callback ~f:(show_progress ~server_progress_file);
        wait_for_server_message
          ~connection_log_id
          ~expected_message
          ~ic
          ~deadline
          ~server_specific_files
          ~progress_callback
          ~root
      )
    with
    | (End_of_file | Sys_error _ | M.Monitor_failed_to_handoff) as exn ->
      let e = Exception.wrap exn in
      let finale_data =
        get_finale_data
          server_specific_files.ServerCommandTypes.server_finale_file
      in
      let client_exn = Exception.get_ctor_string e in
      let client_stack =
        e |> Exception.get_backtrace_string |> Exception.clean_stack
      in
      (* log to logfile *)
      log
        ~connection_log_id
        "SERVER_HUNG_UP [%s]\nfinale_data: %s\n%s"
        client_exn
        (Option.value_map
           finale_data
           ~f:Exit.show_finale_data
           ~default:"[none]")
        client_stack;
      (* stderr *)
      let msg =
        match (exn, finale_data) with
        | (M.Monitor_failed_to_handoff, None) -> "Hack server is too busy."
        | (_, None) ->
          "Hack server disconnected suddenly. It might have crashed."
        | (_, Some finale_data) ->
          Printf.sprintf
            "Hack server disconnected suddenly [%s]\n%s"
            (Exit_status.show finale_data.Exit.exit_status)
            (Option.value ~default:"" finale_data.Exit.msg)
      in
      Printf.eprintf "%s\n" msg;
      (* spinner *)
      Option.iter progress_callback ~f:(fun callback -> callback None);
      (* exception, caught by hh_client.ml and logged.
      In most cases we report that find_hh.sh should simply retry the failed command.
      There are only two cases where we say it shouldn't. *)
      let underlying_exit_status =
        Option.map finale_data ~f:(fun d -> d.Exit.exit_status)
      in
      let external_exit_status =
        match underlying_exit_status with
        | Some
            Exit_status.(
              Failed_to_load_should_abort | Server_non_opt_build_mode) ->
          Exit_status.Server_hung_up_should_abort
        | _ -> Exit_status.Server_hung_up_should_retry
      in
      (* log to telemetry *)
      HackEventLogger.server_hung_up
        ~external_exit_status
        ~underlying_exit_status
        ~client_exn
        ~client_stack
        ~server_stack:
          (Option.map
             finale_data
             ~f:(fun { Exit.stack = Utils.Callstack stack; _ } -> stack))
        ~server_msg:(Option.bind finale_data ~f:(fun d -> d.Exit.msg));
      raise (Exit_status.Exit_with external_exit_status)

let wait_for_server_hello
    (connection_log_id : string)
    (ic : Timeout.in_channel)
    (deadline : float option)
    (server_specific_files : ServerCommandTypes.server_specific_files)
    (progress_callback : (string option -> unit) option)
    (root : Path.t) : unit Lwt.t =
  let%lwt (_ : 'a ServerCommandTypes.message_type) =
    wait_for_server_message
      ~connection_log_id
      ~expected_message:(Some ServerCommandTypes.Hello)
      ~ic
      ~deadline
      ~server_specific_files
      ~progress_callback
      ~root
  in
  Lwt.return_unit

let rec connect ?(allow_macos_hack = true) (env : env) (start_time : float) :
    conn Lwt.t =
  check_for_deadline env.deadline;
  let handoff_options =
    {
      MonitorRpc.force_dormant_start = env.force_dormant_start;
      pipe_name =
        HhServerMonitorConfig.pipe_type_to_string
          ( if env.force_dormant_start then
            HhServerMonitorConfig.Force_dormant_start_only
          else if env.use_priority_pipe then
            HhServerMonitorConfig.Priority
          else
            HhServerMonitorConfig.Default );
    }
  in
  let tracker = Connection_tracker.create () in
  let connection_log_id = Connection_tracker.log_id tracker in
  (* We'll attempt to connect, with timeout up to [env.deadline]. Effectively, the
  unix process list will be where we store our (unbounded) queue of incoming client requests,
  each of them waiting for the monitor's incoming socket to become available; if there's a backlog
  in the monitor->server pipe and the monitor's incoming queue is full, then the monitor's incoming
  socket will become only available after the server has finished a request, and the monitor gets to
  send its next handoff, and take the next item off its incoming queue.
  If the deadline is infinite, I arbitrarily picked 60s as the timeout coupled with "will retry..."
  if it timed out. That's because I distrust infinite timeouts, just in case something got stuck for
  unknown causes, and maybe retrying the connection attempt will get it unstuck? -- a sort of
  "try turning it off then on again". This timeout must be comfortably longer than the monitor's
  own 30s timeout in serverMonitor.hand_off_client_connection_wrapper to handoff to the server;
  if it were shorter, then the monitor's incoming queue would be entirely full of requests that
  were all stale by the time it got to handle them. *)
  let timeout =
    match
      (env.local_config.ServerLocalConfig.monitor_backpressure, env.deadline)
    with
    | (false, _) -> 1
    | (true, None) -> 60
    | (true, Some deadline) ->
      Int.max 1 (int_of_float (deadline -. Unix.gettimeofday ()))
  in
  log
    ~connection_log_id
    "ClientConnect.connect: attempting MonitorConnection.connect_once (%ds)"
    timeout;
  let conn =
    MonitorConnection.connect_once ~tracker ~timeout env.root handoff_options
  in
  let t_connected_to_monitor = Unix.gettimeofday () in
  match conn with
  | Ok (ic, oc, server_specific_files) ->
    log
      ~connection_log_id
      "ClientConnect.connect: successfully connected to monitor.";
    let%lwt () =
      if env.do_post_handoff_handshake then
        wait_for_server_hello
          connection_log_id
          ic
          env.deadline
          server_specific_files
          env.progress_callback
          env.root
      else
        Lwt.return_unit
    in
    let t_received_hello = Unix.gettimeofday () in
    let threshold = 2.0 in
    if
      Sys_utils.is_apple_os ()
      && allow_macos_hack
      && Float.(Unix.gettimeofday () -. t_connected_to_monitor > threshold)
    then (
      (*
        HACK: on MacOS, re-establish the connection if it took a long time
        during the initial attempt.

        The MacOS implementation of the server monitor does not appear to make a
        graceful handoff of the client connection to the server main process.
        If, after the handoff, the monitor closes its connection fd before the
        server main attempts any reads, the server main's connection will go
        stale for reads (i.e., reading will generate an EOF). This is the case
        if the server needs to run a long typecheck phase before communication
        with the client, e.g. for cold starts.

        For shorter startup times, ServerMonitor.Sent_fds_collector attempts to
        compensate for this issue by having the monitor wait a few seconds after
        handoff before attempting to close its connection fd.

        For longer startup times, a sufficient (if not exactly clean) workaround
        is simply to have the client re-establish a connection.
      *)
      Printf.eprintf
        "Server connection took over %.1f seconds. Refreshing...\n"
        threshold;
      (try Timeout.shutdown_connection ic with _ -> ());
      Timeout.close_in_noerr ic;
      Stdlib.close_out_noerr oc;

      (* allow_macos_hack:false is a defensive measure against infinite connection loops *)
      connect ~allow_macos_hack:false env start_time
    ) else
      Lwt.return
        {
          connection_log_id = Connection_tracker.log_id tracker;
          t_connected_to_monitor;
          t_received_hello;
          t_sent_connection_type = 0.;
          (* placeholder, until we actually send it *)
          channels = (ic, oc);
          server_specific_files;
          conn_progress_callback = env.progress_callback;
          conn_root = env.root;
          conn_deadline = env.deadline;
          from = env.from;
        }
  | Error e ->
    (match e with
    | ServerMonitorUtils.(
        Connect_to_monitor_failure
          {
            server_exists = true;
            failure_phase = Connect_open_socket;
            failure_reason = Connect_timeout;
          })
      when not env.local_config.ServerLocalConfig.monitor_backpressure ->
      (* If server+monitor are too busy, this is manifest either as timeouts
      during Connect_open_socket (this case) or receiving SERVER_HUNG_UP in
      [wait_for_server_message] above. Arbitrarily, we fail fatally in this
      first case, but we fail with Exit_status.Server_hung_up_should_retry in
      the second case above causing find_hh.sh to reattempt after exponential
      backoff. See discussion in T85425990. *)
      Printf.eprintf
        "\nError: Hh_server is overloaded with too many concurrent requests. Giving up.\n%!";
      raise Exit_status.(Exit_with Monitor_connection_failure)
    | ServerMonitorUtils.Server_died
    | ServerMonitorUtils.(
        Connect_to_monitor_failure { server_exists = true; _ }) ->
      log ~tracker "connect: no response yet from server; will retry...";
      Unix.sleepf 0.1;
      connect env start_time
    | ServerMonitorUtils.(
        Connect_to_monitor_failure { server_exists = false; _ }) ->
      log ~tracker "connect: autostart=%b" env.autostart;
      if env.autostart then (
        let {
          root;
          from;
          local_config = _;
          autostart = _;
          force_dormant_start = _;
          deadline = _;
          no_load;
          watchman_debug_logging;
          log_inference_constraints;
          profile_log;
          remote = _;
          ai_mode;
          progress_callback = _;
          do_post_handoff_handshake = _;
          ignore_hh_version;
          save_64bit;
          saved_state_ignore_hhconfig;
          use_priority_pipe = _;
          prechecked;
          mini_state;
          config;
          custom_telemetry_data;
          allow_non_opt_build;
        } =
          env
        in
        HackEventLogger.client_connect_autostart ();
        ClientStart.(
          start_server
            {
              root;
              from;
              no_load;
              watchman_debug_logging;
              log_inference_constraints;
              profile_log;
              silent = false;
              exit_on_failure = false;
              ai_mode;
              debug_port = None;
              ignore_hh_version;
              save_64bit;
              saved_state_ignore_hhconfig;
              dynamic_view = false;
              prechecked;
              mini_state;
              config;
              custom_telemetry_data;
              allow_non_opt_build;
            });
        connect env start_time
      ) else (
        Printf.eprintf
          ( "Error: no hh_server running. Either start hh_server"
          ^^ " yourself or run hh_client without --autostart-server false\n%!"
          );
        raise Exit_status.(Exit_with No_server_running_should_retry)
      )
    | ServerMonitorUtils.Server_dormant_out_of_retries ->
      Printf.eprintf
        ( "Ran out of retries while waiting for Mercurial to finish rebase. Starting "
        ^^ "the server in the middle of rebase is strongly not recommended and you should "
        ^^ "first finish the rebase before retrying. If you really "
        ^^ "know what you're doing, maybe try --force-dormant-start\n%!" );
      raise Exit_status.(Exit_with Out_of_retries)
    | ServerMonitorUtils.Server_dormant ->
      Printf.eprintf
        ( "Error: No server running and connection limit reached for waiting"
        ^^ " on next server to be started. Please wait patiently. If you really"
        ^^ " know what you're doing, maybe try --force-dormant-start\n%!" );
      raise Exit_status.(Exit_with No_server_running_should_retry)
    | ServerMonitorUtils.Build_id_mismatched mismatch_info_opt ->
      ServerMonitorUtils.(
        Printf.eprintf
          "hh_server's version doesn't match the client's, so it will exit.\n";
        begin
          match mismatch_info_opt with
          | None -> ()
          | Some mismatch_info ->
            let secs =
              int_of_float
                (Unix.gettimeofday () -. mismatch_info.existing_launch_time)
            in
            let time =
              if secs > 86400 then
                Printf.sprintf "%n days" (secs / 86400)
              else if secs > 3600 then
                Printf.sprintf "%n hours" (secs / 3600)
              else if secs > 60 then
                Printf.sprintf "%n minutes" (secs / 60)
              else
                Printf.sprintf "%n seconds" secs
            in
            Printf.eprintf
              "  hh_server '%s' was launched %s ago;\n  hh_client '%s' launched now.\n%!"
              (String.concat ~sep:" " mismatch_info.existing_argv)
              time
              (String.concat ~sep:" " (Array.to_list Sys.argv));
            ()
        end;
        if env.autostart then (
          (* The new server is definitely not running yet, adjust the
           * start time and deadline to absorb the server startup time.
           *)
          let now = Unix.time () in
          let deadline =
            Option.map ~f:(fun d -> d +. (now -. start_time)) env.deadline
          in
          Printf.eprintf "Going to launch a new one.\n%!";
          connect { env with deadline } now
        ) else
          raise Exit_status.(Exit_with Exit_status.Build_id_mismatch)))

let connect (env : env) : conn Lwt.t =
  let start_time = Unix.time () in
  try%lwt
    let%lwt ({ channels = (_, oc); _ } as conn) = connect env start_time in
    HackEventLogger.client_established_connection start_time;
    if env.do_post_handoff_handshake then
      ServerCommandLwt.send_connection_type oc ServerCommandTypes.Non_persistent;
    Lwt.return { conn with t_sent_connection_type = Unix.gettimeofday () }
  with e ->
    (* we'll log this exception, then re-raise the exception, but using the *)
    (* original backtrace of "e" rather than generating a new backtrace.    *)
    let backtrace = Caml.Printexc.get_raw_backtrace () in
    HackEventLogger.client_establish_connection_exception e;
    Caml.Printexc.raise_with_backtrace e backtrace

let rpc :
    type a.
    conn -> desc:string -> a ServerCommandTypes.t -> (a * Telemetry.t) Lwt.t =
 fun {
       connection_log_id;
       t_connected_to_monitor;
       t_received_hello;
       t_sent_connection_type;
       channels = (ic, oc);
       server_specific_files;
       conn_progress_callback = progress_callback;
       conn_root;
       conn_deadline = deadline;
       from;
     }
     ~desc
     cmd ->
  let t_ready_to_send_cmd = Unix.gettimeofday () in
  let metadata = { ServerCommandTypes.from; desc } in
  Marshal.to_channel oc (ServerCommandTypes.Rpc (metadata, cmd)) [];
  Out_channel.flush oc;
  let t_sent_cmd = Unix.gettimeofday () in
  let%lwt res =
    wait_for_server_message
      ~connection_log_id
      ~expected_message:None
      ~ic
      ~deadline
      ~server_specific_files
      ~progress_callback
      ~root:conn_root
  in
  match res with
  | ServerCommandTypes.Response (response, tracker) ->
    let open Connection_tracker in
    let telemetry =
      tracker
      |> track ~key:Client_ready_to_send_cmd ~time:t_ready_to_send_cmd
      |> track ~key:Client_sent_cmd ~time:t_sent_cmd
      |> track ~key:Client_received_response
      (* now we can fill in missing information in tracker, which we couldn't fill in earlier
      because we'd already transferred ownership of the tracker to the monitor... *)
      |> track ~key:Client_connected_to_monitor ~time:t_connected_to_monitor
      |> track ~key:Client_received_hello ~time:t_received_hello
      |> track ~key:Client_sent_connection_type ~time:t_sent_connection_type
      |> get_telemetry
    in
    Lwt.return (response, telemetry)
  | ServerCommandTypes.Push _ -> failwith "unexpected 'push' RPC response"
  | ServerCommandTypes.Hello -> failwith "unexpected 'hello' RPC response"
  | ServerCommandTypes.Ping -> failwith "unexpected 'ping' RPC response"
  | ServerCommandTypes.Monitor_failed_to_handoff ->
    failwith "unexpected 'monitor_failed_to_handoff' RPC response"

let rpc_with_retry
    (conn_f : unit -> conn Lwt.t)
    ~(desc : string)
    (cmd : 'a ServerCommandTypes.Done_or_retry.t ServerCommandTypes.t) :
    'a Lwt.t =
  ServerCommandTypes.Done_or_retry.call ~f:(fun () ->
      let%lwt conn = conn_f () in
      let%lwt (result, _telemetry) = rpc conn ~desc cmd in
      Lwt.return result)
