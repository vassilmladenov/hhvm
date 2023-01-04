/**
 * Autogenerated by Thrift for thrift/compiler/test/fixtures/refs/src/module.thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated @nocommit
 */
#pragma once

#include <thrift/lib/cpp2/visitation/visit_by_thrift_field_metadata.h>
#include "thrift/compiler/test/fixtures/refs/gen-cpp2/module_metadata.h"

namespace apache {
namespace thrift {
namespace detail {

template <>
struct VisitByFieldId<::cpp2::MyUnion> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).anInteger_ref());
    case 2:
      return f(1, static_cast<T&&>(t).aString_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::MyUnion");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::MyField> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).opt_value_ref());
    case 2:
      return f(1, static_cast<T&&>(t).value_ref());
    case 3:
      return f(2, static_cast<T&&>(t).req_value_ref());
    case 4:
      return f(3, static_cast<T&&>(t).opt_enum_value_ref());
    case 5:
      return f(4, static_cast<T&&>(t).enum_value_ref());
    case 6:
      return f(5, static_cast<T&&>(t).req_enum_value_ref());
    case 7:
      return f(6, static_cast<T&&>(t).opt_str_value_ref());
    case 8:
      return f(7, static_cast<T&&>(t).str_value_ref());
    case 9:
      return f(8, static_cast<T&&>(t).req_str_value_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::MyField");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::MyStruct> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).opt_ref_ref());
    case 2:
      return f(1, static_cast<T&&>(t).ref_ref());
    case 3:
      return f(2, static_cast<T&&>(t).req_ref_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::MyStruct");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithUnion> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).u_ref());
    case 2:
      return f(1, static_cast<T&&>(t).aDouble_ref());
    case 3:
      return f(2, static_cast<T&&>(t).f_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithUnion");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::RecursiveStruct> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).mes_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::RecursiveStruct");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithContainers> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).list_ref_ref());
    case 2:
      return f(1, static_cast<T&&>(t).set_ref_ref());
    case 3:
      return f(2, static_cast<T&&>(t).map_ref_ref());
    case 4:
      return f(3, static_cast<T&&>(t).list_ref_unique_ref());
    case 5:
      return f(4, static_cast<T&&>(t).set_ref_shared_ref());
    case 6:
      return f(5, static_cast<T&&>(t).list_ref_shared_const_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithContainers");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithSharedConst> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).opt_shared_const_ref());
    case 2:
      return f(1, static_cast<T&&>(t).shared_const_ref());
    case 3:
      return f(2, static_cast<T&&>(t).req_shared_const_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithSharedConst");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::Empty> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    default:
      throwInvalidThriftId(fieldId, "::cpp2::Empty");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithRef> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).def_field_ref());
    case 2:
      return f(1, static_cast<T&&>(t).opt_field_ref());
    case 3:
      return f(2, static_cast<T&&>(t).req_field_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithRef");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithBox> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).a_ref());
    case 2:
      return f(1, static_cast<T&&>(t).b_ref());
    case 3:
      return f(2, static_cast<T&&>(t).c_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithBox");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithInternBox> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).field1_ref());
    case 2:
      return f(1, static_cast<T&&>(t).field2_ref());
    case 3:
      return f(2, static_cast<T&&>(t).field3_ref());
    case 4:
      return f(3, static_cast<T&&>(t).field4_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithInternBox");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::AdaptedStructWithInternBox> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).field1_ref());
    case 2:
      return f(1, static_cast<T&&>(t).field2_ref());
    case 3:
      return f(2, static_cast<T&&>(t).field3_ref());
    case 4:
      return f(3, static_cast<T&&>(t).field4_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::AdaptedStructWithInternBox");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithRefTypeUnique> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).def_field_ref());
    case 2:
      return f(1, static_cast<T&&>(t).opt_field_ref());
    case 3:
      return f(2, static_cast<T&&>(t).req_field_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithRefTypeUnique");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithRefTypeShared> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).def_field_ref());
    case 2:
      return f(1, static_cast<T&&>(t).opt_field_ref());
    case 3:
      return f(2, static_cast<T&&>(t).req_field_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithRefTypeShared");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithRefTypeSharedConst> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).def_field_ref());
    case 2:
      return f(1, static_cast<T&&>(t).opt_field_ref());
    case 3:
      return f(2, static_cast<T&&>(t).req_field_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithRefTypeSharedConst");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithRefAndAnnotCppNoexceptMoveCtor> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).def_field_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithRefAndAnnotCppNoexceptMoveCtor");
    }
  }
};

template <>
struct VisitByFieldId<::cpp2::StructWithString> {
  template <typename F, typename T>
  void operator()(FOLLY_MAYBE_UNUSED F&& f, int32_t fieldId, FOLLY_MAYBE_UNUSED T&& t) const {
    switch (fieldId) {
    case 1:
      return f(0, static_cast<T&&>(t).def_unique_string_ref_ref());
    case 2:
      return f(1, static_cast<T&&>(t).def_shared_string_ref_ref());
    case 3:
      return f(2, static_cast<T&&>(t).def_shared_string_const_ref_ref());
    case 4:
      return f(3, static_cast<T&&>(t).unique_string_ref_ref());
    case 5:
      return f(4, static_cast<T&&>(t).shared_string_ref_ref());
    default:
      throwInvalidThriftId(fieldId, "::cpp2::StructWithString");
    }
  }
};
} // namespace detail
} // namespace thrift
} // namespace apache
