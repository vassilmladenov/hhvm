/**
 * Autogenerated by Thrift for thrift/compiler/test/fixtures/terse_write/src/terse_write.thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated @nocommit
 */
#pragma once

#include "thrift/compiler/test/fixtures/terse_write/gen-cpp2/terse_write_metadata.h"
#include <thrift/lib/cpp2/visitation/visit_union.h>

namespace apache {
namespace thrift {
namespace detail {

template <>
struct VisitUnion<::facebook::thrift::test::terse_write::MyUnion> {

  template <typename F, typename T>
  decltype(auto) operator()([[maybe_unused]] F&& f, T&& t) const {
    using Union = std::remove_reference_t<T>;
    switch (t.getType()) {
    case Union::Type::bool_field:
      return f(0, *static_cast<T&&>(t).bool_field_ref());
    case Union::Type::byte_field:
      return f(1, *static_cast<T&&>(t).byte_field_ref());
    case Union::Type::short_field:
      return f(2, *static_cast<T&&>(t).short_field_ref());
    case Union::Type::int_field:
      return f(3, *static_cast<T&&>(t).int_field_ref());
    case Union::Type::long_field:
      return f(4, *static_cast<T&&>(t).long_field_ref());
    case Union::Type::float_field:
      return f(5, *static_cast<T&&>(t).float_field_ref());
    case Union::Type::double_field:
      return f(6, *static_cast<T&&>(t).double_field_ref());
    case Union::Type::string_field:
      return f(7, *static_cast<T&&>(t).string_field_ref());
    case Union::Type::binary_field:
      return f(8, *static_cast<T&&>(t).binary_field_ref());
    case Union::Type::enum_field:
      return f(9, *static_cast<T&&>(t).enum_field_ref());
    case Union::Type::list_field:
      return f(10, *static_cast<T&&>(t).list_field_ref());
    case Union::Type::set_field:
      return f(11, *static_cast<T&&>(t).set_field_ref());
    case Union::Type::map_field:
      return f(12, *static_cast<T&&>(t).map_field_ref());
    case Union::Type::struct_field:
      return f(13, *static_cast<T&&>(t).struct_field_ref());
    case Union::Type::__EMPTY__:
      return decltype(f(0, *static_cast<T&&>(t).bool_field_ref()))();
    }
  }
};
} // namespace detail
} // namespace thrift
} // namespace apache
