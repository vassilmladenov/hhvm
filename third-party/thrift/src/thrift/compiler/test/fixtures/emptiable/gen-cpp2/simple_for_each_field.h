/**
 * Autogenerated by Thrift for thrift/compiler/test/fixtures/emptiable/src/simple.thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated @nocommit
 */
#pragma once

#include "thrift/compiler/test/fixtures/emptiable/gen-cpp2/simple_metadata.h"
#include <thrift/lib/cpp2/visitation/for_each.h>

namespace apache {
namespace thrift {
namespace detail {

template <>
struct ForEachField<::apache::thrift::test::MyStruct> {
  template <typename F, typename... T>
  void operator()([[maybe_unused]] F&& f, [[maybe_unused]] T&&... t) const {
  }
};

template <>
struct ForEachField<::apache::thrift::test::EmptiableStruct> {
  template <typename F, typename... T>
  void operator()([[maybe_unused]] F&& f, [[maybe_unused]] T&&... t) const {
    f(0, static_cast<T&&>(t).bool_field_ref()...);
    f(1, static_cast<T&&>(t).byte_field_ref()...);
    f(2, static_cast<T&&>(t).short_field_ref()...);
    f(3, static_cast<T&&>(t).int_field_ref()...);
    f(4, static_cast<T&&>(t).long_field_ref()...);
    f(5, static_cast<T&&>(t).float_field_ref()...);
    f(6, static_cast<T&&>(t).double_field_ref()...);
    f(7, static_cast<T&&>(t).string_field_ref()...);
    f(8, static_cast<T&&>(t).binary_field_ref()...);
    f(9, static_cast<T&&>(t).enum_field_ref()...);
    f(10, static_cast<T&&>(t).list_field_ref()...);
    f(11, static_cast<T&&>(t).set_field_ref()...);
    f(12, static_cast<T&&>(t).map_field_ref()...);
    f(13, static_cast<T&&>(t).struct_field_ref()...);
  }
};

template <>
struct ForEachField<::apache::thrift::test::EmptiableTerseStruct> {
  template <typename F, typename... T>
  void operator()([[maybe_unused]] F&& f, [[maybe_unused]] T&&... t) const {
    f(0, static_cast<T&&>(t).bool_field_ref()...);
    f(1, static_cast<T&&>(t).byte_field_ref()...);
    f(2, static_cast<T&&>(t).short_field_ref()...);
    f(3, static_cast<T&&>(t).int_field_ref()...);
    f(4, static_cast<T&&>(t).long_field_ref()...);
    f(5, static_cast<T&&>(t).float_field_ref()...);
    f(6, static_cast<T&&>(t).double_field_ref()...);
    f(7, static_cast<T&&>(t).string_field_ref()...);
    f(8, static_cast<T&&>(t).binary_field_ref()...);
    f(9, static_cast<T&&>(t).enum_field_ref()...);
    f(10, static_cast<T&&>(t).list_field_ref()...);
    f(11, static_cast<T&&>(t).set_field_ref()...);
    f(12, static_cast<T&&>(t).map_field_ref()...);
    f(13, static_cast<T&&>(t).struct_field_ref()...);
  }
};

template <>
struct ForEachField<::apache::thrift::test::NotEmptiableStruct> {
  template <typename F, typename... T>
  void operator()([[maybe_unused]] F&& f, [[maybe_unused]] T&&... t) const {
    f(0, static_cast<T&&>(t).bool_field_ref()...);
    f(1, static_cast<T&&>(t).byte_field_ref()...);
    f(2, static_cast<T&&>(t).short_field_ref()...);
    f(3, static_cast<T&&>(t).int_field_ref()...);
    f(4, static_cast<T&&>(t).long_field_ref()...);
    f(5, static_cast<T&&>(t).float_field_ref()...);
    f(6, static_cast<T&&>(t).double_field_ref()...);
    f(7, static_cast<T&&>(t).string_field_ref()...);
    f(8, static_cast<T&&>(t).binary_field_ref()...);
    f(9, static_cast<T&&>(t).enum_field_ref()...);
    f(10, static_cast<T&&>(t).list_field_ref()...);
    f(11, static_cast<T&&>(t).set_field_ref()...);
    f(12, static_cast<T&&>(t).map_field_ref()...);
    f(13, static_cast<T&&>(t).struct_field_ref()...);
  }
};
} // namespace detail
} // namespace thrift
} // namespace apache
