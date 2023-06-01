(*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

open Core
module Ty = Typing_defs_core

exception Already_bound of Patt_var.t * string

module Value = struct
  type t =
    | Ty of (Typing_defs_core.locl_ty[@compare.ignore] [@sexp.opaque])
    | Name of ((Pos_or_decl.t[@opaque]) * string)
  [@@deriving compare, sexp]
end

module Match = struct
  module X = struct
    (* TODO[mjt] - decompose into safe and unsafe match? *)
    type ('a, 'err) t =
      | Matched of 'a
      | No_match
      | Match_err of 'err

    let map =
      `Custom
        (fun t ~f ->
          match t with
          | Matched a -> Matched (f a)
          | No_match -> No_match
          | Match_err err -> Match_err err)

    let map_err t ~f =
      match t with
      | Match_err err -> Match_err (f err)
      | Matched a -> Matched a
      | No_match -> No_match

    let bind t ~f =
      match t with
      | Matched x -> f x
      | No_match -> No_match
      | Match_err err -> Match_err err

    let return x = Matched x

    let matched x = Matched x

    let no_match = No_match

    let match_err err = Match_err err
  end

  include X
  include Core.Monad.Make2 (X)
end

module Err = struct
  type t = Already_bound of Patt_var.t
end

module Env = struct
  type t = Env of Value.t String.Map.t

  let empty = Env String.Map.empty

  let add (Env t) ~lbl ~data =
    match Map.add t ~key:lbl ~data with
    | `Duplicate -> Match.match_err (Err.Already_bound lbl)
    | `Ok t -> Match.matched (Env t)

  let add_name t ~lbl ~name = add t ~lbl ~data:(Value.Name name)

  let add_ty t ~lbl ~ty = add t ~lbl ~data:(Value.Ty ty)

  let get (Env t) lbl = Map.find_exn t lbl
end

(* -- Helpers --------------------------------------------------------------- *)

let match_exists patt ~matches ~scruts ~env =
  let rec aux = function
    | [] -> Match.no_match
    | scrut :: scruts ->
      (match matches patt scrut ~env with
      | Match.Matched _ as m -> m
      | _ -> aux scruts)
  in
  aux scruts

(* -- Strings --------------------------------------------------------------- *)

let matches_patt_string_help t ~scrut =
  let open Patt_string in
  let rec aux = function
    | Exactly str -> String.equal scrut str
    | Starts_with prefix -> String.is_prefix scrut ~prefix
    | Ends_with suffix -> String.is_suffix scrut ~suffix
    | Contains substring -> String.is_substring scrut ~substring
    | One_of ts -> List.exists ~f:aux ts
    | And ts -> List.for_all ~f:aux ts
    | Is_not t -> not @@ aux t
  in
  aux t

(* Since this pattern can never bind a variable we can't produce a match
   error. We use this invariant to simply the inner matching function *)
let matches_string ?(env = Env.empty) t ~scrut =
  if matches_patt_string_help t ~scrut then
    Match.matched env
  else
    Match.no_match

(* -- Names ----------------------------------------------------------------- *)

let matches_name ?(env = Env.empty) t ~scrut =
  let open Patt_name in
  match t with
  | Wildcard -> Match.matched env
  | Name patt_string ->
    Match.(
      matches_string patt_string ~scrut:(snd scrut) ~env
      |> map ~f:(Fn.const env)
      |> map_err ~f:(fun _ -> assert false))
  | As { lbl; patt } ->
    Match.(
      matches_string patt ~scrut:(snd scrut) ~env
      |> map_err ~f:(fun _ -> assert false)
      >>= Env.add_name ~lbl ~name:scrut)

(* -- Types ----------------------------------------------------------------- *)

let split_fields flds =
  List.fold
    ~f:(fun (str_map, cconst_map, int_map) (k, ty) ->
      match k with
      | Ty.TSFclass_const ((_, cls_nm), (_, cnst_nm)) ->
        ( str_map,
          String.Map.add_exn ~key:(cls_nm ^ "::" ^ cnst_nm) ~data:ty cconst_map,
          int_map )
      | Ty.TSFlit_str (_, nm) ->
        (String.Map.add_exn ~key:nm ~data:ty str_map, cconst_map, int_map)
      | Ty.TSFlit_int (_, n) ->
        (str_map, cconst_map, String.Map.add_exn ~key:n ~data:ty int_map))
    ~init:(String.Map.empty, String.Map.empty, String.Map.empty)
  @@ Ty.TShapeMap.elements flds

let matches_locl_ty ?(env = Env.empty) t ~scrut =
  let open Patt_locl_ty in
  let rec aux t ty ~env =
    let ty_pos = Ty.get_pos ty in
    match (t, Ty.get_node ty) with
    (* -- Type wildcards ---------------------------------------------------- *)
    | (Any, _) -> Match.Matched env
    (* -- Type constructor like types --------------------------------------- *)
    | (Apply { patt_name; patt_params }, Ty.Tclass (name, _, tys)) ->
      Match.(
        matches_name patt_name ~scrut:name ~env >>= fun env ->
        aux_params patt_params tys ~env)
    | (Apply { patt_name; patt_params }, Ty.Tnewtype (id, tys, _)) ->
      Match.(
        matches_name patt_name ~scrut:(ty_pos, id) ~env >>= fun env ->
        aux_params patt_params tys ~env)
    | (Apply { patt_name; patt_params }, Ty.Tvec_or_dict (ty_key, ty_val)) ->
      Match.(
        matches_name patt_name ~scrut:(ty_pos, "vec_or_dict") ~env
        >>= fun env -> aux_params patt_params [ty_key; ty_val] ~env)
    | (Option t, Ty.Toption ty) -> aux t ty ~env
    | (Tuple ts, Ty.Ttuple tys) -> aux_tuple ts tys ~env
    (* -- Primitives & other base types ------------------------------------- *)
    | (Prim Null, Ty.Tprim Ast_defs.Tnull)
    | (Prim Void, Ty.Tprim Ast_defs.Tvoid)
    | (Prim Int, Ty.Tprim Ast_defs.Tint)
    | (Prim Bool, Ty.Tprim Ast_defs.Tbool)
    | (Prim Float, Ty.Tprim Ast_defs.Tfloat)
    | (Prim String, Ty.Tprim Ast_defs.Tstring)
    | (Prim Resource, Ty.Tprim Ast_defs.Tresource)
    | (Prim Num, Ty.Tprim Ast_defs.Tnum)
    | (Prim Arraykey, Ty.Tprim Ast_defs.Tarraykey)
    | (Prim Noreturn, Ty.Tprim Ast_defs.Tnoreturn)
    | (Dynamic, Ty.Tdynamic)
    | (Nonnull, Ty.Tnonnull) ->
      Match.matched env
    (* -- Variable binding -------------------------------------------------- *)
    | (As { lbl; patt }, _) -> Match.(aux patt ty ~env >>= Env.add_ty ~lbl ~ty)
    (* -- Or patterns ------------------------------------------------------- *)
    | (Or { patt_fst; patt_snd }, _) ->
      (match aux patt_fst ty ~env with
      | Match.Matched _ as m -> m
      | _ -> aux patt_snd ty ~env)
    (* -- Shapes ------------------------------------------------------------ *)
    | (Shape patt_flds, Ty.Tshape (_, _, flds)) ->
      (* Split [TShapeMap.t] into three [String.Map.t]s, eliminating positional
         information *)
      let (str_flds, cconst_flds, int_flds) = split_fields flds in
      aux_shape patt_flds (str_flds, cconst_flds, int_flds) ~env
    (* -- Mismatches -------------------------------------------------------- *)
    | ((Apply _ | Option _ | Tuple _ | Prim _ | Dynamic | Nonnull | Shape _), _)
      ->
      Match.no_match
  and aux_shape t (str_flds, cconst_flds, int_flds) ~env =
    match t with
    | Fld { patt_fld; patt_rest } ->
      (match
         aux_shape_field patt_fld (str_flds, cconst_flds, int_flds) ~env
       with
      | Match.Matched (str_flds, cconst_flds, int_flds, env) ->
        aux_shape patt_rest (str_flds, cconst_flds, int_flds) ~env
      | Match.No_match -> Match.No_match
      | Match.Match_err err -> Match.match_err err)
    (* -- Open matches any remaining shape fields --------------------------- *)
    | Open -> Match.matched env
    (* -- Closed matches when we have no remaining shape fields ------------- *)
    | Closed
      when Map.is_empty str_flds
           && Map.is_empty cconst_flds
           && Map.is_empty int_flds ->
      Match.matched env
    | Closed -> Match.no_match
  and aux_shape_field fld (str_flds, cconst_flds, int_flds) ~env =
    match fld.lbl with
    | StrLbl str ->
      Option.value_map
        ~default:Match.no_match
        ~f:(fun Ty.{ sft_optional; sft_ty } ->
          if Bool.(sft_optional = fld.optional) then
            match aux fld.patt sft_ty ~env with
            | Match.Matched env ->
              Match.matched (Map.remove str_flds str, cconst_flds, int_flds, env)
            | Match.No_match -> Match.No_match
            | Match.Match_err err -> Match.Match_err err
          else
            Match.no_match)
      @@ Map.find str_flds str
    | CConstLbl { cls_nm; cnst_nm } ->
      let str = cls_nm ^ "::" ^ cnst_nm in
      Option.value_map
        ~default:Match.no_match
        ~f:(fun Ty.{ sft_optional; sft_ty } ->
          if Bool.(sft_optional = fld.optional) then
            match aux fld.patt sft_ty ~env with
            | Match.Matched env ->
              Match.matched (str_flds, Map.remove cconst_flds str, int_flds, env)
            | Match.No_match -> Match.No_match
            | Match.Match_err err -> Match.Match_err err
          else
            Match.no_match)
      @@ Map.find cconst_flds str
    | IntLbl n ->
      Option.value_map
        ~default:Match.no_match
        ~f:(fun Ty.{ sft_optional; sft_ty } ->
          if Bool.(sft_optional = fld.optional) then
            match aux fld.patt sft_ty ~env with
            | Match.Matched env ->
              Match.matched (str_flds, cconst_flds, Map.remove int_flds n, env)
            | Match.No_match -> Match.No_match
            | Match.Match_err err -> Match.Match_err err
          else
            Match.no_match)
      @@ Map.find int_flds n
  and aux_params t tys ~env =
    match (t, tys) with
    | (Cons { patt_hd; patt_tl }, ty :: tys) ->
      Match.(aux patt_hd ty ~env >>= fun env -> aux_params patt_tl tys ~env)
    | (Exists t, _) -> match_exists t ~matches:aux ~scruts:tys ~env
    | (Nil, [])
    | (Wildcard, _) ->
      Match.matched env
    | (Nil, _)
    | (Cons _, []) ->
      Match.no_match
  and aux_tuple ts tys ~env =
    match (ts, tys) with
    | (t :: ts, ty :: tys) ->
      Match.(aux t ty ~env >>= fun env -> aux_tuple ts tys ~env)
    | ([], []) -> Match.matched env
    | _ -> Match.no_match
  in
  aux t scrut ~env

(* -- Errors ---------------------------------------------------------------- *)

let matches_error ?(env = Env.empty) t ~scrut =
  let open Patt_error in
  (* -- Top-level typing errors --------------------------------------------- *)
  let rec aux t err ~env =
    match (t, err) with
    | (_, Typing_error.Error.Intersection errs)
    | (_, Typing_error.Error.Union errs)
    | (_, Typing_error.Error.Multiple errs) ->
      match_exists t ~matches:aux ~scruts:errs ~env
    (* -- Primary errors ---------------------------------------------------- *)
    | (Primary patt_prim, Typing_error.Error.Primary err_prim) ->
      aux_primary patt_prim err_prim ~env
    (* -- Callback application ---------------------------------------------- *)
    | (Apply (patt_callback, patt), Typing_error.Error.Apply (err_callback, err))
      ->
      Match.(
        aux_callback patt_callback err_callback ~env >>= fun env ->
        aux patt err ~env)
    (* -- Reasons callback application -------------------------------------- *)
    | ( Apply_reasons (patt_reasons_callback, patt_secondary),
        Typing_error.Error.Apply_reasons (err_reasons_callback, err_snd) ) ->
      Match.(
        aux_reasons_callback patt_reasons_callback err_reasons_callback ~env
        >>= fun env -> aux_secondary patt_secondary err_snd ~env)
    (* -- Or patterns ------------------------------------------------------- *)
    | (Or (t1, t2), _) ->
      (match aux t1 err ~env with
      | Match.Matched _ as m -> m
      | _ -> aux t2 err ~env)
    (* -- Mismatches -------------------------------------------------------- *)
    | (Primary _, _)
    | (Apply _, _)
    | (Apply_reasons _, _) ->
      Match.no_match
  (* -- Primary errors ------------------------------------------------------ *)
  and aux_primary t err_prim ~env =
    match (t, err_prim) with
    | (Any_prim, _) -> Match.matched env
  (* -- Secondary errors ---------------------------------------------------- *)
  and aux_secondary t err_snd ~env =
    match (t, err_snd) with
    | (Of_error patt_err, Typing_error.Secondary.Of_error err) ->
      aux patt_err err ~env
    | (Of_error _, _) -> Match.no_match
    (* We don't expose our internal `constraint_ty` so we handle this here *)
    | ( Violated_constraint (patt_name, patt_ty_sub, patt_ty_sup),
        Typing_error.Secondary.Violated_constraint { cstrs; ty_sub; ty_sup; _ }
      ) ->
      Match.(
        match_exists patt_name ~matches:aux_param ~scruts:cstrs ~env
        >>= fun env ->
        aux_internal_ty patt_ty_sub ty_sub ~env >>= fun env ->
        aux_internal_ty patt_ty_sup ty_sup ~env)
    | (Violated_constraint _, _) -> Match.no_match
    | ( Subtyping_error (patt_ty_sub, patt_ty_sup),
        Typing_error.Secondary.Subtyping_error { ty_sub; ty_sup; _ } ) ->
      Match.(
        aux_internal_ty patt_ty_sub ty_sub ~env >>= fun env ->
        aux_internal_ty patt_ty_sup ty_sup ~env)
    | (Subtyping_error _, _) -> Match.no_match
    | (Any_snd, _) -> Match.matched env
  (* -- Primary callbacks --------------------------------------------------- *)
  and aux_callback t err_callback ~env =
    match (t, err_callback) with
    | (Any_callback, _) -> Match.matched env
  (* -- Secondary / reasons callbacks --------------------------------------- *)
  and aux_reasons_callback t err_reasons_callback ~env =
    match (t, err_reasons_callback) with
    | (Any_reasons_callback, _) -> Match.matched env
  (* -- Internal types: we don't expose contraint types so handle here ------ *)
  and aux_internal_ty patt_locl_ty internal_ty ~env =
    match internal_ty with
    | Typing_defs_core.LoclType scrut ->
      matches_locl_ty patt_locl_ty ~scrut ~env
    | _ -> Match.no_match
  (* -- Type parameters ----------------------------------------------------- *)
  and aux_param patt_name (_, scrut) ~env =
    matches_name patt_name ~scrut ~env
  in
  aux t scrut ~env

let eval_error_message t ~env =
  let open Error_message in
  let rec aux t ~k ~acc =
    match t with
    | Lit str -> k (Either.First str :: acc)
    | Ty_var var
    | Name_var var ->
      k (Either.Second (Env.get env var) :: acc)
    | Append (l, r) -> aux r ~acc ~k:(fun acc -> aux l ~acc ~k)
  in
  aux t ~k:Fn.id ~acc:[]

let eval Custom_error.{ name; patt; error_message } ~err =
  match matches_error patt ~scrut:err with
  | Match.Matched env -> Some (eval_error_message error_message ~env)
  | Match.No_match -> None
  | Match.Match_err (Err.Already_bound var) -> raise (Already_bound (var, name))
