#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#  @generated
#

import typing as _typing

import folly.iobuf as _fbthrift_iobuf
import thrift.py3.builder


import module.types as _module_types


class MyStructNestedAnnotation_Builder(thrift.py3.builder.StructBuilder):
    name: _typing.Optional[str]

    def __iter__(self) -> _typing.Iterator[_typing.Tuple[str, _typing.Any]]: ...


class SecretStruct_Builder(thrift.py3.builder.StructBuilder):
    id: _typing.Optional[int]
    password: _typing.Optional[str]

    def __iter__(self) -> _typing.Iterator[_typing.Tuple[str, _typing.Any]]: ...


