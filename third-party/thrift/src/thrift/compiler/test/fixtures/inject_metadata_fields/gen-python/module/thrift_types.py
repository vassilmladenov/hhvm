#
# Autogenerated by Thrift
#
# DO NOT EDIT
#  @generated
#

from __future__ import annotations

import folly.iobuf as _fbthrift_iobuf
import thrift.python.types as _fbthrift_python_types
import thrift.python.exceptions as _fbthrift_python_exceptions


import foo.thrift_types


class Fields(metaclass=_fbthrift_python_types.StructMeta):
    _fbthrift_SPEC = (
        (
            100,  # id
            _fbthrift_python_types.FieldQualifier.Unqualified, # qualifier
            "injected_field",  # name
            _fbthrift_python_types.typeinfo_string,  # typeinfo
            None,  # default value
            None,  # adapter info
        ),
    )

    @staticmethod
    def __get_thrift_name__() -> str:
        return "module.Fields"

    @staticmethod
    def __get_thrift_uri__():
        return None

    @staticmethod
    def __get_metadata__():
        return _fbthrift_metadata__struct_Fields()

    def _to_python(self):
        return self

    def _to_py3(self):
        import importlib
        py3_types = importlib.import_module("module.types")
        import thrift.py3.converter
        return thrift.py3.converter.to_py3_struct(py3_types.Fields, self)

    def _to_py_deprecated(self):
        import importlib
        py_deprecated_types = importlib.import_module("module.ttypes")
        import thrift.util.converter
        return thrift.util.converter.to_py_struct(py_deprecated_types.Fields, self)


class FieldsInjectedToEmptyStruct(metaclass=_fbthrift_python_types.StructMeta):
    _fbthrift_SPEC = (
        (
            -1100,  # id
            _fbthrift_python_types.FieldQualifier.Unqualified, # qualifier
            "injected_field",  # name
            _fbthrift_python_types.typeinfo_string,  # typeinfo
            None,  # default value
            None,  # adapter info
        ),
    )

    @staticmethod
    def __get_thrift_name__() -> str:
        return "module.FieldsInjectedToEmptyStruct"

    @staticmethod
    def __get_thrift_uri__():
        return None

    @staticmethod
    def __get_metadata__():
        return _fbthrift_metadata__struct_FieldsInjectedToEmptyStruct()

    def _to_python(self):
        return self

    def _to_py3(self):
        import importlib
        py3_types = importlib.import_module("module.types")
        import thrift.py3.converter
        return thrift.py3.converter.to_py3_struct(py3_types.FieldsInjectedToEmptyStruct, self)

    def _to_py_deprecated(self):
        import importlib
        py_deprecated_types = importlib.import_module("module.ttypes")
        import thrift.util.converter
        return thrift.util.converter.to_py_struct(py_deprecated_types.FieldsInjectedToEmptyStruct, self)


class FieldsInjectedToStruct(metaclass=_fbthrift_python_types.StructMeta):
    _fbthrift_SPEC = (
        (
            -1100,  # id
            _fbthrift_python_types.FieldQualifier.Unqualified, # qualifier
            "injected_field",  # name
            _fbthrift_python_types.typeinfo_string,  # typeinfo
            None,  # default value
            None,  # adapter info
        ),
        (
            1,  # id
            _fbthrift_python_types.FieldQualifier.Unqualified, # qualifier
            "string_field",  # name
            _fbthrift_python_types.typeinfo_string,  # typeinfo
            None,  # default value
            None,  # adapter info
        ),
    )

    @staticmethod
    def __get_thrift_name__() -> str:
        return "module.FieldsInjectedToStruct"

    @staticmethod
    def __get_thrift_uri__():
        return None

    @staticmethod
    def __get_metadata__():
        return _fbthrift_metadata__struct_FieldsInjectedToStruct()

    def _to_python(self):
        return self

    def _to_py3(self):
        import importlib
        py3_types = importlib.import_module("module.types")
        import thrift.py3.converter
        return thrift.py3.converter.to_py3_struct(py3_types.FieldsInjectedToStruct, self)

    def _to_py_deprecated(self):
        import importlib
        py_deprecated_types = importlib.import_module("module.ttypes")
        import thrift.util.converter
        return thrift.util.converter.to_py_struct(py_deprecated_types.FieldsInjectedToStruct, self)


class FieldsInjectedWithIncludedStruct(metaclass=_fbthrift_python_types.StructMeta):
    _fbthrift_SPEC = (
        (
            -1102,  # id
            _fbthrift_python_types.FieldQualifier.Optional, # qualifier
            "injected_unstructured_annotation_field",  # name
            _fbthrift_python_types.typeinfo_string,  # typeinfo
            None,  # default value
            None,  # adapter info
        ),
        (
            -1101,  # id
            _fbthrift_python_types.FieldQualifier.Optional, # qualifier
            "injected_structured_annotation_field",  # name
            _fbthrift_python_types.typeinfo_string,  # typeinfo
            None,  # default value
            None,  # adapter info
        ),
        (
            -1100,  # id
            _fbthrift_python_types.FieldQualifier.Unqualified, # qualifier
            "injected_field",  # name
            _fbthrift_python_types.typeinfo_string,  # typeinfo
            None,  # default value
            None,  # adapter info
        ),
        (
            1,  # id
            _fbthrift_python_types.FieldQualifier.Unqualified, # qualifier
            "string_field",  # name
            _fbthrift_python_types.typeinfo_string,  # typeinfo
            None,  # default value
            None,  # adapter info
        ),
    )

    @staticmethod
    def __get_thrift_name__() -> str:
        return "module.FieldsInjectedWithIncludedStruct"

    @staticmethod
    def __get_thrift_uri__():
        return None

    @staticmethod
    def __get_metadata__():
        return _fbthrift_metadata__struct_FieldsInjectedWithIncludedStruct()

    def _to_python(self):
        return self

    def _to_py3(self):
        import importlib
        py3_types = importlib.import_module("module.types")
        import thrift.py3.converter
        return thrift.py3.converter.to_py3_struct(py3_types.FieldsInjectedWithIncludedStruct, self)

    def _to_py_deprecated(self):
        import importlib
        py_deprecated_types = importlib.import_module("module.ttypes")
        import thrift.util.converter
        return thrift.util.converter.to_py_struct(py_deprecated_types.FieldsInjectedWithIncludedStruct, self)

# This unfortunately has to be down here to prevent circular imports
import module.thrift_metadata


_fbthrift_all_enums = [
]

def _fbthrift_metadata__struct_Fields():
    return module.thrift_metadata.gen_metadata_struct_Fields()
def _fbthrift_metadata__struct_FieldsInjectedToEmptyStruct():
    return module.thrift_metadata.gen_metadata_struct_FieldsInjectedToEmptyStruct()
def _fbthrift_metadata__struct_FieldsInjectedToStruct():
    return module.thrift_metadata.gen_metadata_struct_FieldsInjectedToStruct()
def _fbthrift_metadata__struct_FieldsInjectedWithIncludedStruct():
    return module.thrift_metadata.gen_metadata_struct_FieldsInjectedWithIncludedStruct()

_fbthrift_all_structs = [
    Fields,
    FieldsInjectedToEmptyStruct,
    FieldsInjectedToStruct,
    FieldsInjectedWithIncludedStruct,
]
_fbthrift_python_types.fill_specs(*_fbthrift_all_structs)
