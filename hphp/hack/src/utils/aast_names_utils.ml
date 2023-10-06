(*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

module A = Aast

let stmt_name = function
  | A.Fallthrough -> "Fallthrough"
  | A.Expr _ -> "Expr"
  | A.Break -> "Break"
  | A.Continue -> "Continue"
  | A.Throw _ -> "Throw"
  | A.Return _ -> "Return"
  | A.Yield_break -> "Yield_break"
  | A.Awaitall _ -> "Awaitall"
  | A.Concurrent _ -> "Concurrent"
  | A.If _ -> "If"
  | A.Do _ -> "Do"
  | A.While _ -> "While"
  | A.Using _ -> "Using"
  | A.For _ -> "For"
  | A.Switch _ -> "Switch"
  | A.Match _ -> "Match"
  | A.Foreach _ -> "Foreach"
  | A.Try _ -> "Try"
  | A.Noop -> "Noop"
  | A.Declare_local _ -> "Declare_local"
  | A.Block _ -> "Block"
  | A.Markup _ -> "Markup"
  | A.AssertEnv _ -> "AssertEnv"

let expr_name = function
  | A.Darray _ -> "Darray"
  | A.Varray _ -> "Varray"
  | A.Shape _ -> "Shape"
  | A.ValCollection _ -> "ValCollection"
  | A.KeyValCollection _ -> "KeyValCollection"
  | A.Null -> "Null"
  | A.This -> "This"
  | A.True -> "True"
  | A.False -> "False"
  | A.Omitted -> "Omitted"
  | A.Id _ -> "Id"
  | A.Lvar _ -> "Lvar"
  | A.Dollardollar _ -> "Dollardollar"
  | A.Clone _ -> "Clone"
  | A.Obj_get _ -> "Obj_get"
  | A.Array_get _ -> "Array_get"
  | A.Class_get _ -> "Class_get"
  | A.Class_const _ -> "Class_const"
  | A.Call _ -> "Call"
  | A.FunctionPointer _ -> "FunctionPointer"
  | A.Int _ -> "Int"
  | A.Float _ -> "Float"
  | A.String _ -> "String"
  | A.String2 _ -> "String2"
  | A.PrefixedString _ -> "PrefixedString"
  | A.Yield _ -> "Yield"
  | A.Await _ -> "Await"
  | A.Tuple _ -> "Tuple"
  | A.List _ -> "List"
  | A.Cast _ -> "Cast"
  | A.Unop _ -> "Unop"
  | A.Binop _ -> "Binop"
  | A.Pipe _ -> "Pipe"
  | A.Eif _ -> "Eif"
  | A.Is _ -> "Is"
  | A.As _ -> "As"
  | A.Upcast _ -> "Upcast"
  | A.New _ -> "New"
  | A.Efun _ -> "Efun"
  | A.Lfun _ -> "Lfun"
  | A.Xml _ -> "Xml"
  | A.Import _ -> "Import"
  | A.Collection _ -> "Collection"
  | A.ExpressionTree _ -> "ExpressionTree"
  | A.Lplaceholder _ -> "Lplaceholder"
  | A.Method_caller _ -> "Method_caller"
  | A.Pair _ -> "Pair"
  | A.ET_Splice _ -> "ET_splice"
  | A.EnumClassLabel _ -> "EnumClassLabel"
  | A.ReadonlyExpr _ -> "Readonly"
  | A.Hole _ -> "Hole"
  | A.Invalid _ -> "Invalid"
  | A.Package _ -> "Package"
  | A.Nameof _ -> "Nameof"
