(**
 * Copyright (c) 2018, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

open Printf
open Buffer

module GenErr(M: Errors.Error_category) = struct
  let generate_errors buffer name =
    add_string buffer @@ sprintf "%s Errors:\n" name;
    for i = M.min to M.max do
      match M.of_enum i with
      | Some err -> add_string buffer @@ sprintf "%s = %d\n" (M.show err) i;
      | None -> ();
    done;
    add_string buffer "\n"

end

module P = GenErr(Errors.Parsing)
module N = GenErr(Errors.Naming)
module NC = GenErr(Errors.NastCheck)
module T = GenErr(Errors.Typing)

let gen_error_map_content () : string =
  let buffer = create 4096 in
  P.generate_errors buffer "Parsing";
  N.generate_errors buffer "Naming";
  NC.generate_errors buffer "NastCheck";
  T.generate_errors buffer "Typing";
  contents buffer

 (*
   Please modify the error map below if you have changed the error codes.
  *)

let%expect_test "error_map" =
  let map = gen_error_map_content () in
  Printf.printf "%s\n" map;
  [%expect {|
Parsing Errors:
FixmeFormat = 1001
ParsingError = 1002
UnexpectedEof = 1003
UnterminatedComment = 1004
UnterminatedXhpComment = 1005
CallTimePassByReferenceDEPRECATED = 1006

Naming Errors:
AddATypehint = 2001
TypeparamAlok = 2002
AssertArity = 2003
PrimitiveInvalidAlias = 2004
CyclicConstraintDEPRECATED = 2005
DidYouMeanNaming = 2006
DifferentScope = 2007
DisallowedXhpType = 2008
DoubleInsteadOfFloatDEPRECATED = 2009
DynamicClassDEPRECATED = 2010
DynamicMethodCall = 2011
ErrorNameAlreadyBound = 2012
ExpectedCollection = 2013
ExpectedVariable = 2014
FdNameAlreadyBound = 2015
GenArrayRecArity = 2016
GenArrayVaRecArityDEPRECATED = 2017
GenaArity = 2018
GenericClassVar = 2019
GenvaArity = 2020
IllegalClass = 2021
IllegalClassMeth = 2022
IllegalConstant = 2023
IllegalFun = 2024
IllegalInstMeth = 2025
IllegalMethCaller = 2026
IllegalMethFun = 2027
IntegerInsteadOfIntDEPRECATED = 2028
InvalidReqExtends = 2029
InvalidReqImplements = 2030
LocalConst = 2031
LowercaseThis = 2032
MethodNameAlreadyBound = 2033
MissingArrow = 2034
MissingTypehint = 2035
NameAlreadyBound = 2036
NamingTooFewArguments = 2037
NamingTooManyArguments = 2038
PrimitiveToplevel = 2039
RealInsteadOfFloatDEPRECATED = 2040
ShadowedTypeParam = 2041
StartWith_T = 2042
ThisMustBeReturn = 2043
ThisNoArgument = 2044
ThisHintOutsideClass = 2045
ThisReserved = 2046
TparamWithTparam = 2047
TypedefConstraint = 2048
UnboundName = 2049
Undefined = 2050
UnexpectedArrow = 2051
UnexpectedTypedef = 2052
UsingInternalClass = 2053
VoidCast = 2054
ObjectCast = 2055
UnsetCast = 2056
NullsafePropertyAccessDEPRECATED = 2057
IllegalTrait = 2058
ShapeTypehintDEPRECATED = 2059
DynamicNewInStrictMode = 2060
InvalidTypeAccessRoot = 2061
DuplicateUserAttribute = 2062
ReturnOnlyTypehint = 2063
UnexpectedTypeArguments = 2064
TooManyTypeArguments = 2065
ClassnameParam = 2066
InvalidInstanceof = 2067
NameIsReserved = 2068
DollardollarUnused = 2069
IllegalMemberVariableClass = 2070
TooFewTypeArguments = 2071
GotoLabelAlreadyDefined = 2072
GotoLabelUndefined = 2073
GotoLabelDefinedInFinally = 2074
GotoInvokedInFinally = 2075
DynamicClassPropertyNameInStrictMode = 2076
ThisAsLexicalVariable = 2077
DynamicClassNameInStrictMode = 2078
XhpOptionalRequiredAttr = 2079
XhpRequiredWithDefault = 2080
VariableVariablesDisallowed = 2081
ArrayTypehintsDisallowed = 2082
ArrayLiteralsDisallowed = 2083
WildcardDisallowed = 2084
AttributeClassNameConflict = 2085
MethodNeedsVisibility = 2086
ReferenceInStrictMode = 2087
ReferenceInRx = 2088
DeclareStatement = 2089
MisplacedRxOfScope = 2090
RxOfScopeAndExplicitRx = 2091
UnsupportedFeature = 2092
TraitInterfaceConstructorPromo = 2093

NastCheck Errors:
AbstractBody = 3001
AbstractWithBody = 3002
AwaitInSyncFunction = 3003
CallBeforeInit = 3004
CaseFallthrough = 3005
ContinueInSwitch = 3006
DangerousMethodName = 3007
DefaultFallthrough = 3008
InterfaceWithMemberVariable = 3009
InterfaceWithStaticMemberVariable = 3010
Magic = 3011
NoConstructParent = 3012
NonInterface = 3013
NotAbstractWithoutBody = 3014
NotInitialized = 3015
NotPublicInterface = 3016
RequiresNonClass = 3017
ReturnInFinally = 3018
ReturnInGen = 3019
ToStringReturnsString = 3020
ToStringVisibility = 3021
ToplevelBreak = 3022
ToplevelContinue = 3023
UsesNonTrait = 3024
IllegalFunctionName = 3025
NotAbstractWithoutTypeconst = 3026
TypeconstDependsOnExternalTparam = 3027
TypeconstAssignedTparam = 3028
AbstractWithTypeconst = 3029
ConstructorRequired = 3030
InterfaceWithPartialTypeconst = 3031
MultipleXhpCategory = 3032
OptionalShapeFieldsNotSupportedDEPRECATED = 3033
AwaitNotAllowed = 3034
AsyncInInterface = 3035
AwaitInCoroutine = 3036
YieldInCoroutine = 3037
SuspendOutsideOfCoroutine = 3038
SuspendInFinally = 3039
BreakContinueNNotSupported = 3040
StaticMemoizedFunction = 3041
InoutParamsOutsideOfSync = 3042
InoutParamsSpecial = 3043
InoutParamsMixByref = 3044
InoutParamsMemoize = 3045
InoutParamsRetByRef = 3046
ReadingFromAppend = 3047
ConstAttributeProhibited = 3048
RetiredError3049DEPRECATED = 3049
InoutArgumentBadExpr = 3050
MutableParamsOutsideOfSync = 3051
MutableAsyncMethod = 3052
MutableMethodsMustBeReactive = 3053
MutableAttributeOnFunction = 3054
MutableReturnAnnotatedDeclsMustBeReactive = 3055
IllegalDestructor = 3056
ConditionallyReactiveFunctionDEPRECATED = 3057
MultipleConditionallyReactiveAnnotations = 3058
ConditionallyReactiveAnnotationInvalidArguments = 3059
MissingReactivityForConditionDEPRECATED = 3060
MultipleReactivityAnnotationsDEPRECATED = 3061
RxIsEnabledInvalidLocation = 3062
MaybeRxInvalidLocation = 3063
NoOnlyrxIfRxfuncForRxIfArgs = 3064
CoroutineInConstructor = 3065
IllegalReturnByRef = 3066
IllegalByRefExpr = 3067
VariadicByRefParam = 3068
MaybeMutableAttributeOnFunction = 3069
ConflictingMutableAndMaybeMutableAttributes = 3070
MaybeMutableMethodsMustBeReactive = 3071
RequiresFinalClass = 3072
InterfaceUsesTrait = 3073
NonstaticMethodInAbstractFinalClass = 3074
MutableOnStatic = 3075
ClassnameConstInstanceOf = 3076

Typing Errors:
AbstractClassFinalDEPRECATED = 4001
UninstantiableClass = 4002
AnonymousRecursive = 4003
AnonymousRecursiveCall = 4004
ArrayAccess = 4005
ArrayAppend = 4006
ArrayCast = 4007
ArrayGetArity = 4008
BadCall = 4009
ClassArity = 4010
ConstMutation = 4011
ConstructorNoArgs = 4012
CyclicClassDef = 4013
CyclicTypedef = 4014
DiscardedAwaitable = 4015
IssetEmptyInStrict = 4016
DynamicYieldPrivateDEPRECATED = 4017
EnumConstantTypeBad = 4018
EnumSwitchNonexhaustive = 4019
EnumSwitchNotConst = 4020
EnumSwitchRedundant = 4021
EnumSwitchRedundantDefault = 4022
EnumSwitchWrongClass = 4023
EnumTypeBad = 4024
EnumTypeTypedefMixed = 4025
ExpectedClass = 4026
ExpectedLiteralFormatString = 4027
ExpectedStaticIntDEPRECATED = 4028
ExpectedTparam = 4029
ExpectingReturnTypeHint = 4030
ExpectingReturnTypeHintSuggest = 4031
ExpectingTypeHint = 4032
ExpectingTypeHintSuggest = 4033
RetiredError4034DEPRECATED = 4034
ExtendFinal = 4035
FieldKinds = 4036
FieldMissingDEPRECATED = 4037
FormatString = 4038
FunArityMismatch = 4039
FunTooFewArgs = 4040
FunTooManyArgs = 4041
FunUnexpectedNonvariadic = 4042
FunVariadicityHhVsPhp56 = 4043
GenaExpectsArray = 4044
GenericArrayStrict = 4045
GenericStatic = 4046
ImplementAbstract = 4047
InterfaceFinal = 4048
InvalidShapeFieldConst = 4049
InvalidShapeFieldLiteral = 4050
InvalidShapeFieldName = 4051
InvalidShapeFieldType = 4052
MemberNotFound = 4053
MemberNotImplemented = 4054
MissingAssign = 4055
MissingConstructor = 4056
MissingField = 4057
NegativeTupleIndexDEPRECATED = 4058
SelfOutsideClass = 4059
NewStaticInconsistent = 4060
StaticOutsideClass = 4061
NonObjectMember = 4062
NullContainer = 4063
NullMember = 4064
NullableParameterDEPRECATED = 4065
OptionReturnOnlyTypehint = 4066
ObjectString = 4067
OptionMixed = 4068
Overflow = 4069
OverrideFinal = 4070
OverridePerTrait = 4071
PairArity = 4072
AbstractCall = 4073
ParentInTrait = 4074
ParentOutsideClass = 4075
ParentUndefined = 4076
PreviousDefault = 4077
PrivateClassMeth = 4078
PrivateInstMeth = 4079
PrivateOverride = 4080
ProtectedClassMeth = 4081
ProtectedInstMeth = 4082
ReadBeforeWrite = 4083
ReturnInVoid = 4084
ShapeFieldClassMismatch = 4085
ShapeFieldTypeMismatch = 4086
ShouldBeOverride = 4087
SketchyNullCheck = 4088
SketchyNullCheckPrimitive = 4089
SmemberNotFound = 4090
StaticDynamic = 4091
StaticOverflowDEPRECATED = 4092
RetiredError4093DEPRECATED = 4093
ThisInStatic = 4094
ThisVarOutsideClass = 4095
TraitFinal = 4096
TupleArity = 4097
TupleArityMismatch = 4098
TupleIndexTooLargeDEPRECATED = 4099
TupleSyntax = 4100
TypeArityMismatch = 4101
TypeParamArity = 4102
RetiredError4103DEPRECATED = 4103
TypingTooFewArgs = 4104
TypingTooManyArgs = 4105
UnboundGlobal = 4106
UnboundNameTyping = 4107
UndefinedField = 4108
UndefinedParent = 4109
UnifyError = 4110
UnsatisfiedReq = 4111
Visibility = 4112
VisibilityExtends = 4113
VoidParameterDEPRECATED = 4114
WrongExtendKind = 4115
GenericUnify = 4116
NullsafeNotNeeded = 4117
TrivialStrictEq = 4118
VoidUsage = 4119
DeclaredCovariant = 4120
DeclaredContravariant = 4121
UnsetInStrictDEPRECATED = 4122
StrictMembersNotKnown = 4123
GenericAtRuntime = 4124
DynamicClassDEPRECATED = 4125
AttributeTooManyArguments = 4126
AttributeParamType = 4127
DeprecatedUse = 4128
AbstractConstUsage = 4129
CannotDeclareConstant = 4130
CyclicTypeconst = 4131
NullsafePropertyWriteContext = 4132
NoreturnUsage = 4133
ThisLvalue = 4134
UnsetNonidxInStrict = 4135
InvalidShapeFieldNameEmpty = 4136
InvalidShapeFieldNameNumber = 4137
ShapeFieldsUnknown = 4138
InvalidShapeRemoveKey = 4139
MissingOptionalFieldDEPRECATED = 4140
ShapeFieldUnset = 4141
AbstractConcreteOverride = 4142
LocalVariableModifedAndUsed = 4143
LocalVariableModifedTwice = 4144
AssignDuringCase = 4145
CyclicEnumConstraint = 4146
UnpackingDisallowed = 4147
InvalidClassname = 4148
InvalidMemoizedParam = 4149
IllegalTypeStructure = 4150
NotNullableCompareNullTrivial = 4151
ClassPropertyOnlyStaticLiteral = 4152
AttributeTooFewArguments = 4153
ReferenceExpr = 4154
UnificationCycle = 4155
KeysetSet = 4156
EqIncompatibleTypes = 4157
ContravariantThis = 4158
InstanceofAlwaysFalseDEPRECATED = 4159
InstanceofAlwaysTrueDEPRECATED = 4160
AmbiguousMember = 4161
InstanceofGenericClassname = 4162
RequiredFieldIsOptional = 4163
FinalProperty = 4164
ArrayGetWithOptionalField = 4165
UnknownFieldDisallowedInShape = 4166
NullableCast = 4167
PassByRefAnnotationMissing = 4168
NonCallArgumentInSuspend = 4169
NonCoroutineCallInSuspend = 4170
CoroutineCallOutsideOfSuspend = 4171
FunctionIsNotCoroutine = 4172
CoroutinnessMismatch = 4173
ExpectingAwaitableReturnTypeHint = 4174
ReffinessInvariant = 4175
DollardollarLvalue = 4176
StaticMethodOnInterfaceDEPRECATED = 4177
DuplicateUsingVar = 4178
IllegalDisposable = 4179
EscapingDisposable = 4180
PassByRefAnnotationUnexpected = 4181
InoutAnnotationMissing = 4182
InoutAnnotationUnexpected = 4183
InoutnessMismatch = 4184
StaticSyntheticMethod = 4185
TraitReuse = 4186
InvalidNewDisposable = 4187
EscapingDisposableParameter = 4188
AcceptDisposableInvariant = 4189
InvalidDisposableHint = 4190
XhpRequired = 4191
EscapingThis = 4192
IllegalXhpChild = 4193
MustExtendDisposable = 4194
InvalidIsAsExpressionHint = 4195
AssigningToConst = 4196
SelfConstParentNot = 4197
ParentConstSelfNot = 4198
PartiallyValidIsAsExpressionHint = 4199
NonreactiveFunctionCall = 4200
NonreactiveAppend = 4201
ObjSetReactive = 4202
FunReactivityMismatch = 4203
OverridingPropConstMismatch = 4204
InvalidReturnDisposable = 4205
InvalidDisposableReturnHint = 4206
ReturnDisposableMismatch = 4207
InoutArgumentBadType = 4208
FrozenInIncorrectScope = 4209
ReassignMutableVar = 4210
InvalidFreezeTarget = 4211
InvalidFreezeUse = 4212
FreezeInNonreactiveContext = 4213
MutableCallOnImmutable = 4214
MutableArgumentMismatch = 4215
InvalidMutableReturnResult = 4216
MutableReturnResultMismatch = 4217
NonreactiveCallFromShallow = 4218
EnumTypeTypedefNonnull = 4219
RxEnabledInNonRxContext = 4220
RxEnabledInLambdas = 4221
AmbiguousLambda = 4222
EllipsisStrictMode = 4223
UntypedLambdaStrictMode = 4224
BindingRefInArray = 4225
EchoInReactiveContext = 4226
SuperglobalInReactiveContext = 4227
StaticPropertyInReactiveContext = 4228
StaticInReactiveContext = 4229
GlobalInReactiveContext = 4230
WrongExpressionKindAttribute = 4231
AttributeClassNoConstructorArgs = 4232
InvalidTypeForOnlyrxIfRxfuncParameter = 4233
MissingAnnotationForOnlyrxIfRxfuncParameter = 4234
CannotReturnBorrowedValueAsImmutable = 4235
DeclOverrideMissingHint = 4236
InvalidConditionallyReactiveCall = 4237
ExtendSealed = 4238
SealedFinal = 4239
ComparisonInvalidTypes = 4240
OptionVoid = 4241
MutableInNonreactiveContext = 4242
InvalidArgumentOfRxMutableFunction = 4243
LetVarImmutabilityViolation = 4244
Unsealable = 4245
ReturnVoidToRxMismatch = 4246
ReturnsVoidToRxAsNonExpressionStatement = 4247
NonawaitedAwaitableInReactiveContext = 4248
ShapesKeyExistsAlwaysTrue = 4249
ShapesKeyExistsAlwaysFalse = 4250
ShapesIdxWithNonExistentField = 4251
NonClassMember = 4252
PassingArrayCellByRef = 4253
CallSiteReactivityMismatch = 4254
RxParameterConditionMismatch = 4255
AmbiguousObjectAccess = 4256
ExtendPPL = 4257
ReassignMaybeMutableVar = 4258
MaybeMutableArgumentMismatch = 4259
ImmutableArgumentMismatch = 4260
ImmutableCallOnMutable = 4261
InvalidCallMaybeMutable = 4262
MutabilityMismatch = 4263
InvalidPPLCall = 4264
InvalidPPLStaticCall = 4265
TypeTestInLambda = 4266
InvalidTraversableInRx = 4267
ReassignMutableThis = 4268
MutableExpressionAsMultipleMutableArguments = 4269
InvalidUnsetTargetInRx = 4270
CoroutineOutsideExperimental = 4271
PPLMethPointer = 4272
InvalidTruthinessTest = 4273
RePrefixedNonString = 4274
BadRegexPattern = 4275
SketchyTruthinessTest = 4276
LateInitWithDefault = 4277
OverrideMemoizeLSB = 4278
ClassVarTypeGenericParam = 4279
InvalidSwitchCaseValueType = 4280
StringCast = 4281
  |}]
