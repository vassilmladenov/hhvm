/**
 * Autogenerated by Thrift for thrift/compiler/test/fixtures/empty-struct/src/module.thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated @nocommit
 */
#pragma once

#include "thrift/compiler/test/fixtures/empty-struct/gen-cpp2/module_metadata.h"
#include <thrift/lib/cpp2/visitation/for_each.h>

namespace apache {
namespace thrift {
namespace detail {

template <>
struct ForEachField<::cpp2::Empty> {
  template <typename F, typename... T>
  void operator()([[maybe_unused]] F&& f, [[maybe_unused]] T&&... t) const {
  }
};

template <>
struct ForEachField<::cpp2::Nada> {
  template <typename F, typename... T>
  void operator()([[maybe_unused]] F&& f, [[maybe_unused]] T&&... t) const {
  }
};
} // namespace detail
} // namespace thrift
} // namespace apache
