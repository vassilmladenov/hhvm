/**
 * Copyright (c) 2016, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional
 * directory.
 *
 **
 *
 * THIS FILE IS @generated; DO NOT EDIT IT
 * To regenerate this file, run
 *
 *   buck run //hphp/hack/src:generate_full_fidelity
 *
 **
 *
 */

use ocamlrep::{FromOcamlRep, ToOcamlRep};

use crate::token_kind::TokenKind;

#[derive(Debug, Copy, Clone, FromOcamlRep, ToOcamlRep, PartialEq)]
pub enum SyntaxKind {
    Missing,
    Token(TokenKind),
    SyntaxList,
    EndOfFile,
    Script,
    QualifiedName,
    ModuleName,
    SimpleTypeSpecifier,
    LiteralExpression,
    PrefixedStringExpression,
    PrefixedCodeExpression,
    VariableExpression,
    PipeVariableExpression,
    FileAttributeSpecification,
    EnumDeclaration,
    EnumUse,
    Enumerator,
    EnumClassDeclaration,
    EnumClassEnumerator,
    AliasDeclaration,
    ContextAliasDeclaration,
    PropertyDeclaration,
    PropertyDeclarator,
    NamespaceDeclaration,
    NamespaceDeclarationHeader,
    NamespaceBody,
    NamespaceEmptyBody,
    NamespaceUseDeclaration,
    NamespaceGroupUseDeclaration,
    NamespaceUseClause,
    FunctionDeclaration,
    FunctionDeclarationHeader,
    Contexts,
    WhereClause,
    WhereConstraint,
    MethodishDeclaration,
    MethodishTraitResolution,
    ClassishDeclaration,
    ClassishBody,
    TraitUse,
    RequireClause,
    ConstDeclaration,
    ConstantDeclarator,
    TypeConstDeclaration,
    ContextConstDeclaration,
    DecoratedExpression,
    ParameterDeclaration,
    VariadicParameter,
    OldAttributeSpecification,
    AttributeSpecification,
    Attribute,
    InclusionExpression,
    InclusionDirective,
    CompoundStatement,
    ExpressionStatement,
    MarkupSection,
    MarkupSuffix,
    UnsetStatement,
    UsingStatementBlockScoped,
    UsingStatementFunctionScoped,
    WhileStatement,
    IfStatement,
    ElseClause,
    TryStatement,
    CatchClause,
    FinallyClause,
    DoStatement,
    ForStatement,
    ForeachStatement,
    SwitchStatement,
    SwitchSection,
    SwitchFallthrough,
    CaseLabel,
    DefaultLabel,
    ReturnStatement,
    YieldBreakStatement,
    ThrowStatement,
    BreakStatement,
    ContinueStatement,
    EchoStatement,
    ConcurrentStatement,
    SimpleInitializer,
    AnonymousClass,
    AnonymousFunction,
    AnonymousFunctionUseClause,
    LambdaExpression,
    LambdaSignature,
    CastExpression,
    ScopeResolutionExpression,
    MemberSelectionExpression,
    SafeMemberSelectionExpression,
    EmbeddedMemberSelectionExpression,
    YieldExpression,
    PrefixUnaryExpression,
    PostfixUnaryExpression,
    BinaryExpression,
    IsExpression,
    AsExpression,
    NullableAsExpression,
    UpcastExpression,
    ConditionalExpression,
    EvalExpression,
    IssetExpression,
    FunctionCallExpression,
    FunctionPointerExpression,
    ParenthesizedExpression,
    BracedExpression,
    ETSpliceExpression,
    EmbeddedBracedExpression,
    ListExpression,
    CollectionLiteralExpression,
    ObjectCreationExpression,
    ConstructorCall,
    DarrayIntrinsicExpression,
    DictionaryIntrinsicExpression,
    KeysetIntrinsicExpression,
    VarrayIntrinsicExpression,
    VectorIntrinsicExpression,
    ElementInitializer,
    SubscriptExpression,
    EmbeddedSubscriptExpression,
    AwaitableCreationExpression,
    XHPChildrenDeclaration,
    XHPChildrenParenthesizedList,
    XHPCategoryDeclaration,
    XHPEnumType,
    XHPLateinit,
    XHPRequired,
    XHPClassAttributeDeclaration,
    XHPClassAttribute,
    XHPSimpleClassAttribute,
    XHPSimpleAttribute,
    XHPSpreadAttribute,
    XHPOpen,
    XHPExpression,
    XHPClose,
    TypeConstant,
    VectorTypeSpecifier,
    KeysetTypeSpecifier,
    TupleTypeExplicitSpecifier,
    VarrayTypeSpecifier,
    FunctionCtxTypeSpecifier,
    TypeParameter,
    TypeConstraint,
    ContextConstraint,
    DarrayTypeSpecifier,
    DictionaryTypeSpecifier,
    ClosureTypeSpecifier,
    ClosureParameterTypeSpecifier,
    TypeRefinement,
    TypeInRefinement,
    CtxInRefinement,
    ClassnameTypeSpecifier,
    FieldSpecifier,
    FieldInitializer,
    ShapeTypeSpecifier,
    ShapeExpression,
    TupleExpression,
    GenericTypeSpecifier,
    NullableTypeSpecifier,
    LikeTypeSpecifier,
    SoftTypeSpecifier,
    AttributizedSpecifier,
    ReifiedTypeArgument,
    TypeArguments,
    TypeParameters,
    TupleTypeSpecifier,
    UnionTypeSpecifier,
    IntersectionTypeSpecifier,
    ErrorSyntax,
    ListItem,
    EnumClassLabelExpression,
    ModuleDeclaration,
    ModuleExports,
    ModuleImports,
    ModuleMembershipDeclaration,
    PackageDeclaration,
    PackageUses,
    PackageIncludes,

}

impl SyntaxKind {
    pub fn to_string(&self) -> &str {
        match self {
            SyntaxKind::SyntaxList => "list",
            SyntaxKind::Missing => "missing",
            SyntaxKind::Token(_) => "token",
            SyntaxKind::EndOfFile                         => "end_of_file",
            SyntaxKind::Script                            => "script",
            SyntaxKind::QualifiedName                     => "qualified_name",
            SyntaxKind::ModuleName                        => "module_name",
            SyntaxKind::SimpleTypeSpecifier               => "simple_type_specifier",
            SyntaxKind::LiteralExpression                 => "literal",
            SyntaxKind::PrefixedStringExpression          => "prefixed_string",
            SyntaxKind::PrefixedCodeExpression            => "prefixed_code",
            SyntaxKind::VariableExpression                => "variable",
            SyntaxKind::PipeVariableExpression            => "pipe_variable",
            SyntaxKind::FileAttributeSpecification        => "file_attribute_specification",
            SyntaxKind::EnumDeclaration                   => "enum_declaration",
            SyntaxKind::EnumUse                           => "enum_use",
            SyntaxKind::Enumerator                        => "enumerator",
            SyntaxKind::EnumClassDeclaration              => "enum_class_declaration",
            SyntaxKind::EnumClassEnumerator               => "enum_class_enumerator",
            SyntaxKind::AliasDeclaration                  => "alias_declaration",
            SyntaxKind::ContextAliasDeclaration           => "context_alias_declaration",
            SyntaxKind::PropertyDeclaration               => "property_declaration",
            SyntaxKind::PropertyDeclarator                => "property_declarator",
            SyntaxKind::NamespaceDeclaration              => "namespace_declaration",
            SyntaxKind::NamespaceDeclarationHeader        => "namespace_declaration_header",
            SyntaxKind::NamespaceBody                     => "namespace_body",
            SyntaxKind::NamespaceEmptyBody                => "namespace_empty_body",
            SyntaxKind::NamespaceUseDeclaration           => "namespace_use_declaration",
            SyntaxKind::NamespaceGroupUseDeclaration      => "namespace_group_use_declaration",
            SyntaxKind::NamespaceUseClause                => "namespace_use_clause",
            SyntaxKind::FunctionDeclaration               => "function_declaration",
            SyntaxKind::FunctionDeclarationHeader         => "function_declaration_header",
            SyntaxKind::Contexts                          => "contexts",
            SyntaxKind::WhereClause                       => "where_clause",
            SyntaxKind::WhereConstraint                   => "where_constraint",
            SyntaxKind::MethodishDeclaration              => "methodish_declaration",
            SyntaxKind::MethodishTraitResolution          => "methodish_trait_resolution",
            SyntaxKind::ClassishDeclaration               => "classish_declaration",
            SyntaxKind::ClassishBody                      => "classish_body",
            SyntaxKind::TraitUse                          => "trait_use",
            SyntaxKind::RequireClause                     => "require_clause",
            SyntaxKind::ConstDeclaration                  => "const_declaration",
            SyntaxKind::ConstantDeclarator                => "constant_declarator",
            SyntaxKind::TypeConstDeclaration              => "type_const_declaration",
            SyntaxKind::ContextConstDeclaration           => "context_const_declaration",
            SyntaxKind::DecoratedExpression               => "decorated_expression",
            SyntaxKind::ParameterDeclaration              => "parameter_declaration",
            SyntaxKind::VariadicParameter                 => "variadic_parameter",
            SyntaxKind::OldAttributeSpecification         => "old_attribute_specification",
            SyntaxKind::AttributeSpecification            => "attribute_specification",
            SyntaxKind::Attribute                         => "attribute",
            SyntaxKind::InclusionExpression               => "inclusion_expression",
            SyntaxKind::InclusionDirective                => "inclusion_directive",
            SyntaxKind::CompoundStatement                 => "compound_statement",
            SyntaxKind::ExpressionStatement               => "expression_statement",
            SyntaxKind::MarkupSection                     => "markup_section",
            SyntaxKind::MarkupSuffix                      => "markup_suffix",
            SyntaxKind::UnsetStatement                    => "unset_statement",
            SyntaxKind::UsingStatementBlockScoped         => "using_statement_block_scoped",
            SyntaxKind::UsingStatementFunctionScoped      => "using_statement_function_scoped",
            SyntaxKind::WhileStatement                    => "while_statement",
            SyntaxKind::IfStatement                       => "if_statement",
            SyntaxKind::ElseClause                        => "else_clause",
            SyntaxKind::TryStatement                      => "try_statement",
            SyntaxKind::CatchClause                       => "catch_clause",
            SyntaxKind::FinallyClause                     => "finally_clause",
            SyntaxKind::DoStatement                       => "do_statement",
            SyntaxKind::ForStatement                      => "for_statement",
            SyntaxKind::ForeachStatement                  => "foreach_statement",
            SyntaxKind::SwitchStatement                   => "switch_statement",
            SyntaxKind::SwitchSection                     => "switch_section",
            SyntaxKind::SwitchFallthrough                 => "switch_fallthrough",
            SyntaxKind::CaseLabel                         => "case_label",
            SyntaxKind::DefaultLabel                      => "default_label",
            SyntaxKind::ReturnStatement                   => "return_statement",
            SyntaxKind::YieldBreakStatement               => "yield_break_statement",
            SyntaxKind::ThrowStatement                    => "throw_statement",
            SyntaxKind::BreakStatement                    => "break_statement",
            SyntaxKind::ContinueStatement                 => "continue_statement",
            SyntaxKind::EchoStatement                     => "echo_statement",
            SyntaxKind::ConcurrentStatement               => "concurrent_statement",
            SyntaxKind::SimpleInitializer                 => "simple_initializer",
            SyntaxKind::AnonymousClass                    => "anonymous_class",
            SyntaxKind::AnonymousFunction                 => "anonymous_function",
            SyntaxKind::AnonymousFunctionUseClause        => "anonymous_function_use_clause",
            SyntaxKind::LambdaExpression                  => "lambda_expression",
            SyntaxKind::LambdaSignature                   => "lambda_signature",
            SyntaxKind::CastExpression                    => "cast_expression",
            SyntaxKind::ScopeResolutionExpression         => "scope_resolution_expression",
            SyntaxKind::MemberSelectionExpression         => "member_selection_expression",
            SyntaxKind::SafeMemberSelectionExpression     => "safe_member_selection_expression",
            SyntaxKind::EmbeddedMemberSelectionExpression => "embedded_member_selection_expression",
            SyntaxKind::YieldExpression                   => "yield_expression",
            SyntaxKind::PrefixUnaryExpression             => "prefix_unary_expression",
            SyntaxKind::PostfixUnaryExpression            => "postfix_unary_expression",
            SyntaxKind::BinaryExpression                  => "binary_expression",
            SyntaxKind::IsExpression                      => "is_expression",
            SyntaxKind::AsExpression                      => "as_expression",
            SyntaxKind::NullableAsExpression              => "nullable_as_expression",
            SyntaxKind::UpcastExpression                  => "upcast_expression",
            SyntaxKind::ConditionalExpression             => "conditional_expression",
            SyntaxKind::EvalExpression                    => "eval_expression",
            SyntaxKind::IssetExpression                   => "isset_expression",
            SyntaxKind::FunctionCallExpression            => "function_call_expression",
            SyntaxKind::FunctionPointerExpression         => "function_pointer_expression",
            SyntaxKind::ParenthesizedExpression           => "parenthesized_expression",
            SyntaxKind::BracedExpression                  => "braced_expression",
            SyntaxKind::ETSpliceExpression                => "et_splice_expression",
            SyntaxKind::EmbeddedBracedExpression          => "embedded_braced_expression",
            SyntaxKind::ListExpression                    => "list_expression",
            SyntaxKind::CollectionLiteralExpression       => "collection_literal_expression",
            SyntaxKind::ObjectCreationExpression          => "object_creation_expression",
            SyntaxKind::ConstructorCall                   => "constructor_call",
            SyntaxKind::DarrayIntrinsicExpression         => "darray_intrinsic_expression",
            SyntaxKind::DictionaryIntrinsicExpression     => "dictionary_intrinsic_expression",
            SyntaxKind::KeysetIntrinsicExpression         => "keyset_intrinsic_expression",
            SyntaxKind::VarrayIntrinsicExpression         => "varray_intrinsic_expression",
            SyntaxKind::VectorIntrinsicExpression         => "vector_intrinsic_expression",
            SyntaxKind::ElementInitializer                => "element_initializer",
            SyntaxKind::SubscriptExpression               => "subscript_expression",
            SyntaxKind::EmbeddedSubscriptExpression       => "embedded_subscript_expression",
            SyntaxKind::AwaitableCreationExpression       => "awaitable_creation_expression",
            SyntaxKind::XHPChildrenDeclaration            => "xhp_children_declaration",
            SyntaxKind::XHPChildrenParenthesizedList      => "xhp_children_parenthesized_list",
            SyntaxKind::XHPCategoryDeclaration            => "xhp_category_declaration",
            SyntaxKind::XHPEnumType                       => "xhp_enum_type",
            SyntaxKind::XHPLateinit                       => "xhp_lateinit",
            SyntaxKind::XHPRequired                       => "xhp_required",
            SyntaxKind::XHPClassAttributeDeclaration      => "xhp_class_attribute_declaration",
            SyntaxKind::XHPClassAttribute                 => "xhp_class_attribute",
            SyntaxKind::XHPSimpleClassAttribute           => "xhp_simple_class_attribute",
            SyntaxKind::XHPSimpleAttribute                => "xhp_simple_attribute",
            SyntaxKind::XHPSpreadAttribute                => "xhp_spread_attribute",
            SyntaxKind::XHPOpen                           => "xhp_open",
            SyntaxKind::XHPExpression                     => "xhp_expression",
            SyntaxKind::XHPClose                          => "xhp_close",
            SyntaxKind::TypeConstant                      => "type_constant",
            SyntaxKind::VectorTypeSpecifier               => "vector_type_specifier",
            SyntaxKind::KeysetTypeSpecifier               => "keyset_type_specifier",
            SyntaxKind::TupleTypeExplicitSpecifier        => "tuple_type_explicit_specifier",
            SyntaxKind::VarrayTypeSpecifier               => "varray_type_specifier",
            SyntaxKind::FunctionCtxTypeSpecifier          => "function_ctx_type_specifier",
            SyntaxKind::TypeParameter                     => "type_parameter",
            SyntaxKind::TypeConstraint                    => "type_constraint",
            SyntaxKind::ContextConstraint                 => "context_constraint",
            SyntaxKind::DarrayTypeSpecifier               => "darray_type_specifier",
            SyntaxKind::DictionaryTypeSpecifier           => "dictionary_type_specifier",
            SyntaxKind::ClosureTypeSpecifier              => "closure_type_specifier",
            SyntaxKind::ClosureParameterTypeSpecifier     => "closure_parameter_type_specifier",
            SyntaxKind::TypeRefinement                    => "type_refinement",
            SyntaxKind::TypeInRefinement                  => "type_in_refinement",
            SyntaxKind::CtxInRefinement                   => "ctx_in_refinement",
            SyntaxKind::ClassnameTypeSpecifier            => "classname_type_specifier",
            SyntaxKind::FieldSpecifier                    => "field_specifier",
            SyntaxKind::FieldInitializer                  => "field_initializer",
            SyntaxKind::ShapeTypeSpecifier                => "shape_type_specifier",
            SyntaxKind::ShapeExpression                   => "shape_expression",
            SyntaxKind::TupleExpression                   => "tuple_expression",
            SyntaxKind::GenericTypeSpecifier              => "generic_type_specifier",
            SyntaxKind::NullableTypeSpecifier             => "nullable_type_specifier",
            SyntaxKind::LikeTypeSpecifier                 => "like_type_specifier",
            SyntaxKind::SoftTypeSpecifier                 => "soft_type_specifier",
            SyntaxKind::AttributizedSpecifier             => "attributized_specifier",
            SyntaxKind::ReifiedTypeArgument               => "reified_type_argument",
            SyntaxKind::TypeArguments                     => "type_arguments",
            SyntaxKind::TypeParameters                    => "type_parameters",
            SyntaxKind::TupleTypeSpecifier                => "tuple_type_specifier",
            SyntaxKind::UnionTypeSpecifier                => "union_type_specifier",
            SyntaxKind::IntersectionTypeSpecifier         => "intersection_type_specifier",
            SyntaxKind::ErrorSyntax                       => "error",
            SyntaxKind::ListItem                          => "list_item",
            SyntaxKind::EnumClassLabelExpression          => "enum_class_label",
            SyntaxKind::ModuleDeclaration                 => "module_declaration",
            SyntaxKind::ModuleExports                     => "module_exports",
            SyntaxKind::ModuleImports                     => "module_imports",
            SyntaxKind::ModuleMembershipDeclaration       => "module_membership_declaration",
            SyntaxKind::PackageDeclaration                => "package_declaration",
            SyntaxKind::PackageUses                       => "package_uses",
            SyntaxKind::PackageIncludes                   => "package_includes",
        }
    }

    pub fn ocaml_tag(self) -> u8 {
        match self {
            SyntaxKind::Missing => 0,
            SyntaxKind::Token(_) => 0,
            SyntaxKind::SyntaxList => 1,
            SyntaxKind::EndOfFile => 2,
            SyntaxKind::Script => 3,
            SyntaxKind::QualifiedName => 4,
            SyntaxKind::ModuleName => 5,
            SyntaxKind::SimpleTypeSpecifier => 6,
            SyntaxKind::LiteralExpression => 7,
            SyntaxKind::PrefixedStringExpression => 8,
            SyntaxKind::PrefixedCodeExpression => 9,
            SyntaxKind::VariableExpression => 10,
            SyntaxKind::PipeVariableExpression => 11,
            SyntaxKind::FileAttributeSpecification => 12,
            SyntaxKind::EnumDeclaration => 13,
            SyntaxKind::EnumUse => 14,
            SyntaxKind::Enumerator => 15,
            SyntaxKind::EnumClassDeclaration => 16,
            SyntaxKind::EnumClassEnumerator => 17,
            SyntaxKind::AliasDeclaration => 18,
            SyntaxKind::ContextAliasDeclaration => 19,
            SyntaxKind::PropertyDeclaration => 20,
            SyntaxKind::PropertyDeclarator => 21,
            SyntaxKind::NamespaceDeclaration => 22,
            SyntaxKind::NamespaceDeclarationHeader => 23,
            SyntaxKind::NamespaceBody => 24,
            SyntaxKind::NamespaceEmptyBody => 25,
            SyntaxKind::NamespaceUseDeclaration => 26,
            SyntaxKind::NamespaceGroupUseDeclaration => 27,
            SyntaxKind::NamespaceUseClause => 28,
            SyntaxKind::FunctionDeclaration => 29,
            SyntaxKind::FunctionDeclarationHeader => 30,
            SyntaxKind::Contexts => 31,
            SyntaxKind::WhereClause => 32,
            SyntaxKind::WhereConstraint => 33,
            SyntaxKind::MethodishDeclaration => 34,
            SyntaxKind::MethodishTraitResolution => 35,
            SyntaxKind::ClassishDeclaration => 36,
            SyntaxKind::ClassishBody => 37,
            SyntaxKind::TraitUse => 38,
            SyntaxKind::RequireClause => 39,
            SyntaxKind::ConstDeclaration => 40,
            SyntaxKind::ConstantDeclarator => 41,
            SyntaxKind::TypeConstDeclaration => 42,
            SyntaxKind::ContextConstDeclaration => 43,
            SyntaxKind::DecoratedExpression => 44,
            SyntaxKind::ParameterDeclaration => 45,
            SyntaxKind::VariadicParameter => 46,
            SyntaxKind::OldAttributeSpecification => 47,
            SyntaxKind::AttributeSpecification => 48,
            SyntaxKind::Attribute => 49,
            SyntaxKind::InclusionExpression => 50,
            SyntaxKind::InclusionDirective => 51,
            SyntaxKind::CompoundStatement => 52,
            SyntaxKind::ExpressionStatement => 53,
            SyntaxKind::MarkupSection => 54,
            SyntaxKind::MarkupSuffix => 55,
            SyntaxKind::UnsetStatement => 56,
            SyntaxKind::UsingStatementBlockScoped => 57,
            SyntaxKind::UsingStatementFunctionScoped => 58,
            SyntaxKind::WhileStatement => 59,
            SyntaxKind::IfStatement => 60,
            SyntaxKind::ElseClause => 61,
            SyntaxKind::TryStatement => 62,
            SyntaxKind::CatchClause => 63,
            SyntaxKind::FinallyClause => 64,
            SyntaxKind::DoStatement => 65,
            SyntaxKind::ForStatement => 66,
            SyntaxKind::ForeachStatement => 67,
            SyntaxKind::SwitchStatement => 68,
            SyntaxKind::SwitchSection => 69,
            SyntaxKind::SwitchFallthrough => 70,
            SyntaxKind::CaseLabel => 71,
            SyntaxKind::DefaultLabel => 72,
            SyntaxKind::ReturnStatement => 73,
            SyntaxKind::YieldBreakStatement => 74,
            SyntaxKind::ThrowStatement => 75,
            SyntaxKind::BreakStatement => 76,
            SyntaxKind::ContinueStatement => 77,
            SyntaxKind::EchoStatement => 78,
            SyntaxKind::ConcurrentStatement => 79,
            SyntaxKind::SimpleInitializer => 80,
            SyntaxKind::AnonymousClass => 81,
            SyntaxKind::AnonymousFunction => 82,
            SyntaxKind::AnonymousFunctionUseClause => 83,
            SyntaxKind::LambdaExpression => 84,
            SyntaxKind::LambdaSignature => 85,
            SyntaxKind::CastExpression => 86,
            SyntaxKind::ScopeResolutionExpression => 87,
            SyntaxKind::MemberSelectionExpression => 88,
            SyntaxKind::SafeMemberSelectionExpression => 89,
            SyntaxKind::EmbeddedMemberSelectionExpression => 90,
            SyntaxKind::YieldExpression => 91,
            SyntaxKind::PrefixUnaryExpression => 92,
            SyntaxKind::PostfixUnaryExpression => 93,
            SyntaxKind::BinaryExpression => 94,
            SyntaxKind::IsExpression => 95,
            SyntaxKind::AsExpression => 96,
            SyntaxKind::NullableAsExpression => 97,
            SyntaxKind::UpcastExpression => 98,
            SyntaxKind::ConditionalExpression => 99,
            SyntaxKind::EvalExpression => 100,
            SyntaxKind::IssetExpression => 101,
            SyntaxKind::FunctionCallExpression => 102,
            SyntaxKind::FunctionPointerExpression => 103,
            SyntaxKind::ParenthesizedExpression => 104,
            SyntaxKind::BracedExpression => 105,
            SyntaxKind::ETSpliceExpression => 106,
            SyntaxKind::EmbeddedBracedExpression => 107,
            SyntaxKind::ListExpression => 108,
            SyntaxKind::CollectionLiteralExpression => 109,
            SyntaxKind::ObjectCreationExpression => 110,
            SyntaxKind::ConstructorCall => 111,
            SyntaxKind::DarrayIntrinsicExpression => 112,
            SyntaxKind::DictionaryIntrinsicExpression => 113,
            SyntaxKind::KeysetIntrinsicExpression => 114,
            SyntaxKind::VarrayIntrinsicExpression => 115,
            SyntaxKind::VectorIntrinsicExpression => 116,
            SyntaxKind::ElementInitializer => 117,
            SyntaxKind::SubscriptExpression => 118,
            SyntaxKind::EmbeddedSubscriptExpression => 119,
            SyntaxKind::AwaitableCreationExpression => 120,
            SyntaxKind::XHPChildrenDeclaration => 121,
            SyntaxKind::XHPChildrenParenthesizedList => 122,
            SyntaxKind::XHPCategoryDeclaration => 123,
            SyntaxKind::XHPEnumType => 124,
            SyntaxKind::XHPLateinit => 125,
            SyntaxKind::XHPRequired => 126,
            SyntaxKind::XHPClassAttributeDeclaration => 127,
            SyntaxKind::XHPClassAttribute => 128,
            SyntaxKind::XHPSimpleClassAttribute => 129,
            SyntaxKind::XHPSimpleAttribute => 130,
            SyntaxKind::XHPSpreadAttribute => 131,
            SyntaxKind::XHPOpen => 132,
            SyntaxKind::XHPExpression => 133,
            SyntaxKind::XHPClose => 134,
            SyntaxKind::TypeConstant => 135,
            SyntaxKind::VectorTypeSpecifier => 136,
            SyntaxKind::KeysetTypeSpecifier => 137,
            SyntaxKind::TupleTypeExplicitSpecifier => 138,
            SyntaxKind::VarrayTypeSpecifier => 139,
            SyntaxKind::FunctionCtxTypeSpecifier => 140,
            SyntaxKind::TypeParameter => 141,
            SyntaxKind::TypeConstraint => 142,
            SyntaxKind::ContextConstraint => 143,
            SyntaxKind::DarrayTypeSpecifier => 144,
            SyntaxKind::DictionaryTypeSpecifier => 145,
            SyntaxKind::ClosureTypeSpecifier => 146,
            SyntaxKind::ClosureParameterTypeSpecifier => 147,
            SyntaxKind::TypeRefinement => 148,
            SyntaxKind::TypeInRefinement => 149,
            SyntaxKind::CtxInRefinement => 150,
            SyntaxKind::ClassnameTypeSpecifier => 151,
            SyntaxKind::FieldSpecifier => 152,
            SyntaxKind::FieldInitializer => 153,
            SyntaxKind::ShapeTypeSpecifier => 154,
            SyntaxKind::ShapeExpression => 155,
            SyntaxKind::TupleExpression => 156,
            SyntaxKind::GenericTypeSpecifier => 157,
            SyntaxKind::NullableTypeSpecifier => 158,
            SyntaxKind::LikeTypeSpecifier => 159,
            SyntaxKind::SoftTypeSpecifier => 160,
            SyntaxKind::AttributizedSpecifier => 161,
            SyntaxKind::ReifiedTypeArgument => 162,
            SyntaxKind::TypeArguments => 163,
            SyntaxKind::TypeParameters => 164,
            SyntaxKind::TupleTypeSpecifier => 165,
            SyntaxKind::UnionTypeSpecifier => 166,
            SyntaxKind::IntersectionTypeSpecifier => 167,
            SyntaxKind::ErrorSyntax => 168,
            SyntaxKind::ListItem => 169,
            SyntaxKind::EnumClassLabelExpression => 170,
            SyntaxKind::ModuleDeclaration => 171,
            SyntaxKind::ModuleExports => 172,
            SyntaxKind::ModuleImports => 173,
            SyntaxKind::ModuleMembershipDeclaration => 174,
            SyntaxKind::PackageDeclaration => 175,
            SyntaxKind::PackageUses => 176,
            SyntaxKind::PackageIncludes => 177,
        }
    }
}
