(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

open Hh_prelude
module Syntax = Full_fidelity_positioned_syntax
include Classish_positions_types

type classish_body_offsets = int classish_positions

let classish_body_braces_offsets s : classish_body_offsets option =
  let open Syntax in
  let brace_to_offset brace (f : offset:int -> width:int -> int) : int option =
    match brace.syntax with
    | Token t -> Some (f ~offset:t.Token.offset ~width:t.Token.width)
    | _ -> None
  in
  match s.syntax with
  | ClassishBody cb ->
    let open Option.Let_syntax in
    let* classish_start =
      brace_to_offset cb.classish_body_left_brace @@ fun ~offset ~width ->
      offset + width
    in
    let* classish_end =
      brace_to_offset cb.classish_body_right_brace @@ fun ~offset ~width:_ ->
      offset
    in
    Some { classish_start; classish_end }
  | _ -> None

let namespace_name (s : Syntax.t) : string option =
  let open Syntax in
  match s.syntax with
  | Syntax.NamespaceDeclarationHeader h ->
    let name_token = h.namespace_name in
    (match name_token.syntax with
    | Syntax.Token _ -> Some (text name_token)
    | _ ->
      (* Anonymous namespace: namespace { ... } *)
      None)
  | _ -> None

(* Covnert ["Foo"; "Bar"] to \Foo\Bar. *)
let name_from_parts (parts : string list) : string =
  String.concat (List.map parts ~f:(fun p -> "\\" ^ p))

let classish_start_offsets (s : Syntax.t) : classish_body_offsets SMap.t =
  let open Syntax in
  let rec aux (acc : classish_body_offsets SMap.t * string list) (s : Syntax.t)
      =
    let (offsets, namespace) = acc in
    match s.syntax with
    | Syntax.Script s -> aux acc s.script_declarations
    | Syntax.SyntaxList sl -> List.fold sl ~init:acc ~f:aux
    | Syntax.NamespaceDeclaration n ->
      let b = n.namespace_body in
      (match b.syntax with
      | Syntax.NamespaceBody nb ->
        (* We're looking at: namespace Foo { ... } *)
        let inner_namespace =
          match namespace_name n.namespace_header with
          | Some name -> name :: namespace
          | None -> namespace
        in
        let (offsets, _) =
          aux (offsets, inner_namespace) nb.namespace_declarations
        in
        (offsets, namespace)
      | Syntax.NamespaceEmptyBody _ ->
        (* We're looking at: namespace Foo; *)
        let namespace =
          match namespace_name n.namespace_header with
          | Some name -> name :: namespace
          | None -> namespace
        in
        (offsets, namespace)
      | _ -> acc)
    | Syntax.ClassishDeclaration c ->
      (match classish_body_braces_offsets c.classish_body with
      | Some class_offsets ->
        let name = name_from_parts (namespace @ [text c.classish_name]) in
        let offsets = SMap.add name class_offsets offsets in
        (offsets, namespace)
      | _ -> acc)
    | _ -> acc
  in

  fst (aux (SMap.empty, []) s)

let empty = SMap.empty

let extract
    (s : Syntax.t)
    (source_text : Full_fidelity_source_text.t)
    (filename : Relative_path.t) : Pos.t t =
  let offsets = classish_start_offsets s in
  let to_pos offset =
    Full_fidelity_source_text.relative_pos filename source_text offset offset
  in
  SMap.map
    (fun { classish_start; classish_end } ->
      {
        classish_start = to_pos classish_start;
        classish_end = to_pos classish_end;
      })
    offsets

let map_pos ~f = function
  | Precomputed p -> Precomputed (f p)
  | Classish_start_of_body class_name -> Classish_start_of_body class_name
  | Classish_end_of_body class_name -> Classish_end_of_body class_name

let find pos t =
  let map_class class_name f = SMap.find_opt class_name t |> Option.map ~f in
  match pos with
  | Precomputed pos -> Some pos
  | Classish_start_of_body class_name ->
    map_class class_name @@ fun c -> c.classish_start
  | Classish_end_of_body class_name ->
    map_class class_name @@ fun c -> c.classish_end
