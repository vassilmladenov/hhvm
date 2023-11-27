(*
 * Copyrighd (c) 2015, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

open Core
module Error_code = Error_codes.Typing

type error =
  Error_code.t
  * Pos.t Message.t Lazy.t
  * Pos_or_decl.t Message.t list Lazy.t
  * Pos.t Quickfix.t list

module Common = struct
  let map2 ~f x y = Lazy.(x >>= fun x -> map ~f:(fun y -> f x y) y)

  (* The contents of the following error message can trigger `hh rage` in
   * sandcastle. If you change it, please make sure the existing trigger in
   * `flib/intern/sandcastle/hack/SandcastleCheckHackOnDiffsStep.php` still
   * catches this error message. *)
  let please_file_a_bug_message =
    let hacklang_feedback_support_link =
      "https://fb.workplace.com/groups/hackforhiphop/"
    in
    let hh_rage = Markdown_lite.md_codify "hh rage" in
    Printf.sprintf
      "Please run %s and post in %s."
      hh_rage
      hacklang_feedback_support_link

  let reasons_of_trail trail =
    List.map trail ~f:(fun pos -> (pos, "Typedef definition comes from here"))

  let typing_too_many_args pos decl_pos actual expected =
    let claim =
      lazy
        ( pos,
          Printf.sprintf
            "Too many arguments (expected %d but got %d)"
            expected
            actual )
    and reasons = lazy [(decl_pos, "Definition is here")] in
    (Error_code.TypingTooManyArgs, claim, reasons)

  let typing_too_few_args pos decl_pos actual expected =
    let claim =
      lazy
        ( pos,
          Printf.sprintf
            "Too few arguments (required %d but got %d)"
            expected
            actual )
    and reasons = lazy [(decl_pos, "Definition is here")] in
    (Error_code.TypingTooFewArgs, claim, reasons)

  let snot_found_suggestion orig similar kind =
    match similar with
    | (`instance, pos, v) -> begin
      match kind with
      | `static_method ->
        Render.suggestion_message ~modifier:"instance method " orig v pos
      | `class_constant ->
        Render.suggestion_message ~modifier:"instance property " orig v pos
      | `class_variable
      | `class_typeconst ->
        Render.suggestion_message orig v pos
    end
    | (`static, pos, v) -> Render.suggestion_message orig v pos

  let smember_not_found pos kind member_name class_name class_pos hint =
    let claim =
      lazy
        ( pos,
          Printf.sprintf
            "No %s %s in %s"
            (Render.string_of_class_member_kind kind)
            (Markdown_lite.md_codify member_name)
            (Markdown_lite.md_codify @@ Render.strip_ns class_name) )
    in
    let reasons =
      lazy
        (let default =
           [
             ( class_pos,
               "Declaration of "
               ^ (Markdown_lite.md_codify @@ Render.strip_ns class_name)
               ^ " is here" );
           ]
         in
         Option.value_map hint ~default ~f:(fun similar ->
             snot_found_suggestion member_name similar kind :: default))
    in

    (Error_code.SmemberNotFound, claim, reasons)

  let non_object_member pos ctxt ty_name member_name kind decl_pos =
    let code =
      match ctxt with
      | `read -> Error_code.NonObjectMemberRead
      | `write -> Error_code.NonObjectMemberWrite
    in
    let claim =
      lazy
        (let msg_start =
           Printf.sprintf
             "You are trying to access the %s %s but this is %s"
             (Render.string_of_class_member_kind kind)
             (Markdown_lite.md_codify member_name)
             ty_name
         in
         let msg =
           if String.equal ty_name "a shape" then
             msg_start ^ ". Did you mean `$foo['" ^ member_name ^ "']` instead?"
           else
             msg_start
         in
         (pos, msg))
    and reasons = lazy [(decl_pos, "Definition is here")] in
    (code, claim, reasons)

  let badpos_message =
    Printf.sprintf
      "Incomplete position information! Your type error is in this file, but we could only find related positions in another file. %s"
      please_file_a_bug_message

  let badpos_message_2 =
    Printf.sprintf
      "Incomplete position information! We couldn't find the exact line of your type error in this definition. %s"
      please_file_a_bug_message

  let wrap_error_in_different_file ~current_file ~current_span reasons =
    let claim =
      lazy
        (let message =
           List.map reasons ~f:(fun (pos, msg) ->
               Pos.print_verbose_relative (Pos_or_decl.unsafe_to_raw_pos pos)
               ^ ": "
               ^ msg)
         in
         let stack =
           Exception.get_current_callstack_string 99 |> Exception.clean_stack
         in
         Hh_logger.log
           "TYPE_CHECK_PRIMARY_POSITION_BUG in %s\n%s\n%s"
           (Relative_path.to_absolute current_file)
           (String.concat message ~sep:"\n")
           stack;
         HackEventLogger.type_check_primary_position_bug
           ~current_file
           ~message
           ~stack;
         if Pos.equal current_span Pos.none then
           (Pos.make_from current_file, badpos_message)
         else
           (current_span, badpos_message_2))
    in
    (claim, reasons)

  let eval_assert ctx current_span (code, reasons) : error option =
    match Lazy.force reasons with
    | (pos, msg) :: rest as reasons ->
      let (claim, reasons) =
        match
          Pos_or_decl.fill_in_filename_if_in_current_decl
            ~current_decl_and_file:ctx
            pos
        with
        | Some pos -> (lazy (pos, msg), rest)
        | _ ->
          wrap_error_in_different_file
            ~current_file:ctx.Pos_or_decl.file
            ~current_span
            reasons
      in
      Some (code, claim, lazy reasons, [])
    | _ -> None
end

module Eval_result : sig
  type 'a t

  val empty : 'a t

  val single : 'a -> 'a t

  val multiple : 'a t list -> 'a t

  val union : 'a t list -> 'a t

  val intersect : 'a t list -> 'a t

  val of_option : 'a option -> 'a t

  val map : 'a t -> f:('a -> 'b) -> 'b t

  val bind : 'a t -> f:('a -> 'b t) -> 'b t

  val iter : 'a t -> f:('a -> unit) -> unit

  val suppress_intersection : 'a t -> is_suppressed:('a -> bool) -> 'a t
end = struct
  type 'a t =
    | Empty
    | Single of 'a
    | Multiple of 'a t list
    | Union of 'a t list
    | Intersect of 'a t list

  let empty = Empty

  let single a = Single a

  let multiple = function
    | [] -> Empty
    | xs -> Multiple xs

  let union = function
    | [] -> Empty
    | xs -> Union xs

  let intersect = function
    | [] -> Empty
    | xs -> Intersect xs

  let of_option = function
    | Some x -> Single x
    | _ -> Empty

  let map t ~f =
    let rec aux = function
      | Empty -> Empty
      | Single x -> Single (f x)
      | Multiple xs -> Multiple (List.map ~f:aux xs)
      | Union xs -> Union (List.map ~f:aux xs)
      | Intersect xs -> Intersect (List.map ~f:aux xs)
    in
    aux t

  let bind t ~f =
    let rec aux = function
      | Empty -> Empty
      | Single x -> f x
      | Multiple xs -> Multiple (List.map ~f:aux xs)
      | Union xs -> Union (List.map ~f:aux xs)
      | Intersect xs -> Intersect (List.map ~f:aux xs)
    in
    aux t

  let iter t ~f =
    let rec aux = function
      | Empty -> ()
      | Single x -> f x
      | Multiple xs
      | Union xs
      | Intersect xs ->
        List.iter ~f:aux xs
    in
    aux t

  let is_suppressed t p =
    let rec f = function
      | Intersect xs -> List.exists ~f xs
      | Multiple xs
      | Union xs ->
        List.for_all ~f xs
      | Empty -> false
      | Single x -> p x
    in
    f t

  let suppress_intersection t ~is_suppressed:p =
    let p t = is_suppressed t p in
    let rec aux t =
      match t with
      | Intersect xs -> auxs [] xs
      | Multiple xs -> multiple @@ List.map ~f:aux xs
      | Union xs -> union @@ List.map ~f:aux xs
      | _ -> t
    and auxs acc = function
      | [] -> intersect @@ List.rev acc
      | next :: rest ->
        if p next then
          aux next
        else
          auxs (next :: acc) rest
    in
    aux t
end

module Eval_primary = struct
  module Eval_shape = struct
    let invalid_shape_field_type pos ty_pos ty_name trail =
      let reasons =
        lazy
          ((ty_pos, "Not " ^ Lazy.force ty_name)
          :: Common.reasons_of_trail trail)
      and claim =
        lazy (pos, "A shape field name must be an `int` or `string`")
      in
      (Error_code.InvalidShapeFieldType, claim, reasons, [])

    let invalid_shape_field_name pos =
      let claim =
        lazy
          ( pos,
            "Shape access requires a string literal, integer literal, or a class constant"
          )
      in
      (Error_code.InvalidShapeFieldName, claim, lazy [], [])

    let invalid_shape_field_name_empty pos =
      let claim = lazy (pos, "A shape field name cannot be an empty string") in

      (Error_code.InvalidShapeFieldNameEmpty, claim, lazy [], [])

    let invalid_shape_field_literal pos witness_pos =
      let claim = lazy (pos, "Shape uses literal string as field name")
      and reason =
        lazy
          [
            (Pos_or_decl.of_raw_pos witness_pos, "But expected a class constant");
          ]
      in
      (Error_code.InvalidShapeFieldLiteral, claim, reason, [])

    let invalid_shape_field_const pos witness_pos =
      let claim = lazy (pos, "Shape uses class constant as field name")
      and reason =
        lazy
          [
            (Pos_or_decl.of_raw_pos witness_pos, "But expected a literal string");
          ]
      in
      (Error_code.InvalidShapeFieldConst, claim, reason, [])

    let shape_field_class_mismatch pos class_name witness_pos witness_class_name
        =
      let claim =
        lazy
          ( pos,
            "Shape field name is class constant from "
            ^ Markdown_lite.md_codify class_name )
      and reason =
        lazy
          [
            ( Pos_or_decl.of_raw_pos witness_pos,
              "But expected constant from "
              ^ Markdown_lite.md_codify witness_class_name );
          ]
      in
      (Error_code.ShapeFieldClassMismatch, claim, reason, [])

    let shape_field_type_mismatch pos ty_name witness_pos witness_ty_name =
      let claim =
        lazy
          (pos, "Shape field name is " ^ Lazy.force ty_name ^ " class constant")
      and reason =
        lazy
          [
            ( Pos_or_decl.of_raw_pos witness_pos,
              "But expected " ^ Lazy.force witness_ty_name );
          ]
      in
      (Error_code.ShapeFieldTypeMismatch, claim, reason, [])

    let invalid_shape_remove_key pos =
      let claim =
        lazy (pos, "You can only unset fields of **local** variables")
      in
      (Error_code.InvalidShapeRemoveKey, claim, lazy [], [])

    let shapes_key_exists_always_true pos field_name decl_pos =
      let claim = lazy (pos, "This `Shapes::keyExists()` check is always true")
      and reason =
        lazy
          [
            ( decl_pos,
              "The field "
              ^ Markdown_lite.md_codify field_name
              ^ " exists because of this definition" );
          ]
      in
      (Error_code.ShapesKeyExistsAlwaysTrue, claim, reason, [])

    let shape_field_non_existence_reason pos name = function
      | `Undefined ->
        lazy
          [
            ( pos,
              "The field "
              ^ Markdown_lite.md_codify name
              ^ " is not defined in this shape" );
          ]
      | `Nothing reason ->
        Lazy.map reason ~f:(fun reason ->
            ( pos,
              "The type of the field "
              ^ Markdown_lite.md_codify name
              ^ " in this shape doesn't allow any values" )
            :: reason)

    let shapes_key_exists_always_false pos field_name decl_pos reason =
      let claim = lazy (pos, "This `Shapes::keyExists()` check is always false")
      and reason =
        shape_field_non_existence_reason decl_pos field_name reason
      in
      (Error_code.ShapesKeyExistsAlwaysFalse, claim, reason, [])

    let shapes_method_access_with_non_existent_field
        pos field_name method_name decl_pos reason =
      let claim =
        lazy
          ( pos,
            "You are calling "
            ^ Markdown_lite.md_codify ("Shapes::" ^ method_name ^ "()")
            ^ " on a field known to not exist" )
      and reason =
        shape_field_non_existence_reason decl_pos field_name reason
      in
      (Error_code.ShapesMethodAccessWithNonExistentField, claim, reason, [])

    let shapes_access_with_non_existent_field pos field_name decl_pos reason =
      let claim = lazy (pos, "You are accessing a field known to not exist")
      and reason =
        shape_field_non_existence_reason decl_pos field_name reason
      in
      (Error_code.ShapeAccessWithNonExistentField, claim, reason, [])

    let to_error t ~env:_ =
      let open Typing_error.Primary.Shape in
      match t with
      | Invalid_shape_field_type { pos; ty_pos; ty_name; trail } ->
        invalid_shape_field_type pos ty_pos ty_name trail
      | Invalid_shape_field_name { pos; is_empty = false } ->
        invalid_shape_field_name pos
      | Invalid_shape_field_name { pos; is_empty = true } ->
        invalid_shape_field_name_empty pos
      | Invalid_shape_field_literal { pos; witness_pos } ->
        invalid_shape_field_literal pos witness_pos
      | Invalid_shape_field_const { pos; witness_pos } ->
        invalid_shape_field_const pos witness_pos
      | Shape_field_class_mismatch
          { pos; class_name; witness_pos; witness_class_name } ->
        shape_field_class_mismatch pos class_name witness_pos witness_class_name
      | Shape_field_type_mismatch { pos; ty_name; witness_pos; witness_ty_name }
        ->
        shape_field_type_mismatch pos ty_name witness_pos witness_ty_name
      | Invalid_shape_remove_key pos -> invalid_shape_remove_key pos
      | Shapes_key_exists_always_true { pos; field_name; decl_pos } ->
        shapes_key_exists_always_true pos field_name decl_pos
      | Shapes_key_exists_always_false { pos; field_name; decl_pos; reason } ->
        shapes_key_exists_always_false pos field_name decl_pos reason
      | Shapes_method_access_with_non_existent_field
          { pos; field_name; method_name; decl_pos; reason } ->
        shapes_method_access_with_non_existent_field
          pos
          field_name
          method_name
          decl_pos
          reason
      | Shapes_access_with_non_existent_field
          { pos; field_name; decl_pos; reason } ->
        shapes_access_with_non_existent_field pos field_name decl_pos reason
  end

  module Eval_enum = struct
    let enum_class_label_member_mismatch pos label expected_ty_msg_opt =
      let claim = lazy (pos, "Enum class label/member mismatch")
      and reasons =
        match expected_ty_msg_opt with
        | Some expected_ty_msg ->
          Lazy.map expected_ty_msg ~f:(fun expected_ty_msg ->
              expected_ty_msg
              @ [
                  ( Pos_or_decl.of_raw_pos pos,
                    Format.sprintf
                      "But got an enum class label/member: `%s`"
                      label );
                ])
        | None ->
          lazy
            [
              ( Pos_or_decl.of_raw_pos pos,
                Format.sprintf "Unexpected enum class label/member: `%s`" label
              );
            ]
      in
      (Error_code.UnifyError, claim, reasons, [])

    let enum_type_bad pos is_enum_class ty_name trail =
      let claim =
        Lazy.map ty_name ~f:(fun ty_name ->
            let ty = Markdown_lite.md_codify ty_name in
            let msg =
              if is_enum_class then
                "Invalid base type for an enum class: "
              else
                "Enums must be `int` or `string` or `arraykey`, not "
            in
            (pos, msg ^ ty))
      and reasons = lazy (Common.reasons_of_trail trail) in
      (Error_code.EnumTypeBad, claim, reasons, [])

    let enum_type_bad_case_type pos ty_name case_type_decl_pos =
      let claim =
        lazy
          (pos, "Cannot use a case type as the base type for an enum/enum class")
      and reasons =
        Lazy.map ty_name ~f:(fun ty_name ->
            let ty = Markdown_lite.md_codify ty_name in
            [(case_type_decl_pos, ty ^ " is declared as a case type here")])
      in
      (Error_code.EnumTypeBad, claim, reasons, [])

    let enum_constant_type_bad pos ty_pos ty_name trail =
      let claim = lazy (pos, "Enum constants must be an `int` or `string`")
      and reasons =
        Lazy.map ty_name ~f:(fun ty_name ->
            (ty_pos, "Not " ^ Markdown_lite.md_codify ty_name)
            :: Common.reasons_of_trail trail)
      in
      (Error_code.EnumConstantTypeBad, claim, reasons, [])

    let enum_type_typedef_nonnull pos =
      let claim =
        lazy (pos, "Can't use `typedef` that resolves to nonnull in enum")
      in
      (Error_code.EnumTypeTypedefNonnull, claim, lazy [], [])

    let enum_switch_redundant pos first_pos const_name =
      let const_name =
        Typing_error.Primary.Enum.Const.(to_user_string const_name)
      in
      let claim = lazy (pos, "Redundant `case` statement")
      and reason =
        lazy
          [
            ( Pos_or_decl.of_raw_pos first_pos,
              Markdown_lite.md_codify const_name ^ " already handled here" );
          ]
      in
      (Error_code.EnumSwitchRedundant, claim, reason, [])

    let enum_switch_nonexhaustive pos kind decl_pos missing =
      let open Typing_error.Primary.Enum.Const in
      let claim =
        lazy
          ( pos,
            "`switch` statement nonexhaustive; at least the following cases are missing: "
            ^ (List.map
                 ~f:(fun x ->
                   x |> opt_to_user_string |> Markdown_lite.md_codify)
                 missing
              |> String.concat ~sep:", ") )
      and reason =
        lazy
          begin
            match kind with
            | Some kind -> [(decl_pos, kind ^ " declared here")]
            | None ->
              if List.exists missing ~f:Option.is_none then
                [
                  ( decl_pos,
                    "only unions and intersections of bool, null and enums can be switched on without a default"
                  );
                ]
              else
                []
          end
      in
      (Error_code.EnumSwitchNonexhaustive, claim, reason, [])

    let enum_switch_redundant_default pos kind decl_pos =
      let claim =
        lazy
          ( pos,
            "All cases already covered; a redundant `default` case prevents "
            ^ "detecting future errors. If your goal is to guard against "
            ^ "invalid values for this type, do an `is` check before the switch."
          )
      and reason = lazy [(decl_pos, kind ^ " declared here")] in
      (Error_code.EnumSwitchRedundantDefault, claim, reason, [])

    let enum_switch_not_const pos =
      let claim =
        lazy
          ( pos,
            "Case in `switch` must be either an enum constant or a literal expression."
          )
      in
      (Error_code.EnumSwitchNotConst, claim, lazy [], [])

    let enum_switch_wrong_class pos kind expected actual exp_pos =
      let expected = Lazy.map ~f:Markdown_lite.md_codify expected in
      let claim =
        Lazy.bind expected ~f:(fun expected ->
            Lazy.map actual ~f:(fun actual ->
                ( pos,
                  "Switching on "
                  ^ kind
                  ^ expected
                  ^ " but using constant from "
                  ^ Markdown_lite.md_codify actual )))
      in
      let reason =
        Lazy.map expected ~f:(fun expected ->
            Option.value_map exp_pos ~default:[] ~f:(fun exp_pos ->
                [(exp_pos, "expecting " ^ expected ^ " based on this")]))
      in
      (Error_code.EnumSwitchWrongClass, claim, reason, [])

    let enum_switch_inconsistent_int_literal_format expected exp_pos actual pos
        =
      let claim =
        lazy
          ( pos,
            "This int literal is in "
            ^ Markdown_lite.md_codify actual
            ^ ", but was expecting it to be in "
            ^ Markdown_lite.md_codify expected )
      in
      let reason =
        lazy
          [
            ( Pos_or_decl.of_raw_pos exp_pos,
              "All int literals in this switch must be written in the same base as the first one"
            );
          ]
      in
      (Error_code.EnumSwitchWrongClass, claim, reason, [])

    let enum_class_label_unknown
        pos label_name enum_name decl_pos most_similar ty_pos =
      let enum_name = Markdown_lite.md_codify (Render.strip_ns enum_name) in

      let claim =
        lazy
          ( pos,
            Printf.sprintf
              "Enum class %s does not contain a label named %s."
              enum_name
              (Markdown_lite.md_codify label_name) )
      in

      let decl_reason =
        [(decl_pos, Printf.sprintf "%s is defined here" enum_name)]
      in
      let (similar_reason, quickfixes) =
        match most_similar with
        | Some (similar_name, similar_pos) ->
          ( [
              ( similar_pos,
                Printf.sprintf
                  "Did you mean %s?"
                  (Markdown_lite.md_codify similar_name) );
            ],
            [
              Quickfix.make
                ~title:("Change to " ^ Markdown_lite.md_codify similar_name)
                ~new_text:similar_name
                pos;
            ] )
        | None -> ([], [])
      in
      let ty_reason =
        match ty_pos with
        | Some ty_pos ->
          [
            ( ty_pos,
              Printf.sprintf
                "This is why I expected an enum class label from %s."
                enum_name );
          ]
        | None -> []
      in

      let reason = lazy (decl_reason @ similar_reason @ ty_reason) in
      (Error_code.EnumClassLabelUnknown, claim, reason, quickfixes)

    let enum_class_label_as_expr pos =
      let claim =
        lazy
          ( pos,
            "Not enough type information to infer the type of this enum class label."
          )
      in
      (Error_code.EnumClassLabelAsExpression, claim, lazy [], [])

    let incompatible_enum_inclusion_base pos classish_name src_classish_name =
      let claim =
        lazy
          ( pos,
            "Enum "
            ^ Render.strip_ns classish_name
            ^ " includes enum "
            ^ Render.strip_ns src_classish_name
            ^ " but their base types are incompatible" )
      in
      (Error_code.IncompatibleEnumInclusion, claim, lazy [], [])

    let incompatible_enum_inclusion_constraint
        pos classish_name src_classish_name =
      let claim =
        lazy
          ( pos,
            "Enum "
            ^ Render.strip_ns classish_name
            ^ " includes enum "
            ^ Render.strip_ns src_classish_name
            ^ " but their constraints are incompatible" )
      in
      (Error_code.IncompatibleEnumInclusion, claim, lazy [], [])

    let enum_inclusion_not_enum pos classish_name src_classish_name =
      let claim =
        lazy
          ( pos,
            "Enum "
            ^ Render.strip_ns classish_name
            ^ " includes "
            ^ Render.strip_ns src_classish_name
            ^ " which is not an enum" )
      in
      (Error_code.IncompatibleEnumInclusion, claim, lazy [], [])

    let to_error t ~env:_ =
      let open Typing_error.Primary.Enum in
      match t with
      | Enum_type_bad { pos; is_enum_class; ty_name; trail } ->
        enum_type_bad pos is_enum_class ty_name trail
      | Enum_type_bad_case_type { pos; ty_name; case_type_decl_pos } ->
        enum_type_bad_case_type pos ty_name case_type_decl_pos
      | Enum_constant_type_bad { pos; ty_pos; ty_name; trail } ->
        enum_constant_type_bad pos ty_pos ty_name trail
      | Enum_type_typedef_nonnull pos -> enum_type_typedef_nonnull pos
      | Enum_switch_redundant { pos; first_pos; const_name } ->
        enum_switch_redundant pos first_pos const_name
      | Enum_switch_nonexhaustive { pos; kind; decl_pos; missing } ->
        enum_switch_nonexhaustive pos kind decl_pos missing
      | Enum_switch_redundant_default { pos; kind; decl_pos } ->
        enum_switch_redundant_default pos kind decl_pos
      | Enum_switch_not_const pos -> enum_switch_not_const pos
      | Enum_switch_wrong_class { pos; kind; expected; actual; expected_pos } ->
        enum_switch_wrong_class pos kind expected actual expected_pos
      | Enum_switch_inconsistent_int_literal_format
          { expected; actual; expected_pos; pos } ->
        enum_switch_inconsistent_int_literal_format
          expected
          expected_pos
          actual
          pos
      | Enum_class_label_unknown
          { pos; label_name; enum_name; decl_pos; most_similar; ty_pos } ->
        enum_class_label_unknown
          pos
          label_name
          enum_name
          decl_pos
          most_similar
          ty_pos
      | Enum_class_label_as_expr pos -> enum_class_label_as_expr pos
      | Enum_class_label_member_mismatch { pos; label; expected_ty_msg_opt } ->
        enum_class_label_member_mismatch pos label expected_ty_msg_opt
      | Incompatible_enum_inclusion_base
          { pos; classish_name; src_classish_name } ->
        incompatible_enum_inclusion_base pos classish_name src_classish_name
      | Incompatible_enum_inclusion_constraint
          { pos; classish_name; src_classish_name } ->
        incompatible_enum_inclusion_constraint
          pos
          classish_name
          src_classish_name
      | Enum_inclusion_not_enum { pos; classish_name; src_classish_name } ->
        enum_inclusion_not_enum pos classish_name src_classish_name
  end

  module Eval_expr_tree = struct
    let expression_tree_non_public_member pos decl_pos =
      let claim =
        lazy (pos, "Cannot access non-public members within expression trees.")
      and reason = lazy [(decl_pos, "Member defined here")] in
      (Error_code.ExpressionTreeNonPublicProperty, claim, reason, [])

    let reified_static_method_in_expr_tree pos =
      let claim =
        lazy
          ( pos,
            "Static method calls on reified generics are not permitted in Expression Trees."
          )
      in
      (Error_code.ReifiedStaticMethodInExprTree, claim, lazy [], [])

    let this_var_in_expr_tree pos =
      let claim = lazy (pos, "`$this` is not bound inside expression trees") in
      (Error_code.ThisVarOutsideClass, claim, lazy [], [])

    let experimental_expression_trees pos =
      let claim =
        lazy
          ( pos,
            "This type is not permitted as an expression tree visitor. It is not included in "
            ^ "`allowed_expression_tree_visitors` in `.hhconfig`, and this file does not "
            ^ "contain `<<file:__EnableUnstableFeatures('expression_trees')>>`."
          )
      in
      (Error_code.ExperimentalExpressionTrees, claim, lazy [], [])

    let expression_tree_unsupported_operator pos member_name class_name =
      let claim =
        lazy
          ( pos,
            match member_name with
            | "__bool" ->
              (* If the user writes `if ($not_bool)`, provide a more specific
                 error rather than a generic missing method error for
                 `$not_bool->__bool()`. *)
              Printf.sprintf
                "`%s` cannot be used as a boolean (it has no instance method named `__bool`)"
                class_name
            | _ ->
              (* If the user writes `$not_int + ...`, provide a more specific
                 error rather than a generic missing method error for
                 `$not_int->__plus(...)`. *)
              Printf.sprintf
                "`%s` does not support this operator (it has no instance method named `%s`)"
                class_name
                member_name )
      in
      (Error_code.MemberNotFound, claim, lazy [], [])

    let to_error t ~env:_ =
      let open Typing_error.Primary.Expr_tree in
      match t with
      | Expression_tree_non_public_member { pos; decl_pos } ->
        expression_tree_non_public_member pos decl_pos
      | Reified_static_method_in_expr_tree pos ->
        reified_static_method_in_expr_tree pos
      | This_var_in_expr_tree pos -> this_var_in_expr_tree pos
      | Experimental_expression_trees pos -> experimental_expression_trees pos
      | Expression_tree_unsupported_operator { pos; member_name; class_name } ->
        expression_tree_unsupported_operator pos member_name class_name
  end

  module Eval_readonly = struct
    let readonly_modified pos reason_opt =
      let claim =
        lazy (pos, "This value is readonly, its properties cannot be modified")
      and reason =
        Option.value_map
          reason_opt
          ~default:(lazy [])
          ~f:(Lazy.map ~f:List.return)
      in
      (Error_code.ReadonlyValueModified, claim, reason, [])

    let readonly_mismatch pos what pos_sub pos_super =
      let (msg, msg_sub, msg_super) =
        match what with
        | `prop_assign ->
          ( "property assignment",
            "readonly",
            "But it's being assigned to a mutable property" )
        | `collection_mod ->
          ("collection modification", "readonly", "But this value is mutable")
        | `arg_readonly ->
          ( "argument",
            "readonly",
            "It is incompatible with this parameter, which is mutable" )
        | `arg_mut ->
          ( "argument",
            "mutable",
            "It is incompatible with this parameter, which is readonly" )
      in
      let claim = lazy (pos, Format.sprintf "Invalid %s" msg)
      and reason =
        lazy
          [
            (pos_sub, Format.sprintf "This expression is %s" msg_sub);
            (pos_super, msg_super);
          ]
      in
      (Error_code.ReadonlyMismatch, claim, reason, [])

    let readonly_invalid_as_mut pos =
      let claim =
        lazy
          ( pos,
            "Only value types and arrays can be converted to mutable. This value can never be a primitive."
          )
      in
      (Error_code.ReadonlyInvalidAsMut, claim, lazy [], [])

    let readonly_exception pos =
      let claim =
        lazy
          ( pos,
            "This exception is readonly; throwing readonly exceptions is not currently supported."
          )
      in
      (Error_code.ReadonlyException, claim, lazy [], [])

    let explicit_readonly_cast pos decl_pos kind =
      let qf_pos = Pos.shrink_to_start pos in
      let quickfixes =
        [Quickfix.make ~title:"Insert `readonly`" ~new_text:"readonly " qf_pos]
      in
      let kind_str =
        match kind with
        | `fn_call -> "function call"
        | `property -> "property"
        | `static_property -> "static property"
      in
      let claim =
        lazy
          ( pos,
            "This "
            ^ kind_str
            ^ " returns a readonly value. It must be explicitly wrapped in a readonly expression."
          )
      and reason = lazy [(decl_pos, "The " ^ kind_str ^ " is defined here.")] in
      (Error_code.ExplicitReadonlyCast, claim, reason, quickfixes)

    let readonly_method_call pos decl_pos =
      let claim =
        lazy
          ( pos,
            "This expression is readonly, so it can only call readonly methods"
          )
      and reason = lazy [(decl_pos, "This method is not readonly")] in
      (Error_code.ReadonlyMethodCall, claim, reason, [])

    let readonly_closure_call pos decl_pos suggestion =
      let claim =
        lazy
          ( pos,
            "This function is readonly, so it must be marked readonly at declaration time to be called."
          )
      and reason = lazy [(decl_pos, "Did you mean to " ^ suggestion ^ "?")] in
      (Error_code.ReadonlyClosureCall, claim, reason, [])

    let to_error t ~env:_ =
      let open Typing_error.Primary.Readonly in
      match t with
      | Readonly_modified { pos; reason_opt } ->
        readonly_modified pos reason_opt
      | Readonly_mismatch { pos; what; pos_sub; pos_super } ->
        readonly_mismatch pos what pos_sub pos_super
      | Readonly_invalid_as_mut pos -> readonly_invalid_as_mut pos
      | Readonly_exception pos -> readonly_exception pos
      | Explicit_readonly_cast { pos; decl_pos; kind } ->
        explicit_readonly_cast pos decl_pos kind
      | Readonly_method_call { pos; decl_pos } ->
        readonly_method_call pos decl_pos
      | Readonly_closure_call { pos; decl_pos; suggestion } ->
        readonly_closure_call pos decl_pos suggestion
  end

  module Eval_coeffect = struct
    let call_coeffect
        pos available_pos available_incl_unsafe required_pos required =
      let reasons =
        Common.map2
          available_incl_unsafe
          required
          ~f:(fun available_incl_unsafe required ->
            [
              ( available_pos,
                "From this declaration, the context of this function body provides "
                ^ available_incl_unsafe );
              ( required_pos,
                "But the function being called requires " ^ required );
            ])
      and claim =
        lazy
          ( pos,
            "This call is not allowed because its capabilities are incompatible with the context"
          )
      in
      (Error_code.CallCoeffects, claim, reasons, [])

    let op_coeffect_error
        pos op_name required available_pos locally_available suggestion err_code
        =
      let reasons =
        Common.map2
          (Option.value ~default:(lazy []) suggestion)
          locally_available
          ~f:(fun suggestion locally_available ->
            let x =
              ( available_pos,
                "The local (enclosing) context provides " ^ locally_available )
            in
            x :: suggestion)
      and claim =
        Lazy.map required ~f:(fun required ->
            ( pos,
              op_name
              ^ " requires "
              ^ required
              ^ ", which is not provided by the context." ))
      in
      (err_code, claim, reasons, [])

    let to_error t ~env:_ =
      let open Typing_error.Primary.Coeffect in
      match t with
      | Op_coeffect_error
          {
            pos;
            op_name;
            required;
            available_pos;
            locally_available;
            suggestion;
            err_code;
          } ->
        op_coeffect_error
          pos
          op_name
          required
          available_pos
          locally_available
          suggestion
          err_code
      | Call_coeffect
          { pos; available_pos; available_incl_unsafe; required_pos; required }
        ->
        call_coeffect
          pos
          available_pos
          available_incl_unsafe
          required_pos
          required
  end

  module Eval_wellformedness = struct
    let missing_return pos hint_pos is_async =
      let return_type =
        if is_async then
          "Awaitable<void>"
        else
          "void"
      in

      let quickfixes =
        match hint_pos with
        | None -> []
        | Some hint_pos ->
          [
            Quickfix.make
              ~title:("Change to " ^ Markdown_lite.md_codify return_type)
              ~new_text:"void"
              (Pos_or_decl.unsafe_to_raw_pos hint_pos);
          ]
      in
      let claim = lazy (pos, "Invalid return type") in

      (Error_code.MissingReturnInNonVoidFunction, claim, lazy [], quickfixes)

    let void_usage pos reason =
      let claim =
        lazy (pos, "You are using the return value of a `void` function")
      in
      (Error_code.VoidUsage, claim, reason, [])

    let noreturn_usage pos reason =
      let claim =
        lazy (pos, "You are using the return value of a `noreturn` function")
      in
      (Error_code.NoreturnUsage, claim, reason, [])

    let returns_with_and_without_value pos with_value_pos without_value_pos_opt
        =
      let claim =
        lazy (pos, "This function can exit with and without returning a value")
      and reason =
        lazy
          ((Pos_or_decl.of_raw_pos with_value_pos, "Returning a value here.")
          :: Option.value_map
               without_value_pos_opt
               ~default:
                 [
                   ( Pos_or_decl.of_raw_pos pos,
                     "This function does not always return a value" );
                 ]
               ~f:(fun p ->
                 [(Pos_or_decl.of_raw_pos p, "Returning without a value here")])
          )
      in
      (Error_code.ReturnsWithAndWithoutValue, claim, reason, [])

    let non_void_annotation_on_return_void_function is_async hint_pos =
      let (async_indicator, return_type) =
        if is_async then
          ("Async f", "Awaitable<void>")
        else
          ("F", "void")
      in
      let claim =
        lazy
          ( hint_pos,
            Printf.sprintf
              "%sunctions that do not return a value must have a type of %s"
              async_indicator
              return_type )
      in
      let quickfixes =
        [
          Quickfix.make
            ~title:("Change to " ^ Markdown_lite.md_codify return_type)
            ~new_text:return_type
            hint_pos;
        ]
      in

      (Error_code.NonVoidAnnotationOnReturnVoidFun, claim, lazy [], quickfixes)

    let tuple_syntax p =
      ( Error_code.TupleSyntax,
        lazy (p, "Did you want a *tuple*? Try `(X,Y)`, not `tuple<X,Y>`"),
        lazy [],
        [] )

    let invalid_class_refinement pos =
      ( Error_code.InvalidClassRefinement,
        lazy (pos, "Invalid class refinement"),
        lazy [],
        [] )

    let to_error t ~env:_ =
      let open Typing_error.Primary.Wellformedness in
      match t with
      | Missing_return { pos; hint_pos; is_async } ->
        missing_return pos hint_pos is_async
      | Void_usage { pos; reason } -> void_usage pos reason
      | Noreturn_usage { pos; reason } -> noreturn_usage pos reason
      | Returns_with_and_without_value
          { pos; with_value_pos; without_value_pos_opt } ->
        returns_with_and_without_value pos with_value_pos without_value_pos_opt
      | Non_void_annotation_on_return_void_function { is_async; hint_pos } ->
        non_void_annotation_on_return_void_function is_async hint_pos
      | Tuple_syntax pos -> tuple_syntax pos
      | Invalid_class_refinement { pos } -> invalid_class_refinement pos
  end

  module Eval_modules = struct
    let module_hint pos decl_pos =
      let claim = lazy (pos, "You cannot use this type in a public declaration.")
      and reason = lazy [(decl_pos, "It is declared as `internal` here")] in
      (Error_code.ModuleHintError, claim, reason, [])

    let module_mismatch pos current_module_opt decl_pos target_module =
      let claim =
        lazy
          ( pos,
            Printf.sprintf
              "Cannot access an internal element from module `%s` %s"
              target_module
              (match current_module_opt with
              | Some m -> Printf.sprintf "in module `%s`" m
              | None -> "in the default module") )
      and reason =
        lazy
          [(decl_pos, Printf.sprintf "This is from module `%s`" target_module)]
      in
      (Error_code.ModuleError, claim, reason, [])

    let module_unsafe_trait_access access_pos trait_pos =
      ( Error_code.ModuleError,
        lazy
          ( access_pos,
            "Cannot access `internal` members inside a non-internal trait" ),
        lazy
          [
            ( trait_pos,
              "This trait must be made `internal` to access other internal members"
            );
          ],
        [] )

    let module_missing_import
        pos decl_pos module_pos current_module target_module_opt =
      let target_module =
        match target_module_opt with
        | Some m -> m
        | None -> "global"
      in
      let claim =
        lazy
          ( pos,
            Printf.sprintf
              "Cannot access a public element from module '%s' in module '%s'"
              target_module
              current_module )
      and reason =
        lazy
          [
            (decl_pos, Printf.sprintf "This is from module `%s`" target_module);
            ( module_pos,
              Printf.sprintf
                "Module '%s' does not import the public members of module '%s'"
                current_module
                target_module );
          ]
      in
      (Error_code.ModuleError, claim, reason, [])

    let module_missing_export
        pos decl_pos module_pos current_module_opt target_module =
      let current_module =
        match current_module_opt with
        | Some m -> m
        | None -> "global"
      in
      let claim =
        lazy
          ( pos,
            Printf.sprintf
              "Cannot access a public element from module '%s' in module '%s'"
              target_module
              current_module )
      and reason =
        lazy
          [
            (decl_pos, Printf.sprintf "This is from module `%s`" target_module);
            ( module_pos,
              Printf.sprintf
                "Module '%s' does not export its public members to module '%s'"
                target_module
                current_module );
          ]
      in
      (Error_code.ModuleError, claim, reason, [])

    let get_module_str m_opt =
      match m_opt with
      | Some s -> Printf.sprintf "module `%s`" s
      | None -> "the default module"

    let get_package_str p_opt =
      match p_opt with
      | Some s -> Printf.sprintf "package `%s`" s
      | None -> "the default package"

    let module_cross_pkg_call
        (pos : Pos.t)
        (decl_pos : Pos_or_decl.t)
        (current_package_opt : string option)
        (target_package_opt : string option) =
      let current_package = get_package_str current_package_opt in
      let target_package =
        match target_package_opt with
        | Some s -> s
        | None ->
          failwith "target package can't be default for cross_package call"
      in
      let claim =
        lazy
          ( pos,
            Printf.sprintf
              "Cannot reference this CrossPackage method defined in package %s from %s"
              target_package
              current_package )
      and reason =
        lazy
          [
            ( decl_pos,
              Printf.sprintf
                "This function is marked cross package, so requires the package %s to be loaded. You can check if package %s is loaded by placing this call inside a block like `if(package %s)`"
                target_package
                target_package
                target_package );
          ]
      in
      (Error_code.InvalidCrossPackage, claim, reason, [])

    let module_cross_pkg_access
        (pos : Pos.t)
        (decl_pos : Pos_or_decl.t)
        (module_pos : Pos_or_decl.t)
        (package_pos : Pos.t)
        (current_module_opt : string option)
        (current_package_opt : string option)
        (target_module_opt : string option)
        (target_package_opt : string option)
        (soft : bool) =
      let current_module = get_module_str current_module_opt in
      let target_module = get_module_str target_module_opt in
      let current_package = get_package_str current_package_opt in
      let target_package = get_package_str target_package_opt in
      let is_default = Pos.equal Pos.none package_pos in
      let relationship =
        if soft then
          "only soft includes"
        else
          "does not include"
      in
      let module_missing = Pos_or_decl.equal Pos_or_decl.none module_pos in
      let claim =
        lazy
          ( pos,
            Printf.sprintf
              "Cannot access a public element which belongs to %s from %s"
              target_package
              current_package )
      and reason =
        lazy
          [
            ( decl_pos,
              Printf.sprintf
                "This is from %s, which belongs to %s"
                target_module
                target_package );
            ( module_pos,
              Printf.sprintf
                "But %s%s %s"
                current_module
                (if module_missing then
                  " is undefined, though it would belong to"
                else
                  " belongs to")
                current_package );
            ( (if is_default then
                module_pos
              else
                Pos_or_decl.of_raw_pos package_pos),
              Printf.sprintf
                "And %s %s %s"
                current_package
                relationship
                target_package );
          ]
      in
      let error_code =
        if soft then
          Error_code.InvalidCrossPackageSoft
        else
          Error_code.InvalidCrossPackage
      in
      (error_code, claim, reason, [])

    let to_error t ~env:_ =
      let open Typing_error.Primary.Modules in
      match t with
      | Module_hint { pos; decl_pos } -> module_hint pos decl_pos
      | Module_mismatch { pos; current_module_opt; decl_pos; target_module } ->
        module_mismatch pos current_module_opt decl_pos target_module
      | Module_unsafe_trait_access { access_pos; trait_pos } ->
        module_unsafe_trait_access access_pos trait_pos
      | Module_missing_import
          { pos; decl_pos; module_pos; current_module; target_module_opt } ->
        module_missing_import
          pos
          decl_pos
          module_pos
          current_module
          target_module_opt
      | Module_missing_export
          { pos; decl_pos; module_pos; current_module_opt; target_module } ->
        module_missing_export
          pos
          decl_pos
          module_pos
          current_module_opt
          target_module
      | Module_cross_pkg_call
          { pos; decl_pos; current_package_opt; target_package_opt } ->
        module_cross_pkg_call
          pos
          decl_pos
          current_package_opt
          target_package_opt
      | Module_cross_pkg_access
          {
            pos;
            decl_pos;
            module_pos;
            package_pos;
            current_module_opt;
            current_package_opt;
            target_module_opt;
            target_package_opt;
          } ->
        module_cross_pkg_access
          pos
          decl_pos
          module_pos
          package_pos
          current_module_opt
          current_package_opt
          target_module_opt
          target_package_opt
          false (* Soft *)
      | Module_soft_included_access
          {
            pos;
            decl_pos;
            module_pos;
            package_pos;
            current_module_opt;
            current_package_opt;
            target_module_opt;
            target_package_opt;
          } ->
        module_cross_pkg_access
          pos
          decl_pos
          module_pos
          package_pos
          current_module_opt
          current_package_opt
          target_module_opt
          target_package_opt
          true (* Soft *)
  end

  module Eval_xhp = struct
    let xhp_required pos why_xhp ty_reason_msg =
      let claim = lazy (pos, "An XHP instance was expected") in
      ( Error_code.XhpRequired,
        claim,
        Lazy.map ty_reason_msg ~f:(fun ty_reason_msg ->
            (Pos_or_decl.of_raw_pos pos, why_xhp) :: ty_reason_msg),
        [] )

    let illegal_xhp_child pos ty_reason_msg =
      let claim = lazy (pos, "XHP children must be compatible with XHPChild") in
      (Error_code.IllegalXhpChild, claim, ty_reason_msg, [])

    let missing_xhp_required_attr pos attr ty_reason_msg =
      let claim =
        lazy
          ( pos,
            "Required attribute "
            ^ Markdown_lite.md_codify attr
            ^ " is missing." )
      in
      (Error_code.MissingXhpRequiredAttr, claim, ty_reason_msg, [])

    let to_error t ~env:_ =
      let open Typing_error.Primary.Xhp in
      match t with
      | Xhp_required { pos; why_xhp; ty_reason_msg } ->
        xhp_required pos why_xhp ty_reason_msg
      | Illegal_xhp_child { pos; ty_reason_msg } ->
        illegal_xhp_child pos ty_reason_msg
      | Missing_xhp_required_attr { pos; attr; ty_reason_msg } ->
        missing_xhp_required_attr pos attr ty_reason_msg
  end

  module Eval_casetype = struct
    let overlapping_variant_types pos name why =
      let claim =
        lazy
          ( pos,
            let name = Utils.strip_ns name in
            "Invalid case type declaration. More than one variant of "
            ^ Markdown_lite.md_codify name
            ^ " could contain values with the same runtime tag" )
      in
      (Error_code.IllegalCaseTypeVariants, claim, why, [])

    let to_error t ~env:_ =
      let open Typing_error.Primary.CaseType in
      match t with
      | Overlapping_variant_types { pos; name; why } ->
        overlapping_variant_types pos name why
  end

  let unify_error pos msg_opt reasons_opt =
    let claim = lazy (pos, Option.value ~default:"Typing error" msg_opt)
    and reasons = Option.value ~default:(lazy []) reasons_opt in
    (Error_code.UnifyError, claim, reasons, [])

  let generic_unify pos msg =
    let claim = lazy (pos, msg) in
    (Error_code.GenericUnify, claim, lazy [], [])

  let unresolved_tyvar pos =
    let claim =
      lazy
        (pos, "The type of this expression contains an unresolved type variable")
    in
    (Error_code.UnresolvedTypeVariable, claim, lazy [], [])

  let using_error pos has_await =
    let claim =
      lazy
        (let (note, cls) =
           if has_await then
             (" with await", Naming_special_names.Classes.cIAsyncDisposable)
           else
             ("", Naming_special_names.Classes.cIDisposable)
         in
         ( pos,
           Printf.sprintf
             "This expression is used in a `using` clause%s so it must have type `%s`"
             note
             cls ))
    in
    (Error_code.UnifyError, claim, lazy [], [])

  let bad_enum_decl pos =
    ( Error_code.BadEnumExtends,
      lazy (pos, "This enum declaration is invalid."),
      lazy [],
      [] )

  let bad_conditional_support_dynamic pos child parent ty_name self_ty_name =
    let claim =
      Lazy.(
        ty_name >>= fun ty_name ->
        self_ty_name >>= fun self_ty_name ->
        let statement =
          ty_name
          ^ " is subtype of dynamic implies "
          ^ self_ty_name
          ^ " is subtype of dynamic"
        in
        return
          ( pos,
            "Class "
            ^ Render.strip_ns child
            ^ " must support dynamic at least as often as "
            ^ Render.strip_ns parent
            ^ ":\n"
            ^ statement ))
    in
    (Error_code.BadConditionalSupportDynamic, claim, lazy [], [])

  let bad_decl_override name parent_pos parent_name =
    ( Error_code.BadDeclOverride,
      lazy
        ( parent_pos,
          Printf.sprintf
            "Some members in class %s are incompatible with those declared in type %s"
            (Render.strip_ns name |> Markdown_lite.md_codify)
            (Render.strip_ns parent_name |> Markdown_lite.md_codify) ),
      lazy [],
      [] )

  let explain_where_constraint pos decl_pos in_class =
    ( Error_code.TypeConstraintViolation,
      lazy (pos, "A `where` type constraint is violated here"),
      lazy
        [
          ( decl_pos,
            Printf.sprintf "This is the %s with `where` type constraints"
            @@
            if in_class then
              "class"
            else
              "method" );
        ],
      [] )

  let explain_constraint pos =
    ( Error_code.TypeConstraintViolation,
      lazy (pos, "Some type arguments violate their constraints"),
      lazy [],
      [] )

  let rigid_tvar_escape pos what =
    ( Error_code.RigidTVarEscape,
      lazy (pos, "Rigid type variable escapes its " ^ what),
      lazy [],
      [] )

  let invalid_type_hint pos =
    (Error_code.InvalidTypeHint, lazy (pos, "Invalid type hint"), lazy [], [])

  let unsatisfied_req pos trait_pos req_name req_pos =
    let reasons =
      lazy
        (let r =
           ( trait_pos,
             "This requires to extend or implement " ^ Render.strip_ns req_name
           )
         in
         if Pos_or_decl.equal trait_pos req_pos then
           [r]
         else
           [r; (req_pos, "Required here")])
    and claim =
      lazy
        ( pos,
          "This class does not satisfy all the requirements of its traits or interfaces."
        )
    in
    (Error_code.UnsatisfiedReq, claim, reasons, [])

  let unsatisfied_req_class pos trait_pos req_name req_pos =
    let reasons =
      lazy
        (let r =
           (trait_pos, "This requires to be exactly " ^ Render.strip_ns req_name)
         in
         if Pos_or_decl.equal trait_pos req_pos then
           [r]
         else
           [r; (req_pos, "Required here")])
    and claim =
      lazy
        ( pos,
          "This class does not satisfy all the requirements of its traits or interfaces."
        )
    in
    (Error_code.UnsatisfiedReq, claim, reasons, [])

  let req_class_not_final pos trait_pos req_pos =
    let reasons =
      lazy
        (let r =
           (trait_pos, "The trait with a require class constraint is used here")
         in
         if Pos_or_decl.equal trait_pos req_pos then
           [r]
         else
           [r; (req_pos, "The require class constraint is here")])
    and claim =
      lazy
        ( pos,
          "This class must be final because it uses a trait with a require class constraint."
        )
    in
    (Error_code.UnsatisfiedReq, claim, reasons, [])

  let incompatible_reqs pos req_name req_class_pos req_extends_pos =
    let reasons =
      lazy
        (let r1 =
           ( req_class_pos,
             "This requires exactly class " ^ Render.strip_ns req_name )
         in
         let r2 =
           ( req_extends_pos,
             "This requires a subtype of class " ^ Render.strip_ns req_name )
         in
         [r1; r2])
    in
    let claim = lazy (pos, "This trait defines incompatible requirements.") in
    (Error_code.UnsatisfiedReq, claim, reasons, [])

  let trait_not_used pos trait_name req_class_pos class_pos class_name =
    let class_name = Render.strip_ns class_name in
    let reasons =
      lazy
        [
          (class_pos, "Class " ^ class_name ^ " is defined here.");
          (req_class_pos, "The require class requirement is here.");
        ]
    in
    let claim =
      lazy
        ( pos,
          "Trait "
          ^ Render.strip_ns trait_name
          ^ " requires class "
          ^ Render.strip_ns class_name
          ^ " but "
          ^ Render.strip_ns class_name
          ^ " does not use it. Either use the trait or delete it." )
    in
    (Error_code.TraitNotUsed, claim, reasons, [])

  let invalid_echo_argument pos =
    let claim =
      lazy
        ( pos,
          "Invalid "
          ^ Markdown_lite.md_codify "echo"
          ^ "/"
          ^ Markdown_lite.md_codify "print"
          ^ " argument" )
    in
    (Error_code.InvalidEchoArgument, claim, lazy [], [])

  let index_type_mismatch pos is_covariant_container msg_opt reasons_opt =
    let code =
      if is_covariant_container then
        Error_code.CovariantIndexTypeMismatch
      else
        Error_code.IndexTypeMismatch
    and claim =
      lazy (pos, Option.value ~default:"Invalid index expression" msg_opt)
    and reasons = Option.value reasons_opt ~default:(lazy []) in
    (code, claim, reasons, [])

  let member_not_found pos kind member_name class_name class_pos hint reason =
    let kind_str =
      match kind with
      | `method_ -> "instance method"
      | `property -> "property"
    in
    let claim =
      lazy
        ( pos,
          Printf.sprintf
            "No %s %s in %s"
            kind_str
            (Markdown_lite.md_codify member_name)
            (Markdown_lite.md_codify @@ Render.strip_ns class_name) )
    in
    let default =
      Lazy.map reason ~f:(fun reason ->
          reason
          @ [
              ( class_pos,
                "Declaration of "
                ^ (Markdown_lite.md_codify @@ Render.strip_ns class_name)
                ^ " is here" );
            ])
    in
    let reasons =
      Option.value_map hint ~default ~f:(function
          | (`instance, pos, v) ->
            Lazy.map default ~f:(fun default ->
                Render.suggestion_message member_name v pos :: default)
          | (`static, pos, v) ->
            let modifier =
              match kind with
              | `method_ -> "static method "
              | `property -> "static property "
            in
            Lazy.map default ~f:(fun default ->
                Render.suggestion_message member_name ~modifier v pos :: default))
    in
    let quickfixes =
      Option.value_map hint ~default:[] ~f:(fun (_, _, new_text) ->
          [Quickfix.make ~title:("Change to ->" ^ new_text) ~new_text pos])
    in
    (Error_code.MemberNotFound, claim, reasons, quickfixes)

  let construct_not_instance_method pos =
    let claim =
      lazy
        ( pos,
          "`__construct` is not an instance method and shouldn't be invoked directly"
        )
    in
    (Error_code.ConstructNotInstanceMethod, claim, lazy [], [])

  let ambiguous_inheritance pos origin class_name =
    let claim =
      lazy
        ( pos,
          "This declaration was inherited from an object of type "
          ^ Markdown_lite.md_codify origin
          ^ ". Redeclare this member in "
          ^ Markdown_lite.md_codify class_name
          ^ " with a compatible signature." )
    in
    (Error_code.UnifyError, claim, lazy [], [])

  let expected_tparam pos n decl_pos =
    let claim =
      lazy
        ( pos,
          "Expected "
          ^
          match n with
          | 0 -> "no type parameters"
          | 1 -> "exactly one type parameter"
          | n -> string_of_int n ^ " type parameters" )
    and reasons = lazy [(decl_pos, "Definition is here")] in
    (Error_code.ExpectedTparam, claim, reasons, [])

  let typeconst_concrete_concrete_override pos decl_pos =
    let reasons = lazy [(decl_pos, "Previously defined here")]
    and claim = lazy (pos, "Cannot re-declare this type constant") in
    (Error_code.TypeconstConcreteConcreteOverride, claim, reasons, [])

  let constant_multiple_concrete_conflict pos name definitions =
    let reasons =
      lazy
        (List.mapi
           ~f:(fun i (p, via) ->
             let first =
               if i = 0 then
                 "One"
               else
                 "Another"
             in
             let message =
               Format.sprintf "%s conflicting definition is here" first
             in
             let full_message =
               match via with
               | Some parent_name ->
                 Format.sprintf "%s, inherited through %s" message parent_name
               | None -> message
             in
             (p, full_message))
           definitions)
    in

    let claim =
      lazy
        ( pos,
          Format.sprintf
            "Constant %s is defined concretely in multiple ancestors"
            name )
    in
    (Error_code.ConcreteConstInterfaceOverride, claim, reasons, [])

  let invalid_memoized_param pos reason =
    let claim =
      lazy
        ( pos,
          "Parameters to memoized function must be null, bool, int, float, string, an object deriving IMemoizeParam, or a Container thereof. See also http://docs.hhvm.com/hack/attributes/special#__memoize"
        )
    in
    (Error_code.InvalidMemoizedParam, claim, reason, [])

  let invalid_arraykey
      pos container_pos container_ty_name key_pos key_ty_name ctxt =
    let reasons =
      lazy
        [
          (container_pos, "This container is " ^ container_ty_name);
          ( key_pos,
            String.capitalize key_ty_name
            ^ " cannot be used as a key for "
            ^ container_ty_name );
        ]
    and claim =
      lazy (pos, "This value is not a valid key type for this container")
    and code =
      Error_code.(
        match ctxt with
        | `read -> IndexTypeMismatch
        | `write -> InvalidArrayKeyWrite)
    in
    (code, claim, reasons, [])

  let invalid_keyset_value
      pos container_pos container_ty_name value_pos value_ty_name =
    let reasons =
      lazy
        [
          (container_pos, "This container is " ^ container_ty_name);
          (value_pos, String.capitalize value_ty_name ^ " is not an arraykey");
        ]
    and claim = lazy (pos, "Keyset values must be arraykeys") in
    (Error_code.IndexTypeMismatch, claim, reasons, [])

  let invalid_set_value
      pos container_pos container_ty_name value_pos value_ty_name =
    let reasons =
      lazy
        [
          (container_pos, "This container is " ^ container_ty_name);
          (value_pos, String.capitalize value_ty_name ^ " is not an arraykey");
        ]
    and claim = lazy (pos, "Set values must be arraykeys") in
    (Error_code.IndexTypeMismatch, claim, reasons, [])

  let hkt_alias_with_implicit_constraints
      pos
      typedef_name
      typedef_pos
      used_class_in_def_pos
      used_class_in_def_name
      used_class_tparam_name
      typedef_tparam_name =
    let reasons =
      lazy
        [
          ( typedef_pos,
            "The definition of " ^ Render.strip_ns typedef_name ^ " is here." );
          ( used_class_in_def_pos,
            "The definition of "
            ^ Render.strip_ns typedef_name
            ^ " relies on "
            ^ Render.strip_ns used_class_in_def_name
            ^ " and the constraints that "
            ^ Render.strip_ns used_class_in_def_name
            ^ " imposes on its type parameter "
            ^ Render.strip_ns used_class_tparam_name
            ^ " then become implicit constraints on the type parameter "
            ^ typedef_tparam_name
            ^ " of "
            ^ Render.strip_ns typedef_name
            ^ "." );
        ]
    and claim =
      lazy
        ( pos,
          Format.sprintf
            "The type %s implicitly imposes constraints on its type parameters. Therefore, it cannot be used as a higher-kinded type at this time."
          @@ Render.strip_ns typedef_name )
    in
    (Error_code.HigherKindedTypesUnsupportedFeature, claim, reasons, [])

  let hkt_wildcard pos =
    let claim =
      lazy
        ( pos,
          "You are supplying _ where a higher-kinded type is expected."
          ^ " We cannot infer higher-kinded type arguments at this time, please state the actual type."
        )
    in
    (Error_code.HigherKindedTypesUnsupportedFeature, claim, lazy [], [])

  let hkt_implicit_argument pos decl_pos param_name =
    let param_desc =
      (* This should be Naming_special_names.Typehints.wildcard, but its not available in this
         module *)
      if String.equal param_name "_" then
        "the anonymous generic parameter"
      else
        "the generic parameter " ^ param_name
    in
    let claim =
      lazy
        ( pos,
          "You left out the type arguments here such that they may be inferred."
          ^ " However, a higher-kinded type is expected in place of "
          ^ param_desc
          ^ ", meaning that the type arguments cannot be inferred."
          ^ " Please provide the type arguments explicitly." )
    and reasons =
      lazy
        [
          ( decl_pos,
            Format.sprintf
              {|%s was declared to be higher-kinded here.|}
              param_desc );
        ]
    in
    (Error_code.HigherKindedTypesUnsupportedFeature, claim, reasons, [])

  let invalid_substring pos ty_name =
    let claim =
      lazy
        ( pos,
          "Expected an object convertible to string but got "
          ^ Lazy.force ty_name )
    in
    (Error_code.InvalidSubString, claim, lazy [], [])

  let nullable_cast pos ty_pos ty_name =
    let reasons =
      Lazy.map ty_name ~f:(fun ty_name ->
          [(ty_pos, "This is " ^ Markdown_lite.md_codify ty_name)])
    and claim = lazy (pos, "Casting from a nullable type is forbidden") in
    (Error_code.NullableCast, claim, reasons, [])

  let hh_expect pos equivalent =
    let (claim, error_code) =
      if equivalent then
        ( lazy (pos, "hh_expect_equivalent type mismatch"),
          Error_code.HHExpectEquivalentFailure )
      else
        (lazy (pos, "hh_expect type mismatch"), Error_code.HHExpectFailure)
    in

    (error_code, claim, lazy [], [])

  let null_member pos ~obj_pos_opt ctxt kind member_name reason =
    let claim =
      lazy
        ( pos,
          Printf.sprintf
            "You are trying to access the %s %s but this object can be null."
            (match kind with
            | `method_ -> "method"
            | `property -> "property")
            (Markdown_lite.md_codify member_name) )
    in
    let error_code =
      match ctxt with
      | `read -> Error_code.NullMemberRead
      | `write -> Error_code.NullMemberWrite
    in
    let quickfixes =
      match obj_pos_opt with
      | Some obj_pos ->
        let (obj_pos_start_line, _) = Pos.line_column obj_pos in
        let (rhs_pos_start_line, rhs_pos_start_column) = Pos.line_column pos in
        (*
        heuristic: if the lhs and rhs of the Objget are on the same line, then we assume they are
        separated by two characters (`->`). So we do not generate a quickfix for chained Objgets:
        ```
        obj
        ->rhs
        ```
      *)
        if obj_pos_start_line = rhs_pos_start_line then
          let width = 2 (* length of "->" *) in
          let quickfix_pos =
            pos
            |> Pos.set_col_start (rhs_pos_start_column - width)
            |> Pos.set_col_end rhs_pos_start_column
          in
          [
            Quickfix.make ~title:"Add null-safe get" ~new_text:"?->" quickfix_pos;
          ]
        else
          []
      | None -> []
    in
    (error_code, claim, reason, quickfixes)

  let typing_too_many_args pos decl_pos actual expected =
    let (code, claim, reasons) =
      Common.typing_too_many_args pos decl_pos actual expected
    in
    (code, claim, reasons, [])

  let typing_too_few_args pos decl_pos actual expected =
    let (code, claim, reasons) =
      Common.typing_too_few_args pos decl_pos actual expected
    in
    (code, claim, reasons, [])

  let non_object_member pos ctxt ty_name member_name kind decl_pos =
    let (code, claim, reasons) =
      Common.non_object_member
        pos
        ctxt
        (Lazy.force ty_name)
        member_name
        kind
        decl_pos
    in
    (code, claim, reasons, [])

  let static_instance_intersection
      class_pos instance_pos static_pos member_name kind =
    let claim =
      lazy
        ( class_pos,
          "This class overrides some members with a different staticness" )
    in
    ( Error_code.StaticDynamic,
      claim,
      lazy
        [
          ( Lazy.force instance_pos,
            "The "
            ^ (match kind with
              | `meth -> "method"
              | `prop -> "property")
            ^ " "
            ^ Markdown_lite.md_codify member_name
            ^ " is declared as non-static here" );
          ( Lazy.force static_pos,
            "But it conflicts with an inherited static declaration here" );
        ],
      [] )

  let nullsafe_property_write_context pos =
    let claim =
      lazy
        ( pos,
          "`?->` syntax not supported here, this function effectively does a write"
        )
    in
    (Error_code.NullsafePropertyWriteContext, claim, lazy [], [])

  let uninstantiable_class pos class_name reason_ty_opt decl_pos =
    let default_claim =
      lazy
        ( pos,
          Markdown_lite.md_codify (Render.strip_ns class_name)
          ^ " is uninstantiable" )
    and default_reasons = lazy [(decl_pos, "Declaration is here")] in
    let (claim, reasons) =
      match reason_ty_opt with
      | Some (reason_pos, ty_name) ->
        let claim =
          Lazy.map ty_name ~f:(fun ty_name ->
              ( reason_pos,
                "This would be " ^ ty_name ^ " which must be instantiable" ))
        and reasons =
          Lazy.(
            default_claim >>= fun claim ->
            default_reasons >>= fun reasons ->
            return (Message.map ~f:Pos_or_decl.of_raw_pos claim :: reasons))
        in
        (claim, reasons)
      | _ -> (default_claim, default_reasons)
    in
    (Error_code.UninstantiableClass, claim, reasons, [])

  let abstract_const_usage pos name decl_pos =
    let claim =
      lazy
        ( pos,
          "Cannot reference abstract constant "
          ^ Markdown_lite.md_codify (Render.strip_ns name)
          ^ " directly" )
    and reason = lazy [(decl_pos, "Declaration is here")] in
    (Error_code.AbstractConstUsage, claim, reason, [])

  let type_arity_mismatch pos decl_pos actual expected =
    let claim =
      lazy
        ( pos,
          Printf.sprintf
            "Wrong number of type arguments (expected %d, got %d)"
            expected
            actual )
    and reasons = lazy [(decl_pos, "Definition is here")] in
    (Error_code.TypeArityMismatch, claim, reasons, [])

  let member_not_implemented parent_pos member_name decl_pos quickfixes =
    let claim = lazy (parent_pos, "This interface is not properly implemented")
    and reasons =
      lazy
        [
          ( decl_pos,
            Printf.sprintf
              "Method %s does not have an implementation"
              (Markdown_lite.md_codify member_name) );
        ]
    in
    (Error_code.MemberNotImplemented, claim, reasons, quickfixes)

  let kind_mismatch pos decl_pos tparam_name expected_kind actual_kind =
    let claim =
      lazy
        ( pos,
          "This is "
          ^ actual_kind
          ^ ", but "
          ^ expected_kind
          ^ " was expected here." )
    and reason =
      lazy
        [
          ( decl_pos,
            "We are expecting "
            ^ expected_kind
            ^ " due to the definition of "
            ^ tparam_name
            ^ " here." );
        ]
    in
    (Error_code.KindMismatch, claim, reason, [])

  let trait_parent_construct_inconsistent pos decl_pos =
    let claim =
      lazy
        ( pos,
          "This use of `parent::__construct` requires that the parent class be marked <<__ConsistentConstruct>>"
        )
    and reason = lazy [(decl_pos, "Parent definition is here")] in
    (Error_code.TraitParentConstructInconsistent, claim, reason, [])

  let top_member pos ctxt ty_name decl_pos kind name is_nullable ty_reasons =
    let claim =
      Lazy.map ty_name ~f:(fun ty_name ->
          let kind_str =
            match kind with
            | `method_ -> "method"
            | `property -> "property"
          in
          ( pos,
            Printf.sprintf
              "You are trying to access the %s %s but this is %s. Use a **specific** class or interface name."
              kind_str
              (Markdown_lite.md_codify name)
              ty_name ))
    and reason =
      lazy
        begin
          let reasons = Lazy.force ty_reasons in
          if List.is_empty reasons then
            [(decl_pos, "Definition is here")]
          else
            reasons
        end
    and code =
      Error_code.(
        match ctxt with
        | `read when is_nullable -> NullMemberRead
        | `write when is_nullable -> NullMemberWrite
        | `read -> NonObjectMemberRead
        | `write -> NonObjectMemberWrite)
    in
    (code, claim, reason, [])

  let unresolved_tyvar_projection pos proj_pos tconst_name =
    let claim =
      lazy
        ( pos,
          "Can't access a type constant "
          ^ tconst_name
          ^ " from an unresolved type" )
    and reason =
      lazy
        [
          (proj_pos, "Access happens here");
          ( Pos_or_decl.of_raw_pos pos,
            "Disambiguate the types using explicit type annotations here." );
        ]
    in
    (Error_code.UnresolvedTypeVariableProjection, claim, reason, [])

  let cyclic_class_constant pos class_name const_name =
    let claim =
      lazy
        ( pos,
          "Cannot declare self-referencing constant "
          ^ const_name
          ^ " in "
          ^ Render.strip_ns class_name )
    in
    (Error_code.CyclicClassConstant, claim, lazy [], [])

  let inout_annotation_missing pos1 pos2 =
    let claim = lazy (pos1, "This argument should be annotated with `inout`") in
    let reason = lazy [(pos2, "Because this is an `inout` parameter")] in
    let pos = Pos.shrink_to_start pos1 in

    ( Error_code.InoutAnnotationMissing,
      claim,
      reason,
      [Quickfix.make ~title:"Insert `inout` annotation" ~new_text:"inout " pos]
    )

  let inout_annotation_unexpected pos1 pos2 pos2_is_variadic pos3 =
    let claim = lazy (pos1, "Unexpected `inout` annotation for argument") in
    let reason =
      lazy
        [
          ( pos2,
            if pos2_is_variadic then
              "A variadic parameter can never be `inout`"
            else
              "This is a normal parameter (does not have `inout`)" );
        ]
    in
    ( Error_code.InoutAnnotationUnexpected,
      claim,
      reason,
      [Quickfix.make ~title:"Remove `inout` annotation" ~new_text:"" pos3] )

  let inout_argument_bad_type pos reasons =
    let claim =
      lazy
        ( pos,
          "Expected argument marked `inout` to be contained in a local or "
          ^ "a value-typed container (e.g. vec, dict, keyset, array). "
          ^ "To use `inout` here, assign to/from a temporary local variable." )
    in
    (Error_code.InoutArgumentBadType, claim, reasons, [])

  let invalid_meth_caller_calling_convention pos decl_pos convention =
    let claim =
      lazy
        ( pos,
          "`meth_caller` does not support methods with the "
          ^ convention
          ^ " calling convention" )
    and reason =
      lazy
        [
          ( decl_pos,
            "This is why I think this method uses the `inout` calling convention"
          );
        ]
    in
    (Error_code.InvalidMethCallerCallingConvention, claim, reason, [])

  let invalid_meth_caller_readonly_return pos decl_pos =
    let claim =
      lazy
        ( pos,
          "`meth_caller` does not support methods that return `readonly` objects"
        )
    in
    let reason =
      lazy
        [
          ( decl_pos,
            "This is why I think this method returns a `readonly` object" );
        ]
    in
    (Error_code.InvalidMethCallerReadonlyReturn, claim, reason, [])

  let invalid_new_disposable pos =
    let claim =
      lazy
        ( pos,
          "Disposable objects may only be created in a `using` statement or `return` from function marked `<<__ReturnDisposable>>`"
        )
    in
    (Error_code.InvalidNewDisposable, claim, lazy [], [])

  let invalid_return_disposable pos =
    let claim =
      lazy
        ( pos,
          "Return expression must be new disposable in function marked `<<__ReturnDisposable>>`"
        )
    in
    (Error_code.InvalidReturnDisposable, claim, lazy [], [])

  let invalid_disposable_hint pos class_name =
    let claim =
      lazy
        ( pos,
          "Parameter with type "
          ^ Markdown_lite.md_codify class_name
          ^ " must not implement `IDisposable` or `IAsyncDisposable`. "
          ^ "Please use `<<__AcceptDisposable>>` attribute or create disposable object with `using` statement instead."
        )
    in
    (Error_code.InvalidDisposableHint, claim, lazy [], [])

  let invalid_disposable_return_hint pos class_name =
    let claim =
      lazy
        ( pos,
          "Return type "
          ^ Markdown_lite.md_codify class_name
          ^ " must not implement `IDisposable` or `IAsyncDisposable`. Please add `<<__ReturnDisposable>>` attribute."
        )
    in
    (Error_code.InvalidDisposableReturnHint, claim, lazy [], [])

  let ambiguous_lambda pos uses =
    let claim =
      lazy
        ( pos,
          "Lambda has parameter types that could not be determined at definition site."
        )
    and reason =
      Lazy.map uses ~f:(fun uses ->
          ( Pos_or_decl.of_raw_pos pos,
            Printf.sprintf
              "%d distinct use types were determined: please add type hints to lambda parameters."
              (List.length uses) )
          :: List.map uses ~f:(fun (pos, ty) ->
                 (pos, "This use has type " ^ Markdown_lite.md_codify ty)))
    in
    (Error_code.AmbiguousLambda, claim, reason, [])

  let smember_not_found
      pos kind member_name class_name class_pos hint quickfixes =
    let (code, claim, reasons) =
      Common.smember_not_found pos kind member_name class_name class_pos hint
    in
    (code, claim, reasons, quickfixes)

  let wrong_extend_kind pos kind name parent_pos parent_kind parent_name =
    let reason =
      lazy
        (let parent_kind_str = Ast_defs.string_of_classish_kind parent_kind in
         [(parent_pos, "This is " ^ parent_kind_str ^ ".")])
    in
    let claim =
      lazy
        (let parent_name = Render.strip_ns parent_name in
         let child_name = Render.strip_ns name in
         let use_msg =
           Printf.sprintf
             " Did you mean to add `use %s;` within the body of %s?"
             parent_name
             (Markdown_lite.md_codify child_name)
         in
         let child_msg =
           match kind with
           | Ast_defs.Cclass _ ->
             let extends_msg = "Classes can only extend other classes." in
             let suggestion =
               if Ast_defs.is_c_interface parent_kind then
                 " Did you mean `implements " ^ parent_name ^ "`?"
               else if Ast_defs.is_c_trait parent_kind then
                 use_msg
               else
                 ""
             in
             extends_msg ^ suggestion
           | Ast_defs.Cinterface ->
             let extends_msg = "Interfaces can only extend other interfaces." in
             let suggestion =
               if Ast_defs.is_c_trait parent_kind then
                 use_msg
               else
                 ""
             in
             extends_msg ^ suggestion
           | Ast_defs.Cenum_class _ ->
             "Enum classes can only extend other enum classes."
           | Ast_defs.Cenum ->
             (* This case should never happen, as the type checker will have already caught
                it with EnumTypeBad. But just in case, report this error here too. *)
             "Enums can only extend int, string, or arraykey."
           | Ast_defs.Ctrait ->
             (* This case should never happen, as the parser will have caught it before
                 we get here. *)
             "A trait cannot use `extends`. This is a parser error."
         in
         (pos, child_msg))
    in
    (Error_code.WrongExtendKind, claim, reason, [])

  let wrong_use_kind pos name parent_pos parent_name =
    let parent_name = Render.strip_ns parent_name in
    let child_name = Render.strip_ns name in
    let reason =
      lazy
        [
          ( parent_pos,
            "Trait "
            ^ parent_name
            ^ " is not annotated with <<__ModuleLevelTrait>>." );
        ]
    in
    let claim =
      lazy
        ( pos,
          "Module level trait "
          ^ child_name
          ^ " cannot use the non-module level trait "
          ^ parent_name
          ^ "." )
    in
    (Error_code.WrongUseKind, claim, reason, [])

  let cyclic_class_def pos stack =
    let claim =
      lazy
        (let stack =
           SSet.fold
             (fun x y ->
               (Render.strip_ns x |> Markdown_lite.md_codify) ^ " " ^ y)
             stack
             ""
         in

         (pos, "Cyclic class definition : " ^ stack))
    in
    (Error_code.CyclicClassDef, claim, lazy [], [])

  let trait_reuse_with_final_method use_pos trait_name parent_cls_name trace =
    let claim =
      lazy
        ( use_pos,
          Printf.sprintf
            "Traits with final methods cannot be reused, and `%s` is already used by `%s`."
            (Render.strip_ns trait_name)
            (Render.strip_ns parent_cls_name) )
    in
    (Error_code.TraitReuse, claim, trace, [])

  let trait_reuse_inside_class c_pos c_name trait occurrences =
    let claim =
      lazy
        (let c_name = Render.strip_ns c_name |> Markdown_lite.md_codify in
         let trait = Render.strip_ns trait |> Markdown_lite.md_codify in
         let err =
           "Class " ^ c_name ^ " uses trait " ^ trait ^ " multiple times"
         in
         (c_pos, err))
    in
    ( Error_code.TraitReuseInsideClass,
      claim,
      lazy (List.map ~f:(fun p -> (p, "used here")) occurrences),
      [] )

  let invalid_is_as_expression_hint hint_pos op reasons =
    let op =
      match op with
      | `is -> "is"
      | `as_ -> "as"
    in
    let claim =
      lazy
        (hint_pos, "Invalid " ^ Markdown_lite.md_codify op ^ " expression hint")
    and reasons =
      Lazy.map reasons ~f:(fun reasons ->
          List.map reasons ~f:(fun (ty_pos, ty_str) ->
              ( ty_pos,
                "The "
                ^ Markdown_lite.md_codify op
                ^ " operator cannot be used with "
                ^ ty_str )))
    in
    (Error_code.InvalidIsAsExpressionHint, claim, reasons, [])

  let invalid_enforceable_type targ_pos ty_info kind tp_pos tp_name =
    let reason =
      Lazy.map ty_info ~f:(fun ty_info ->
          let kind_str =
            match kind with
            | `constant -> "constant"
            | `param -> "parameter"
          in
          let (ty_pos, ty_str) = List.hd_exn ty_info in
          [
            ( tp_pos,
              "Type "
              ^ kind_str
              ^ " "
              ^ Markdown_lite.md_codify tp_name
              ^ " was declared `__Enforceable` here" );
            (ty_pos, "This type is not enforceable because it has " ^ ty_str);
          ])
    in
    ( Error_code.InvalidEnforceableTypeArgument,
      lazy (targ_pos, "Invalid type"),
      reason,
      [] )

  let reifiable_attr attr_pos kind decl_pos ty_info =
    let claim =
      lazy
        (let decl_kind =
           match kind with
           | `ty -> "type"
           | `cnstr -> "constraint"
           | `super_cnstr -> "super_constraint"
         in
         (decl_pos, "Invalid " ^ decl_kind))
    in
    let reason =
      Lazy.map ty_info ~f:(fun ty_info ->
          let (ty_pos, ty_msg) = List.hd_exn ty_info in
          [
            (attr_pos, "This type constant has the `__Reifiable` attribute");
            (ty_pos, "It cannot contain " ^ ty_msg);
          ])
    in
    (Error_code.DisallowPHPArraysAttr, claim, reason, [])

  let invalid_newable_type_argument pos tp_pos tp_name =
    ( Error_code.InvalidNewableTypeArgument,
      lazy
        ( pos,
          "A newable type argument must be a concrete class or a newable type parameter."
        ),
      lazy
        [
          ( tp_pos,
            "Type parameter "
            ^ Markdown_lite.md_codify tp_name
            ^ " was declared `__Newable` here" );
        ],
      [] )

  let invalid_newable_type_param_constraints
      (tparam_pos, tparam_name) constraint_list =
    let claim =
      lazy
        (let partial =
           if List.is_empty constraint_list then
             "No constraints"
           else
             "The constraints "
             ^ String.concat
                 ~sep:", "
                 (List.map ~f:Render.strip_ns constraint_list)
         in
         let msg =
           "The type parameter "
           ^ Markdown_lite.md_codify tparam_name
           ^ " has the `<<__Newable>>` attribute. "
           ^ "Newable type parameters must be constrained with `as`, and exactly one of those constraints must be a valid newable class. "
           ^ "The class must either be final, or it must have the `<<__ConsistentConstruct>>` attribute or extend a class that has it. "
           ^ partial
           ^ " are valid newable classes"
         in
         (tparam_pos, msg))
    in
    (Error_code.InvalidNewableTypeParamConstraints, claim, lazy [], [])

  let override_per_trait class_name meth_name trait_name m_pos =
    let claim =
      lazy
        (let (c_pos, c_name) = class_name in
         let err_msg =
           Printf.sprintf
             "`%s::%s` is marked `__Override` but `%s` does not define or inherit a `%s` method."
             (Render.strip_ns trait_name)
             meth_name
             (Render.strip_ns c_name)
             meth_name
         in
         (c_pos, err_msg))
    in
    ( Error_code.OverridePerTrait,
      claim,
      lazy
        [
          ( m_pos,
            "Declaration of " ^ Markdown_lite.md_codify meth_name ^ " is here"
          );
        ],
      [] )

  let should_not_be_override pos class_id id =
    ( Error_code.ShouldNotBeOverride,
      lazy
        ( pos,
          Printf.sprintf
            "%s has no parent class with a method %s to override"
            (Render.strip_ns class_id |> Markdown_lite.md_codify)
            (Markdown_lite.md_codify id) ),
      lazy [],
      [] )

  let typedef_trail_entry pos = (pos, "Typedef definition comes from here")

  let trivial_strict_eq p b left right left_trail right_trail =
    let claim =
      lazy
        (let b =
           Markdown_lite.md_codify
             (if b then
               "true"
             else
               "false")
         in
         let msg = sprintf "This expression is always %s" b in
         (p, msg))
    and reason =
      Lazy.(
        left >>= fun left ->
        right >>= fun right ->
        let left_trail = List.map left_trail ~f:typedef_trail_entry in
        let right_trail = List.map right_trail ~f:typedef_trail_entry in
        return (left @ left_trail @ right @ right_trail))
    in
    (Error_code.TrivialStrictEq, claim, reason, [])

  let trivial_strict_not_nullable_compare_null p result type_reason =
    let claim =
      lazy
        (let b =
           Markdown_lite.md_codify
             (if result then
               "true"
             else
               "false")
         in
         let msg = sprintf "This expression is always %s" b in
         (p, msg))
    in
    (Error_code.NotNullableCompareNullTrivial, claim, type_reason, [])

  let eq_incompatible_types p left right =
    let claim = lazy (p, "This equality test has incompatible types")
    and reason = lazy (left @ right) in
    (Error_code.EqIncompatibleTypes, claim, reason, [])

  let comparison_invalid_types p left right =
    let claim =
      lazy
        ( p,
          "This comparison has invalid types.  Only comparisons in which both arguments are strings, nums, DateTime, or DateTimeImmutable are allowed"
        )
    and reason = lazy (left @ right) in
    (Error_code.ComparisonInvalidTypes, claim, reason, [])

  let strict_eq_value_incompatible_types p left right =
    let claim =
      lazy
        ( p,
          "The arguments to this value equality test are not the same types or are not the allowed types (int, bool, float, string, vec, keyset, dict). The behavior for this test is changing and will soon either be universally false or throw an exception."
        )
    and reason = lazy (left @ right) in
    (Error_code.StrictEqValueIncompatibleTypes, claim, reason, [])

  let deprecated_use pos ?(pos_def = None) msg =
    let reason =
      lazy
        (match pos_def with
        | Some pos_def -> [(pos_def, "Definition is here")]
        | None -> [])
    in
    (Error_code.DeprecatedUse, lazy (pos, msg), reason, [])

  let cannot_declare_constant pos (class_pos, class_name) =
    ( Error_code.CannotDeclareConstant,
      lazy (pos, "Cannot declare a constant in an enum"),
      lazy
        [
          ( Pos_or_decl.of_raw_pos class_pos,
            (Render.strip_ns class_name |> Markdown_lite.md_codify)
            ^ " was defined as an enum here" );
        ],
      [] )

  let invalid_classname p =
    ( Error_code.InvalidClassname,
      lazy (p, "Not a valid class name"),
      lazy [],
      [] )

  let illegal_type_structure pos msg =
    let claim =
      lazy
        (let msg =
           "The two arguments to `type_structure()` must be:"
           ^ "\n - first: `ValidClassname::class` or an object of that class"
           ^ "\n - second: a single-quoted string literal containing the name"
           ^ " of a type constant of that class\n"
           ^ msg
         in
         (pos, msg))
    in
    (Error_code.IllegalTypeStructure, claim, lazy [], [])

  let illegal_typeconst_direct_access pos =
    let claim =
      lazy
        (let msg =
           "Type constants cannot be directly accessed. "
           ^ "Use `type_structure(ValidClassname::class, 'TypeConstName')` instead"
         in
         (pos, msg))
    in
    (Error_code.IllegalTypeStructure, claim, lazy [], [])

  let wrong_expression_kind_attribute
      expr_kind pos attr attr_class_pos attr_class_name intf_name =
    let claim =
      lazy
        ( pos,
          Printf.sprintf
            "The %s attribute cannot be used on %s."
            (Render.strip_ns attr |> Markdown_lite.md_codify)
            expr_kind )
    in
    let reason =
      lazy
        [
          ( attr_class_pos,
            Printf.sprintf
              "The attribute's class is defined here. To be available for use on %s, the %s class must implement %s."
              expr_kind
              (Render.strip_ns attr_class_name |> Markdown_lite.md_codify)
              (Render.strip_ns intf_name |> Markdown_lite.md_codify) );
        ]
    in
    (Error_code.WrongExpressionKindAttribute, claim, reason, [])

  let ambiguous_object_access
      pos name self_pos vis subclass_pos class_self class_subclass =
    let reason =
      lazy
        (let class_self = Render.strip_ns class_self in
         let class_subclass = Render.strip_ns class_subclass in
         [
           ( self_pos,
             "You will access the private instance declared in "
             ^ Markdown_lite.md_codify class_self );
           ( subclass_pos,
             "Instead of the "
             ^ vis
             ^ " instance declared in "
             ^ Markdown_lite.md_codify class_subclass );
         ])
    in
    ( Error_code.AmbiguousObjectAccess,
      lazy
        ( pos,
          "This object access to "
          ^ Markdown_lite.md_codify name
          ^ " is ambiguous" ),
      reason,
      [] )

  let unserializable_type pos message =
    ( Error_code.UnserializableType,
      lazy
        ( pos,
          "Unserializable type (could not be converted to JSON and back again): "
          ^ message ),
      lazy [],
      [] )

  let invalid_arraykey_constraint pos t =
    ( Error_code.InvalidArrayKeyConstraint,
      lazy
        ( pos,
          "This type is "
          ^ t
          ^ ", which cannot be used as an arraykey (string | int)" ),
      lazy [],
      [] )

  let redundant_covariant pos msg suggest =
    ( Error_code.RedundantGeneric,
      lazy
        ( pos,
          "This generic parameter is redundant because it only appears in a covariant (output) position"
          ^ msg
          ^ ". Consider replacing uses of generic parameter with "
          ^ Markdown_lite.md_codify suggest
          ^ " or specifying `<<__Explicit>>` on the generic parameter" ),
      lazy [],
      [] )

  let meth_caller_trait pos trait_name =
    ( Error_code.MethCallerTrait,
      lazy
        ( pos,
          (Render.strip_ns trait_name |> Markdown_lite.md_codify)
          ^ " is a trait which cannot be used with `meth_caller`. Use a class instead."
        ),
      lazy [],
      [] )

  let duplicate_interface pos name others =
    ( Error_code.DuplicateInterface,
      lazy
        ( pos,
          Printf.sprintf
            "Interface %s is used more than once in this declaration."
            (Render.strip_ns name |> Markdown_lite.md_codify) ),
      lazy (List.map others ~f:(fun pos -> (pos, "Here is another occurrence"))),
      [] )

  let reified_function_reference call_pos =
    ( Error_code.ReifiedFunctionReference,
      lazy
        ( call_pos,
          "Invalid function reference. This function requires reified generics. Prefer using a lambda instead."
        ),
      lazy [],
      [] )

  let class_meth_abstract_call cname meth_name call_pos decl_pos =
    let cname = Render.strip_ns cname in
    ( Error_code.ClassMethAbstractCall,
      lazy
        ( call_pos,
          "Cannot create a class_meth of "
          ^ cname
          ^ "::"
          ^ meth_name
          ^ "; it is abstract." ),
      lazy [(decl_pos, "Declaration is here")],
      [] )

  let reinheriting_classish_const
      dest_classish_pos
      dest_classish_name
      src_classish_pos
      src_classish_name
      existing_const_origin
      const_name =
    ( Error_code.RedeclaringClassishConstant,
      lazy
        ( src_classish_pos,
          Render.strip_ns dest_classish_name
          ^ " cannot re-inherit constant "
          ^ const_name
          ^ " from "
          ^ Render.strip_ns src_classish_name ),
      lazy
        [
          ( Pos_or_decl.of_raw_pos dest_classish_pos,
            "because it already inherited it via "
            ^ Render.strip_ns existing_const_origin );
        ],
      [] )

  let redeclaring_classish_const
      classish_pos
      classish_name
      redeclaration_pos
      existing_const_origin
      const_name =
    ( Error_code.RedeclaringClassishConstant,
      lazy
        ( redeclaration_pos,
          Render.strip_ns classish_name
          ^ " cannot re-declare constant "
          ^ const_name ),
      lazy
        [
          ( Pos_or_decl.of_raw_pos classish_pos,
            "because it already inherited it via "
            ^ Render.strip_ns existing_const_origin );
        ],
      [] )

  let abstract_function_pointer cname meth_name call_pos decl_pos =
    ( Error_code.AbstractFunctionPointer,
      lazy
        ( call_pos,
          "Cannot create a function pointer to "
          ^ Markdown_lite.md_codify (Render.strip_ns cname ^ "::" ^ meth_name)
          ^ "; it is abstract" ),
      lazy [(decl_pos, "Declaration is here")],
      [] )

  let inherited_class_member_with_different_case
      member_type name name_prev p child_class prev_class prev_class_pos =
    let name = Render.strip_ns name in
    let name_prev = Render.strip_ns name_prev in
    let claim =
      lazy
        (let child_class = Render.strip_ns child_class in
         ( p,
           child_class
           ^ " inherits a "
           ^ member_type
           ^ " named "
           ^ Markdown_lite.md_codify name_prev
           ^ " whose name differs from this one ("
           ^ Markdown_lite.md_codify name
           ^ ") only by case." ))
    in
    let reasons =
      lazy
        (let prev_class = Render.strip_ns prev_class in
         [
           ( prev_class_pos,
             "It was inherited from "
             ^ prev_class
             ^ " as "
             ^ (Render.highlight_differences name name_prev
               |> Markdown_lite.md_codify)
             ^ ". If you meant to override it, please use the same casing as the inherited "
             ^ member_type
             ^ "."
             ^ " Otherwise, please choose a different name for the new "
             ^ member_type );
         ])
    in
    (Error_code.InheritedMethodCaseDiffers, claim, reasons, [])

  let multiple_inherited_class_member_with_different_case
      ~member_type ~name1 ~name2 ~class1 ~class2 ~child_class ~child_p ~p1 ~p2 =
    let name1 = Render.strip_ns name1 in
    let name2 = Render.strip_ns name2 in
    let class1 = Render.strip_ns class1 in
    let class2 = Render.strip_ns class2 in
    let claim =
      lazy
        (let child_class = Render.strip_ns child_class in
         ( child_p,
           Markdown_lite.md_codify child_class
           ^ " inherited two versions of the "
           ^ member_type
           ^ " "
           ^ Markdown_lite.md_codify name1
           ^ " whose names differ only by case." ))
    in
    let reasons =
      lazy
        [
          ( p1,
            "It inherited "
            ^ Markdown_lite.md_codify name1
            ^ " from "
            ^ class1
            ^ " here." );
          ( p2,
            "And "
            ^ Markdown_lite.md_codify name2
            ^ " from "
            ^ class2
            ^ " here. Please rename these "
            ^ member_type
            ^ "s to the same casing." );
        ]
    in
    (Error_code.InheritedMethodCaseDiffers, claim, reasons, [])

  let classish_kind_to_string = function
    | Ast_defs.Cclass _ -> "class "
    | Ast_defs.Ctrait -> "trait "
    | Ast_defs.Cinterface -> "interface "
    | Ast_defs.Cenum_class _ -> "enum class "
    | Ast_defs.Cenum -> "enum "

  let parent_support_dynamic_type
      pos
      (child_name, child_kind)
      (parent_name, parent_kind)
      child_support_dynamic_type =
    let claim =
      lazy
        (let kinds_to_use child_kind parent_kind =
           match (child_kind, parent_kind) with
           | (_, Ast_defs.Cclass _) -> "extends "
           | (_, Ast_defs.Ctrait) -> "uses "
           | (Ast_defs.Cinterface, Ast_defs.Cinterface) -> "extends "
           | (_, Ast_defs.Cinterface) -> "implements "
           | (_, Ast_defs.Cenum_class _)
           | (_, Ast_defs.Cenum) ->
             ""
         in
         let child_name =
           Markdown_lite.md_codify (Render.strip_ns child_name)
         in
         let child_kind_s = classish_kind_to_string child_kind in
         let parent_name =
           Markdown_lite.md_codify (Render.strip_ns parent_name)
         in
         let parent_kind_s = classish_kind_to_string parent_kind in
         ( pos,
           String.capitalize child_kind_s
           ^ child_name
           ^ (if child_support_dynamic_type then
               " cannot "
             else
               " must ")
           ^ "declare <<__SupportDynamicType>> because it "
           ^ kinds_to_use child_kind parent_kind
           ^ parent_kind_s
           ^ parent_name
           ^ " which does"
           ^
           if child_support_dynamic_type then
             " not"
           else
             "" ))
    in
    (Error_code.ImplementsDynamic, claim, lazy [], [])

  let property_is_not_enforceable pos prop_name class_name (prop_pos, prop_type)
      =
    let prop_name = Markdown_lite.md_codify prop_name in
    let claim =
      lazy
        (let class_name =
           Markdown_lite.md_codify (Render.strip_ns class_name)
         in
         ( pos,
           "Class "
           ^ class_name
           ^ " cannot support dynamic because property "
           ^ prop_name
           ^ " does not have an enforceable type" ))
    and reason =
      lazy
        (let prop_type = Markdown_lite.md_codify prop_type in
         [(prop_pos, "Property " ^ prop_name ^ " has type " ^ prop_type)])
    in
    (Error_code.ImplementsDynamic, claim, reason, [])

  let property_is_not_dynamic pos prop_name class_name (prop_pos, prop_type) =
    let prop_name = Markdown_lite.md_codify prop_name in
    let claim =
      lazy
        (let class_name =
           Markdown_lite.md_codify (Render.strip_ns class_name)
         in
         ( pos,
           "Class "
           ^ class_name
           ^ " cannot support dynamic because property "
           ^ prop_name
           ^ " cannot be assigned to dynamic" ))
    and reason =
      lazy
        (let prop_type = Markdown_lite.md_codify prop_type in
         [(prop_pos, "Property " ^ prop_name ^ " has type " ^ prop_type)])
    in
    (Error_code.ImplementsDynamic, claim, reason, [])

  let private_property_is_not_enforceable
      pos prop_name class_name (prop_pos, prop_type) =
    let prop_name = Markdown_lite.md_codify prop_name in
    let claim =
      lazy
        (let class_name =
           Markdown_lite.md_codify (Render.strip_ns class_name)
         in

         ( pos,
           "Cannot write to property "
           ^ prop_name
           ^ " through dynamic type because private property in "
           ^ class_name
           ^ " does not have an enforceable type" ))
    and reason =
      lazy
        (let prop_type = Markdown_lite.md_codify prop_type in

         [(prop_pos, "Property " ^ prop_name ^ " has type " ^ prop_type)])
    in
    (Error_code.PrivateDynamicWrite, claim, reason, [])

  let private_property_is_not_dynamic
      pos prop_name class_name (prop_pos, prop_type) =
    let prop_name = Markdown_lite.md_codify prop_name in
    let claim =
      lazy
        (let class_name =
           Markdown_lite.md_codify (Render.strip_ns class_name)
         in

         ( pos,
           "Cannot read from property "
           ^ prop_name
           ^ " through dynamic type because private property in "
           ^ class_name
           ^ " cannot be assigned to dynamic" ))
    and reason =
      lazy
        (let prop_type = Markdown_lite.md_codify prop_type in

         [(prop_pos, "Property " ^ prop_name ^ " has type " ^ prop_type)])
    in
    (Error_code.PrivateDynamicRead, claim, reason, [])

  let immutable_local pos =
    ( Error_code.ImmutableLocal,
      lazy
        ( pos,
          (* TODO: generalize this error message in the future for arbitrary immutable locals *)
          "This variable cannot be reassigned because it is used for a dependent context"
        ),
      lazy [],
      [] )

  let nonsense_member_selection pos kind =
    ( Error_code.NonsenseMemberSelection,
      lazy
        ( pos,
          "Dynamic member access requires a local variable, not `" ^ kind ^ "`."
        ),
      lazy [],
      [] )

  let consider_meth_caller pos class_name meth_name =
    ( Error_code.ConsiderMethCaller,
      lazy
        ( pos,
          "Function pointer syntax requires a static method. "
          ^ "Use `meth_caller("
          ^ Render.strip_ns class_name
          ^ "::class, '"
          ^ meth_name
          ^ "')` to create a function pointer to the instance method" ),
      lazy [],
      [] )

  let method_import_via_diamond
      pos class_name method_pos method_name trace1 trace2 =
    let claim =
      lazy
        (let class_name =
           Markdown_lite.md_codify (Render.strip_ns class_name)
         in
         let method_name =
           Markdown_lite.md_codify (Render.strip_ns method_name)
         in
         ( pos,
           "Class "
           ^ class_name
           ^ " inherits trait method "
           ^ method_name
           ^ " via multiple traits.  Add the __EnableMethodTraitDiamond attribute to "
           ^ class_name
           ^ ", remove the multiple paths, or override the method" ))
    in
    let reason =
      Lazy.(
        trace1 >>= fun trace1 ->
        trace2 >>= fun trace2 ->
        return
          (((method_pos, "Trait method is defined here") :: trace1) @ trace2))
    in
    (Error_code.DiamondTraitMethod, claim, reason, [])

  let property_import_via_diamond
      generic pos class_name property_pos property_name trace1 trace2 =
    let claim =
      lazy
        (let class_name =
           Markdown_lite.md_codify (Render.strip_ns class_name)
         in
         let property_name =
           Markdown_lite.md_codify (Render.strip_ns property_name)
         in
         ( pos,
           "Class "
           ^ class_name
           ^ " inherits "
           ^ (if generic then
               "generic "
             else
               "")
           ^ "trait property "
           ^ property_name
           ^ " via multiple paths"
           ^ (if generic then
               " at different types."
             else
               ".")
           ^
           if not generic then
             " Currently, traits with properties are not supported by "
             ^ "the <<__EnableMethodTraitDiamond>> experimental feature."
           else
             "" ))
    in
    let reason =
      Lazy.(
        trace1 >>= fun trace1 ->
        trace2 >>= fun trace2 ->
        return
          (((property_pos, "Trait property is defined here") :: trace1) @ trace2))
    in
    (Error_code.DiamondTraitProperty, claim, reason, [])

  let unification_cycle pos ty =
    ( Error_code.UnificationCycle,
      lazy
        ( pos,
          "Type circularity: in order to type-check this expression it "
          ^ "is necessary for a type [rec] to be equal to type "
          ^ Markdown_lite.md_codify ty ),
      lazy [],
      [] )

  let method_variance pos =
    ( Error_code.MethodVariance,
      lazy
        ( pos,
          "Covariance or contravariance is not allowed in type parameters of methods or functions."
        ),
      lazy [],
      [] )

  let explain_tconst_where_constraint use_pos definition_pos msgl =
    let claim = lazy (use_pos, "A `where` type constraint is violated here")
    and reason =
      Lazy.map msgl ~f:(fun msgl ->
          ( definition_pos,
            "This method's `where` constraints contain a generic type access" )
          :: msgl)
    in
    (Error_code.TypeConstraintViolation, claim, reason, [])

  let format_string pos snippet s class_pos fname class_suggest =
    ( Error_code.FormatString,
      lazy
        ( pos,
          "Invalid format string "
          ^ Markdown_lite.md_codify snippet
          ^ " in "
          ^ Markdown_lite.md_codify ("\"" ^ s ^ "\"") ),
      lazy
        [
          ( class_pos,
            "You can add a new format specifier by adding "
            ^ Markdown_lite.md_codify (fname ^ "()")
            ^ " to "
            ^ Markdown_lite.md_codify class_suggest );
        ],
      [] )

  let expected_literal_format_string pos =
    ( Error_code.ExpectedLiteralFormatString,
      lazy (pos, "This argument must be a literal format string"),
      lazy [],
      [] )

  let re_prefixed_non_string pos reason =
    let claim =
      lazy
        (let non_strings =
           match reason with
           | `embedded_expr -> "Strings with embedded expressions"
           | `non_string -> "Non-strings"
         in
         (pos, non_strings ^ " are not allowed to be to be `re`-prefixed"))
    in
    (Error_code.RePrefixedNonString, claim, lazy [], [])

  let bad_regex_pattern pos reason =
    let claim =
      lazy
        (let s =
           match reason with
           | `bad_patt s -> s
           | `empty_patt -> "This pattern is empty"
           | `missing_delim -> "Missing delimiter(s)"
           | `invalid_option -> "Invalid global option(s)"
         in
         (pos, "Bad regex pattern; " ^ s ^ "."))
    in
    (Error_code.BadRegexPattern, claim, lazy [], [])

  let generic_array_strict p =
    ( Error_code.GenericArrayStrict,
      lazy (p, "You cannot have an array without generics in strict mode"),
      lazy [],
      [] )

  let option_return_only_typehint p kind =
    let claim =
      lazy
        (let (typehint, reason) =
           match kind with
           | `void -> ("?void", "only return implicitly")
           | `noreturn -> ("?noreturn", "never return")
         in
         ( p,
           Markdown_lite.md_codify typehint
           ^ " is a nonsensical typehint; a function cannot both "
           ^ reason
           ^ " and return null." ))
    in
    (Error_code.OptionReturnOnlyTypehint, claim, lazy [], [])

  let redeclaring_missing_method p trait_method =
    ( Error_code.RedeclaringMissingMethod,
      lazy
        ( p,
          "Attempting to redeclare a trait method "
          ^ Markdown_lite.md_codify trait_method
          ^ " which was never inherited. "
          ^ "You might be trying to redeclare a non-static method as `static` or vice-versa."
        ),
      lazy [],
      [] )

  let expecting_type_hint p =
    ( Error_code.ExpectingTypeHint,
      lazy (p, "Was expecting a type hint"),
      lazy [],
      [] )

  let expecting_type_hint_variadic p =
    ( Error_code.ExpectingTypeHintVariadic,
      lazy (p, "Was expecting a type hint on this variadic parameter"),
      lazy [],
      [] )

  let expecting_return_type_hint p =
    ( Error_code.ExpectingReturnTypeHint,
      lazy (p, "Was expecting a return type hint"),
      lazy [],
      [] )

  let duplicate_using_var pos =
    ( Error_code.DuplicateUsingVar,
      lazy (pos, "Local variable already used in `using` statement"),
      lazy [],
      [] )

  let illegal_disposable pos verb =
    let claim =
      lazy
        (let verb =
           match verb with
           | `assigned -> "assigned"
         in
         ( pos,
           "Disposable objects must only be " ^ verb ^ " in a `using` statement"
         ))
    in
    (Error_code.IllegalDisposable, claim, lazy [], [])

  let escaping_disposable pos =
    ( Error_code.EscapingDisposable,
      lazy
        ( pos,
          "Variable from `using` clause may only be used as receiver in method invocation "
          ^ "or passed to function with `<<__AcceptDisposable>>` parameter attribute"
        ),
      lazy [],
      [] )

  let escaping_disposable_parameter pos =
    ( Error_code.EscapingDisposableParameter,
      lazy
        ( pos,
          "Parameter with `<<__AcceptDisposable>>` attribute may only be used as receiver in method invocation "
          ^ "or passed to another function with `<<__AcceptDisposable>>` parameter attribute"
        ),
      lazy [],
      [] )

  let escaping_this pos =
    ( Error_code.EscapingThis,
      lazy
        ( pos,
          "`$this` implementing `IDisposable` or `IAsyncDisposable` may only be used as receiver in method invocation "
          ^ "or passed to another function with `<<__AcceptDisposable>>` parameter attribute"
        ),
      lazy [],
      [] )

  let must_extend_disposable pos =
    ( Error_code.MustExtendDisposable,
      lazy
        ( pos,
          "A disposable type may not extend a class or use a trait that is not disposable"
        ),
      lazy [],
      [] )

  let field_kinds pos1 pos2 =
    ( Error_code.FieldKinds,
      lazy (pos1, "You cannot use this kind of field (value)"),
      lazy [(pos2, "Mixed with this kind of field (key => value)")],
      [] )

  let unbound_name_typing pos name class_exists =
    let quickfixes =
      match class_exists with
      | true ->
        let newpos = Pos.shrink_to_start pos in
        [
          Quickfix.make
            ~title:("Add " ^ Markdown_lite.md_codify "new")
            ~new_text:"new "
            newpos;
        ]
      | false -> []
    in
    ( Error_code.UnboundNameTyping,
      lazy
        ( pos,
          "Unbound name (typing): "
          ^ Markdown_lite.md_codify (Render.strip_ns name) ),
      lazy [],
      quickfixes )

  let previous_default p =
    ( Error_code.PreviousDefault,
      lazy
        ( p,
          "A previous parameter has a default value.\n"
          ^ "Remove all the default values for the preceding parameters,\n"
          ^ "or add a default value to this one." ),
      lazy [],
      [] )

  let return_in_void pos1 pos2 =
    ( Error_code.ReturnInVoid,
      lazy (pos1, "You cannot return a value"),
      lazy [(Pos_or_decl.of_raw_pos pos2, "This is a `void` function")],
      [] )

  let this_var_outside_class p =
    ( Error_code.ThisVarOutsideClass,
      lazy (p, "Can't use `$this` outside of a class"),
      lazy [],
      [] )

  let unbound_global cst_pos =
    ( Error_code.UnboundGlobal,
      lazy (cst_pos, "Unbound global constant (Typing)"),
      lazy [],
      [] )

  let private_inst_meth use_pos def_pos =
    ( Error_code.PrivateInstMeth,
      lazy
        ( use_pos,
          "You cannot use this method with `inst_meth` (whether you are in the same class or not)."
        ),
      lazy [(def_pos, "It is declared as `private` here")],
      [] )

  let protected_inst_meth use_pos def_pos =
    ( Error_code.ProtectedInstMeth,
      lazy
        ( use_pos,
          "You cannot use this method with `inst_meth` (whether you are in the same class hierarchy or not)."
        ),
      lazy [(def_pos, "It is declared as `protected` here")],
      [] )

  let private_meth_caller use_pos def_pos =
    ( Error_code.PrivateMethCaller,
      lazy
        ( use_pos,
          "You cannot access this method with `meth_caller` (even from the same class hierarchy)"
        ),
      lazy [(def_pos, "It is declared as `private` here")],
      [] )

  let protected_meth_caller use_pos def_pos =
    ( Error_code.ProtectedMethCaller,
      lazy
        ( use_pos,
          "You cannot access this method with `meth_caller` (even from the same class hierarchy)"
        ),
      lazy [(def_pos, "It is declared as `protected` here")],
      [] )

  let private_class_meth use_pos def_pos =
    ( Error_code.PrivateClassMeth,
      lazy
        ( use_pos,
          "You cannot use this method with `class_meth` (whether you are in the same class or not)."
        ),
      lazy [(def_pos, "It is declared as `private` here")],
      [] )

  let protected_class_meth use_pos def_pos =
    ( Error_code.ProtectedClassMeth,
      lazy
        ( use_pos,
          "You cannot use this method with `class_meth` (whether you are in the same class hierarchy or not)."
        ),
      lazy [(def_pos, "It is declared as `protected` here")],
      [] )

  let array_cast pos =
    ( Error_code.ArrayCast,
      lazy
        ( pos,
          "(array) cast forbidden; arrays with unspecified key and value types are not allowed"
        ),
      lazy [],
      [] )

  let string_cast pos ty =
    ( Error_code.StringCast,
      lazy
        ( pos,
          Printf.sprintf
            "Cannot cast a value of type %s to string. Only primitives may be used in a `(string)` cast."
            (Markdown_lite.md_codify ty) ),
      lazy [],
      [] )

  let static_outside_class pos =
    ( Error_code.StaticOutsideClass,
      lazy (pos, "`static` is undefined outside of a class"),
      lazy [],
      [] )

  let self_outside_class pos =
    ( Error_code.SelfOutsideClass,
      lazy (pos, "`self` is undefined outside of a class"),
      lazy [],
      [] )

  let new_inconsistent_construct new_pos (cpos, cname) kind =
    let claim =
      lazy
        (let name = Render.strip_ns cname in
         let preamble =
           match kind with
           | `static ->
             "Can't use `new static()` for " ^ Markdown_lite.md_codify name
           | `classname ->
             "Can't use `new` on "
             ^ Markdown_lite.md_codify ("classname<" ^ name ^ ">")
         in
         ( new_pos,
           preamble
           ^ "; `__construct` arguments are not guaranteed to be consistent in child classes"
         ))
    in
    ( Error_code.NewStaticInconsistent,
      claim,
      lazy
        [
          ( cpos,
            "This declaration is neither `final` nor uses the `<<__ConsistentConstruct>>` attribute"
          );
        ],
      [] )

  let undefined_parent pos =
    ( Error_code.UndefinedParent,
      lazy (pos, "The parent class is undefined"),
      lazy [],
      [] )

  let parent_outside_class pos =
    ( Error_code.ParentOutsideClass,
      lazy (pos, "`parent` is undefined outside of a class"),
      lazy [],
      [] )

  let parent_abstract_call call_pos meth_name decl_pos =
    ( Error_code.AbstractCall,
      lazy
        ( call_pos,
          "Cannot call "
          ^ Markdown_lite.md_codify ("parent::" ^ meth_name ^ "()")
          ^ "; it is abstract" ),
      lazy [(decl_pos, "Declaration is here")],
      [] )

  let self_abstract_call call_pos meth_name self_pos decl_pos =
    let quickfixes =
      [
        Quickfix.make
          ~title:
            ("Change to " ^ Markdown_lite.md_codify ("static::" ^ meth_name))
          ~new_text:"static"
          self_pos;
      ]
    in
    ( Error_code.AbstractCall,
      lazy
        ( call_pos,
          "Cannot call "
          ^ Markdown_lite.md_codify ("self::" ^ meth_name ^ "()")
          ^ "; it is abstract. Did you mean "
          ^ Markdown_lite.md_codify ("static::" ^ meth_name ^ "()")
          ^ "?" ),
      lazy [(decl_pos, "Declaration is here")],
      quickfixes )

  let classname_abstract_call call_pos meth_name cname decl_pos =
    ( Error_code.AbstractCall,
      lazy
        ( call_pos,
          "Cannot call "
          ^ Markdown_lite.md_codify
              (Render.strip_ns cname ^ "::" ^ meth_name ^ "()")
          ^ "; it is abstract" ),
      lazy [(decl_pos, "Declaration is here")],
      [] )

  let static_synthetic_method call_pos meth_name cname decl_pos =
    let cname = Render.strip_ns cname in
    ( Error_code.StaticSyntheticMethod,
      lazy
        ( call_pos,
          "Cannot call "
          ^ Markdown_lite.md_codify (cname ^ "::" ^ meth_name ^ "()")
          ^ "; "
          ^ Markdown_lite.md_codify meth_name
          ^ " is not defined in "
          ^ Markdown_lite.md_codify cname ),
      lazy [(decl_pos, "Declaration is here")],
      [] )

  let static_call_on_trait_require_class
      call_pos meth_name trait_name req_class_name =
    let trait_name = Render.strip_ns trait_name in
    let req_class_name = Render.strip_ns req_class_name in
    ( Error_code.StaticCallOnTraitRequireClass,
      lazy
        ( call_pos,
          "Invoking static methods on traits is dangerous and must be avoided. Since trait "
          ^ trait_name
          ^ " has a "
          ^ Markdown_lite.md_codify ("require class " ^ req_class_name)
          ^ " constraint, replace "
          ^ Markdown_lite.md_codify (trait_name ^ "::" ^ meth_name ^ "(...)")
          ^ " with "
          ^ Markdown_lite.md_codify (req_class_name ^ "::" ^ meth_name ^ "(...)")
          ^ "." ),
      lazy [],
      [] )

  let isset_in_strict pos =
    ( Error_code.IssetEmptyInStrict,
      lazy
        ( pos,
          "`isset` tends to hide errors due to variable typos and so is limited to dynamic checks in "
          ^ "`strict` mode" ),
      lazy [],
      [] )

  let isset_inout_arg pos =
    ( Error_code.InoutInPseudofunction,
      lazy (pos, "`isset` does not allow arguments to be passed by `inout`"),
      lazy [],
      [] )

  let unset_nonidx_in_strict pos msgs =
    ( Error_code.UnsetNonidxInStrict,
      lazy
        ( pos,
          "In `strict` mode, `unset` is banned except on dynamic, "
          ^ "darray, keyset, or dict indexing" ),
      msgs,
      [] )

  let unpacking_disallowed_builtin_function pos name =
    ( Error_code.UnpackingDisallowed,
      lazy
        ( pos,
          "Arg unpacking is disallowed for "
          ^ Markdown_lite.md_codify (Render.strip_ns name) ),
      lazy [],
      [] )

  let array_get_arity pos1 name pos2 =
    ( Error_code.ArrayGetArity,
      lazy
        ( pos1,
          "You cannot use this "
          ^ (Render.strip_ns name |> Markdown_lite.md_codify) ),
      lazy [(pos2, "It is missing its type parameters")],
      [] )

  let undefined_field use_pos name shape_type_pos =
    ( Error_code.UndefinedField,
      lazy
        ( use_pos,
          "This shape doesn't have a field " ^ Markdown_lite.md_codify name ),
      lazy [(shape_type_pos, "The shape is defined here")],
      [] )

  let array_access code pos1 pos2 ty =
    ( code,
      lazy
        (pos1, "This is not an object of type `KeyedContainer`, this is " ^ ty),
      lazy
        (if not Pos_or_decl.(equal pos2 none) then
          [(pos2, "Definition is here")]
        else
          []),
      [] )

  let array_access_read = array_access Error_code.ArrayAccessRead

  let array_access_write = array_access Error_code.ArrayAccessWrite

  let keyset_set pos1 pos2 =
    ( Error_code.KeysetSet,
      lazy (pos1, "Elements in a keyset cannot be assigned, use append instead."),
      lazy
        (if not Pos_or_decl.(equal pos2 none) then
          [(pos2, "Definition is here")]
        else
          []),
      [] )

  let array_append pos1 pos2 ty =
    ( Error_code.ArrayAppend,
      lazy (pos1, ty ^ " does not allow array append"),
      lazy
        (if not Pos_or_decl.(equal pos2 none) then
          [(pos2, "Definition is here")]
        else
          []),
      [] )

  let const_mutation pos1 pos2 ty =
    ( Error_code.ConstMutation,
      lazy (pos1, "You cannot mutate this"),
      lazy
        (if not Pos_or_decl.(equal pos2 none) then
          [(pos2, "This is " ^ ty)]
        else
          []),
      [] )

  let expected_class pos suffix =
    ( Error_code.ExpectedClass,
      lazy (pos, "Was expecting a class" ^ suffix),
      lazy [],
      [] )

  let unknown_type pos description r =
    let claim =
      lazy (pos, "Was expecting " ^ description ^ " but type is unknown")
    in
    (Error_code.UnknownType, claim, r, [])

  let parent_in_trait pos =
    ( Error_code.ParentInTrait,
      lazy
        ( pos,
          "You can only use `parent::` in traits that specify `require extends SomeClass`"
        ),
      lazy [],
      [] )

  let parent_undefined pos =
    (Error_code.ParentUndefined, lazy (pos, "parent is undefined"), lazy [], [])

  let constructor_no_args pos =
    ( Error_code.ConstructorNoArgs,
      lazy (pos, "This constructor expects no argument"),
      lazy [],
      [] )

  let visibility p msg1 p_vis msg2 =
    (Error_code.Visibility, lazy (p, msg1), lazy [(p_vis, msg2)], [])

  let bad_call pos ty =
    ( Error_code.BadCall,
      lazy (pos, "This call is invalid, this is not a function, it is " ^ ty),
      lazy [],
      [] )

  let extend_final extend_pos decl_pos name =
    ( Error_code.ExtendFinal,
      lazy
        ( extend_pos,
          "You cannot extend final class "
          ^ Markdown_lite.md_codify (Render.strip_ns name) ),
      lazy [(decl_pos, "Declaration is here")],
      [] )

  let extend_sealed child_pos parent_pos parent_name parent_kind verb =
    let claim =
      lazy
        (let parent_kind =
           match parent_kind with
           | `intf -> "interface"
           | `trait -> "trait"
           | `class_ -> "class"
           | `enum -> "enum"
           | `enum_class -> "enum class"
         and verb =
           match verb with
           | `extend -> "extend"
           | `implement -> "implement"
           | `use -> "use"
         and name = Render.strip_ns parent_name in
         ( child_pos,
           "You cannot "
           ^ verb
           ^ " sealed "
           ^ parent_kind
           ^ " "
           ^ Markdown_lite.md_codify name ))
    in
    ( Error_code.ExtendSealed,
      claim,
      lazy [(parent_pos, "Declaration is here")],
      [] )

  let sealed_not_subtype parent_pos parent_name child_name child_kind child_pos
      =
    let claim =
      lazy
        (let parent_name = Render.strip_ns parent_name
         and child_name = Render.strip_ns child_name
         and (child_kind, verb) =
           match child_kind with
           | Ast_defs.Cclass _ -> ("Class", "extend")
           | Ast_defs.Cinterface -> ("Interface", "implement")
           | Ast_defs.Ctrait -> ("Trait", "use")
           | Ast_defs.Cenum -> ("Enum", "use")
           | Ast_defs.Cenum_class _ -> ("Enum Class", "extend")
         in
         ( parent_pos,
           child_kind
           ^ " "
           ^ Markdown_lite.md_codify child_name
           ^ " in sealed allowlist for "
           ^ Markdown_lite.md_codify parent_name
           ^ ", but does not "
           ^ verb
           ^ " "
           ^ Markdown_lite.md_codify parent_name ))
    in

    ( Error_code.SealedNotSubtype,
      claim,
      lazy [(child_pos, "Definition is here")],
      [] )

  let trait_prop_const_class pos x =
    ( Error_code.TraitPropConstClass,
      lazy
        ( pos,
          "Trait declaration of non-const property "
          ^ Markdown_lite.md_codify x
          ^ " is incompatible with a const class" ),
      lazy [],
      [] )

  let implement_abstract pos1 is_final pos2 x kind qfxs trace =
    let kind =
      match kind with
      | `meth -> "method"
      | `prop -> "property"
      | `const -> "constant"
      | `ty_const -> "type constant"
    in
    let claim =
      lazy
        (let name = "abstract " ^ kind ^ " " ^ Markdown_lite.md_codify x in
         let msg1 =
           if is_final then
             "This class was declared as `final`. It must provide an implementation for the "
             ^ name
           else
             "This class must be declared `abstract`, or provide an implementation for the "
             ^ name
         in
         (pos1, msg1))
    in
    ( Error_code.ImplementAbstract,
      claim,
      lazy
        (Lazy.force trace
        @ [(pos2, Printf.sprintf "The %s is defined here" kind)]),
      qfxs )

  let abstract_member_in_concrete_class
      ~member_pos ~class_name_pos ~is_final member_kind member_name =
    let claim =
      lazy
        ( member_pos,
          Printf.sprintf
            "%s `%s%s` is abstract but the class is %s. Either provide an implementation here."
            (match member_kind with
            | `method_ -> "Method"
            | `property -> "Property"
            | `constant -> "Constant"
            | `type_constant -> "Type constant")
            (match member_kind with
            | `property -> "$"
            | _ -> "")
            member_name
            (if is_final then
              "final"
            else
              "concrete") )
    in
    let reasons =
      lazy
        [
          ( Pos_or_decl.of_raw_pos class_name_pos,
            Printf.sprintf
              "Or make the class abstract%s."
              (if is_final then
                " and not final"
              else
                "") );
        ]
    in
    (Error_code.AbstractMemberInConcreteClass, claim, reasons, [])

  let generic_static pos x =
    ( Error_code.GenericStatic,
      lazy
        ( pos,
          "This static variable cannot use the type parameter "
          ^ Markdown_lite.md_codify x
          ^ "." ),
      lazy [],
      [] )

  let ellipsis_strict_mode pos require =
    let claim =
      lazy
        ( pos,
          match require with
          | `Param_name ->
            "Variadic function arguments require a name in strict mode, e.g. `...$args`."
          | `Type_and_param_name ->
            "Variadic function arguments require a name and type in strict mode, e.g. `int ...$args`."
        )
    in
    (Error_code.EllipsisStrictMode, claim, lazy [], [])

  let object_string pos1 pos2 =
    ( Error_code.ObjectString,
      lazy (pos1, "You cannot use this object as a string"),
      lazy [(pos2, "This object doesn't implement `__toString`")],
      [] )

  let object_string_deprecated pos =
    ( Error_code.ObjectString,
      lazy
        ( pos,
          "You cannot use this object as a string\nImplicit conversions of Stringish objects to string are deprecated."
        ),
      lazy [],
      [] )

  let cyclic_typedef def_pos use_pos =
    ( Error_code.CyclicTypedef,
      lazy (def_pos, "Cyclic type definition"),
      lazy [(use_pos, "Cyclic use is here")],
      [] )

  let require_args_reify arg_pos def_pos =
    ( Error_code.RequireArgsReify,
      lazy
        ( arg_pos,
          "All type arguments must be specified because a type parameter is reified"
        ),
      lazy [(def_pos, "Definition is here")],
      [] )

  let require_generic_explicit arg_pos def_pos def_name =
    ( Error_code.RequireGenericExplicit,
      lazy
        ( arg_pos,
          "Illegal wildcard (`_`): generic type parameter "
          ^ Markdown_lite.md_codify def_name
          ^ " must be specified explicitly" ),
      lazy [(def_pos, "Definition is here")],
      [] )

  let invalid_reified_argument hint_pos def_name def_pos arg_info =
    let reason =
      Lazy.map arg_info ~f:(fun arg_info ->
          let (arg_pos, arg_kind) = List.hd_exn arg_info in
          [
            ( arg_pos,
              "This is "
              ^ arg_kind
              ^ ", it cannot be used as a reified type argument" );
            (def_pos, Markdown_lite.md_codify def_name ^ " is reified");
          ])
    in
    ( Error_code.InvalidReifiedArgument,
      lazy (hint_pos, "Invalid reified hint"),
      reason,
      [] )

  let invalid_reified_argument_reifiable arg_pos def_name def_pos ty_pos ty_msg
      =
    ( Error_code.InvalidReifiedArgument,
      lazy (arg_pos, "PHP arrays cannot be used as a reified type argument"),
      lazy
        [
          (ty_pos, String.capitalize ty_msg);
          (def_pos, Markdown_lite.md_codify def_name ^ " is reified");
        ],
      [] )

  let new_class_reified pos class_type suggested_class =
    let claim =
      lazy
        (let suggestion =
           match suggested_class with
           | Some s ->
             let s = Render.strip_ns s in
             sprintf ". Try `new %s` instead." s
           | None -> ""
         in
         ( pos,
           sprintf
             "Cannot call `new %s` because the current class has reified generics%s"
             class_type
             suggestion ))
    in
    (Error_code.NewClassReified, claim, lazy [], [])

  let class_get_reified pos =
    ( Error_code.ClassGetReified,
      lazy (pos, "Cannot access static properties on reified generics"),
      lazy [],
      [] )

  let static_meth_with_class_reified_generic meth_pos generic_pos =
    ( Error_code.StaticMethWithClassReifiedGeneric,
      lazy
        ( meth_pos,
          "Static methods cannot use generics reified at the class level. Try reifying them at the static method itself."
        ),
      lazy
        [
          ( Pos_or_decl.of_raw_pos generic_pos,
            "Class-level reified generic used here." );
        ],
      [] )

  let consistent_construct_reified pos =
    ( Error_code.ConsistentConstructReified,
      lazy
        ( pos,
          "This class or one of its ancestors is annotated with `<<__ConsistentConstruct>>`. It cannot have reified generics."
        ),
      lazy [],
      [] )

  let bad_function_pointer_construction pos =
    ( Error_code.BadFunctionPointerConstruction,
      lazy (pos, "Function pointers must be explicitly named"),
      lazy [],
      [] )

  let reified_generics_not_allowed pos =
    ( Error_code.InvalidReifiedFunctionPointer,
      lazy
        ( pos,
          "Creating function pointers with reified generics is not currently allowed"
        ),
      lazy [],
      [] )

  let new_without_newable pos name =
    ( Error_code.NewWithoutNewable,
      lazy
        ( pos,
          Markdown_lite.md_codify name
          ^ " cannot be used with `new` because it does not have the `<<__Newable>>` attribute"
        ),
      lazy [],
      [] )

  let discarded_awaitable pos1 pos2 =
    ( Error_code.DiscardedAwaitable,
      lazy
        ( pos1,
          "This expression is of type `Awaitable`, but it's "
          ^ "either being discarded or used in a dangerous way before "
          ^ "being awaited" ),
      lazy [(pos2, "This is why I think it is `Awaitable`")],
      [] )

  let elt_type_to_string = function
    | `meth -> "method"
    | `prop -> "property"

  let unknown_object_member pos s elt r =
    let claim =
      lazy
        (let elt = elt_type_to_string elt in
         let msg =
           Printf.sprintf
             "You are trying to access the %s %s on a value whose class is unknown."
             elt
             (Markdown_lite.md_codify s)
         in
         (pos, msg))
    in
    (Error_code.UnknownObjectMember, claim, r, [])

  let non_class_member pos1 s elt ty pos2 =
    let claim =
      lazy
        (let elt = elt_type_to_string elt in
         let msg =
           Printf.sprintf
             "You are trying to access the static %s %s but this is %s"
             elt
             (Markdown_lite.md_codify s)
             ty
         in
         (pos1, msg))
    in
    (Error_code.NonClassMember, claim, lazy [(pos2, "Definition is here")], [])

  let null_container p null_witness =
    ( Error_code.NullContainer,
      lazy
        ( p,
          "You are trying to access an element of this container"
          ^ " but the container could be `null`. " ),
      null_witness,
      [] )

  let declared_covariant pos1 pos2 emsg =
    let reason =
      Lazy.map emsg ~f:(fun emsg ->
          [
            ( Pos_or_decl.of_raw_pos pos1,
              "This is where the parameter was declared as covariant `+`" );
          ]
          @ List.map emsg ~f:(Message.map ~f:Pos_or_decl.of_raw_pos))
    in
    ( Error_code.DeclaredCovariant,
      lazy (pos2, "Illegal usage of a covariant type parameter"),
      reason,
      [] )

  let declared_contravariant pos1 pos2 emsg =
    let reason =
      Lazy.map emsg ~f:(fun emsg ->
          [
            ( Pos_or_decl.of_raw_pos pos1,
              "This is where the parameter was declared as contravariant `-`" );
          ]
          @ List.map emsg ~f:(Message.map ~f:Pos_or_decl.of_raw_pos))
    in
    ( Error_code.DeclaredContravariant,
      lazy (pos2, "Illegal usage of a contravariant type parameter"),
      reason,
      [] )

  let static_property_type_generic_param generic_pos class_pos var_type_pos =
    ( Error_code.ClassVarTypeGenericParam,
      lazy
        ( generic_pos,
          "A generic parameter cannot be used in the type of a static property"
        ),
      lazy
        [
          ( var_type_pos,
            "This is where the type of the static property was declared" );
          (class_pos, "This is the class containing the static property");
        ],
      [] )

  let contravariant_this pos class_name tp =
    ( Error_code.ContravariantThis,
      lazy
        ( pos,
          "The `this` type cannot be used in this "
          ^ "contravariant position because its enclosing class "
          ^ Markdown_lite.md_codify class_name
          ^ " "
          ^ "is final and has a variant type parameter "
          ^ Markdown_lite.md_codify tp ),
      lazy [],
      [] )

  let cyclic_typeconst pos sl =
    let claim =
      lazy
        (let sl =
           List.map sl ~f:(fun s ->
               Render.strip_ns s |> Markdown_lite.md_codify)
         in
         (pos, "Cyclic type constant:\n  " ^ String.concat ~sep:" -> " sl))
    in
    (Error_code.CyclicTypeconst, claim, lazy [], [])

  let array_get_with_optional_field
      ~(field_pos : Pos.t) ~(recv_pos : Pos.t) ~decl_pos name =
    let (_, recv_end_col) = Pos.end_line_column recv_pos in
    let open_bracket_pos =
      recv_pos
      |> Pos.set_col_start recv_end_col
      |> Pos.set_col_end (recv_end_col + 1)
    in
    let (_, field_end_col) = Pos.end_line_column field_pos in
    let close_bracket_pos =
      field_pos
      |> Pos.set_col_start field_end_col
      |> Pos.set_col_end (field_end_col + 1)
    in

    let quickfixes =
      [
        Quickfix.make_with_edits
          ~title:"Change to `Shapes::idx()`"
          ~edits:
            [
              (")", close_bracket_pos);
              (", ", open_bracket_pos);
              ("Shapes::idx(", Pos.shrink_to_start recv_pos);
            ];
      ]
    in
    ( Error_code.ArrayGetWithOptionalField,
      lazy
        ( field_pos,
          Printf.sprintf
            "The field %s may not be present in this shape. Use `??` or `Shapes::idx()` instead."
            (Markdown_lite.md_codify name) ),
      lazy [(decl_pos, "This is where the field was declared as optional.")],
      quickfixes )

  let mutating_const_property pos =
    ( Error_code.AssigningToConst,
      lazy (pos, "Cannot mutate a `__Const` property"),
      lazy [],
      [] )

  let self_const_parent_not pos =
    ( Error_code.SelfConstParentNot,
      lazy (pos, "A `__Const` class may only extend other `__Const` classes"),
      lazy [],
      [] )

  let unexpected_ty_in_tast pos ~actual_ty ~expected_ty =
    ( Error_code.UnexpectedTy,
      lazy
        ( pos,
          "Unexpected type in TAST: expected "
          ^ Markdown_lite.md_codify expected_ty
          ^ ", got "
          ^ Markdown_lite.md_codify actual_ty ),
      lazy [],
      [] )

  let call_lvalue pos =
    ( Error_code.CallLvalue,
      lazy
        ( pos,
          "Array updates cannot be applied to function results. Use a local variable instead."
        ),
      lazy [],
      [] )

  let unsafe_cast_await pos =
    ( Error_code.UnsafeCastAwait,
      lazy
        (pos, "UNSAFE_CAST cannot be used as the operand of an await operation"),
      lazy [],
      [] )

  let match_not_exhaustive pos ty =
    let backticks ty = "`" ^ ty ^ "`" in
    ( Error_code.MatchNotExhaustive,
      lazy
        ( pos,
          "This match statement is not exhaustive: there is no arm matching values of type "
          ^ backticks ty ),
      lazy [],
      [] )

  let match_on_unsupported_type pos expr_ty unsupported_tys =
    let backticks ty = "`" ^ ty ^ "`" in
    ( Error_code.MatchOnUnsupportedType,
      lazy
        ( pos,
          "This expression has type "
          ^ backticks expr_ty
          ^ ", which is not supported in match statements"
          ^
          match unsupported_tys with
          | [] -> ""
          | [ty] when String.equal ty expr_ty -> ""
          | [ty] -> " because it contains the type " ^ backticks ty
          | _ ->
            " because it contains the following types: "
            ^ (unsupported_tys
              |> List.map ~f:backticks
              |> String.concat ~sep:", ") ),
      lazy [],
      [] )

  let to_error t ~env =
    let open Typing_error.Primary in
    match t with
    | Coeffect err -> Eval_coeffect.to_error err ~env
    | Enum err -> Eval_enum.to_error err ~env
    | Expr_tree err -> Eval_expr_tree.to_error err ~env
    | Modules err -> Eval_modules.to_error err ~env
    | Readonly err -> Eval_readonly.to_error err ~env
    | Shape err -> Eval_shape.to_error err ~env
    | Wellformedness err -> Eval_wellformedness.to_error err ~env
    | Xhp err -> Eval_xhp.to_error err ~env
    | CaseType err -> Eval_casetype.to_error err ~env
    | Unify_error { pos; msg_opt; reasons_opt } ->
      unify_error pos msg_opt reasons_opt
    | Generic_unify { pos; msg } -> generic_unify pos msg
    | Unresolved_tyvar pos -> unresolved_tyvar pos
    | Using_error { pos; has_await } -> using_error pos has_await
    | Bad_enum_decl pos -> bad_enum_decl pos
    | Bad_conditional_support_dynamic
        { pos; child; parent; ty_name; self_ty_name } ->
      bad_conditional_support_dynamic pos child parent ty_name self_ty_name
    | Bad_decl_override { pos; name; parent_name } ->
      bad_decl_override name pos parent_name
    | Explain_where_constraint { pos; decl_pos; in_class } ->
      explain_where_constraint pos decl_pos in_class
    | Explain_constraint pos -> explain_constraint pos
    | Rigid_tvar_escape { pos; what } -> rigid_tvar_escape pos what
    | Invalid_type_hint pos -> invalid_type_hint pos
    | Unsatisfied_req { pos; trait_pos; req_name; req_pos } ->
      unsatisfied_req pos trait_pos req_name req_pos
    | Unsatisfied_req_class { pos; trait_pos; req_name; req_pos } ->
      unsatisfied_req_class pos trait_pos req_name req_pos
    | Req_class_not_final { pos; trait_pos; req_pos } ->
      req_class_not_final pos trait_pos req_pos
    | Incompatible_reqs { pos; req_name; req_class_pos; req_extends_pos } ->
      incompatible_reqs pos req_name req_class_pos req_extends_pos
    | Trait_not_used { pos; trait_name; req_class_pos; class_pos; class_name }
      ->
      trait_not_used pos trait_name req_class_pos class_pos class_name
    | Invalid_echo_argument pos -> invalid_echo_argument pos
    | Index_type_mismatch { pos; is_covariant_container; msg_opt; reasons_opt }
      ->
      index_type_mismatch pos is_covariant_container msg_opt reasons_opt
    | Member_not_found
        { pos; kind; member_name; class_name; class_pos; hint; reason } ->
      member_not_found
        pos
        kind
        member_name
        class_name
        class_pos
        (Lazy.force hint)
        reason
    | Construct_not_instance_method pos -> construct_not_instance_method pos
    | Ambiguous_inheritance { pos; origin; class_name } ->
      ambiguous_inheritance pos origin class_name
    | Expected_tparam { pos; n; decl_pos } -> expected_tparam pos n decl_pos
    | Typeconst_concrete_concrete_override { pos; decl_pos } ->
      typeconst_concrete_concrete_override pos decl_pos
    | Constant_multiple_concrete_conflict { pos; name; definitions } ->
      constant_multiple_concrete_conflict pos name definitions
    | Invalid_memoized_param { pos; reason; _ } ->
      invalid_memoized_param pos reason
    | Invalid_arraykey
        { pos; container_pos; container_ty_name; key_pos; key_ty_name; ctxt } ->
      invalid_arraykey
        pos
        container_pos
        (Lazy.force container_ty_name)
        key_pos
        (Lazy.force key_ty_name)
        ctxt
    | Invalid_keyset_value
        { pos; container_pos; container_ty_name; value_pos; value_ty_name } ->
      invalid_keyset_value
        pos
        container_pos
        (Lazy.force container_ty_name)
        value_pos
        (Lazy.force value_ty_name)
    | Invalid_set_value
        { pos; container_pos; container_ty_name; value_pos; value_ty_name } ->
      invalid_set_value
        pos
        container_pos
        (Lazy.force container_ty_name)
        value_pos
        (Lazy.force value_ty_name)
    | HKT_alias_with_implicit_constraints
        {
          pos;
          typedef_name;
          typedef_pos;
          used_class_in_def_pos;
          used_class_in_def_name;
          used_class_tparam_name;
          typedef_tparam_name;
          _;
        } ->
      hkt_alias_with_implicit_constraints
        pos
        typedef_name
        typedef_pos
        used_class_in_def_pos
        used_class_in_def_name
        used_class_tparam_name
        typedef_tparam_name
    | HKT_wildcard pos -> hkt_wildcard pos
    | HKT_implicit_argument { pos; decl_pos; param_name } ->
      hkt_implicit_argument pos decl_pos param_name
    | Object_string_deprecated pos -> object_string_deprecated pos
    | Invalid_substring { pos; ty_name } -> invalid_substring pos ty_name
    | Unset_nonidx_in_strict { pos; reason } ->
      unset_nonidx_in_strict pos reason
    | Nullable_cast { pos; ty_pos; ty_name } -> nullable_cast pos ty_pos ty_name
    | Hh_expect { pos; equivalent } -> hh_expect pos equivalent
    | Null_member { pos; obj_pos_opt; ctxt; kind; member_name; reason } ->
      null_member pos ~obj_pos_opt ctxt kind member_name reason
    | Typing_too_many_args { pos; decl_pos; actual; expected } ->
      typing_too_many_args pos decl_pos actual expected
    | Typing_too_few_args { pos; decl_pos; actual; expected } ->
      typing_too_few_args pos decl_pos actual expected
    | Non_object_member { pos; ctxt; ty_name; member_name; kind; decl_pos } ->
      non_object_member pos ctxt ty_name member_name kind decl_pos
    | Static_instance_intersection
        { class_pos; instance_pos; static_pos; member_name; kind } ->
      static_instance_intersection
        class_pos
        instance_pos
        static_pos
        member_name
        kind
    | Nullsafe_property_write_context pos -> nullsafe_property_write_context pos
    | Uninstantiable_class { pos; class_name; reason_ty_opt; decl_pos } ->
      uninstantiable_class pos class_name reason_ty_opt decl_pos
    | Abstract_const_usage { pos; name; decl_pos } ->
      abstract_const_usage pos name decl_pos
    | Type_arity_mismatch { pos; decl_pos; actual; expected } ->
      type_arity_mismatch pos decl_pos actual expected
    | Member_not_implemented { pos; member_name; decl_pos; quickfixes } ->
      member_not_implemented pos member_name decl_pos quickfixes
    | Kind_mismatch { pos; decl_pos; tparam_name; expected_kind; actual_kind }
      ->
      kind_mismatch pos decl_pos tparam_name expected_kind actual_kind
    | Trait_parent_construct_inconsistent { pos; decl_pos } ->
      trait_parent_construct_inconsistent pos decl_pos
    | Top_member
        { pos; ctxt; ty_name; decl_pos; kind; name; is_nullable; ty_reasons } ->
      top_member pos ctxt ty_name decl_pos kind name is_nullable ty_reasons
    | Unresolved_tyvar_projection { pos; proj_pos; tconst_name } ->
      unresolved_tyvar_projection pos proj_pos tconst_name
    | Cyclic_class_constant { pos; class_name; const_name } ->
      cyclic_class_constant pos class_name const_name
    | Inout_annotation_missing { pos; decl_pos } ->
      inout_annotation_missing pos decl_pos
    | Inout_annotation_unexpected { pos; decl_pos; param_is_variadic; qfx_pos }
      ->
      inout_annotation_unexpected pos decl_pos param_is_variadic qfx_pos
    | Inout_argument_bad_type { pos; reasons } ->
      inout_argument_bad_type pos reasons
    | Invalid_meth_caller_calling_convention { pos; decl_pos; convention } ->
      invalid_meth_caller_calling_convention pos decl_pos convention
    | Invalid_meth_caller_readonly_return { pos; decl_pos } ->
      invalid_meth_caller_readonly_return pos decl_pos
    | Invalid_new_disposable pos -> invalid_new_disposable pos
    | Invalid_return_disposable pos -> invalid_return_disposable pos
    | Invalid_disposable_hint { pos; class_name } ->
      invalid_disposable_hint pos class_name
    | Invalid_disposable_return_hint { pos; class_name } ->
      invalid_disposable_return_hint pos class_name
    | Ambiguous_lambda { pos; uses } -> ambiguous_lambda pos uses
    | Wrong_extend_kind
        { pos; kind; name; parent_pos; parent_kind; parent_name } ->
      wrong_extend_kind pos kind name parent_pos parent_kind parent_name
    | Wrong_use_kind { pos; name; parent_pos; parent_name } ->
      wrong_use_kind pos name parent_pos parent_name
    | Smember_not_found
        { pos; kind; member_name; class_name; class_pos; hint; quickfixes } ->
      smember_not_found
        pos
        kind
        member_name
        class_name
        class_pos
        hint
        quickfixes
    | Cyclic_class_def { pos; stack } -> cyclic_class_def pos stack
    | Trait_reuse_with_final_method
        { pos; trait_name; parent_cls_name = (lazy parent_cls_name); trace } ->
      trait_reuse_with_final_method pos trait_name parent_cls_name trace
    | Trait_reuse_inside_class { pos; class_name; trait_name; occurrences } ->
      trait_reuse_inside_class pos class_name trait_name occurrences
    | Invalid_is_as_expression_hint { pos; op; reasons } ->
      invalid_is_as_expression_hint pos op reasons
    | Invalid_enforceable_type { pos; ty_info; tp_pos; tp_name; kind } ->
      invalid_enforceable_type pos ty_info kind tp_pos tp_name
    | Reifiable_attr { pos; ty_info; attr_pos; kind } ->
      reifiable_attr attr_pos kind pos ty_info
    | Invalid_newable_type_argument { pos; tp_pos; tp_name } ->
      invalid_newable_type_argument pos tp_pos tp_name
    | Invalid_newable_typaram_constraints { pos; tp_name; constraints } ->
      invalid_newable_type_param_constraints (pos, tp_name) constraints
    | Override_per_trait { pos; class_name; meth_name; trait_name; meth_pos } ->
      override_per_trait (pos, class_name) meth_name trait_name meth_pos
    | Should_not_be_override { pos; class_id; id } ->
      should_not_be_override pos class_id id
    | Trivial_strict_eq { pos; result; left; right; left_trail; right_trail } ->
      trivial_strict_eq pos result left right left_trail right_trail
    | Trivial_strict_not_nullable_compare_null { pos; result; ty_reason_msg } ->
      trivial_strict_not_nullable_compare_null pos result ty_reason_msg
    | Eq_incompatible_types { pos; left; right } ->
      eq_incompatible_types pos (Lazy.force left) (Lazy.force right)
    | Comparison_invalid_types { pos; left; right } ->
      comparison_invalid_types pos (Lazy.force left) (Lazy.force right)
    | Strict_eq_value_incompatible_types { pos; left; right } ->
      strict_eq_value_incompatible_types
        pos
        (Lazy.force left)
        (Lazy.force right)
    | Deprecated_use { pos; decl_pos_opt; msg } ->
      deprecated_use pos ~pos_def:decl_pos_opt msg
    | Cannot_declare_constant { pos; class_pos; class_name } ->
      cannot_declare_constant pos (class_pos, class_name)
    | Invalid_classname pos -> invalid_classname pos
    | Illegal_type_structure { pos; msg } -> illegal_type_structure pos msg
    | Illegal_typeconst_direct_access pos -> illegal_typeconst_direct_access pos
    | Wrong_expression_kind_attribute
        {
          pos;
          attr_name;
          expr_kind;
          attr_class_pos;
          attr_class_name;
          intf_name;
        } ->
      wrong_expression_kind_attribute
        expr_kind
        pos
        attr_name
        attr_class_pos
        attr_class_name
        intf_name
    | Ambiguous_object_access
        { pos; name; self_pos; vis; subclass_pos; class_self; class_subclass }
      ->
      ambiguous_object_access
        pos
        name
        self_pos
        vis
        subclass_pos
        class_self
        class_subclass
    | Unserializable_type { pos; message } -> unserializable_type pos message
    | Invalid_arraykey_constraint { pos; ty_name } ->
      invalid_arraykey_constraint pos @@ Lazy.force ty_name
    | Redundant_covariant { pos; msg; suggest } ->
      redundant_covariant pos msg suggest
    | Meth_caller_trait { pos; trait_name } -> meth_caller_trait pos trait_name
    | Duplicate_interface { pos; name; others } ->
      duplicate_interface pos name others
    | Reified_function_reference pos -> reified_function_reference pos
    | Class_meth_abstract_call { pos; class_name; meth_name; decl_pos } ->
      class_meth_abstract_call class_name meth_name pos decl_pos
    | Reinheriting_classish_const
        {
          pos;
          classish_name;
          src_pos;
          src_classish_name;
          existing_const_origin;
          const_name;
        } ->
      reinheriting_classish_const
        pos
        classish_name
        src_pos
        src_classish_name
        existing_const_origin
        const_name
    | Redeclaring_classish_const
        {
          pos;
          classish_name;
          redeclaration_pos;
          existing_const_origin;
          const_name;
        } ->
      redeclaring_classish_const
        pos
        classish_name
        redeclaration_pos
        existing_const_origin
        const_name
    | Abstract_function_pointer { pos; class_name; meth_name; decl_pos } ->
      abstract_function_pointer class_name meth_name pos decl_pos
    | Inherited_class_member_with_different_case
        {
          pos;
          member_type;
          name;
          name_prev;
          child_class;
          prev_class;
          prev_class_pos;
        } ->
      inherited_class_member_with_different_case
        member_type
        name
        name_prev
        pos
        child_class
        prev_class
        prev_class_pos
    | Multiple_inherited_class_member_with_different_case
        {
          pos;
          child_class_name;
          member_type;
          class1_name;
          class1_pos;
          name1;
          class2_name;
          class2_pos;
          name2;
        } ->
      multiple_inherited_class_member_with_different_case
        ~member_type
        ~name1
        ~name2
        ~class1:class1_name
        ~class2:class2_name
        ~child_class:child_class_name
        ~child_p:pos
        ~p1:class1_pos
        ~p2:class2_pos
    | Parent_support_dynamic_type
        {
          pos;
          child_name;
          child_kind;
          parent_name;
          parent_kind;
          child_support_dyn;
        } ->
      parent_support_dynamic_type
        pos
        (child_name, child_kind)
        (parent_name, parent_kind)
        child_support_dyn
    | Property_is_not_enforceable
        { pos; prop_name; class_name; prop_pos; prop_type } ->
      property_is_not_enforceable pos prop_name class_name (prop_pos, prop_type)
    | Property_is_not_dynamic
        { pos; prop_name; class_name; prop_pos; prop_type } ->
      property_is_not_dynamic pos prop_name class_name (prop_pos, prop_type)
    | Private_property_is_not_enforceable
        { pos; prop_name; class_name; prop_pos; prop_type } ->
      private_property_is_not_enforceable
        pos
        prop_name
        class_name
        (prop_pos, prop_type)
    | Private_property_is_not_dynamic
        { pos; prop_name; class_name; prop_pos; prop_type } ->
      private_property_is_not_dynamic
        pos
        prop_name
        class_name
        (prop_pos, prop_type)
    | Immutable_local pos -> immutable_local pos
    | Nonsense_member_selection { pos; kind } ->
      nonsense_member_selection pos kind
    | Consider_meth_caller { pos; class_name; meth_name } ->
      consider_meth_caller pos class_name meth_name
    | Method_import_via_diamond
        { pos; class_name; method_pos; method_name; trace1; trace2 } ->
      method_import_via_diamond
        pos
        class_name
        method_pos
        method_name
        trace1
        trace2
    | Property_import_via_diamond
        {
          generic;
          pos;
          class_name;
          property_pos;
          property_name;
          trace1;
          trace2;
        } ->
      property_import_via_diamond
        generic
        pos
        class_name
        property_pos
        property_name
        trace1
        trace2
    | Unification_cycle { pos; ty_name } ->
      unification_cycle pos @@ Lazy.force ty_name
    | Method_variance pos -> method_variance pos
    | Explain_tconst_where_constraint { pos; decl_pos; msgs } ->
      explain_tconst_where_constraint pos decl_pos msgs
    | Format_string
        { pos; snippet; fmt_string; class_pos; fn_name; class_suggest } ->
      format_string pos snippet fmt_string class_pos fn_name class_suggest
    | Expected_literal_format_string pos -> expected_literal_format_string pos
    | Re_prefixed_non_string { pos; reason } ->
      re_prefixed_non_string pos reason
    | Bad_regex_pattern { pos; reason } -> bad_regex_pattern pos reason
    | Generic_array_strict pos -> generic_array_strict pos
    | Option_return_only_typehint { pos; kind } ->
      option_return_only_typehint pos kind
    | Redeclaring_missing_method { pos; trait_method } ->
      redeclaring_missing_method pos trait_method
    | Expecting_type_hint pos -> expecting_type_hint pos
    | Expecting_type_hint_variadic pos -> expecting_type_hint_variadic pos
    | Expecting_return_type_hint pos -> expecting_return_type_hint pos
    | Duplicate_using_var pos -> duplicate_using_var pos
    | Illegal_disposable { pos; verb } -> illegal_disposable pos verb
    | Escaping_disposable pos -> escaping_disposable pos
    | Escaping_disposable_param pos -> escaping_disposable_parameter pos
    | Escaping_this pos -> escaping_this pos
    | Must_extend_disposable pos -> must_extend_disposable pos
    | Field_kinds { pos; decl_pos } -> field_kinds pos decl_pos
    | Unbound_name { pos; name; class_exists } ->
      unbound_name_typing pos name class_exists
    | Previous_default pos -> previous_default pos
    | Return_in_void { pos; decl_pos } -> return_in_void pos decl_pos
    | This_var_outside_class pos -> this_var_outside_class pos
    | Unbound_global pos -> unbound_global pos
    | Private_inst_meth { pos; decl_pos } -> private_inst_meth pos decl_pos
    | Protected_inst_meth { pos; decl_pos } -> protected_inst_meth pos decl_pos
    | Private_meth_caller { pos; decl_pos } -> private_meth_caller pos decl_pos
    | Protected_meth_caller { pos; decl_pos } ->
      protected_meth_caller pos decl_pos
    | Private_class_meth { pos; decl_pos } -> private_class_meth pos decl_pos
    | Protected_class_meth { pos; decl_pos } ->
      protected_class_meth pos decl_pos
    | Array_cast pos -> array_cast pos
    | String_cast { pos; ty_name } -> string_cast pos @@ Lazy.force ty_name
    | Static_outside_class pos -> static_outside_class pos
    | Self_outside_class pos -> self_outside_class pos
    | New_inconsistent_construct { pos; class_pos; class_name; kind } ->
      new_inconsistent_construct pos (class_pos, class_name) kind
    | Undefined_parent pos -> undefined_parent pos
    | Parent_outside_class pos -> parent_outside_class pos
    | Parent_abstract_call { pos; meth_name; decl_pos } ->
      parent_abstract_call pos meth_name decl_pos
    | Self_abstract_call { pos; self_pos; meth_name; decl_pos } ->
      self_abstract_call pos meth_name self_pos decl_pos
    | Classname_abstract_call { pos; meth_name; class_name; decl_pos } ->
      classname_abstract_call pos meth_name class_name decl_pos
    | Static_synthetic_method { pos; meth_name; class_name; decl_pos } ->
      static_synthetic_method pos meth_name class_name decl_pos
    | Static_call_on_trait_require_class
        { pos; meth_name; trait_name; req_class_name } ->
      static_call_on_trait_require_class pos meth_name trait_name req_class_name
    | Isset_in_strict pos -> isset_in_strict pos
    | Isset_inout_arg pos -> isset_inout_arg pos
    | Unpacking_disallowed_builtin_function { pos; fn_name } ->
      unpacking_disallowed_builtin_function pos fn_name
    | Array_get_arity { pos; name; decl_pos } ->
      array_get_arity pos name decl_pos
    | Undefined_field { pos; name; decl_pos } ->
      undefined_field pos name decl_pos
    | Array_access { pos; ctxt = `read; ty_name; decl_pos } ->
      array_access_read pos decl_pos @@ Lazy.force ty_name
    | Array_access { pos; ctxt = `write; ty_name; decl_pos } ->
      array_access_write pos decl_pos @@ Lazy.force ty_name
    | Keyset_set { pos; decl_pos } -> keyset_set pos decl_pos
    | Array_append { pos; ty_name; decl_pos } ->
      array_append pos decl_pos @@ Lazy.force ty_name
    | Const_mutation { pos; ty_name; decl_pos } ->
      const_mutation pos decl_pos @@ Lazy.force ty_name
    | Expected_class { pos; suffix } ->
      expected_class pos Option.(value_map ~default:"" ~f:Lazy.force suffix)
    | Unknown_type { pos; expected; reason } -> unknown_type pos expected reason
    | Parent_in_trait pos -> parent_in_trait pos
    | Parent_undefined pos -> parent_undefined pos
    | Constructor_no_args pos -> constructor_no_args pos
    | Visibility { pos; msg; decl_pos; reason_msg } ->
      visibility pos msg decl_pos reason_msg
    | Bad_call { pos; ty_name } -> bad_call pos @@ Lazy.force ty_name
    | Extend_final { pos; name; decl_pos } -> extend_final pos decl_pos name
    | Extend_sealed { pos; parent_pos; parent_name; parent_kind; verb } ->
      extend_sealed pos parent_pos parent_name parent_kind verb
    | Sealed_not_subtype { pos; name; child_kind; child_pos; child_name } ->
      sealed_not_subtype pos name child_name child_kind child_pos
    | Trait_prop_const_class { pos; name } -> trait_prop_const_class pos name
    | Implement_abstract
        { pos; is_final; decl_pos; trace; name; kind; quickfixes } ->
      implement_abstract pos is_final decl_pos name kind quickfixes trace
    | Abstract_member_in_concrete_class
        { pos; class_name_pos; is_final; member_kind; member_name } ->
      abstract_member_in_concrete_class
        ~member_pos:pos
        ~class_name_pos
        ~is_final
        member_kind
        member_name
    | Generic_static { pos; typaram_name } -> generic_static pos typaram_name
    | Ellipsis_strict_mode { pos; require } -> ellipsis_strict_mode pos require
    | Object_string { pos; decl_pos } -> object_string pos decl_pos
    | Cyclic_typedef { pos; decl_pos } -> cyclic_typedef pos decl_pos
    | Require_args_reify { pos; decl_pos } -> require_args_reify pos decl_pos
    | Require_generic_explicit { pos; param_name; decl_pos } ->
      require_generic_explicit pos decl_pos param_name
    | Invalid_reified_arg { pos; param_name; decl_pos; arg_info } ->
      invalid_reified_argument pos param_name decl_pos arg_info
    | Invalid_reified_arg_reifiable
        { pos; param_name : string; decl_pos; ty_pos; ty_msg } ->
      invalid_reified_argument_reifiable pos param_name decl_pos ty_pos
      @@ Lazy.force ty_msg
    | New_class_reified { pos; class_kind; suggested_class_name } ->
      new_class_reified pos class_kind suggested_class_name
    | Class_get_reified pos -> class_get_reified pos
    | Static_meth_with_class_reified_generic { pos; generic_pos } ->
      static_meth_with_class_reified_generic pos generic_pos
    | Consistent_construct_reified pos -> consistent_construct_reified pos
    | Bad_fn_ptr_construction pos -> bad_function_pointer_construction pos
    | Reified_generics_not_allowed pos -> reified_generics_not_allowed pos
    | New_without_newable { pos; name } -> new_without_newable pos name
    | Discarded_awaitable { pos; decl_pos } -> discarded_awaitable pos decl_pos
    | Unknown_object_member { pos; member_name; elt; reason } ->
      unknown_object_member pos member_name elt reason
    | Non_class_member { pos; member_name; elt; ty_name; decl_pos } ->
      non_class_member pos member_name elt (Lazy.force ty_name) decl_pos
    | Null_container { pos; null_witness } -> null_container pos null_witness
    | Declared_covariant { pos; param_pos; msgs } ->
      declared_covariant param_pos pos msgs
    | Declared_contravariant { pos; param_pos; msgs } ->
      declared_contravariant pos param_pos msgs
    | Static_prop_type_generic_param { pos; var_ty_pos; class_pos } ->
      static_property_type_generic_param pos class_pos var_ty_pos
    | Contravariant_this { pos; class_name; typaram_name } ->
      contravariant_this pos class_name typaram_name
    | Cyclic_typeconst { pos; tyconst_names } ->
      cyclic_typeconst pos tyconst_names
    | Array_get_with_optional_field
        { recv_pos; field_pos; field_name; decl_pos } ->
      array_get_with_optional_field field_name ~decl_pos ~recv_pos ~field_pos
    | Mutating_const_property pos -> mutating_const_property pos
    | Self_const_parent_not pos -> self_const_parent_not pos
    | Unexpected_ty_in_tast { pos; expected_ty; actual_ty } ->
      unexpected_ty_in_tast
        pos
        ~expected_ty:(Lazy.force expected_ty)
        ~actual_ty:(Lazy.force actual_ty)
    | Call_lvalue pos -> call_lvalue pos
    | Unsafe_cast_await pos -> unsafe_cast_await pos
    | Match_not_exhaustive { pos; ty_not_covered } ->
      match_not_exhaustive pos (Lazy.force ty_not_covered)
    | Match_on_unsupported_type { pos; expr_ty; unsupported_tys } ->
      match_on_unsupported_type
        pos
        (Lazy.force expr_ty)
        (List.map unsupported_tys ~f:Lazy.force)
end

module rec Eval_error : sig
  val eval :
    Typing_error.Error.t ->
    env:Typing_env_types.env ->
    current_span:Pos.t ->
    error Eval_result.t

  val to_user_error :
    Typing_error.Error.t ->
    env:Typing_env_types.env ->
    current_span:Pos.t ->
    (Pos.t, Pos_or_decl.t) User_error.t Eval_result.t
end = struct
  let eval t ~env ~current_span =
    let open Typing_error.Error in
    let rec aux ~k = function
      | Primary base ->
        k @@ Eval_result.single @@ Eval_primary.to_error base ~env
      | With_code (t, code) ->
        aux t ~k:(fun res ->
            k
            @@ Eval_result.map res ~f:(fun (_, claim, reason, qfx) ->
                   (code, claim, reason, qfx)))
      | Intersection ts -> auxs ~k:(fun xs -> k @@ Eval_result.intersect xs) ts
      | Union ts -> auxs ~k:(fun xs -> k @@ Eval_result.union xs) ts
      | Multiple ts -> auxs ~k:(fun xs -> k @@ Eval_result.multiple xs) ts
      | Apply (cb, err) ->
        aux err ~k:(fun t ->
            k
            @@ Eval_result.bind t ~f:(fun (code, claim, reasons, quickfixes) ->
                   Eval_result.single
                   @@ Eval_callback.apply
                        cb
                        ~env
                        ~code
                        ~claim
                        ~reasons
                        ~quickfixes))
      | Apply_reasons (cb, snd_err) ->
        k
        @@ Eval_result.bind ~f:(fun (code, reasons) ->
               Eval_reasons_callback.apply_help
                 cb
                 ~code
                 ~reasons
                 ~env
                 ~current_span)
        @@ Eval_secondary.eval snd_err ~env ~current_span
      | Assert_in_current_decl (snd_err, ctx) ->
        k
        @@ Eval_result.bind ~f:(fun e ->
               Eval_result.of_option @@ Common.eval_assert ctx current_span e)
        @@ Eval_secondary.eval snd_err ~env ~current_span
    and auxs ~k = function
      | [] -> k []
      | next :: rest ->
        aux next ~k:(fun x -> auxs rest ~k:(fun xs -> k @@ (x :: xs)))
    in
    aux ~k:Fn.id t

  let make_error (code, claim, reasons, quickfixes) ~custom_msgs =
    User_error.make
      (Error_code.to_enum code)
      (Lazy.force claim)
      (Lazy.force reasons)
      ~quickfixes
      ~custom_msgs

  let render_custom_error
      (t : (string, Custom_error_eval.Value.t) Base.Either.t list) ~env =
    List.fold_right
      t
      ~f:(fun v acc ->
        match v with
        | Core.Either.First str -> str ^ acc
        | Either.Second (Custom_error_eval.Value.Name (_, nm)) ->
          Markdown_lite.md_codify nm ^ acc
        | Either.Second (Custom_error_eval.Value.Ty ty) ->
          (Markdown_lite.md_codify
          @@ Typing_print.with_blank_tyvars (fun () ->
                 Typing_print.full_strip_ns_i env
                 @@ Typing_defs_core.LoclType ty))
          ^ acc)
      ~init:""

  let to_user_error t ~env ~current_span =
    let result = eval t ~env ~current_span in
    let custom_err_config =
      TypecheckerOptions.custom_error_config (Typing_env.get_tcopt env)
    in
    let custom_msgs =
      List.map ~f:(render_custom_error ~env)
      @@ Custom_error_eval.eval custom_err_config ~err:t
    in
    Eval_result.map ~f:(make_error ~custom_msgs) result
end

and Eval_secondary : sig
  val eval :
    Typing_error.Secondary.t ->
    env:Typing_env_types.env ->
    current_span:Pos.t ->
    (Error_code.t * Pos_or_decl.t Message.t list Lazy.t) Eval_result.t
end = struct
  let fun_too_many_args pos decl_pos actual expected =
    let reasons =
      lazy
        [
          ( pos,
            Printf.sprintf
              "Too many mandatory arguments (expected %d but got %d)"
              expected
              actual );
          (decl_pos, "Because of this definition");
        ]
    in
    (Error_code.FunTooManyArgs, reasons)

  let fun_too_few_args pos decl_pos actual expected =
    let reasons =
      lazy
        [
          ( pos,
            Printf.sprintf
              "Too few arguments (required %d but got %d)"
              expected
              actual );
          (decl_pos, "Because of this definition");
        ]
    in
    (Error_code.FunTooFewArgs, reasons)

  let fun_unexpected_nonvariadic pos decl_pos =
    let reasons =
      lazy
        [
          (pos, "Should have a variadic argument");
          (decl_pos, "Because of this definition");
        ]
    in
    (Error_code.FunUnexpectedNonvariadic, reasons)

  let fun_variadicity_hh_vs_php56 pos decl_pos =
    let reasons =
      lazy
        [
          (pos, "Variadic arguments: `...`-style is not a subtype of `...$args`");
          (decl_pos, "Because of this definition");
        ]
    in
    (Error_code.FunVariadicityHhVsPhp56, reasons)

  let type_arity_mismatch pos actual decl_pos expected =
    let reasons =
      lazy
        [
          (pos, "This type has " ^ string_of_int actual ^ " arguments");
          (decl_pos, "This one has " ^ string_of_int expected);
        ]
    in
    (Error_code.TypeArityMismatch, reasons)

  (* In typing_coercion.ml we sometimes check t1 <: t2 by adding dynamic
     to check t1 < t|dynamic. In that case, we use the Rdynamic_coercion
     reason so that we can detect it here and not print the dynamic if there
     is a type error. *)
  let detect_attempting_dynamic_coercion_reason r ty =
    let open Typing_defs_core in
    match r with
    | Typing_reason.Rdynamic_coercion r ->
      (match ty with
      | LoclType lty ->
        (match get_node lty with
        | Tunion [t1; t2] ->
          (match (get_node t1, get_node t2) with
          | (Tdynamic, _) -> (r, LoclType t2)
          | (_, Tdynamic) -> (r, LoclType t1)
          | _ -> (r, ty))
        | _ -> (r, ty))
      | _ -> (r, ty))
    | _ -> (r, ty)

  let describe_coeffect env ty =
    lazy
      (let (env, ty) = Typing_utils.simplify_intersections env ty in
       Typing_print.coeffects env ty)

  let describe_ty_default env ty =
    Typing_print.with_blank_tyvars (fun () ->
        Typing_print.full_strip_ns_i env ty)

  let describe_ty ~is_coeffect =
    (* Optimization: specialize on partial application, i.e.
       *    let describe_ty_sub = describe_ty ~is_coeffect in
       *  will check the flag only once, not every time the function is called *)
    if not is_coeffect then
      describe_ty_default
    else
      fun env -> function
       | Typing_defs_core.LoclType ty -> Lazy.force @@ describe_coeffect env ty
       | ty -> describe_ty_default env ty

  let rec describe_ty_super ~is_coeffect env ty =
    let open Typing_defs_core in
    let describe_ty_super = describe_ty_super ~is_coeffect in
    let print = (describe_ty ~is_coeffect) env in
    let default () = print ty in
    match ty with
    | LoclType ty ->
      let (env, ty) = Typing_env.expand_type env ty in
      (match Typing_defs_core.get_node ty with
      | Typing_defs_core.Tvar v ->
        let upper_bounds =
          Internal_type_set.elements (Typing_env.get_tyvar_upper_bounds env v)
        in
        (* The constraint graph is transitively closed so we can filter tyvars. *)
        let upper_bounds =
          List.filter upper_bounds ~f:(fun t -> not (Typing_defs.is_tyvar_i t))
        in
        (match upper_bounds with
        | [] -> "some type not known yet"
        | tyl ->
          let (locl_tyl, cstr_tyl) =
            List.partition_tf tyl ~f:Typing_defs.is_locl_type
          in
          let sep =
            match (locl_tyl, cstr_tyl) with
            | (_ :: _, _ :: _) -> " and "
            | _ -> ""
          in
          let locl_descr =
            match locl_tyl with
            | [] -> ""
            | tyl ->
              "of type "
              ^ (String.concat ~sep:" & " (List.map tyl ~f:print)
                |> Markdown_lite.md_codify)
          in
          let cstr_descr =
            String.concat
              ~sep:" and "
              (List.map cstr_tyl ~f:(describe_ty_super env))
          in
          "something " ^ locl_descr ^ sep ^ cstr_descr)
      | Toption ty when Typing_defs.is_tyvar ty ->
        "`null` or " ^ describe_ty_super env (LoclType ty)
      | _ -> Markdown_lite.md_codify (default ()))
    | ConstraintType ty ->
      (match deref_constraint_type ty with
      | (_, Thas_member hm) ->
        let {
          hm_name = (_, name);
          hm_type = _;
          hm_class_id = _;
          hm_explicit_targs = targs;
        } =
          hm
        in
        (match targs with
        | None -> Printf.sprintf "an object with property `%s`" name
        | Some _ -> Printf.sprintf "an object with method `%s`" name)
      | (_, Thas_type_member htm) ->
        let { htm_id = id; htm_lower = lo; htm_upper = up } = htm in
        if phys_equal lo up then
          (* We use physical equality as a heuristic to generate
             slightly more readable descriptions. *)
          Printf.sprintf
            "a class with `{type %s = %s}`"
            id
            (describe_ty ~is_coeffect:false env (LoclType lo))
        else
          let bound_desc ~prefix ~is_trivial bnd =
            if is_trivial env bnd then
              ""
            else
              prefix ^ describe_ty ~is_coeffect:false env (LoclType bnd)
          in
          Printf.sprintf
            "a class with `{type %s%s%s}`"
            id
            (bound_desc
               ~prefix:" super "
               ~is_trivial:Typing_utils.is_nothing
               lo)
            (bound_desc ~prefix:" as " ~is_trivial:Typing_utils.is_mixed up)
      | (_, Tcan_traverse _) -> "an array that can be traversed with foreach"
      | (_, Tcan_index _) -> "an array that can be indexed"
      | (_, Tdestructure _) ->
        Markdown_lite.md_codify
          (Typing_print.with_blank_tyvars (fun () ->
               Typing_print.full_strip_ns_i env (ConstraintType ty)))
      | (_, TCunion (lty, cty)) ->
        Printf.sprintf
          "%s or %s"
          (describe_ty_super env (LoclType lty))
          (describe_ty_super env (ConstraintType cty))
      | (_, TCintersection (lty, cty)) ->
        Printf.sprintf
          "%s and %s"
          (describe_ty_super env (LoclType lty))
          (describe_ty_super env (ConstraintType cty)))

  let describe_ty_sub ~is_coeffect env ety =
    let ty_descr = describe_ty ~is_coeffect env ety in
    let ty_constraints =
      match ety with
      | Typing_defs.LoclType ty -> Typing_print.constraints_for_type env ty
      | Typing_defs.ConstraintType _ -> ""
    in

    let ( = ) = String.equal in
    let ty_constraints =
      (* Don't say `T as T` as it's not helpful (occurs in some coffect errors). *)
      if ty_constraints = "as " ^ ty_descr then
        ""
      else if ty_constraints = "" then
        ""
      else
        " " ^ ty_constraints
    in
    Markdown_lite.md_codify (ty_descr ^ ty_constraints)

  let explain_subtype_failure is_coeffect ~ty_sub ~ty_sup env =
    lazy
      (let r_super = Typing_defs.reason ty_sup in
       let r_sub = Typing_defs.reason ty_sub in
       let (r_super, ty_sup) =
         detect_attempting_dynamic_coercion_reason r_super ty_sup
       in
       let ty_super_descr = describe_ty_super ~is_coeffect env ty_sup in
       let ty_sub_descr = describe_ty_sub ~is_coeffect env ty_sub in
       let (ty_super_descr, ty_sub_descr) =
         if String.equal ty_super_descr ty_sub_descr then
           ( "exactly the type " ^ ty_super_descr,
             "the nonexact type " ^ ty_sub_descr )
         else
           (ty_super_descr, ty_sub_descr)
       in
       let left =
         Typing_reason.to_string ("Expected " ^ ty_super_descr) r_super
       in
       let right = Typing_reason.to_string ("But got " ^ ty_sub_descr) r_sub in
       left @ right)

  let subtyping_error is_coeffect ~ty_sub ~ty_sup env =
    ( Error_code.UnifyError,
      explain_subtype_failure is_coeffect ~ty_sub ~ty_sup env )

  let violated_constraint cstrs is_coeffect ~ty_sub ~ty_sup env =
    let reason =
      Lazy.map
        ~f:(fun reasons ->
          let pos_msg = "This type constraint is violated" in
          let f (p_cstr, (p_tparam, tparam)) =
            [
              ( p_tparam,
                Printf.sprintf
                  "%s is a constrained type parameter"
                  (Markdown_lite.md_codify tparam) );
              (p_cstr, pos_msg);
            ]
          in
          let msgs = List.concat_map ~f cstrs in
          msgs @ reasons)
        (explain_subtype_failure is_coeffect ~ty_sub ~ty_sup env)
    in
    (Error_code.TypeConstraintViolation, reason)

  let concrete_const_interface_override pos parent_pos name parent_origin =
    let reasons =
      lazy
        [
          ( pos,
            "Non-abstract constants defined in an interface cannot be overridden when implementing or extending that interface."
          );
          ( parent_pos,
            "You could make "
            ^ Markdown_lite.md_codify name
            ^ " abstract in "
            ^ (Markdown_lite.md_codify @@ Render.strip_ns parent_origin)
            ^ "." );
        ]
    in
    (Error_code.ConcreteConstInterfaceOverride, reasons)

  let interface_or_trait_const_multiple_defs
      pos origin parent_pos parent_origin name =
    let reasons =
      lazy
        (let parent_origin = Render.strip_ns parent_origin
         and child_origin = Render.strip_ns origin in
         [
           ( pos,
             "Non-abstract constants defined in an interface or trait cannot conflict with other inherited constants."
           );
           ( parent_pos,
             Markdown_lite.md_codify name
             ^ " inherited from "
             ^ Markdown_lite.md_codify parent_origin );
           ( pos,
             "conflicts with constant "
             ^ Markdown_lite.md_codify name
             ^ " inherited from "
             ^ Markdown_lite.md_codify child_origin
             ^ "." );
         ])
    in
    (Error_code.ConcreteConstInterfaceOverride, reasons)

  let interface_typeconst_multiple_defs
      pos parent_pos name origin parent_origin is_abstract =
    let reasons =
      lazy
        (let parent_origin = Render.strip_ns parent_origin
         and child_origin = Render.strip_ns origin
         and child_pos = pos
         and child =
           if is_abstract then
             "abstract type constant with default value"
           else
             "concrete type constant"
         in
         [
           ( pos,
             "Concrete and abstract type constants with default values in an interface cannot conflict with inherited"
             ^ " concrete or abstract type constants with default values." );
           ( parent_pos,
             Markdown_lite.md_codify name
             ^ " inherited from "
             ^ Markdown_lite.md_codify parent_origin );
           ( child_pos,
             "conflicts with "
             ^ Markdown_lite.md_codify child
             ^ " "
             ^ Markdown_lite.md_codify name
             ^ " inherited from "
             ^ Markdown_lite.md_codify child_origin
             ^ "." );
         ])
    in
    (Error_code.ConcreteConstInterfaceOverride, reasons)

  let missing_field pos name decl_pos =
    let reasons =
      lazy
        [
          (pos, "The field " ^ Markdown_lite.md_codify name ^ " is missing");
          (decl_pos, "The field " ^ Markdown_lite.md_codify name ^ " is defined");
        ]
    in
    (Error_code.MissingField, reasons)

  let shape_fields_unknown pos decl_pos =
    let reasons =
      lazy
        [
          ( pos,
            "This shape type allows unknown fields, and so it may contain fields other than those explicitly declared in its declaration."
          );
          ( decl_pos,
            "It is incompatible with a shape that does not allow unknown fields."
          );
        ]
    in
    (Error_code.ShapeFieldsUnknown, reasons)

  let abstract_tconst_not_allowed pos decl_pos tconst_name =
    let reasons =
      lazy
        [
          (pos, "An abstract type constant is not allowed in this position.");
          ( decl_pos,
            Printf.sprintf
              "%s is abstract here."
              (Markdown_lite.md_codify tconst_name) );
        ]
    in
    (Error_code.AbstractTconstNotAllowed, reasons)

  let invalid_destructure pos decl_pos ty_name =
    let reasons =
      lazy
        [
          ( pos,
            "This expression cannot be destructured with a `list(...)` expression"
          );
          (decl_pos, "This is " ^ Markdown_lite.md_codify @@ Lazy.force ty_name);
        ]
    in
    (Error_code.InvalidDestructure, reasons)

  let unpack_array_required_argument pos decl_pos =
    let reasons =
      lazy
        [
          ( pos,
            "An array cannot be unpacked into the required arguments of a function"
          );
          (decl_pos, "Definition is here");
        ]
    in
    (Error_code.SplatArrayRequired, reasons)

  let unpack_array_variadic_argument pos decl_pos =
    let reasons =
      lazy
        [
          ( pos,
            "A function that receives an unpacked array as an argument must have a variadic parameter to accept the elements of the array"
          );
          (decl_pos, "Definition is here");
        ]
    in
    (Error_code.SplatArrayRequired, reasons)

  let overriding_prop_const_mismatch pos is_const parent_pos =
    let reasons =
      lazy
        (let (msg, reason_msg) =
           if is_const then
             ("This property is `__Const`", "This property is not `__Const`")
           else
             ("This property is not `__Const`", "This property is `__Const`")
         in
         [(pos, msg); (parent_pos, reason_msg)])
    in
    (Error_code.OverridingPropConstMismatch, reasons)

  let visibility_extends pos vis parent_pos parent_vis =
    let reasons =
      lazy
        [
          (pos, "This member visibility is: " ^ Markdown_lite.md_codify vis);
          (parent_pos, Markdown_lite.md_codify parent_vis ^ " was expected");
        ]
    in
    (Error_code.VisibilityExtends, reasons)

  let visibility_override_internal pos module_name parent_module parent_pos =
    let reasons =
      lazy
        (let msg =
           match module_name with
           | None ->
             Printf.sprintf
               "Cannot override this member outside module `%s`"
               parent_module
           | Some m ->
             Printf.sprintf "Cannot override this member in module `%s`" m
         in
         [
           (pos, msg);
           ( parent_pos,
             Printf.sprintf
               "This member is internal to module `%s`"
               parent_module );
         ])
    in
    (Error_code.ModuleError, reasons)

  let missing_constructor pos =
    let reasons = lazy [(pos, "The constructor is not implemented")] in
    (Error_code.MissingConstructor, reasons)

  let accept_disposable_invariant pos decl_pos =
    let reasons =
      lazy
        [
          (pos, "This parameter is marked `<<__AcceptDisposable>>`");
          (decl_pos, "This parameter is not marked `<<__AcceptDisposable>>`");
        ]
    in
    (Error_code.AcceptDisposableInvariant, reasons)

  let required_field_is_optional pos name decl_pos def_pos =
    let reasons =
      lazy
        [
          (pos, "The field " ^ Markdown_lite.md_codify name ^ " is **optional**");
          ( decl_pos,
            "The field "
            ^ Markdown_lite.md_codify name
            ^ " is defined as **required**" );
          (def_pos, Markdown_lite.md_codify name ^ " is defined here");
        ]
    in
    (Error_code.RequiredFieldIsOptional, reasons)

  let return_disposable_mismatch pos_sub is_marked_return_disposable pos_super =
    let reasons =
      lazy
        (let (msg, reason_msg) =
           if is_marked_return_disposable then
             ( "This is marked `<<__ReturnDisposable>>`.",
               "This is not marked `<<__ReturnDisposable>>`." )
           else
             ( "This is not marked `<<__ReturnDisposable>>`.",
               "This is marked `<<__ReturnDisposable>>`." )
         in
         [(pos_super, msg); (pos_sub, reason_msg)])
    in
    (Error_code.ReturnDisposableMismatch, reasons)

  let override_final pos parent_pos =
    let reasons =
      lazy
        [
          (pos, "You cannot override this method");
          (parent_pos, "It was declared as final");
        ]
    in
    (Error_code.OverrideFinal, reasons)

  let override_async pos parent_pos =
    let reasons =
      lazy
        [
          (pos, "You cannot override this method with a non-async method");
          (parent_pos, "It was declared as async");
        ]
    in
    (Error_code.OverrideAsync, reasons)

  let override_lsb pos member_name parent_pos =
    let reasons =
      lazy
        [
          ( pos,
            "Member "
            ^ Markdown_lite.md_codify member_name
            ^ " may not override `__LSB` member of parent" );
          (parent_pos, "This is being overridden");
        ]
    in
    (Error_code.OverrideLSB, reasons)

  let multiple_concrete_defs pos origin name parent_pos parent_origin class_name
      =
    let reasons =
      lazy
        (let child_origin = Markdown_lite.md_codify @@ Render.strip_ns origin
         and parent_origin =
           Markdown_lite.md_codify @@ Render.strip_ns parent_origin
         and class_ = Markdown_lite.md_codify @@ Render.strip_ns class_name
         and name = Markdown_lite.md_codify name in
         [
           ( pos,
             child_origin
             ^ " and "
             ^ parent_origin
             ^ " both declare ambiguous implementations of "
             ^ name
             ^ "." );
           (pos, child_origin ^ "'s definition is here.");
           (parent_pos, parent_origin ^ "'s definition is here.");
           ( pos,
             "Redeclare "
             ^ name
             ^ " in "
             ^ class_
             ^ " with a compatible signature." );
         ])
    in
    (Error_code.MultipleConcreteDefs, reasons)

  let cyclic_enum_constraint pos =
    let reasons = lazy [(pos, "Cyclic enum constraint")] in
    (Error_code.CyclicEnumConstraint, reasons)

  let inoutness_mismatch pos decl_pos =
    let reasons =
      lazy
        [
          (pos, "This is an `inout` parameter");
          (decl_pos, "It is incompatible with a normal parameter");
        ]
    in
    (Error_code.InoutnessMismatch, reasons)

  let decl_override_missing_hint pos =
    let reasons =
      lazy
        [
          ( pos,
            "When redeclaring class members, both declarations must have a typehint"
          );
        ]
    in
    (Error_code.DeclOverrideMissingHint, reasons)

  let bad_lateinit_override pos parent_pos parent_is_lateinit =
    let reasons =
      lazy
        (let verb =
           if parent_is_lateinit then
             "is"
           else
             "is not"
         in
         [
           ( pos,
             "Redeclared properties must be consistently declared `__LateInit`"
           );
           (parent_pos, "The property " ^ verb ^ " declared `__LateInit` here");
         ])
    in

    (Error_code.BadLateInitOverride, reasons)

  let bad_xhp_attr_required_override pos parent_pos parent_tag tag =
    let reasons =
      lazy
        [
          (pos, "Redeclared attribute must not be less strict");
          ( parent_pos,
            "The attribute is " ^ parent_tag ^ ", which is stricter than " ^ tag
          );
        ]
    in
    (Error_code.BadXhpAttrRequiredOverride, reasons)

  let coeffect_subtyping pos cap pos_expected cap_expected =
    let reasons =
      lazy
        [
          ( pos_expected,
            "Expected a function that requires " ^ Lazy.force cap_expected );
          (pos, "But got a function that requires " ^ Lazy.force cap);
        ]
    in
    (Error_code.SubtypeCoeffects, reasons)

  let not_sub_dynamic pos ty_name dynamic_part =
    let reasons =
      Lazy.map dynamic_part ~f:(fun xs ->
          xs
          @ [
              ( pos,
                "Type "
                ^ (Markdown_lite.md_codify @@ Lazy.force ty_name)
                ^ " is not a subtype of `dynamic` under dynamic-aware subtyping"
              );
            ])
    in
    (Error_code.UnifyError, reasons)

  let override_method_support_dynamic_type
      pos method_name parent_origin parent_pos =
    let reasons =
      lazy
        [
          ( pos,
            "Method "
            ^ method_name
            ^ " must be declared <<__SupportDynamicType>> because it overrides method in class "
            ^ Render.strip_ns parent_origin
            ^ " which does." );
          (parent_pos, "Overridden method is defined here.");
        ]
    in
    (Error_code.ImplementsDynamic, reasons)

  let readonly_mismatch pos kind reason_sub reason_super =
    let reasons =
      Lazy.(
        reason_sub >>= fun reason_sub ->
        reason_super >>= fun reason_super ->
        return
          (( pos,
             match kind with
             | `fn -> "Function readonly mismatch"
             | `fn_return -> "Function readonly return mismatch"
             | `param -> "Mismatched parameter readonlyness" )
           :: reason_sub
          @ reason_super))
    in
    (Error_code.ReadonlyMismatch, reasons)

  let cross_package_mismatch pos reason_sub reason_super =
    let reasons =
      Lazy.(
        reason_sub >>= fun reason_sub ->
        reason_super >>= fun reason_super ->
        return (((pos, "Cross package mismatch") :: reason_sub) @ reason_super))
    in
    (Error_code.InvalidCrossPackage, reasons)

  let typing_too_many_args pos decl_pos actual expected =
    let (code, claim, reasons) =
      Common.typing_too_many_args pos decl_pos actual expected
    in
    let reasons =
      Lazy.(
        claim >>= fun x ->
        reasons >>= fun xs -> return (x :: xs))
    in
    (code, reasons)

  let typing_too_few_args pos decl_pos actual expected =
    let (code, claim, reasons) =
      Common.typing_too_few_args pos decl_pos actual expected
    in
    let reasons =
      Lazy.(
        claim >>= fun x ->
        reasons >>= fun xs -> return (x :: xs))
    in
    (code, reasons)

  let non_object_member pos ctxt ty_name member_name kind decl_pos =
    let (code, claim, reasons) =
      Common.non_object_member
        pos
        ctxt
        (Lazy.force ty_name)
        member_name
        kind
        decl_pos
    in
    let reasons =
      Lazy.(
        claim >>= fun x ->
        reasons >>= fun xs -> return (x :: xs))
    in
    (code, reasons)

  let rigid_tvar_escape pos name =
    ( Error_code.RigidTVarEscape,
      lazy [(pos, "Rigid type variable " ^ name ^ " is escaping")] )

  let smember_not_found pos kind member_name class_name class_pos hint =
    let (code, claim, reasons) =
      Common.smember_not_found pos kind member_name class_name class_pos hint
    in
    let reasons =
      Lazy.(
        claim >>= fun x ->
        reasons >>= fun xs -> return (x :: xs))
    in
    (code, reasons)

  let bad_method_override pos member_name =
    let reasons =
      lazy
        [
          ( pos,
            "The method "
            ^ (Render.strip_ns member_name |> Markdown_lite.md_codify)
            ^ " is not compatible with the overridden method" );
        ]
    in
    (Error_code.BadMethodOverride, reasons)

  let bad_prop_override pos member_name =
    let reasons =
      lazy
        [
          ( pos,
            "The property "
            ^ (Render.strip_ns member_name |> Markdown_lite.md_codify)
            ^ " has the wrong type" );
        ]
    in
    (Error_code.BadMethodOverride, reasons)

  let method_not_dynamically_callable pos parent_pos =
    let reasons =
      lazy
        [
          (parent_pos, "This method is `__DynamicallyCallable`.");
          (pos, "This method is **not**.");
        ]
    in
    (Error_code.BadMethodOverride, reasons)

  let this_final pos_sub pos_super class_name =
    let reasons =
      lazy
        (let n = Render.strip_ns class_name |> Markdown_lite.md_codify in
         let message1 = "Since " ^ n ^ " is not final" in
         let message2 = "this might not be a " ^ n in
         [(pos_super, message1); (pos_sub, message2)])
    in
    (Error_code.ThisFinal, reasons)

  let typeconst_concrete_concrete_override pos parent_pos =
    ( Error_code.TypeconstConcreteConcreteOverride,
      lazy
        [
          (pos, "Cannot re-declare this type constant");
          (parent_pos, "Previously defined here");
        ] )

  let abstract_concrete_override pos parent_pos kind =
    let reasons =
      lazy
        (let kind_str =
           match kind with
           | `method_ -> "method"
           | `typeconst -> "type constant"
           | `constant -> "constant"
           | `property -> "property"
         in
         [
           (pos, "Cannot re-declare this " ^ kind_str ^ " as abstract");
           (parent_pos, "Previously defined here");
         ])
    in
    (Error_code.AbstractConcreteOverride, reasons)

  let override_no_default_typeconst pos parent_pos =
    ( Error_code.OverrideNoDefaultTypeconst,
      lazy
        [
          (pos, "This abstract type constant does not have a default type");
          ( parent_pos,
            "It cannot override an abstract type constant that has a default type"
          );
        ] )

  let unsupported_refinement pos =
    ( Error_code.UnsupportedRefinement,
      lazy [(pos, "Unsupported refinement, only class types can be refined")] )

  let missing_class_constant pos class_name const_name =
    ( Error_code.SmemberNotFound,
      lazy
        [
          ( pos,
            Printf.sprintf
              "Class %s has no constant %s"
              (Render.strip_ns class_name |> Markdown_lite.md_codify)
              (Markdown_lite.md_codify const_name) );
        ] )

  let invalid_refined_const_kind
      pos class_name const_name correct_kind wrong_kind =
    ( Error_code.InvalidRefinedConstKind,
      lazy
        [
          ( pos,
            Printf.sprintf
              "Constant %s in %s is not a %s, did you mean %s?"
              (Markdown_lite.md_codify const_name)
              (Render.strip_ns class_name |> Markdown_lite.md_codify)
              wrong_kind
              correct_kind );
        ] )

  let inexact_tconst_access pos id =
    ( Error_code.InexactTConstAccess,
      lazy
        [
          (fst id, "Type member `" ^ snd id ^ "` cannot be accessed");
          (pos, "  on a loose refinement");
        ] )

  let violated_refinement_constraint (kind, pos) =
    let kind =
      match kind with
      | `As -> "`as` or `=`"
      | `Super -> "`super`"
    in
    ( Error_code.UnifyError,
      lazy [(pos, "This " ^ kind ^ " refinement constraint is violated")] )

  let eval t ~env ~current_span =
    let open Typing_error.Secondary in
    match t with
    | Of_error err ->
      Eval_result.map ~f:(fun (code, claim, reasons, _quickfixes) ->
          (* We discard quickfixes here because a secondary error
             can be in a decl and it doesn't make sense to quickfix a decl *)
          let reasons =
            Lazy.(
              claim >>= fun x ->
              reasons >>= fun xs ->
              return (Message.map ~f:Pos_or_decl.of_raw_pos x :: xs))
          in
          (code, reasons))
      @@ Eval_error.eval err ~env ~current_span
    | Fun_too_many_args { pos; decl_pos; actual; expected } ->
      Eval_result.single (fun_too_many_args pos decl_pos actual expected)
    | Fun_too_few_args { pos; decl_pos; actual; expected } ->
      Eval_result.single (fun_too_few_args pos decl_pos actual expected)
    | Fun_unexpected_nonvariadic { pos; decl_pos } ->
      Eval_result.single (fun_unexpected_nonvariadic pos decl_pos)
    | Fun_variadicity_hh_vs_php56 { pos; decl_pos } ->
      Eval_result.single (fun_variadicity_hh_vs_php56 pos decl_pos)
    | Type_arity_mismatch { pos; actual; decl_pos; expected } ->
      Eval_result.single (type_arity_mismatch pos actual decl_pos expected)
    | Violated_constraint { cstrs; ty_sub; ty_sup; is_coeffect } ->
      Eval_result.single
        (violated_constraint cstrs is_coeffect ~ty_sub ~ty_sup env)
    | Concrete_const_interface_override { pos; parent_pos; name; parent_origin }
      ->
      Eval_result.single
        (concrete_const_interface_override pos parent_pos name parent_origin)
    | Interface_or_trait_const_multiple_defs
        { pos; origin; parent_pos; parent_origin; name } ->
      Eval_result.single
        (interface_or_trait_const_multiple_defs
           pos
           origin
           parent_pos
           parent_origin
           name)
    | Interface_typeconst_multiple_defs
        { pos; parent_pos; name; origin; parent_origin; is_abstract } ->
      Eval_result.single
        (interface_typeconst_multiple_defs
           pos
           parent_pos
           name
           origin
           parent_origin
           is_abstract)
    | Missing_field { pos; name; decl_pos } ->
      Eval_result.single (missing_field pos name decl_pos)
    | Shape_fields_unknown { pos; decl_pos } ->
      Eval_result.single (shape_fields_unknown pos decl_pos)
    | Abstract_tconst_not_allowed { pos; decl_pos; tconst_name } ->
      Eval_result.single (abstract_tconst_not_allowed pos decl_pos tconst_name)
    | Invalid_destructure { pos; decl_pos; ty_name } ->
      Eval_result.single (invalid_destructure pos decl_pos ty_name)
    | Unpack_array_required_argument { pos; decl_pos } ->
      Eval_result.single (unpack_array_required_argument pos decl_pos)
    | Unpack_array_variadic_argument { pos; decl_pos } ->
      Eval_result.single (unpack_array_variadic_argument pos decl_pos)
    | Overriding_prop_const_mismatch { pos; is_const; parent_pos; _ } ->
      Eval_result.single
        (overriding_prop_const_mismatch pos is_const parent_pos)
    | Visibility_extends { pos; vis; parent_pos; parent_vis } ->
      Eval_result.single (visibility_extends pos vis parent_pos parent_vis)
    | Visibility_override_internal
        { pos; module_name; parent_module; parent_pos } ->
      Eval_result.single
        (visibility_override_internal pos module_name parent_module parent_pos)
    | Missing_constructor pos -> Eval_result.single (missing_constructor pos)
    | Accept_disposable_invariant { pos; decl_pos } ->
      Eval_result.single (accept_disposable_invariant pos decl_pos)
    | Required_field_is_optional { pos; name; decl_pos; def_pos } ->
      Eval_result.single (required_field_is_optional pos name decl_pos def_pos)
    | Return_disposable_mismatch
        { pos_sub; is_marked_return_disposable; pos_super } ->
      Eval_result.single
        (return_disposable_mismatch
           pos_sub
           is_marked_return_disposable
           pos_super)
    | Override_final { pos; parent_pos } ->
      Eval_result.single (override_final pos parent_pos)
    | Override_async { pos; parent_pos } ->
      Eval_result.single (override_async pos parent_pos)
    | Override_lsb { pos; member_name; parent_pos } ->
      Eval_result.single (override_lsb pos member_name parent_pos)
    | Multiple_concrete_defs
        { pos; origin; name; parent_pos; parent_origin; class_name } ->
      Eval_result.single
        (multiple_concrete_defs
           pos
           origin
           name
           parent_pos
           parent_origin
           class_name)
    | Cyclic_enum_constraint pos ->
      Eval_result.single (cyclic_enum_constraint pos)
    | Inoutness_mismatch { pos; decl_pos } ->
      Eval_result.single (inoutness_mismatch pos decl_pos)
    | Decl_override_missing_hint pos ->
      Eval_result.single (decl_override_missing_hint pos)
    | Bad_lateinit_override { pos; parent_pos; parent_is_lateinit } ->
      Eval_result.single
        (bad_lateinit_override pos parent_pos parent_is_lateinit)
    | Bad_xhp_attr_required_override { pos; parent_pos; parent_tag; tag } ->
      Eval_result.single
        (bad_xhp_attr_required_override pos parent_pos parent_tag tag)
    | Coeffect_subtyping { pos; cap; pos_expected; cap_expected } ->
      Eval_result.single (coeffect_subtyping pos cap pos_expected cap_expected)
    | Not_sub_dynamic { pos; ty_name; dynamic_part } ->
      Eval_result.single (not_sub_dynamic pos ty_name dynamic_part)
    | Override_method_support_dynamic_type
        { pos; method_name; parent_origin; parent_pos } ->
      Eval_result.single
        (override_method_support_dynamic_type
           pos
           method_name
           parent_origin
           parent_pos)
    | Readonly_mismatch { pos; kind; reason_sub; reason_super } ->
      Eval_result.single (readonly_mismatch pos kind reason_sub reason_super)
    | Cross_package_mismatch { pos; reason_sub; reason_super } ->
      Eval_result.single (cross_package_mismatch pos reason_sub reason_super)
    | Typing_too_many_args { pos; decl_pos; actual; expected } ->
      Eval_result.single (typing_too_many_args pos decl_pos actual expected)
    | Typing_too_few_args { pos; decl_pos; actual; expected } ->
      Eval_result.single (typing_too_few_args pos decl_pos actual expected)
    | Non_object_member { pos; ctxt; ty_name; member_name; kind; decl_pos } ->
      Eval_result.single
        (non_object_member pos ctxt ty_name member_name kind decl_pos)
    | Rigid_tvar_escape { pos; name } ->
      Eval_result.single (rigid_tvar_escape pos name)
    | Smember_not_found { pos; kind; member_name; class_name; class_pos; hint }
      ->
      Eval_result.single
        (smember_not_found pos kind member_name class_name class_pos hint)
    | Bad_method_override { pos; member_name } ->
      Eval_result.single (bad_method_override pos member_name)
    | Bad_prop_override { pos; member_name } ->
      Eval_result.single (bad_prop_override pos member_name)
    | Subtyping_error { ty_sub; ty_sup; is_coeffect } ->
      Eval_result.single (subtyping_error is_coeffect ~ty_sub ~ty_sup env)
    | Method_not_dynamically_callable { pos; parent_pos } ->
      Eval_result.single (method_not_dynamically_callable pos parent_pos)
    | This_final { pos_sub; pos_super; class_name } ->
      Eval_result.single (this_final pos_sub pos_super class_name)
    | Typeconst_concrete_concrete_override { pos; parent_pos } ->
      Eval_result.single (typeconst_concrete_concrete_override pos parent_pos)
    | Abstract_concrete_override { pos; parent_pos; kind } ->
      Eval_result.single (abstract_concrete_override pos parent_pos kind)
    | Override_no_default_typeconst { pos; parent_pos } ->
      Eval_result.single (override_no_default_typeconst pos parent_pos)
    | Unsupported_refinement pos ->
      Eval_result.single (unsupported_refinement pos)
    | Missing_class_constant { pos; class_name; const_name } ->
      Eval_result.single (missing_class_constant pos class_name const_name)
    | Invalid_refined_const_kind
        { pos; class_name; const_name; correct_kind; wrong_kind } ->
      Eval_result.single
        (invalid_refined_const_kind
           pos
           class_name
           const_name
           correct_kind
           wrong_kind)
    | Inexact_tconst_access (pos, id) ->
      Eval_result.single (inexact_tconst_access pos id)
    | Violated_refinement_constraint { cstr } ->
      Eval_result.single (violated_refinement_constraint cstr)
end

and Eval_callback : sig
  val apply :
    ?code:Error_code.t ->
    ?reasons:Pos_or_decl.t Message.t list Lazy.t ->
    ?quickfixes:Pos.t Quickfix.t list ->
    Typing_error.Callback.t ->
    env:Typing_env_types.env ->
    claim:Pos.t Message.t Lazy.t ->
    error
end = struct
  type error_state = {
    code_opt: Error_code.t option;
    claim_opt: Pos.t Message.t Lazy.t option;
    reasons: Pos_or_decl.t Message.t list Lazy.t;
    quickfixes: Pos.t Quickfix.t list;
  }

  let rec eval t ~env ~st =
    let open Typing_error.Callback in
    match t with
    | With_side_effect (t, eff) ->
      eff ();
      eval t ~env ~st
    | Always err ->
      let (code, claim, reasons, quickfixes) = Eval_primary.to_error err ~env in
      (code, Some claim, reasons, quickfixes)
    | Of_primary err ->
      let (code, _claim, _reasons, qfs) = Eval_primary.to_error err ~env in
      ( Option.value ~default:code st.code_opt,
        st.claim_opt,
        st.reasons,
        qfs @ st.quickfixes )
    | With_claim_as_reason (err, claim_from) ->
      let reasons =
        Option.value_map
          ~default:st.reasons
          ~f:(fun claim ->
            Lazy.(
              claim >>= fun claim ->
              st.reasons >>= fun reasons ->
              return (Tuple2.map_fst ~f:Pos_or_decl.of_raw_pos claim :: reasons)))
          st.claim_opt
      in
      let (_, claim, _, _) = Eval_primary.to_error claim_from ~env in
      eval err ~env ~st:{ st with claim_opt = Some claim; reasons }
    | Retain_code t -> eval t ~env ~st:{ st with code_opt = None }
    | With_code (code, qfs) ->
      ( Option.value ~default:code st.code_opt,
        st.claim_opt,
        st.reasons,
        qfs @ st.quickfixes )

  let apply ?code ?(reasons = lazy []) ?(quickfixes = []) t ~env ~claim =
    let st = { code_opt = code; claim_opt = Some claim; reasons; quickfixes } in
    let (code, claim_opt, reasons, quickfixes) = eval t ~env ~st in
    (code, Option.value ~default:claim claim_opt, reasons, quickfixes)
end

and Eval_reasons_callback : sig
  val apply_help :
    ?code:Error_code.t ->
    ?claim:Pos.t Message.t Lazy.t ->
    ?reasons:Pos_or_decl.t Message.t list Lazy.t ->
    ?quickfixes:Pos.t Quickfix.t list ->
    Typing_error.Reasons_callback.t ->
    env:Typing_env_types.env ->
    current_span:Pos.t ->
    error Eval_result.t

  val apply :
    ?code:Error_code.t ->
    ?claim:Pos.t Message.t Lazy.t ->
    ?reasons:Pos_or_decl.t Message.t list Lazy.t ->
    ?quickfixes:Pos.t Quickfix.t list ->
    Typing_error.Reasons_callback.t ->
    env:Typing_env_types.env ->
    current_span:Pos.t ->
    (Pos.t, Pos_or_decl.t) User_error.t Eval_result.t
end = struct
  module Error_state = struct
    type t = {
      code_opt: Error_code.t option;
      claim_opt: Pos.t Message.t Lazy.t option;
      reasons_opt: Pos_or_decl.t Message.t list Lazy.t option;
      quickfixes_opt: Pos.t Quickfix.t list option;
    }

    let with_code t code_opt =
      { t with code_opt = Option.first_some t.code_opt code_opt }

    let prepend_secondary
        { claim_opt; reasons_opt; quickfixes_opt; _ } snd_err ~env ~current_span
        =
      Eval_result.map
        (Eval_secondary.eval snd_err ~env ~current_span)
        ~f:(fun (code, reasons) ->
          let reasons_opt =
            Some
              (match reasons_opt with
              | None -> lazy []
              | Some rlz ->
                Lazy.(
                  rlz >>= fun rlz ->
                  reasons >>= fun reasons -> return (reasons @ rlz)))
          in
          { code_opt = Some code; claim_opt; reasons_opt; quickfixes_opt })

    (** Replace any missing values in the error state with those of the error *)
    let with_defaults
        { code_opt; claim_opt; reasons_opt; quickfixes_opt }
        err
        ~env
        ~current_span =
      Eval_result.map ~f:(fun (code, claim, reasons, quickfixes) ->
          Option.
            ( value code_opt ~default:code,
              value claim_opt ~default:claim,
              value reasons_opt ~default:reasons,
              value quickfixes_opt ~default:quickfixes ))
      @@ Eval_error.eval err ~env ~current_span
  end

  let eval_callback
      k Error_state.{ code_opt; reasons_opt; quickfixes_opt; _ } ~env ~claim =
    Eval_callback.apply
      ?code:code_opt
      ?reasons:reasons_opt
      ?quickfixes:quickfixes_opt
      ~env
      ~claim
      k

  let eval t ~env ~st ~current_span =
    let open Typing_error.Reasons_callback in
    let rec aux t st =
      match t with
      | From_on_error f ->
        let code = Option.map ~f:Error_code.to_enum st.Error_state.code_opt
        and quickfixes = st.Error_state.quickfixes_opt
        and reasons =
          Option.value_map ~default:[] ~f:Lazy.force st.Error_state.reasons_opt
        in
        f ?code ?quickfixes reasons;
        Eval_result.empty
      | Always err -> Eval_error.eval err ~env ~current_span
      | Of_error err -> Error_state.with_defaults st err ~env ~current_span
      | Of_callback (k, claim) ->
        Eval_result.single @@ eval_callback k st ~env ~claim
      | Assert_in_current_decl (default, ctx) ->
        let Error_state.{ code_opt; reasons_opt; _ } = st in
        let crs =
          Option.(value ~default code_opt, value ~default:(lazy []) reasons_opt)
        in
        let res_opt = Common.eval_assert ctx current_span crs in
        Eval_result.of_option res_opt
      | With_code (err, code) ->
        let st = Error_state.with_code st @@ Some code in
        aux err st
      | With_reasons (err, reasons) ->
        aux err Error_state.{ st with reasons_opt = Some reasons }
      | Add_quickfixes (err, qfxs) ->
        aux
          err
          Error_state.
            {
              st with
              quickfixes_opt =
                Option.first_some
                  (Option.map ~f:(List.append qfxs) st.quickfixes_opt)
                  (Some qfxs);
            }
      | Add_reason (err, op, reason) -> aux_reason_op op err reason st
      | Retain (t, comp) -> aux_retain t comp st
      | Incoming_reasons (err, op) ->
        Eval_result.map ~f:(fun ((code, claim, reasons, qfxs) as err) ->
            match (st.Error_state.reasons_opt, op) with
            | (None, _) -> err
            | (Some rs, Append) ->
              (code, claim, Common.map2 ~f:(fun x y -> x @ y) reasons rs, qfxs)
            | (Some rs, Prepend) ->
              (code, claim, Common.map2 ~f:(fun x y -> x @ y) rs reasons, qfxs))
        @@ aux err Error_state.{ st with reasons_opt = None }
      | Prepend_on_apply (t, snd_err) ->
        Eval_result.bind
          ~f:(aux t)
          (Error_state.prepend_secondary st snd_err ~env ~current_span)
      | Drop_reasons_on_apply t ->
        let st = Error_state.{ st with reasons_opt = Some (lazy []) } in
        aux t st
      [@@ocaml.warning "-3"]
    and aux_reason_op op err base_reason (Error_state.{ reasons_opt; _ } as st)
        =
      let reasons_opt =
        Some
          (match reasons_opt with
          | None -> Lazy.map base_reason ~f:(fun x -> [x])
          | Some reasons_lz ->
            (match op with
            | Append ->
              Lazy.(
                reasons_lz >>= fun rs ->
                base_reason >>= fun r -> return (rs @ [r]))
            | Prepend ->
              Lazy.(
                reasons_lz >>= fun rs ->
                base_reason >>= fun r -> return (r :: rs))))
      in

      aux err Error_state.{ st with reasons_opt }
    and aux_retain t comp st =
      match comp with
      | Code -> aux t Error_state.{ st with code_opt = None }
      | Reasons -> aux t Error_state.{ st with reasons_opt = None }
      | Quickfixes -> aux t Error_state.{ st with quickfixes_opt = None }
    in
    aux t st

  let apply_help ?code ?claim ?reasons ?quickfixes t ~env ~current_span =
    let claim =
      Option.map claim ~f:(Lazy.map ~f:(Message.map ~f:Pos_or_decl.of_raw_pos))
    in
    let reasons_opt =
      match (claim, reasons) with
      | (Some claim, Some reasons) ->
        Some (Common.map2 claim reasons ~f:(fun x xs -> x :: xs))
      | (Some claim, _) -> Some (Lazy.map ~f:(fun claim -> [claim]) claim)
      | _ -> reasons
    in
    eval
      t
      ~env
      ~st:
        Error_state.
          {
            code_opt = code;
            claim_opt = None;
            reasons_opt;
            quickfixes_opt = quickfixes;
          }
      ~current_span

  let apply ?code ?claim ?reasons ?quickfixes t ~env ~current_span =
    let f (code, claim, reasons, quickfixes) =
      User_error.make
        (Error_code.to_enum code)
        (Lazy.force claim)
        (Lazy.force reasons)
        ~quickfixes
    in
    Eval_result.map ~f
    @@ apply_help ?code ?claim ?reasons ?quickfixes t ~env ~current_span
end

let is_suppressed User_error.{ claim; code; _ } =
  Errors.fixme_present Message.(get_message_pos claim) code

let add_typing_error err ~env =
  Eval_result.iter ~f:Errors.add_error
  @@ Eval_result.suppress_intersection ~is_suppressed
  @@ Eval_error.to_user_error
       err
       ~env
       ~current_span:(Errors.get_current_span ())

(* Until we return a list of errors from typing, we have to apply
   'client errors' to a callback for using in subtyping *)
let apply_callback_to_errors errors on_error ~env =
  let on_error
      User_error.
        { code; claim; reasons; custom_msgs = _; quickfixes = _; is_fixmed = _ }
      =
    let code = Option.value_exn (Error_code.of_enum code) in
    Eval_result.iter ~f:Errors.add_error
    @@ Eval_result.suppress_intersection ~is_suppressed
    @@ Eval_reasons_callback.apply
         on_error
         ~code
         ~claim:(lazy claim)
         ~reasons:(lazy reasons)
         ~env
         ~current_span:(Errors.get_current_span ())
  in
  Errors.iter errors ~f:on_error

let apply_error_from_reasons_callback ?code ?claim ?reasons ?quickfixes err ~env
    =
  Eval_result.iter ~f:Errors.add_error
  @@ Eval_result.suppress_intersection ~is_suppressed
  @@ Eval_reasons_callback.apply
       ?code
       ?claim
       ?reasons
       ?quickfixes
       err
       ~env
       ~current_span:(Errors.get_current_span ())

let claim_as_reason : Pos.t Message.t -> Pos_or_decl.t Message.t =
 (fun (p, m) -> (Pos_or_decl.of_raw_pos p, m))

(** TODO: Remove use of `User_error.t` representation for nested error &
    callback application *)
let ambiguous_inheritance pos class_ origin error on_error ~env =
  let User_error.
        { code; claim; reasons; custom_msgs = _; quickfixes = _; is_fixmed = _ }
      =
    error
  in
  let origin = Render.strip_ns origin in
  let class_ = Render.strip_ns class_ in
  let message =
    "This declaration was inherited from an object of type "
    ^ Markdown_lite.md_codify origin
    ^ ". Redeclare this member in "
    ^ Markdown_lite.md_codify class_
    ^ " with a compatible signature."
  in
  let code = Option.value_exn (Error_codes.Typing.of_enum code) in
  apply_error_from_reasons_callback
    on_error
    ~code
    ~reasons:(lazy ((claim_as_reason claim :: reasons) @ [(pos, message)]))
    ~env
