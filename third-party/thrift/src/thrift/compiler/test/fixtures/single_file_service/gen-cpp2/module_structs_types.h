/**
 * Autogenerated by Thrift for thrift/compiler/test/fixtures/single_file_service/src/module_structs.thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated @nocommit
 */
#pragma once

#include <thrift/lib/cpp2/gen/module_types_h.h>



namespace apache {
namespace thrift {
namespace ident {
struct value;
} // namespace ident
namespace detail {
#ifndef APACHE_THRIFT_ACCESSOR_value
#define APACHE_THRIFT_ACCESSOR_value
APACHE_THRIFT_DEFINE_ACCESSOR(value);
#endif
} // namespace detail
} // namespace thrift
} // namespace apache

// BEGIN declare_enums

// END declare_enums
// BEGIN forward_declare
namespace cpp2 {
class Foo;
} // cpp2
// END forward_declare
// BEGIN hash_and_equal_to
// END hash_and_equal_to
namespace cpp2 {
using ::apache::thrift::detail::operator!=;
using ::apache::thrift::detail::operator>;
using ::apache::thrift::detail::operator<=;
using ::apache::thrift::detail::operator>=;


class Foo final  {
 private:
  friend struct ::apache::thrift::detail::st::struct_private_access;
  template<class> friend struct ::apache::thrift::detail::invoke_reffer;

  //  used by a static_assert in the corresponding source
  static constexpr bool __fbthrift_cpp2_gen_json = false;
  static const folly::StringPiece __fbthrift_get_field_name(::apache::thrift::FieldOrdinal ord);
  static const folly::StringPiece __fbthrift_get_class_name();
  using __fbthrift_reflection_ident_list = folly::tag_t<
    ::apache::thrift::ident::value
  >;

  static constexpr std::int16_t __fbthrift_reflection_field_id_list[] = {0,1};
  using __fbthrift_reflection_type_tags = folly::tag_t<
    ::apache::thrift::type::i32_t
  >;

  static constexpr std::size_t __fbthrift_field_size_v = 1;

  template<class T>
  using __fbthrift_id = ::apache::thrift::type::field_id<__fbthrift_reflection_field_id_list[folly::to_underlying(T::value)]>;

  template<class T>
  using __fbthrift_type_tag = ::apache::thrift::detail::at<__fbthrift_reflection_type_tags, T::value>;

  template<class T>
  using __fbthrift_ident = ::apache::thrift::detail::at<__fbthrift_reflection_ident_list, T::value>;

  template<class T> using __fbthrift_ordinal = ::apache::thrift::type::ordinal_tag<
    ::apache::thrift::detail::getFieldOrdinal<T,
                                              __fbthrift_reflection_ident_list,
                                              __fbthrift_reflection_type_tags>(
      __fbthrift_reflection_field_id_list
    )
  >;
  void __fbthrift_clear();
  void __fbthrift_clear_terse_fields();
  bool __fbthrift_is_empty() const;

 public:
  using __fbthrift_cpp2_type = Foo;
  static constexpr bool __fbthrift_cpp2_is_union =
    false;


 public:

  Foo() :
      __fbthrift_field_value() {
  }
  // FragileConstructor for use in initialization lists only.
  [[deprecated("This constructor is deprecated")]]
  Foo(apache::thrift::FragileConstructor, ::std::int32_t value__arg);

  Foo(Foo&&) = default;

  Foo(const Foo&) = default;


  Foo& operator=(Foo&&) = default;

  Foo& operator=(const Foo&) = default;
 private:
  ::std::int32_t __fbthrift_field_value;
 private:
  apache::thrift::detail::isset_bitset<1, apache::thrift::detail::IssetBitsetOption::Unpacked> __isset;

 public:

  bool operator==(const Foo&) const;
  bool operator<(const Foo&) const;

  template <typename..., typename T = ::std::int32_t>
  FOLLY_ERASE ::apache::thrift::optional_field_ref<const T&> value_ref() const& {
    return {this->__fbthrift_field_value, __isset.at(0), __isset.bit(0)};
  }

  template <typename..., typename T = ::std::int32_t>
  FOLLY_ERASE ::apache::thrift::optional_field_ref<const T&&> value_ref() const&& {
    return {static_cast<const T&&>(this->__fbthrift_field_value), __isset.at(0), __isset.bit(0)};
  }

  template <typename..., typename T = ::std::int32_t>
  FOLLY_ERASE ::apache::thrift::optional_field_ref<T&> value_ref() & {
    return {this->__fbthrift_field_value, __isset.at(0), __isset.bit(0)};
  }

  template <typename..., typename T = ::std::int32_t>
  FOLLY_ERASE ::apache::thrift::optional_field_ref<T&&> value_ref() && {
    return {static_cast<T&&>(this->__fbthrift_field_value), __isset.at(0), __isset.bit(0)};
  }

  template <typename..., typename T = ::std::int32_t>
  FOLLY_ERASE ::apache::thrift::optional_field_ref<const T&> value() const& {
    return {this->__fbthrift_field_value, __isset.at(0), __isset.bit(0)};
  }

  template <typename..., typename T = ::std::int32_t>
  FOLLY_ERASE ::apache::thrift::optional_field_ref<const T&&> value() const&& {
    return {static_cast<const T&&>(this->__fbthrift_field_value), __isset.at(0), __isset.bit(0)};
  }

  template <typename..., typename T = ::std::int32_t>
  FOLLY_ERASE ::apache::thrift::optional_field_ref<T&> value() & {
    return {this->__fbthrift_field_value, __isset.at(0), __isset.bit(0)};
  }

  template <typename..., typename T = ::std::int32_t>
  FOLLY_ERASE ::apache::thrift::optional_field_ref<T&&> value() && {
    return {static_cast<T&&>(this->__fbthrift_field_value), __isset.at(0), __isset.bit(0)};
  }

  const ::std::int32_t* get_value() const& {
    return value_ref() ? std::addressof(__fbthrift_field_value) : nullptr;
  }

  ::std::int32_t* get_value() & {
    return value_ref() ? std::addressof(__fbthrift_field_value) : nullptr;
  }
  ::std::int32_t* get_value() && = delete;

  [[deprecated("Use `FOO.value_ref() = BAR;` instead of `FOO.set_value(BAR);`")]]
  ::std::int32_t& set_value(::std::int32_t value_) {
    value_ref() = value_;
    return __fbthrift_field_value;
  }

  template <class Protocol_>
  unsigned long read(Protocol_* iprot);
  template <class Protocol_>
  uint32_t serializedSize(Protocol_ const* prot_) const;
  template <class Protocol_>
  uint32_t serializedSizeZC(Protocol_ const* prot_) const;
  template <class Protocol_>
  uint32_t write(Protocol_* prot_) const;

 private:
  template <class Protocol_>
  void readNoXfer(Protocol_* iprot);

  friend class ::apache::thrift::Cpp2Ops<Foo>;
  friend void swap(Foo& a, Foo& b);
};

template <class Protocol_>
unsigned long Foo::read(Protocol_* iprot) {
  auto _xferStart = iprot->getCursorPosition();
  readNoXfer(iprot);
  return iprot->getCursorPosition() - _xferStart;
}


} // cpp2
