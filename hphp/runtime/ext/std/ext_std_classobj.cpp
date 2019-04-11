/*
   +----------------------------------------------------------------------+
   | HipHop for PHP                                                       |
   +----------------------------------------------------------------------+
   | Copyright (c) 2010-present Facebook, Inc. (http://www.facebook.com)  |
   | Copyright (c) 1997-2010 The PHP Group                                |
   +----------------------------------------------------------------------+
   | This source file is subject to version 3.01 of the PHP license,      |
   | that is bundled with this package in the file LICENSE, and is        |
   | available through the world-wide-web at the following url:           |
   | http://www.php.net/license/3_01.txt                                  |
   | If you did not receive a copy of the PHP license and are unable to   |
   | obtain it through the world-wide-web, please send a note to          |
   | license@php.net so we can mail you a copy immediately.               |
   +----------------------------------------------------------------------+
*/

#include "hphp/runtime/ext/std/ext_std_classobj.h"

#include "hphp/runtime/base/array-init.h"
#include "hphp/runtime/base/backtrace.h"
#include "hphp/runtime/ext/array/ext_array.h"
#include "hphp/runtime/ext/string/ext_string.h"
#include "hphp/runtime/vm/jit/translator-inline.h"
#include "hphp/runtime/vm/jit/translator.h"
#include "hphp/runtime/vm/unit.h"

namespace HPHP {

///////////////////////////////////////////////////////////////////////////////
// helpers

static inline StrNR ctxClassName() {
  Class* ctx = g_context->getContextClass();
  return ctx ? ctx->nameStr() : StrNR(staticEmptyString());
}

static const Class* get_cls(const Variant& class_or_object) {
  Class* cls = nullptr;
  if (class_or_object.is(KindOfObject)) {
    ObjectData* obj = class_or_object.toCObjRef().get();
    cls = obj->getVMClass();
  } else if (class_or_object.isArray()) {
    // do nothing but avoid the toString conversion notice
  } else {
    cls = Unit::loadClass(class_or_object.toString().get());
  }
  return cls;
}

///////////////////////////////////////////////////////////////////////////////

Array HHVM_FUNCTION(get_declared_classes) {
  return Unit::getClassesInfo();
}

Array HHVM_FUNCTION(get_declared_interfaces) {
  return Unit::getInterfacesInfo();
}

Array HHVM_FUNCTION(get_declared_traits) {
  return Unit::getTraitsInfo();
}

bool HHVM_FUNCTION(class_alias, const String& original, const String& alias,
                                bool autoload /* = true */) {
  if (RuntimeOption::EvalAuthoritativeMode) {
    raise_warning("Cannot call class_alias dynamically "
                  "in repo-authoritative mode");
    return false;
  }
  return Unit::aliasClass(original.get(), alias.get(), autoload);
}

bool HHVM_FUNCTION(class_exists, const String& class_name,
                                 bool autoload /* = true */) {
  return Unit::classExists(class_name.get(), autoload, ClassKind::Class);
}

bool HHVM_FUNCTION(interface_exists, const String& interface_name,
                                     bool autoload /* = true */) {
  return
    Unit::classExists(interface_name.get(), autoload, ClassKind::Interface);
}

bool HHVM_FUNCTION(trait_exists, const String& trait_name,
                                 bool autoload /* = true */) {
  return Unit::classExists(trait_name.get(), autoload, ClassKind::Trait);
}

bool HHVM_FUNCTION(enum_exists, const String& enum_name,
                   bool autoload /* = true */) {
  Class* cls = Unit::getClass(enum_name.get(), autoload);
  return cls && isEnum(cls);
}

Variant HHVM_FUNCTION(get_class_methods, const Variant& class_or_object) {
  auto const cls = get_cls(class_or_object);
  if (!cls) return init_null();
  VMRegAnchor _;

  auto retVal = Array::attach(PackedArray::MakeReserve(cls->numMethods()));
  Class::getMethodNames(
    cls,
    arGetContextClassFromBuiltin(vmfp()),
    retVal
  );
  return Variant::attach(HHVM_FN(array_values)(retVal)).toArray();
}

Array HHVM_FUNCTION(get_class_constants, const String& className) {
  auto const cls = Unit::loadClass(className.get());
  if (cls == NULL) {
    return Array::attach(PackedArray::MakeReserve(0));
  }

  auto const numConstants = cls->numConstants();
  ArrayInit arrayInit(numConstants, ArrayInit::Map{});

  auto const consts = cls->constants();
  for (size_t i = 0; i < numConstants; i++) {
    // Note: hphpc doesn't include inherited constants in
    // get_class_constants(), so mimic that behavior
    if (consts[i].cls == cls && !consts[i].isAbstract() &&
        !consts[i].isType()) {
      auto const name  = const_cast<StringData*>(consts[i].name.get());
      Cell value = consts[i].val;
      // Handle dynamically set constants
      if (value.m_type == KindOfUninit) {
        value = cls->clsCnsGet(consts[i].name);
      }
      assertx(value.m_type != KindOfUninit);
      arrayInit.set(name, cellAsCVarRef(value));
    }
  }

  return arrayInit.toArray();
}

Variant HHVM_FUNCTION(get_class_vars, const String& className) {
  const Class* cls = Unit::loadClass(className.get());
  if (!cls) {
    return false;
  }
  cls->initialize();


  auto const propInfo = cls->declProperties();

  auto const numDeclProps = cls->numDeclProperties();
  auto const numSProps    = cls->numStaticProperties();

  // The class' instance property initialization template is in different
  // places, depending on whether it has any request-dependent initializers
  // (i.e. constants)
  auto const& declPropInitVec = cls->declPropInit();
  auto const propVals = !cls->pinitVec().empty()
    ? cls->getPropData()
    : &declPropInitVec;

  assertx(propVals != nullptr);
  assertx(propVals->size() == numDeclProps);

  // For visibility checks
  auto ctx = GetCallerClass();

  ArrayInit arr(numDeclProps + numSProps, ArrayInit::Map{});

  for (size_t i = 0; i < numDeclProps; ++i) {
    auto const name = const_cast<StringData*>(propInfo[i].name.get());
    // Empty names are used for invisible/private parent properties; skip them.
    assertx(name->size() != 0);
    if (Class::IsPropAccessible(propInfo[i], ctx)) {
      auto const value = &((*propVals)[i]);
      arr.set(name, tvAsCVarRef(value));
    }
  }

  for (auto const& sprop : cls->staticProperties()) {
    auto const lookup = cls->getSProp(ctx, sprop.name);
    if (lookup.accessible) {
      arr.set(
        const_cast<StringData*>(sprop.name.get()),
        tvAsCVarRef(lookup.val)
      );
    }
  }

  return arr.toArray();
}

///////////////////////////////////////////////////////////////////////////////

Variant HHVM_FUNCTION(get_class, const Variant& object /* = uninit_variant */) {
  auto logOrThrow = [&](const Variant& object) {
    if (RuntimeOption::EvalGetClassBadArgument == 0) return;
    auto msg = folly::sformat("get_class() was called with {}, expected object",
                              getDataTypeString(object.getType()));
    if (RuntimeOption::EvalGetClassBadArgument == 1) {
      raise_warning(msg);
    } else {
      SystemLib::throwRuntimeExceptionObject(msg);
    }
  };
  if (object.isNull()) {
    // No arg passed.
    logOrThrow(object);

    auto cls = GetCallerClassSkipBuiltins();
    if (cls) {
      return Variant{cls->name(), Variant::PersistentStrInit{}};
    }

    raise_warning("get_class() called without object from outside a class");
    return false;
  }
  if (!object.isObject()) {
    logOrThrow(object);
    return false;
  }
  return Variant{object.toCObjRef()->getVMClass()->name(),
                 Variant::PersistentStrInit{}};
}

Variant HHVM_FUNCTION(get_parent_class,
                      const Variant& object /* = uninit_variant */) {
  const Class* cls;
  if (object.isNull()) {
    cls = GetCallerClass();
    if (!cls) return false;
  } else {
    if (object.isObject()) {
      cls = object.toCObjRef()->getVMClass();
    } else if (object.isString()) {
      cls = Unit::loadClass(object.toCStrRef().get());
      if (!cls) return false;
    } else {
      return false;
    }
  }

  if (!cls->parent()) return false;

  return Variant{cls->parentStr().get(), Variant::PersistentStrInit{}};
}

static bool is_a_impl(const Variant& class_or_object, const String& class_name,
                      bool allow_string, bool subclass_only) {
  if (class_or_object.isString() && !allow_string) {
    return false;
  }
  if (!(class_or_object.isString() || class_or_object.isObject())) {
    return false;
  }

  const Class* cls = get_cls(class_or_object);
  if (!cls) return false;
  if (cls->attrs() & AttrTrait) return false;
  const Class* other = Unit::lookupClass(class_name.get());
  if (!other) return false;
  if (other->attrs() & AttrTrait) return false;
  if (other == cls) return !subclass_only;
  return cls->classof(other);
}

bool HHVM_FUNCTION(is_a, const Variant& class_or_object,
                         const String& class_name,
                         bool allow_string /* = false */) {
  return is_a_impl(class_or_object, class_name, allow_string, false);
}

bool HHVM_FUNCTION(is_subclass_of, const Variant& class_or_object,
                                   const String& class_name,
                                   bool allow_string /* = true */) {
  return is_a_impl(class_or_object, class_name, allow_string, true);
}

bool HHVM_FUNCTION(method_exists, const Variant& class_or_object,
                                  const String& method_name) {
  const Class* cls = get_cls(class_or_object);
  if (!cls) return false;
  if (cls->lookupMethod(method_name.get()) != NULL) return true;
  if (cls->attrs() & (AttrAbstract | AttrInterface)) {
    const Class::InterfaceMap& ifaces = cls->allInterfaces();
    for (int i = 0, size = ifaces.size(); i < size; i++) {
      if (ifaces[i]->lookupMethod(method_name.get())) return true;
    }
  }
  return false;
}

Variant HHVM_FUNCTION(property_exists, const Variant& class_or_object,
                                       const String& property) {
  Class* cls = nullptr;
  ObjectData* obj = nullptr;
  if (class_or_object.isObject()) {
    obj = class_or_object.getObjectData();
    cls = obj->getVMClass();
    assertx(cls);
  } else if (class_or_object.isString()) {
    cls = Unit::loadClass(class_or_object.toString().get());
    if (!cls) return false;
  } else {
    raise_warning(
      "First parameter must either be an object"
      " or the name of an existing class"
    );
    return Variant(Variant::NullInit());
  }

  auto const lookup = cls->getDeclPropIndex(cls, property.get());
  if (lookup.slot != kInvalidSlot) return true;

  if (obj &&
      UNLIKELY(obj->getAttribute(ObjectData::HasDynPropArr)) &&
      obj->dynPropArray()->rval(property.get())) {
    if (RuntimeOption::EvalNoticeOnReadDynamicProp) {
      obj->raiseReadDynamicProp(property.get());
    }
    return true;
  }
  auto const propInd = cls->lookupSProp(property.get());
  return propInd != kInvalidSlot;
}

Array HHVM_FUNCTION(get_object_vars, const Object& object) {
  return object
    ->o_toIterArray(ctxClassName(), ObjectData::PreserveRefs)
    .toDArray();
}

///////////////////////////////////////////////////////////////////////////////

Variant HHVM_FUNCTION(call_user_method_array, const String& method_name,
                                              VRefParam obj,
                                              const Variant& paramarr) {
  return obj.toObject()->o_invoke(method_name, paramarr);
}

///////////////////////////////////////////////////////////////////////////////

String HHVM_FUNCTION(HH_class_meth_get_class, TypedValue v) {
  if (!tvIsClsMeth(v)) {
    raise_error("Argument 1 passed to %s must be a class_meth",
                __FUNCTION__+5);
  }
  auto const c = val(v).pclsmeth->getCls();
  return String::attach(const_cast<StringData*>(classToStringHelper(c)));
}

String HHVM_FUNCTION(HH_class_meth_get_method, TypedValue v) {
  if (!tvIsClsMeth(v)) {
    raise_error("Argument 1 passed to %s must be a class_meth",
                __FUNCTION__+5);
  }
  auto const c = val(v).pclsmeth->getFunc();
  return String::attach(const_cast<StringData*>(funcToStringHelper(c)));
}

namespace {
const StaticString
  s_meth_caller_cls("\\__SystemLib\\MethCallerHelper"),
  s_meth_caller_get_cls_name("getClassNameImpl"),
  s_meth_caller_get_meth_name("getMethodNameImpl");

String getMethCallerClsOrMethNameHelper(
  const char* fn, TypedValue v, bool isClass) {
  if (tvIsFunc(v)) {
    if (auto const pos = Func::methCallerOffset(val(v).pfunc->name())) {
      auto clsMethName = val(v).pfunc->name()->slice();
      clsMethName.uncheckedAdvance(pos);
      auto const sep = folly::qfind(clsMethName, folly::StringPiece("::"));
      assertx(sep != std::string::npos);
      if (isClass) {
        clsMethName = clsMethName.uncheckedSubpiece(0, sep);
      } else {
        clsMethName.uncheckedAdvance(sep + 2);
      }
      return String::attach(makeStaticString(clsMethName));
    }
  } else if (tvIsObject(v)) {
    auto const obj = val(v).pobj;
    if (obj->instanceof(s_meth_caller_cls)) {
      return ObjectData::InvokeSimple(
        obj,
        isClass ? s_meth_caller_get_cls_name : s_meth_caller_get_meth_name)
        .toString();
    }
  }
  raise_error("Argument 1 passed to %s must be a MethCaller", fn);
}
}

String HHVM_FUNCTION(HH_meth_caller_get_class, TypedValue v) {
  return getMethCallerClsOrMethNameHelper(__FUNCTION__+5, v, true);
}

String HHVM_FUNCTION(HH_meth_caller_get_method, TypedValue v) {
  return getMethCallerClsOrMethNameHelper(__FUNCTION__+5, v, false);
}

///////////////////////////////////////////////////////////////////////////////

void StandardExtension::initClassobj() {
  HHVM_FE(get_declared_classes);
  HHVM_FE(get_declared_interfaces);
  HHVM_FE(get_declared_traits);
  HHVM_FE(class_alias);
  HHVM_FE(class_exists);
  HHVM_FE(interface_exists);
  HHVM_FE(trait_exists);
  HHVM_FE(enum_exists);
  HHVM_FE(get_class_methods);
  HHVM_FE(get_class_constants);
  HHVM_FE(get_class_vars);
  HHVM_FE(get_class);
  HHVM_FE(get_parent_class);
  HHVM_FE(is_a);
  HHVM_FE(is_subclass_of);
  HHVM_FE(method_exists);
  HHVM_FE(property_exists);
  HHVM_FE(get_object_vars);
  HHVM_FE(call_user_method_array);
  HHVM_FALIAS(HH\\class_meth_get_class, HH_class_meth_get_class);
  HHVM_FALIAS(HH\\class_meth_get_method, HH_class_meth_get_method);
  HHVM_FALIAS(HH\\meth_caller_get_class, HH_meth_caller_get_class);
  HHVM_FALIAS(HH\\meth_caller_get_method, HH_meth_caller_get_method);

  loadSystemlib("std_classobj");
}


}
