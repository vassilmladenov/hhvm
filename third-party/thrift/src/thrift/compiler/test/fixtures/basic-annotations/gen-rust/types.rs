// @generated by Thrift for src/module.thrift
// This file is probably not the place you want to edit!

//! Thrift type definitions for `module`.

#![allow(clippy::redundant_closure)]


pub type MyId = ::std::primitive::i16;

#[derive(Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct MyStructNestedAnnotation {
    pub name: ::std::string::String,
    // This field forces `..Default::default()` when instantiating this
    // struct, to make code future-proof against new fields added later to
    // the definition in Thrift. If you don't want this, add the annotation
    // `(rust.exhaustive)` to the Thrift struct to eliminate this field.
    #[doc(hidden)]
    pub _dot_dot_Default_default: self::dot_dot::OtherFields,
}

#[derive(Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Debug)]
pub enum MyUnion {
    UnknownField(::std::primitive::i32),
}

#[derive(Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct MyException {
    // This field forces `..Default::default()` when instantiating this
    // struct, to make code future-proof against new fields added later to
    // the definition in Thrift. If you don't want this, add the annotation
    // `(rust.exhaustive)` to the Thrift struct to eliminate this field.
    #[doc(hidden)]
    pub _dot_dot_Default_default: self::dot_dot::OtherFields,
}

impl ::fbthrift::ExceptionInfo for MyException {
    fn exn_value(&self) -> String {
        format!("{:?}", self)
    }

    #[inline]
    fn exn_is_declared(&self) -> bool { true }
}

impl ::std::error::Error for MyException {}

impl ::std::fmt::Display for MyException {
    fn fmt(&self, f: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        write!(f, "{:?}", self)
    }
}

#[derive(Clone, PartialEq)]
pub struct MyStruct {
    pub major: ::std::primitive::i64,
    pub package: ::std::string::String,
    pub annotation_with_quote: ::std::string::String,
    pub class_: ::std::string::String,
    pub annotation_with_trailing_comma: ::std::string::String,
    pub empty_annotations: ::std::string::String,
    pub my_enum: crate::types::MyEnum,
    pub cpp_type_annotation: ::std::vec::Vec<::std::string::String>,
    pub my_union: crate::types::MyUnion,
    pub my_id: crate::types::MyId,
    // This field forces `..Default::default()` when instantiating this
    // struct, to make code future-proof against new fields added later to
    // the definition in Thrift. If you don't want this, add the annotation
    // `(rust.exhaustive)` to the Thrift struct to eliminate this field.
    #[doc(hidden)]
    pub _dot_dot_Default_default: self::dot_dot::OtherFields,
}

#[derive(Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct SecretStruct {
    pub id: ::std::primitive::i64,
    pub password: ::std::string::String,
    // This field forces `..Default::default()` when instantiating this
    // struct, to make code future-proof against new fields added later to
    // the definition in Thrift. If you don't want this, add the annotation
    // `(rust.exhaustive)` to the Thrift struct to eliminate this field.
    #[doc(hidden)]
    pub _dot_dot_Default_default: self::dot_dot::OtherFields,
}

#[derive(Copy, Clone, Eq, PartialEq, Ord, PartialOrd, Hash)]
pub struct MyEnum(pub ::std::primitive::i32);

impl MyEnum {
    pub const MyValue1: Self = MyEnum(0i32);
    pub const MyValue2: Self = MyEnum(1i32);
    pub const DOMAIN: Self = MyEnum(2i32);
}

impl ::fbthrift::ThriftEnum for MyEnum {
    fn enumerate() -> &'static [(Self, &'static str)] {
        &[
            (Self::MyValue1, "MyValue1"),
            (Self::MyValue2, "MyValue2"),
            (Self::DOMAIN, "DOMAIN"),
        ]
    }

    fn variants() -> &'static [&'static str] {
        &[
            "MyValue1",
            "MyValue2",
            "DOMAIN",
        ]
    }

    fn variant_values() -> &'static [Self] {
        &[
            Self::MyValue1,
            Self::MyValue2,
            Self::DOMAIN,
        ]
    }
}

impl ::std::default::Default for MyEnum {
    fn default() -> Self {
        Self(::fbthrift::__UNKNOWN_ID)
    }
}

impl<'a> ::std::convert::From<&'a MyEnum> for ::std::primitive::i32 {
    #[inline]
    fn from(x: &'a MyEnum) -> Self {
        x.0
    }
}

impl ::std::convert::From<MyEnum> for ::std::primitive::i32 {
    #[inline]
    fn from(x: MyEnum) -> Self {
        x.0
    }
}

impl ::std::convert::From<::std::primitive::i32> for MyEnum {
    #[inline]
    fn from(x: ::std::primitive::i32) -> Self {
        Self(x)
    }
}

impl ::std::fmt::Display for MyEnum {
    fn fmt(&self, fmt: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        static VARIANTS_BY_NUMBER: &[(&::std::primitive::str, ::std::primitive::i32)] = &[
            ("MyValue1", 0),
            ("MyValue2", 1),
            ("DOMAIN", 2),
        ];
        ::fbthrift::help::enum_display(VARIANTS_BY_NUMBER, fmt, self.0)
    }
}

impl ::std::fmt::Debug for MyEnum {
    fn fmt(&self, fmt: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        write!(fmt, "MyEnum::{}", self)
    }
}

impl ::std::str::FromStr for MyEnum {
    type Err = ::anyhow::Error;

    fn from_str(string: &::std::primitive::str) -> ::std::result::Result<Self, Self::Err> {
        static VARIANTS_BY_NAME: &[(&::std::primitive::str, ::std::primitive::i32)] = &[
            ("DOMAIN", 2),
            ("MyValue1", 0),
            ("MyValue2", 1),
        ];
        ::fbthrift::help::enum_from_str(VARIANTS_BY_NAME, string, "MyEnum").map(Self)
    }
}

impl ::fbthrift::GetTType for MyEnum {
    const TTYPE: ::fbthrift::TType = ::fbthrift::TType::I32;
}

impl<P> ::fbthrift::Serialize<P> for MyEnum
where
    P: ::fbthrift::ProtocolWriter,
{
    #[inline]
    fn write(&self, p: &mut P) {
        p.write_i32(self.into())
    }
}

impl<P> ::fbthrift::Deserialize<P> for MyEnum
where
    P: ::fbthrift::ProtocolReader,
{
    #[inline]
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        ::std::result::Result::Ok(Self::from(p.read_i32()?))
    }
}


#[allow(clippy::derivable_impls)]
impl ::std::default::Default for self::MyStructNestedAnnotation {
    fn default() -> Self {
        Self {
            name: ::std::default::Default::default(),
            _dot_dot_Default_default: self::dot_dot::OtherFields(()),
        }
    }
}

impl ::std::fmt::Debug for self::MyStructNestedAnnotation {
    fn fmt(&self, formatter: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        formatter
            .debug_struct("MyStructNestedAnnotation")
            .field("name", &self.name)
            .finish()
    }
}

unsafe impl ::std::marker::Send for self::MyStructNestedAnnotation {}
unsafe impl ::std::marker::Sync for self::MyStructNestedAnnotation {}

impl ::fbthrift::GetTType for self::MyStructNestedAnnotation {
    const TTYPE: ::fbthrift::TType = ::fbthrift::TType::Struct;
}

impl<P> ::fbthrift::Serialize<P> for self::MyStructNestedAnnotation
where
    P: ::fbthrift::ProtocolWriter,
{
    fn write(&self, p: &mut P) {
        p.write_struct_begin("MyStructNestedAnnotation");
        p.write_field_begin("name", ::fbthrift::TType::String, 1);
        ::fbthrift::Serialize::write(&self.name, p);
        p.write_field_end();
        p.write_field_stop();
        p.write_struct_end();
    }
}

impl<P> ::fbthrift::Deserialize<P> for self::MyStructNestedAnnotation
where
    P: ::fbthrift::ProtocolReader,
{
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        static FIELDS: &[::fbthrift::Field] = &[
            ::fbthrift::Field::new("name", ::fbthrift::TType::String, 1),
        ];
        let mut field_name = ::std::option::Option::None;
        let _ = p.read_struct_begin(|_| ())?;
        loop {
            let (_, fty, fid) = p.read_field_begin(|_| (), FIELDS)?;
            match (fty, fid as ::std::primitive::i32) {
                (::fbthrift::TType::Stop, _) => break,
                (::fbthrift::TType::String, 1) => field_name = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (fty, _) => p.skip(fty)?,
            }
            p.read_field_end()?;
        }
        p.read_struct_end()?;
        ::std::result::Result::Ok(Self {
            name: field_name.unwrap_or_default(),
            _dot_dot_Default_default: self::dot_dot::OtherFields(()),
        })
    }
}



impl ::std::default::Default for MyUnion {
    fn default() -> Self {
        Self::UnknownField(-1)
    }
}

impl ::fbthrift::GetTType for MyUnion {
    const TTYPE: ::fbthrift::TType = ::fbthrift::TType::Struct;
}

impl<P> ::fbthrift::Serialize<P> for MyUnion
where
    P: ::fbthrift::ProtocolWriter,
{
    fn write(&self, p: &mut P) {
        p.write_struct_begin("MyUnion");
        match self {
            Self::UnknownField(_) => {}
        }
        p.write_field_stop();
        p.write_struct_end();
    }
}

impl<P> ::fbthrift::Deserialize<P> for MyUnion
where
    P: ::fbthrift::ProtocolReader,
{
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        static FIELDS: &[::fbthrift::Field] = &[
        ];
        let _ = p.read_struct_begin(|_| ())?;
        let once = false;
        let alt = ::std::option::Option::None;
        loop {
            let (_, fty, fid) = p.read_field_begin(|_| (), FIELDS)?;
            match (fty, fid as ::std::primitive::i32, once) {
                (::fbthrift::TType::Stop, _, _) => break,
                (fty, _, false) => p.skip(fty)?,
                (badty, badid, true) => return ::std::result::Result::Err(::std::convert::From::from(::fbthrift::ApplicationException::new(
                    ::fbthrift::ApplicationExceptionErrorCode::ProtocolError,
                    format!(
                        "unwanted extra union {} field ty {:?} id {}",
                        "MyUnion",
                        badty,
                        badid,
                    ),
                ))),
            }
            p.read_field_end()?;
        }
        p.read_struct_end()?;
        ::std::result::Result::Ok(alt.unwrap_or_default())
    }
}

#[allow(clippy::derivable_impls)]
impl ::std::default::Default for self::MyException {
    fn default() -> Self {
        Self {
            _dot_dot_Default_default: self::dot_dot::OtherFields(()),
        }
    }
}

impl ::std::fmt::Debug for self::MyException {
    fn fmt(&self, formatter: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        formatter
            .debug_struct("MyException")
            .finish()
    }
}

unsafe impl ::std::marker::Send for self::MyException {}
unsafe impl ::std::marker::Sync for self::MyException {}

impl ::fbthrift::GetTType for self::MyException {
    const TTYPE: ::fbthrift::TType = ::fbthrift::TType::Struct;
}

impl<P> ::fbthrift::Serialize<P> for self::MyException
where
    P: ::fbthrift::ProtocolWriter,
{
    fn write(&self, p: &mut P) {
        p.write_struct_begin("MyException");
        p.write_field_stop();
        p.write_struct_end();
    }
}

impl<P> ::fbthrift::Deserialize<P> for self::MyException
where
    P: ::fbthrift::ProtocolReader,
{
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        static FIELDS: &[::fbthrift::Field] = &[
        ];
        let _ = p.read_struct_begin(|_| ())?;
        loop {
            let (_, fty, fid) = p.read_field_begin(|_| (), FIELDS)?;
            match (fty, fid as ::std::primitive::i32) {
                (::fbthrift::TType::Stop, _) => break,
                (fty, _) => p.skip(fty)?,
            }
            p.read_field_end()?;
        }
        p.read_struct_end()?;
        ::std::result::Result::Ok(Self {
            _dot_dot_Default_default: self::dot_dot::OtherFields(()),
        })
    }
}


#[allow(clippy::derivable_impls)]
impl ::std::default::Default for self::MyStruct {
    fn default() -> Self {
        Self {
            major: ::std::default::Default::default(),
            package: ::std::default::Default::default(),
            annotation_with_quote: ::std::default::Default::default(),
            class_: ::std::default::Default::default(),
            annotation_with_trailing_comma: ::std::default::Default::default(),
            empty_annotations: ::std::default::Default::default(),
            my_enum: ::std::default::Default::default(),
            cpp_type_annotation: ::std::default::Default::default(),
            my_union: ::std::default::Default::default(),
            my_id: ::std::default::Default::default(),
            _dot_dot_Default_default: self::dot_dot::OtherFields(()),
        }
    }
}

impl ::std::fmt::Debug for self::MyStruct {
    fn fmt(&self, formatter: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        formatter
            .debug_struct("MyStruct")
            .field("major", &self.major)
            .field("package", &self.package)
            .field("annotation_with_quote", &self.annotation_with_quote)
            .field("class_", &self.class_)
            .field("annotation_with_trailing_comma", &self.annotation_with_trailing_comma)
            .field("empty_annotations", &self.empty_annotations)
            .field("my_enum", &self.my_enum)
            .field("cpp_type_annotation", &self.cpp_type_annotation)
            .field("my_union", &self.my_union)
            .field("my_id", &self.my_id)
            .finish()
    }
}

unsafe impl ::std::marker::Send for self::MyStruct {}
unsafe impl ::std::marker::Sync for self::MyStruct {}

impl ::fbthrift::GetTType for self::MyStruct {
    const TTYPE: ::fbthrift::TType = ::fbthrift::TType::Struct;
}

impl ::fbthrift::GetUri for self::MyStruct {
    fn uri() -> &'static str {
        "facebook.com/thrift/compiler/test/fixtures/basic-annotations/src/module/MyStruct"
    }
}

impl<P> ::fbthrift::Serialize<P> for self::MyStruct
where
    P: ::fbthrift::ProtocolWriter,
{
    fn write(&self, p: &mut P) {
        p.write_struct_begin("MyStruct");
        p.write_field_begin("major", ::fbthrift::TType::I64, 2);
        ::fbthrift::Serialize::write(&self.major, p);
        p.write_field_end();
        p.write_field_begin("package", ::fbthrift::TType::String, 1);
        ::fbthrift::Serialize::write(&self.package, p);
        p.write_field_end();
        p.write_field_begin("annotation_with_quote", ::fbthrift::TType::String, 3);
        ::fbthrift::Serialize::write(&self.annotation_with_quote, p);
        p.write_field_end();
        p.write_field_begin("class_", ::fbthrift::TType::String, 4);
        ::fbthrift::Serialize::write(&self.class_, p);
        p.write_field_end();
        p.write_field_begin("annotation_with_trailing_comma", ::fbthrift::TType::String, 5);
        ::fbthrift::Serialize::write(&self.annotation_with_trailing_comma, p);
        p.write_field_end();
        p.write_field_begin("empty_annotations", ::fbthrift::TType::String, 6);
        ::fbthrift::Serialize::write(&self.empty_annotations, p);
        p.write_field_end();
        p.write_field_begin("my_enum", ::fbthrift::TType::I32, 7);
        ::fbthrift::Serialize::write(&self.my_enum, p);
        p.write_field_end();
        p.write_field_begin("cpp_type_annotation", ::fbthrift::TType::List, 8);
        ::fbthrift::Serialize::write(&self.cpp_type_annotation, p);
        p.write_field_end();
        p.write_field_begin("my_union", ::fbthrift::TType::Struct, 9);
        ::fbthrift::Serialize::write(&self.my_union, p);
        p.write_field_end();
        p.write_field_begin("my_id", ::fbthrift::TType::I16, 10);
        ::fbthrift::Serialize::write(&self.my_id, p);
        p.write_field_end();
        p.write_field_stop();
        p.write_struct_end();
    }
}

impl<P> ::fbthrift::Deserialize<P> for self::MyStruct
where
    P: ::fbthrift::ProtocolReader,
{
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        static FIELDS: &[::fbthrift::Field] = &[
            ::fbthrift::Field::new("annotation_with_quote", ::fbthrift::TType::String, 3),
            ::fbthrift::Field::new("annotation_with_trailing_comma", ::fbthrift::TType::String, 5),
            ::fbthrift::Field::new("class_", ::fbthrift::TType::String, 4),
            ::fbthrift::Field::new("cpp_type_annotation", ::fbthrift::TType::List, 8),
            ::fbthrift::Field::new("empty_annotations", ::fbthrift::TType::String, 6),
            ::fbthrift::Field::new("major", ::fbthrift::TType::I64, 2),
            ::fbthrift::Field::new("my_enum", ::fbthrift::TType::I32, 7),
            ::fbthrift::Field::new("my_id", ::fbthrift::TType::I16, 10),
            ::fbthrift::Field::new("my_union", ::fbthrift::TType::Struct, 9),
            ::fbthrift::Field::new("package", ::fbthrift::TType::String, 1),
        ];
        let mut field_major = ::std::option::Option::None;
        let mut field_package = ::std::option::Option::None;
        let mut field_annotation_with_quote = ::std::option::Option::None;
        let mut field_class_ = ::std::option::Option::None;
        let mut field_annotation_with_trailing_comma = ::std::option::Option::None;
        let mut field_empty_annotations = ::std::option::Option::None;
        let mut field_my_enum = ::std::option::Option::None;
        let mut field_cpp_type_annotation = ::std::option::Option::None;
        let mut field_my_union = ::std::option::Option::None;
        let mut field_my_id = ::std::option::Option::None;
        let _ = p.read_struct_begin(|_| ())?;
        loop {
            let (_, fty, fid) = p.read_field_begin(|_| (), FIELDS)?;
            match (fty, fid as ::std::primitive::i32) {
                (::fbthrift::TType::Stop, _) => break,
                (::fbthrift::TType::I64, 2) => field_major = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::String, 1) => field_package = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::String, 3) => field_annotation_with_quote = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::String, 4) => field_class_ = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::String, 5) => field_annotation_with_trailing_comma = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::String, 6) => field_empty_annotations = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::I32, 7) => field_my_enum = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::List, 8) => field_cpp_type_annotation = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::Struct, 9) => field_my_union = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::I16, 10) => field_my_id = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (fty, _) => p.skip(fty)?,
            }
            p.read_field_end()?;
        }
        p.read_struct_end()?;
        ::std::result::Result::Ok(Self {
            major: field_major.unwrap_or_default(),
            package: field_package.unwrap_or_default(),
            annotation_with_quote: field_annotation_with_quote.unwrap_or_default(),
            class_: field_class_.unwrap_or_default(),
            annotation_with_trailing_comma: field_annotation_with_trailing_comma.unwrap_or_default(),
            empty_annotations: field_empty_annotations.unwrap_or_default(),
            my_enum: field_my_enum.unwrap_or_default(),
            cpp_type_annotation: field_cpp_type_annotation.unwrap_or_default(),
            my_union: field_my_union.unwrap_or_default(),
            my_id: field_my_id.unwrap_or_default(),
            _dot_dot_Default_default: self::dot_dot::OtherFields(()),
        })
    }
}


#[allow(clippy::derivable_impls)]
impl ::std::default::Default for self::SecretStruct {
    fn default() -> Self {
        Self {
            id: ::std::default::Default::default(),
            password: ::std::default::Default::default(),
            _dot_dot_Default_default: self::dot_dot::OtherFields(()),
        }
    }
}

impl ::std::fmt::Debug for self::SecretStruct {
    fn fmt(&self, formatter: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        formatter
            .debug_struct("SecretStruct")
            .field("id", &self.id)
            .field("password", &self.password)
            .finish()
    }
}

unsafe impl ::std::marker::Send for self::SecretStruct {}
unsafe impl ::std::marker::Sync for self::SecretStruct {}

impl ::fbthrift::GetTType for self::SecretStruct {
    const TTYPE: ::fbthrift::TType = ::fbthrift::TType::Struct;
}

impl<P> ::fbthrift::Serialize<P> for self::SecretStruct
where
    P: ::fbthrift::ProtocolWriter,
{
    fn write(&self, p: &mut P) {
        p.write_struct_begin("SecretStruct");
        p.write_field_begin("id", ::fbthrift::TType::I64, 1);
        ::fbthrift::Serialize::write(&self.id, p);
        p.write_field_end();
        p.write_field_begin("password", ::fbthrift::TType::String, 2);
        ::fbthrift::Serialize::write(&self.password, p);
        p.write_field_end();
        p.write_field_stop();
        p.write_struct_end();
    }
}

impl<P> ::fbthrift::Deserialize<P> for self::SecretStruct
where
    P: ::fbthrift::ProtocolReader,
{
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        static FIELDS: &[::fbthrift::Field] = &[
            ::fbthrift::Field::new("id", ::fbthrift::TType::I64, 1),
            ::fbthrift::Field::new("password", ::fbthrift::TType::String, 2),
        ];
        let mut field_id = ::std::option::Option::None;
        let mut field_password = ::std::option::Option::None;
        let _ = p.read_struct_begin(|_| ())?;
        loop {
            let (_, fty, fid) = p.read_field_begin(|_| (), FIELDS)?;
            match (fty, fid as ::std::primitive::i32) {
                (::fbthrift::TType::Stop, _) => break,
                (::fbthrift::TType::I64, 1) => field_id = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::String, 2) => field_password = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (fty, _) => p.skip(fty)?,
            }
            p.read_field_end()?;
        }
        p.read_struct_end()?;
        ::std::result::Result::Ok(Self {
            id: field_id.unwrap_or_default(),
            password: field_password.unwrap_or_default(),
            _dot_dot_Default_default: self::dot_dot::OtherFields(()),
        })
    }
}


mod dot_dot {
    #[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
    pub struct OtherFields(pub(crate) ());

    #[allow(dead_code)] // if serde isn't being used
    pub(super) fn default_for_serde_deserialize() -> OtherFields {
        OtherFields(())
    }
}
