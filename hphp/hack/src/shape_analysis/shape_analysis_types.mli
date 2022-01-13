(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

module LMap = Local_id.Map
module KMap = Typing_continuations.Map

(** Container to collect potential dicts that can be addressed with the shape
    analysis. *)
type potential_targets = {
  expressions_to_modify: Pos.t list;
  hints_to_modify: Pos.t list;
}

type mode =
  | FlagTargets
      (** Flag all possible targets, e.g., `dict['k1' => 42, 'k2' =>
          'meaning']` without performing any analysis *)
  | DumpConstraints  (** Dump constraints generated by analysing the program *)
  | SimplifyConstraints
      (** Partially solve key constraints within functions and methods and
          report back summaries about which `dict`s might be `shape`s and which
          functions/methods they depend on. *)
  | SolveConstraints
      (** Globally solve the key constraints and report back `dict`s that can
          be `shape`s along with the `shape` keys *)

type options = { mode: mode }

type entity_ =
  | Literal of Pos.t
  | Variable of int
[@@deriving eq, ord]

type entity = entity_ option

type shape_key = SK_string of string [@@deriving eq, ord]

module ShapeKeyMap : Map.S with type key = shape_key

(** Identifier used to establish the dependence of results *)
module ResultID = ISet

type shape_keys = ResultID.t * Typing_defs.locl_ty ShapeKeyMap.t

type exists_kind =
  | Allocation  (** A dict allocation such as `dict[]` or `dict['a' => 42]` *)
  | Parameter
      (** A dict parameter to a function or method such as `function
          f(dict<string,int> $d)` *)
  | Argument
      (** A dict argument to a function or method such as `$d = dict[]; f($d)`
       *)

type constraint_ =
  | Exists of exists_kind * Pos.t  (** Records creation of a dict *)
  | Has_static_keys of entity_ * shape_keys
      (** Records the static keys an entity is accessed with along with the Hack
          types of those keys *)
  | Has_dynamic_key of entity_
      (** Records that an entity is accessed with a dynamic key *)
  | Subset of entity_ * entity_
      (** Records that the first keys of the first entity are all present in
          the second. *)

type shape_result =
  | Shape_like_dict of
      Pos.t * ResultID.t * (shape_key * Typing_defs.locl_ty) list
      (** A dict that acts like a shape along with its keys and types the keys
          point to *)
  | Dynamically_accessed_dict of entity_
      (** A dict that is accessed or used dynamically. This is important
          in inter-procedural setting where a locally static dict calls a
          function where the parameter is accessed dynamically. In that case,
          the original result on static access should be invalidated. *)

(** Local variable environment. Its values are `entity`, i.e., `entity_
    option`, so that we can avoid pattern matching in constraint extraction. *)
type lenv = entity LMap.t KMap.t

type env = {
  constraints: constraint_ list;  (** Append-only set of constraints *)
  lenv: lenv;  (** Local variable information *)
  tast_env: Tast_env.env;
      (** TAST env associated with the definition being analysed *)
}

module PointsToSet : Set.S with type elt = entity_ * entity_

module EntityMap : Map.S with type key = entity_

module EntitySet : Set.S with type elt = entity_
