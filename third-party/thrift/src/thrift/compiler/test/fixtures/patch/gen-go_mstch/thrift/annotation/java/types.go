// @generated by Thrift for [[[ program path ]]]
// This file is probably not the place you want to edit!

package java // [[[ program thrift source path ]]]

import (
    "fmt"
    "strings"

    thrift "github.com/facebook/fbthrift/thrift/lib/go/thrift"
)


// (needed to ensure safety because of naive import list construction)
var _ = fmt.Printf
var _ = thrift.ZERO
var _ = strings.Split


type Mutable struct {
}
// Compile time interface enforcer
var _ thrift.Struct = &Mutable{}

func NewMutable() *Mutable {
    return (&Mutable{})
}


// Deprecated: Use Mutable.Set* methods instead or set the fields directly.
type MutableBuilder struct {
    obj *Mutable
}

func NewMutableBuilder() *MutableBuilder {
    return &MutableBuilder{
        obj: NewMutable(),
    }
}

func (x *MutableBuilder) Emit() *Mutable {
    var objCopy Mutable = *x.obj
    return &objCopy
}

func (x *Mutable) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("Mutable"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := p.WriteFieldStop(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field stop error: ", x), err)
    }

    if err := p.WriteStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct end error: ", x), err)
    }
    return nil
}

func (x *Mutable) Read(p thrift.Protocol) error {
    if _, err := p.ReadStructBegin(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read error: ", x), err)
    }

    for {
        _, typ, id, err := p.ReadFieldBegin()
        if err != nil {
            return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", x, id), err)
        }

        if typ == thrift.STOP {
            break;
        }

        switch id {
        default:
            if err := p.Skip(typ); err != nil {
                return err
            }
        }

        if err := p.ReadFieldEnd(); err != nil {
            return err
        }
    }

    if err := p.ReadStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read struct end error: ", x), err)
    }

    return nil
}

func (x *Mutable) String() string {
    if x == nil {
        return "<nil>"
    }

    var sb strings.Builder

    sb.WriteString("Mutable({")
    sb.WriteString("})")

    return sb.String()
}

type Annotation struct {
    JavaAnnotation string `thrift:"java_annotation,1" json:"java_annotation" db:"java_annotation"`
}
// Compile time interface enforcer
var _ thrift.Struct = &Annotation{}

func NewAnnotation() *Annotation {
    return (&Annotation{}).
        SetJavaAnnotationNonCompat("")
}

func (x *Annotation) GetJavaAnnotationNonCompat() string {
    return x.JavaAnnotation
}

func (x *Annotation) GetJavaAnnotation() string {
    return x.JavaAnnotation
}

func (x *Annotation) SetJavaAnnotationNonCompat(value string) *Annotation {
    x.JavaAnnotation = value
    return x
}

func (x *Annotation) SetJavaAnnotation(value string) *Annotation {
    x.JavaAnnotation = value
    return x
}

func (x *Annotation) writeField1(p thrift.Protocol) error {  // JavaAnnotation
    if err := p.WriteFieldBegin("java_annotation", thrift.STRING, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetJavaAnnotationNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Annotation) readField1(p thrift.Protocol) error {  // JavaAnnotation
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetJavaAnnotationNonCompat(result)
    return nil
}

func (x *Annotation) toString1() string {  // JavaAnnotation
    return fmt.Sprintf("%v", x.GetJavaAnnotationNonCompat())
}


// Deprecated: Use Annotation.Set* methods instead or set the fields directly.
type AnnotationBuilder struct {
    obj *Annotation
}

func NewAnnotationBuilder() *AnnotationBuilder {
    return &AnnotationBuilder{
        obj: NewAnnotation(),
    }
}

func (x *AnnotationBuilder) JavaAnnotation(value string) *AnnotationBuilder {
    x.obj.JavaAnnotation = value
    return x
}

func (x *AnnotationBuilder) Emit() *Annotation {
    var objCopy Annotation = *x.obj
    return &objCopy
}

func (x *Annotation) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("Annotation"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := x.writeField1(p); err != nil {
        return err
    }

    if err := p.WriteFieldStop(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field stop error: ", x), err)
    }

    if err := p.WriteStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct end error: ", x), err)
    }
    return nil
}

func (x *Annotation) Read(p thrift.Protocol) error {
    if _, err := p.ReadStructBegin(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read error: ", x), err)
    }

    for {
        _, typ, id, err := p.ReadFieldBegin()
        if err != nil {
            return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", x, id), err)
        }

        if typ == thrift.STOP {
            break;
        }

        switch id {
        case 1:  // java_annotation
            if err := x.readField1(p); err != nil {
                return err
            }
        default:
            if err := p.Skip(typ); err != nil {
                return err
            }
        }

        if err := p.ReadFieldEnd(); err != nil {
            return err
        }
    }

    if err := p.ReadStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read struct end error: ", x), err)
    }

    return nil
}

func (x *Annotation) String() string {
    if x == nil {
        return "<nil>"
    }

    var sb strings.Builder

    sb.WriteString("Annotation({")
    sb.WriteString(fmt.Sprintf("JavaAnnotation:%s", x.toString1()))
    sb.WriteString("})")

    return sb.String()
}

type BinaryString struct {
}
// Compile time interface enforcer
var _ thrift.Struct = &BinaryString{}

func NewBinaryString() *BinaryString {
    return (&BinaryString{})
}


// Deprecated: Use BinaryString.Set* methods instead or set the fields directly.
type BinaryStringBuilder struct {
    obj *BinaryString
}

func NewBinaryStringBuilder() *BinaryStringBuilder {
    return &BinaryStringBuilder{
        obj: NewBinaryString(),
    }
}

func (x *BinaryStringBuilder) Emit() *BinaryString {
    var objCopy BinaryString = *x.obj
    return &objCopy
}

func (x *BinaryString) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("BinaryString"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := p.WriteFieldStop(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field stop error: ", x), err)
    }

    if err := p.WriteStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct end error: ", x), err)
    }
    return nil
}

func (x *BinaryString) Read(p thrift.Protocol) error {
    if _, err := p.ReadStructBegin(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read error: ", x), err)
    }

    for {
        _, typ, id, err := p.ReadFieldBegin()
        if err != nil {
            return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", x, id), err)
        }

        if typ == thrift.STOP {
            break;
        }

        switch id {
        default:
            if err := p.Skip(typ); err != nil {
                return err
            }
        }

        if err := p.ReadFieldEnd(); err != nil {
            return err
        }
    }

    if err := p.ReadStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read struct end error: ", x), err)
    }

    return nil
}

func (x *BinaryString) String() string {
    if x == nil {
        return "<nil>"
    }

    var sb strings.Builder

    sb.WriteString("BinaryString({")
    sb.WriteString("})")

    return sb.String()
}

type Adapter struct {
    AdapterClassName string `thrift:"adapterClassName,1" json:"adapterClassName" db:"adapterClassName"`
    TypeClassName string `thrift:"typeClassName,2" json:"typeClassName" db:"typeClassName"`
}
// Compile time interface enforcer
var _ thrift.Struct = &Adapter{}

func NewAdapter() *Adapter {
    return (&Adapter{}).
        SetAdapterClassNameNonCompat("").
        SetTypeClassNameNonCompat("")
}

func (x *Adapter) GetAdapterClassNameNonCompat() string {
    return x.AdapterClassName
}

func (x *Adapter) GetAdapterClassName() string {
    return x.AdapterClassName
}

func (x *Adapter) GetTypeClassNameNonCompat() string {
    return x.TypeClassName
}

func (x *Adapter) GetTypeClassName() string {
    return x.TypeClassName
}

func (x *Adapter) SetAdapterClassNameNonCompat(value string) *Adapter {
    x.AdapterClassName = value
    return x
}

func (x *Adapter) SetAdapterClassName(value string) *Adapter {
    x.AdapterClassName = value
    return x
}

func (x *Adapter) SetTypeClassNameNonCompat(value string) *Adapter {
    x.TypeClassName = value
    return x
}

func (x *Adapter) SetTypeClassName(value string) *Adapter {
    x.TypeClassName = value
    return x
}

func (x *Adapter) writeField1(p thrift.Protocol) error {  // AdapterClassName
    if err := p.WriteFieldBegin("adapterClassName", thrift.STRING, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetAdapterClassNameNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Adapter) writeField2(p thrift.Protocol) error {  // TypeClassName
    if err := p.WriteFieldBegin("typeClassName", thrift.STRING, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetTypeClassNameNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Adapter) readField1(p thrift.Protocol) error {  // AdapterClassName
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetAdapterClassNameNonCompat(result)
    return nil
}

func (x *Adapter) readField2(p thrift.Protocol) error {  // TypeClassName
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetTypeClassNameNonCompat(result)
    return nil
}

func (x *Adapter) toString1() string {  // AdapterClassName
    return fmt.Sprintf("%v", x.GetAdapterClassNameNonCompat())
}

func (x *Adapter) toString2() string {  // TypeClassName
    return fmt.Sprintf("%v", x.GetTypeClassNameNonCompat())
}


// Deprecated: Use Adapter.Set* methods instead or set the fields directly.
type AdapterBuilder struct {
    obj *Adapter
}

func NewAdapterBuilder() *AdapterBuilder {
    return &AdapterBuilder{
        obj: NewAdapter(),
    }
}

func (x *AdapterBuilder) AdapterClassName(value string) *AdapterBuilder {
    x.obj.AdapterClassName = value
    return x
}

func (x *AdapterBuilder) TypeClassName(value string) *AdapterBuilder {
    x.obj.TypeClassName = value
    return x
}

func (x *AdapterBuilder) Emit() *Adapter {
    var objCopy Adapter = *x.obj
    return &objCopy
}

func (x *Adapter) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("Adapter"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := x.writeField1(p); err != nil {
        return err
    }

    if err := x.writeField2(p); err != nil {
        return err
    }

    if err := p.WriteFieldStop(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field stop error: ", x), err)
    }

    if err := p.WriteStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct end error: ", x), err)
    }
    return nil
}

func (x *Adapter) Read(p thrift.Protocol) error {
    if _, err := p.ReadStructBegin(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read error: ", x), err)
    }

    for {
        _, typ, id, err := p.ReadFieldBegin()
        if err != nil {
            return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", x, id), err)
        }

        if typ == thrift.STOP {
            break;
        }

        switch id {
        case 1:  // adapterClassName
            if err := x.readField1(p); err != nil {
                return err
            }
        case 2:  // typeClassName
            if err := x.readField2(p); err != nil {
                return err
            }
        default:
            if err := p.Skip(typ); err != nil {
                return err
            }
        }

        if err := p.ReadFieldEnd(); err != nil {
            return err
        }
    }

    if err := p.ReadStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read struct end error: ", x), err)
    }

    return nil
}

func (x *Adapter) String() string {
    if x == nil {
        return "<nil>"
    }

    var sb strings.Builder

    sb.WriteString("Adapter({")
    sb.WriteString(fmt.Sprintf("AdapterClassName:%s ", x.toString1()))
    sb.WriteString(fmt.Sprintf("TypeClassName:%s", x.toString2()))
    sb.WriteString("})")

    return sb.String()
}

type Wrapper struct {
    WrapperClassName string `thrift:"wrapperClassName,1" json:"wrapperClassName" db:"wrapperClassName"`
    TypeClassName string `thrift:"typeClassName,2" json:"typeClassName" db:"typeClassName"`
}
// Compile time interface enforcer
var _ thrift.Struct = &Wrapper{}

func NewWrapper() *Wrapper {
    return (&Wrapper{}).
        SetWrapperClassNameNonCompat("").
        SetTypeClassNameNonCompat("")
}

func (x *Wrapper) GetWrapperClassNameNonCompat() string {
    return x.WrapperClassName
}

func (x *Wrapper) GetWrapperClassName() string {
    return x.WrapperClassName
}

func (x *Wrapper) GetTypeClassNameNonCompat() string {
    return x.TypeClassName
}

func (x *Wrapper) GetTypeClassName() string {
    return x.TypeClassName
}

func (x *Wrapper) SetWrapperClassNameNonCompat(value string) *Wrapper {
    x.WrapperClassName = value
    return x
}

func (x *Wrapper) SetWrapperClassName(value string) *Wrapper {
    x.WrapperClassName = value
    return x
}

func (x *Wrapper) SetTypeClassNameNonCompat(value string) *Wrapper {
    x.TypeClassName = value
    return x
}

func (x *Wrapper) SetTypeClassName(value string) *Wrapper {
    x.TypeClassName = value
    return x
}

func (x *Wrapper) writeField1(p thrift.Protocol) error {  // WrapperClassName
    if err := p.WriteFieldBegin("wrapperClassName", thrift.STRING, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetWrapperClassNameNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Wrapper) writeField2(p thrift.Protocol) error {  // TypeClassName
    if err := p.WriteFieldBegin("typeClassName", thrift.STRING, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetTypeClassNameNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Wrapper) readField1(p thrift.Protocol) error {  // WrapperClassName
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetWrapperClassNameNonCompat(result)
    return nil
}

func (x *Wrapper) readField2(p thrift.Protocol) error {  // TypeClassName
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetTypeClassNameNonCompat(result)
    return nil
}

func (x *Wrapper) toString1() string {  // WrapperClassName
    return fmt.Sprintf("%v", x.GetWrapperClassNameNonCompat())
}

func (x *Wrapper) toString2() string {  // TypeClassName
    return fmt.Sprintf("%v", x.GetTypeClassNameNonCompat())
}


// Deprecated: Use Wrapper.Set* methods instead or set the fields directly.
type WrapperBuilder struct {
    obj *Wrapper
}

func NewWrapperBuilder() *WrapperBuilder {
    return &WrapperBuilder{
        obj: NewWrapper(),
    }
}

func (x *WrapperBuilder) WrapperClassName(value string) *WrapperBuilder {
    x.obj.WrapperClassName = value
    return x
}

func (x *WrapperBuilder) TypeClassName(value string) *WrapperBuilder {
    x.obj.TypeClassName = value
    return x
}

func (x *WrapperBuilder) Emit() *Wrapper {
    var objCopy Wrapper = *x.obj
    return &objCopy
}

func (x *Wrapper) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("Wrapper"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := x.writeField1(p); err != nil {
        return err
    }

    if err := x.writeField2(p); err != nil {
        return err
    }

    if err := p.WriteFieldStop(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field stop error: ", x), err)
    }

    if err := p.WriteStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct end error: ", x), err)
    }
    return nil
}

func (x *Wrapper) Read(p thrift.Protocol) error {
    if _, err := p.ReadStructBegin(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read error: ", x), err)
    }

    for {
        _, typ, id, err := p.ReadFieldBegin()
        if err != nil {
            return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", x, id), err)
        }

        if typ == thrift.STOP {
            break;
        }

        switch id {
        case 1:  // wrapperClassName
            if err := x.readField1(p); err != nil {
                return err
            }
        case 2:  // typeClassName
            if err := x.readField2(p); err != nil {
                return err
            }
        default:
            if err := p.Skip(typ); err != nil {
                return err
            }
        }

        if err := p.ReadFieldEnd(); err != nil {
            return err
        }
    }

    if err := p.ReadStructEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read struct end error: ", x), err)
    }

    return nil
}

func (x *Wrapper) String() string {
    if x == nil {
        return "<nil>"
    }

    var sb strings.Builder

    sb.WriteString("Wrapper({")
    sb.WriteString(fmt.Sprintf("WrapperClassName:%s ", x.toString1()))
    sb.WriteString(fmt.Sprintf("TypeClassName:%s", x.toString2()))
    sb.WriteString("})")

    return sb.String()
}

// RegisterTypes registers types found in this file that have a thrift_uri with the passed in registry.
func RegisterTypes(registry interface {
	  RegisterType(name string, initializer func() any)
}) {
    registry.RegisterType("facebook.com/thrift/annotation/java/Mutable", func() any { return NewMutable() })
    registry.RegisterType("facebook.com/thrift/annotation/java/Annotation", func() any { return NewAnnotation() })
    registry.RegisterType("facebook.com/thrift/annotation/java/BinaryString", func() any { return NewBinaryString() })
    registry.RegisterType("facebook.com/thrift/annotation/java/Adapter", func() any { return NewAdapter() })
    registry.RegisterType("facebook.com/thrift/annotation/java/Wrapper", func() any { return NewWrapper() })

}
