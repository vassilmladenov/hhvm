#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#  @generated
#

from cpython.ref cimport PyObject
from libc.stdint cimport (
    int8_t as cint8_t,
    int16_t as cint16_t,
    int32_t as cint32_t,
    int64_t as cint64_t,
)
from libcpp cimport bool as cbool
from libcpp.map cimport map as cmap, pair as cpair
from libcpp.memory cimport shared_ptr, unique_ptr
from libcpp.set cimport set as cset
from libcpp.string cimport string
from libcpp.vector cimport vector

from folly cimport cFollyFuture, cFollyTry, cFollyUnit
cimport folly.iobuf as _fbthrift_iobuf
from thrift.py3.common cimport cRpcOptions
from thrift.py3.client cimport cClientWrapper

cimport module.types as _module_types


cdef extern from "thrift/compiler/test/fixtures/py3/src/gen-py3cpp/module_clients.h" namespace "::py3::simple":
  cdef cppclass cSimpleServiceAsyncClient "::py3::simple::SimpleServiceAsyncClient":
      pass

cdef extern from "<utility>" namespace "std":
  cdef unique_ptr[cSimpleServiceClientWrapper] move(unique_ptr[cSimpleServiceClientWrapper])

cdef extern from "thrift/compiler/test/fixtures/py3/src/gen-py3cpp/module_clients.h" namespace "::py3::simple":
  cdef cppclass cDerivedServiceAsyncClient "::py3::simple::DerivedServiceAsyncClient":
      pass

cdef extern from "<utility>" namespace "std":
  cdef unique_ptr[cDerivedServiceClientWrapper] move(unique_ptr[cDerivedServiceClientWrapper])

cdef extern from "thrift/compiler/test/fixtures/py3/src/gen-py3cpp/module_clients.h" namespace "::py3::simple":
  cdef cppclass cRederivedServiceAsyncClient "::py3::simple::RederivedServiceAsyncClient":
      pass

cdef extern from "<utility>" namespace "std":
  cdef unique_ptr[cRederivedServiceClientWrapper] move(unique_ptr[cRederivedServiceClientWrapper])

cdef extern from "thrift/lib/cpp/TProcessorEventHandler.h" namespace "::apache::thrift":
  cdef cppclass cTProcessorEventHandler "apache::thrift::TProcessorEventHandler":
    pass

cdef extern from "thrift/compiler/test/fixtures/py3/src/gen-py3/module/clients_wrapper.h" namespace "::py3::simple":
  cdef cppclass cSimpleServiceClientWrapper "::py3::simple::SimpleServiceClientWrapper":
    void setPersistentHeader(const string& key, const string& value)
    void addEventHandler(const shared_ptr[cTProcessorEventHandler]& handler)

    cFollyFuture[cint32_t] get_five(cRpcOptions, )
    cFollyFuture[cint32_t] add_five(cRpcOptions, 
      cint32_t arg_num,)
    cFollyFuture[cFollyUnit] do_nothing(cRpcOptions, )
    cFollyFuture[string] concat(cRpcOptions, 
      string arg_first,
      string arg_second,)
    cFollyFuture[cint32_t] get_value(cRpcOptions, 
      _module_types.cSimpleStruct arg_simple_struct,)
    cFollyFuture[cbool] negate(cRpcOptions, 
      cbool arg_input,)
    cFollyFuture[cint8_t] tiny(cRpcOptions, 
      cint8_t arg_input,)
    cFollyFuture[cint16_t] small(cRpcOptions, 
      cint16_t arg_input,)
    cFollyFuture[cint64_t] big(cRpcOptions, 
      cint64_t arg_input,)
    cFollyFuture[double] two(cRpcOptions, 
      double arg_input,)
    cFollyFuture[cFollyUnit] expected_exception(cRpcOptions, )
    cFollyFuture[cint32_t] unexpected_exception(cRpcOptions, )
    cFollyFuture[cint32_t] sum_i16_list(cRpcOptions, 
      vector[cint16_t] arg_numbers,)
    cFollyFuture[cint32_t] sum_i32_list(cRpcOptions, 
      vector[cint32_t] arg_numbers,)
    cFollyFuture[cint32_t] sum_i64_list(cRpcOptions, 
      vector[cint64_t] arg_numbers,)
    cFollyFuture[string] concat_many(cRpcOptions, 
      vector[string] arg_words,)
    cFollyFuture[cint32_t] count_structs(cRpcOptions, 
      vector[_module_types.cSimpleStruct] arg_items,)
    cFollyFuture[cint32_t] sum_set(cRpcOptions, 
      cset[cint32_t] arg_numbers,)
    cFollyFuture[cbool] contains_word(cRpcOptions, 
      cset[string] arg_words,
      string arg_word,)
    cFollyFuture[string] get_map_value(cRpcOptions, 
      cmap[string,string] arg_words,
      string arg_key,)
    cFollyFuture[cint16_t] map_length(cRpcOptions, 
      cmap[string,_module_types.cSimpleStruct] arg_items,)
    cFollyFuture[cint16_t] sum_map_values(cRpcOptions, 
      cmap[string,cint16_t] arg_items,)
    cFollyFuture[cint32_t] complex_sum_i32(cRpcOptions, 
      _module_types.cComplexStruct arg_counter,)
    cFollyFuture[string] repeat_name(cRpcOptions, 
      _module_types.cComplexStruct arg_counter,)
    cFollyFuture[_module_types.cSimpleStruct] get_struct(cRpcOptions, )
    cFollyFuture[vector[cint32_t]] fib(cRpcOptions, 
      cint16_t arg_n,)
    cFollyFuture[cset[string]] unique_words(cRpcOptions, 
      vector[string] arg_words,)
    cFollyFuture[cmap[string,cint16_t]] words_count(cRpcOptions, 
      vector[string] arg_words,)
    cFollyFuture[_module_types.cAnEnum] set_enum(cRpcOptions, 
      _module_types.cAnEnum arg_in_enum,)
    cFollyFuture[vector[vector[cint32_t]]] list_of_lists(cRpcOptions, 
      cint16_t arg_num_lists,
      cint16_t arg_num_items,)
    cFollyFuture[cmap[string,cmap[string,cint32_t]]] word_character_frequency(cRpcOptions, 
      string arg_sentence,)
    cFollyFuture[vector[cset[string]]] list_of_sets(cRpcOptions, 
      string arg_some_words,)
    cFollyFuture[cint32_t] nested_map_argument(cRpcOptions, 
      cmap[string,vector[_module_types.cSimpleStruct]] arg_struct_map,)
    cFollyFuture[string] make_sentence(cRpcOptions, 
      vector[vector[string]] arg_word_chars,)
    cFollyFuture[cset[cint32_t]] get_union(cRpcOptions, 
      vector[cset[cint32_t]] arg_sets,)
    cFollyFuture[cset[string]] get_keys(cRpcOptions, 
      vector[cmap[string,string]] arg_string_map,)
    cFollyFuture[double] lookup_double(cRpcOptions, 
      cint32_t arg_key,)
    cFollyFuture[string] retrieve_binary(cRpcOptions, 
      string arg_something,)
    cFollyFuture[cset[string]] contain_binary(cRpcOptions, 
      vector[string] arg_binaries,)
    cFollyFuture[vector[_module_types.cAnEnum]] contain_enum(cRpcOptions, 
      vector[_module_types.cAnEnum] arg_the_enum,)
    cFollyFuture[_module_types.cBinaryUnionStruct] get_binary_union_struct(cRpcOptions, 
      _module_types.cBinaryUnion arg_u,)


  cdef cppclass cDerivedServiceClientWrapper "::py3::simple::DerivedServiceClientWrapper"(cSimpleServiceClientWrapper):

    cFollyFuture[cint32_t] get_six(cRpcOptions, )


  cdef cppclass cRederivedServiceClientWrapper "::py3::simple::RederivedServiceClientWrapper"(cDerivedServiceClientWrapper):

    cFollyFuture[cint32_t] get_seven(cRpcOptions, )

