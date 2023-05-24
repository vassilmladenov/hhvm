#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#  @generated
#

from libc.stdint cimport (
    int8_t as cint8_t,
    int16_t as cint16_t,
    int32_t as cint32_t,
    int64_t as cint64_t,
    uint32_t as cuint32_t,
)
from libcpp.string cimport string
from libcpp cimport bool as cbool, nullptr, nullptr_t
from cpython cimport bool as pbool
from libcpp.memory cimport shared_ptr, unique_ptr
from libcpp.utility cimport move as cmove
from libcpp.vector cimport vector
from libcpp.set cimport set as cset
from libcpp.map cimport map as cmap, pair as cpair
from thrift.py3.exceptions cimport cTException
cimport folly.iobuf as _fbthrift_iobuf
cimport thrift.py3.exceptions
cimport thrift.py3.types
from thrift.py3.types cimport (
    bstring,
    bytes_to_string,
    field_ref as __field_ref,
    optional_field_ref as __optional_field_ref,
    required_field_ref as __required_field_ref,
    terse_field_ref as __terse_field_ref,
    union_field_ref as __union_field_ref,
    get_union_field_value as __get_union_field_value,
)
from thrift.py3.common cimport (
    RpcOptions as __RpcOptions,
    Protocol as __Protocol,
    cThriftMetadata as __fbthrift_cThriftMetadata,
    MetadataBox as __MetadataBox,
)
from folly.optional cimport cOptional as __cOptional

cimport module.types_fields as _fbthrift_types_fields

cdef extern from "thrift/compiler/test/fixtures/exceptions/src/gen-py3/module/types.h":
  pass





cdef extern from "thrift/compiler/test/fixtures/exceptions/src/gen-cpp2/module_metadata.h" namespace "apache::thrift::detail::md":
    cdef cppclass ExceptionMetadata[T]:
        @staticmethod
        void gen(__fbthrift_cThriftMetadata &metadata)
cdef extern from "thrift/compiler/test/fixtures/exceptions/src/gen-cpp2/module_metadata.h" namespace "apache::thrift::detail::md":
    cdef cppclass StructMetadata[T]:
        @staticmethod
        void gen(__fbthrift_cThriftMetadata &metadata)
cdef extern from "thrift/compiler/test/fixtures/exceptions/src/gen-cpp2/module_types_custom_protocol.h" namespace "::cpp2":

    cdef cppclass cFiery "::cpp2::Fiery"(cTException):
        cFiery() except +
        cFiery(const cFiery&) except +
        bint operator==(cFiery&)
        bint operator!=(cFiery&)
        bint operator<(cFiery&)
        bint operator>(cFiery&)
        bint operator<=(cFiery&)
        bint operator>=(cFiery&)
        __required_field_ref[string] message_ref "message_ref" ()


    cdef cppclass cSerious "::cpp2::Serious"(cTException):
        cSerious() except +
        cSerious(const cSerious&) except +
        bint operator==(cSerious&)
        bint operator!=(cSerious&)
        bint operator<(cSerious&)
        bint operator>(cSerious&)
        bint operator<=(cSerious&)
        bint operator>=(cSerious&)
        __optional_field_ref[string] sonnet_ref "sonnet_ref" ()


    cdef cppclass cComplexFieldNames "::cpp2::ComplexFieldNames"(cTException):
        cComplexFieldNames() except +
        cComplexFieldNames(const cComplexFieldNames&) except +
        bint operator==(cComplexFieldNames&)
        bint operator!=(cComplexFieldNames&)
        bint operator<(cComplexFieldNames&)
        bint operator>(cComplexFieldNames&)
        bint operator<=(cComplexFieldNames&)
        bint operator>=(cComplexFieldNames&)
        __field_ref[string] error_message_ref "error_message_ref" ()
        __field_ref[string] internal_error_message_ref "internal_error_message_ref" ()


    cdef cppclass cCustomFieldNames "::cpp2::CustomFieldNames"(cTException):
        cCustomFieldNames() except +
        cCustomFieldNames(const cCustomFieldNames&) except +
        bint operator==(cCustomFieldNames&)
        bint operator!=(cCustomFieldNames&)
        bint operator<(cCustomFieldNames&)
        bint operator>(cCustomFieldNames&)
        bint operator<=(cCustomFieldNames&)
        bint operator>=(cCustomFieldNames&)
        __field_ref[string] error_message_ref "error_message_ref" ()
        __field_ref[string] internal_error_message_ref "internal_error_message_ref" ()


    cdef cppclass cExceptionWithPrimitiveField "::cpp2::ExceptionWithPrimitiveField"(cTException):
        cExceptionWithPrimitiveField() except +
        cExceptionWithPrimitiveField(const cExceptionWithPrimitiveField&) except +
        bint operator==(cExceptionWithPrimitiveField&)
        bint operator!=(cExceptionWithPrimitiveField&)
        bint operator<(cExceptionWithPrimitiveField&)
        bint operator>(cExceptionWithPrimitiveField&)
        bint operator<=(cExceptionWithPrimitiveField&)
        bint operator>=(cExceptionWithPrimitiveField&)
        __field_ref[string] message_ref "message_ref" ()
        __field_ref[cint32_t] error_code_ref "error_code_ref" ()


    cdef cppclass cExceptionWithStructuredAnnotation "::cpp2::ExceptionWithStructuredAnnotation"(cTException):
        cExceptionWithStructuredAnnotation() except +
        cExceptionWithStructuredAnnotation(const cExceptionWithStructuredAnnotation&) except +
        bint operator==(cExceptionWithStructuredAnnotation&)
        bint operator!=(cExceptionWithStructuredAnnotation&)
        bint operator<(cExceptionWithStructuredAnnotation&)
        bint operator>(cExceptionWithStructuredAnnotation&)
        bint operator<=(cExceptionWithStructuredAnnotation&)
        bint operator>=(cExceptionWithStructuredAnnotation&)
        __field_ref[string] message_field_ref "message_field_ref" ()
        __field_ref[cint32_t] error_code_ref "error_code_ref" ()


    cdef cppclass cBanal "::cpp2::Banal"(cTException):
        cBanal() except +
        cBanal(const cBanal&) except +
        bint operator==(cBanal&)
        bint operator!=(cBanal&)
        bint operator<(cBanal&)
        bint operator>(cBanal&)
        bint operator<=(cBanal&)
        bint operator>=(cBanal&)




cdef class Fiery(thrift.py3.exceptions.GeneratedError):
    cdef shared_ptr[cFiery] _cpp_obj
    cdef _fbthrift_types_fields.__Fiery_FieldsSetter _fields_setter
    cdef inline object message_impl(self)

    @staticmethod
    cdef _fbthrift_create(shared_ptr[cFiery])



cdef class Serious(thrift.py3.exceptions.GeneratedError):
    cdef shared_ptr[cSerious] _cpp_obj
    cdef _fbthrift_types_fields.__Serious_FieldsSetter _fields_setter
    cdef inline object sonnet_impl(self)

    @staticmethod
    cdef _fbthrift_create(shared_ptr[cSerious])



cdef class ComplexFieldNames(thrift.py3.exceptions.GeneratedError):
    cdef shared_ptr[cComplexFieldNames] _cpp_obj
    cdef _fbthrift_types_fields.__ComplexFieldNames_FieldsSetter _fields_setter
    cdef inline object error_message_impl(self)
    cdef inline object internal_error_message_impl(self)

    @staticmethod
    cdef _fbthrift_create(shared_ptr[cComplexFieldNames])



cdef class CustomFieldNames(thrift.py3.exceptions.GeneratedError):
    cdef shared_ptr[cCustomFieldNames] _cpp_obj
    cdef _fbthrift_types_fields.__CustomFieldNames_FieldsSetter _fields_setter
    cdef inline object error_message_impl(self)
    cdef inline object internal_error_message_impl(self)

    @staticmethod
    cdef _fbthrift_create(shared_ptr[cCustomFieldNames])



cdef class ExceptionWithPrimitiveField(thrift.py3.exceptions.GeneratedError):
    cdef shared_ptr[cExceptionWithPrimitiveField] _cpp_obj
    cdef _fbthrift_types_fields.__ExceptionWithPrimitiveField_FieldsSetter _fields_setter
    cdef inline object message_impl(self)
    cdef inline object error_code_impl(self)

    @staticmethod
    cdef _fbthrift_create(shared_ptr[cExceptionWithPrimitiveField])



cdef class ExceptionWithStructuredAnnotation(thrift.py3.exceptions.GeneratedError):
    cdef shared_ptr[cExceptionWithStructuredAnnotation] _cpp_obj
    cdef _fbthrift_types_fields.__ExceptionWithStructuredAnnotation_FieldsSetter _fields_setter
    cdef inline object message_field_impl(self)
    cdef inline object error_code_impl(self)

    @staticmethod
    cdef _fbthrift_create(shared_ptr[cExceptionWithStructuredAnnotation])



cdef class Banal(thrift.py3.exceptions.GeneratedError):
    cdef shared_ptr[cBanal] _cpp_obj
    cdef _fbthrift_types_fields.__Banal_FieldsSetter _fields_setter

    @staticmethod
    cdef _fbthrift_create(shared_ptr[cBanal])



