// @generated by Thrift for [[[ program path ]]]
// This file is probably not the place you want to edit!

package module // [[[ program thrift source path ]]]

import (
    "fmt"

    hack "thrift/annotation/hack"
    thrift "github.com/facebook/fbthrift/thrift/lib/go/thrift"
)

var _ = hack.GoUnusedProtection__

// (needed to ensure safety because of naive import list construction)
var _ = fmt.Printf
var _ = thrift.ZERO


type MyEnum int32

const (
    MyEnum_MyValue1 MyEnum = 0
    MyEnum_MyValue2 MyEnum = 1
)

// Enum value maps for MyEnum
var (
    MyEnumToName = map[MyEnum]string {
        MyEnum_MyValue1: "MyValue1",
        MyEnum_MyValue2: "MyValue2",
    }

    MyEnumToValue = map[string]MyEnum {
        "MyValue1": MyEnum_MyValue1,
        "MyValue2": MyEnum_MyValue2,
    }

    MyEnumNames = []string{
        "MyValue1",
        "MyValue2",
    }

    MyEnumValues = []MyEnum{
        MyEnum_MyValue1,
        MyEnum_MyValue2,
    }
)

func (x MyEnum) String() string {
    if v, ok := MyEnumToName[x]; ok {
        return v
    }
    return "<UNSET>"
}

func (x MyEnum) Ptr() *MyEnum {
    return &x
}

// Deprecated: Use MyEnumToValue instead (e.g. `x, ok := MyEnumToValue["name"]`).
func MyEnumFromString(s string) (MyEnum, error) {
    if v, ok := MyEnumToValue[s]; ok {
        return v, nil
    }
    return MyEnum(0), fmt.Errorf("not a valid MyEnum string")
}

// Deprecated: Use MyEnum.Ptr() instead.
func MyEnumPtr(v MyEnum) *MyEnum {
    return &v
}


type HackEnum int32

const (
    HackEnum_Value1 HackEnum = 0
    HackEnum_Value2 HackEnum = 1
)

// Enum value maps for HackEnum
var (
    HackEnumToName = map[HackEnum]string {
        HackEnum_Value1: "Value1",
        HackEnum_Value2: "Value2",
    }

    HackEnumToValue = map[string]HackEnum {
        "Value1": HackEnum_Value1,
        "Value2": HackEnum_Value2,
    }

    HackEnumNames = []string{
        "Value1",
        "Value2",
    }

    HackEnumValues = []HackEnum{
        HackEnum_Value1,
        HackEnum_Value2,
    }
)

func (x HackEnum) String() string {
    if v, ok := HackEnumToName[x]; ok {
        return v
    }
    return "<UNSET>"
}

func (x HackEnum) Ptr() *HackEnum {
    return &x
}

// Deprecated: Use HackEnumToValue instead (e.g. `x, ok := HackEnumToValue["name"]`).
func HackEnumFromString(s string) (HackEnum, error) {
    if v, ok := HackEnumToValue[s]; ok {
        return v, nil
    }
    return HackEnum(0), fmt.Errorf("not a valid HackEnum string")
}

// Deprecated: Use HackEnum.Ptr() instead.
func HackEnumPtr(v HackEnum) *HackEnum {
    return &v
}


type MyStruct struct {
    MyIntField int64 `thrift:"MyIntField,1" json:"MyIntField" db:"MyIntField"`
    MyStringField string `thrift:"MyStringField,2" json:"MyStringField" db:"MyStringField"`
    MyDataField *MyDataItem `thrift:"MyDataField,3" json:"MyDataField" db:"MyDataField"`
    MyEnum MyEnum `thrift:"myEnum,4" json:"myEnum" db:"myEnum"`
    Oneway bool `thrift:"oneway,5" json:"oneway" db:"oneway"`
    Readonly bool `thrift:"readonly,6" json:"readonly" db:"readonly"`
    Idempotent bool `thrift:"idempotent,7" json:"idempotent" db:"idempotent"`
    FloatSet []float32 `thrift:"floatSet,8" json:"floatSet" db:"floatSet"`
    NoHackCodegenField string `thrift:"no_hack_codegen_field,9" json:"no_hack_codegen_field" db:"no_hack_codegen_field"`
}
// Compile time interface enforcer
var _ thrift.Struct = &MyStruct{}

func NewMyStruct() *MyStruct {
    return (&MyStruct{}).
        SetMyIntField(0).
        SetMyStringField("").
        SetMyDataField(*NewMyDataItem()).
        SetMyEnum(0).
        SetOneway(false).
        SetReadonly(false).
        SetIdempotent(false).
        SetFloatSet(make([]float32, 0)).
        SetNoHackCodegenField("")
}

// Deprecated: Use NewMyStruct().MyDataField instead.
var MyStruct_MyDataField_DEFAULT = NewMyStruct().MyDataField

func (x *MyStruct) GetMyIntFieldNonCompat() int64 {
    return x.MyIntField
}

func (x *MyStruct) GetMyIntField() int64 {
    return x.MyIntField
}

func (x *MyStruct) GetMyStringFieldNonCompat() string {
    return x.MyStringField
}

func (x *MyStruct) GetMyStringField() string {
    return x.MyStringField
}

func (x *MyStruct) GetMyDataFieldNonCompat() *MyDataItem {
    return x.MyDataField
}

func (x *MyStruct) GetMyDataField() *MyDataItem {
    if !x.IsSetMyDataField() {
        return NewMyDataItem()
    }

    return x.MyDataField
}

func (x *MyStruct) GetMyEnumNonCompat() MyEnum {
    return x.MyEnum
}

func (x *MyStruct) GetMyEnum() MyEnum {
    return x.MyEnum
}

func (x *MyStruct) GetOnewayNonCompat() bool {
    return x.Oneway
}

func (x *MyStruct) GetOneway() bool {
    return x.Oneway
}

func (x *MyStruct) GetReadonlyNonCompat() bool {
    return x.Readonly
}

func (x *MyStruct) GetReadonly() bool {
    return x.Readonly
}

func (x *MyStruct) GetIdempotentNonCompat() bool {
    return x.Idempotent
}

func (x *MyStruct) GetIdempotent() bool {
    return x.Idempotent
}

func (x *MyStruct) GetFloatSetNonCompat() []float32 {
    return x.FloatSet
}

func (x *MyStruct) GetFloatSet() []float32 {
    if !x.IsSetFloatSet() {
        return make([]float32, 0)
    }

    return x.FloatSet
}

func (x *MyStruct) GetNoHackCodegenFieldNonCompat() string {
    return x.NoHackCodegenField
}

func (x *MyStruct) GetNoHackCodegenField() string {
    return x.NoHackCodegenField
}

func (x *MyStruct) SetMyIntField(value int64) *MyStruct {
    x.MyIntField = value
    return x
}

func (x *MyStruct) SetMyStringField(value string) *MyStruct {
    x.MyStringField = value
    return x
}

func (x *MyStruct) SetMyDataField(value MyDataItem) *MyStruct {
    x.MyDataField = &value
    return x
}

func (x *MyStruct) SetMyEnum(value MyEnum) *MyStruct {
    x.MyEnum = value
    return x
}

func (x *MyStruct) SetOneway(value bool) *MyStruct {
    x.Oneway = value
    return x
}

func (x *MyStruct) SetReadonly(value bool) *MyStruct {
    x.Readonly = value
    return x
}

func (x *MyStruct) SetIdempotent(value bool) *MyStruct {
    x.Idempotent = value
    return x
}

func (x *MyStruct) SetFloatSet(value []float32) *MyStruct {
    x.FloatSet = value
    return x
}

func (x *MyStruct) SetNoHackCodegenField(value string) *MyStruct {
    x.NoHackCodegenField = value
    return x
}

func (x *MyStruct) IsSetMyDataField() bool {
    return x.MyDataField != nil
}

func (x *MyStruct) IsSetFloatSet() bool {
    return x.FloatSet != nil
}

func (x *MyStruct) writeField1(p thrift.Protocol) error {  // MyIntField
    if err := p.WriteFieldBegin("MyIntField", thrift.I64, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetMyIntFieldNonCompat()
    if err := p.WriteI64(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) writeField2(p thrift.Protocol) error {  // MyStringField
    if err := p.WriteFieldBegin("MyStringField", thrift.STRING, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetMyStringFieldNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) writeField3(p thrift.Protocol) error {  // MyDataField
    if !x.IsSetMyDataField() {
        return nil
    }

    if err := p.WriteFieldBegin("MyDataField", thrift.STRUCT, 3); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetMyDataFieldNonCompat()
    if err := item.Write(p); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) writeField4(p thrift.Protocol) error {  // MyEnum
    if err := p.WriteFieldBegin("myEnum", thrift.I32, 4); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetMyEnumNonCompat()
    if err := p.WriteI32(int32(item)); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) writeField5(p thrift.Protocol) error {  // Oneway
    if err := p.WriteFieldBegin("oneway", thrift.BOOL, 5); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetOnewayNonCompat()
    if err := p.WriteBool(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) writeField6(p thrift.Protocol) error {  // Readonly
    if err := p.WriteFieldBegin("readonly", thrift.BOOL, 6); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetReadonlyNonCompat()
    if err := p.WriteBool(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) writeField7(p thrift.Protocol) error {  // Idempotent
    if err := p.WriteFieldBegin("idempotent", thrift.BOOL, 7); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetIdempotentNonCompat()
    if err := p.WriteBool(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) writeField8(p thrift.Protocol) error {  // FloatSet
    if !x.IsSetFloatSet() {
        return nil
    }

    if err := p.WriteFieldBegin("floatSet", thrift.SET, 8); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetFloatSetNonCompat()
    if err := p.WriteSetBegin(thrift.FLOAT, len(item)); err != nil {
    return thrift.PrependError("error writing set begin: ", err)
}
for _, v := range item {
    {
        item := v
        if err := p.WriteFloat(item); err != nil {
    return err
}
    }
}
if err := p.WriteSetEnd(); err != nil {
    return thrift.PrependError("error writing set end: ", err)
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) writeField9(p thrift.Protocol) error {  // NoHackCodegenField
    if err := p.WriteFieldBegin("no_hack_codegen_field", thrift.STRING, 9); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetNoHackCodegenFieldNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyStruct) readField1(p thrift.Protocol) error {  // MyIntField
    result, err := p.ReadI64()
if err != nil {
    return err
}

    x.SetMyIntField(result)
    return nil
}

func (x *MyStruct) readField2(p thrift.Protocol) error {  // MyStringField
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetMyStringField(result)
    return nil
}

func (x *MyStruct) readField3(p thrift.Protocol) error {  // MyDataField
    result := *NewMyDataItem()
err := result.Read(p)
if err != nil {
    return err
}

    x.SetMyDataField(result)
    return nil
}

func (x *MyStruct) readField4(p thrift.Protocol) error {  // MyEnum
    enumResult, err := p.ReadI32()
if err != nil {
    return err
}
result := MyEnum(enumResult)

    x.SetMyEnum(result)
    return nil
}

func (x *MyStruct) readField5(p thrift.Protocol) error {  // Oneway
    result, err := p.ReadBool()
if err != nil {
    return err
}

    x.SetOneway(result)
    return nil
}

func (x *MyStruct) readField6(p thrift.Protocol) error {  // Readonly
    result, err := p.ReadBool()
if err != nil {
    return err
}

    x.SetReadonly(result)
    return nil
}

func (x *MyStruct) readField7(p thrift.Protocol) error {  // Idempotent
    result, err := p.ReadBool()
if err != nil {
    return err
}

    x.SetIdempotent(result)
    return nil
}

func (x *MyStruct) readField8(p thrift.Protocol) error {  // FloatSet
    _ /* elemType */, size, err := p.ReadSetBegin()
if err != nil {
    return thrift.PrependError("error reading set begin: ", err)
}

setResult := make([]float32, 0, size)
for i := 0; i < size; i++ {
    var elem float32
    {
        result, err := p.ReadFloat()
if err != nil {
    return err
}
        elem = result
    }
    setResult = append(setResult, elem)
}

if err := p.ReadSetEnd(); err != nil {
    return thrift.PrependError("error reading set end: ", err)
}
result := setResult

    x.SetFloatSet(result)
    return nil
}

func (x *MyStruct) readField9(p thrift.Protocol) error {  // NoHackCodegenField
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetNoHackCodegenField(result)
    return nil
}

func (x *MyStruct) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use MyStruct.Set* methods instead or set the fields directly.
type MyStructBuilder struct {
    obj *MyStruct
}

func NewMyStructBuilder() *MyStructBuilder {
    return &MyStructBuilder{
        obj: NewMyStruct(),
    }
}

func (x *MyStructBuilder) MyIntField(value int64) *MyStructBuilder {
    x.obj.MyIntField = value
    return x
}

func (x *MyStructBuilder) MyStringField(value string) *MyStructBuilder {
    x.obj.MyStringField = value
    return x
}

func (x *MyStructBuilder) MyDataField(value *MyDataItem) *MyStructBuilder {
    x.obj.MyDataField = value
    return x
}

func (x *MyStructBuilder) MyEnum(value MyEnum) *MyStructBuilder {
    x.obj.MyEnum = value
    return x
}

func (x *MyStructBuilder) Oneway(value bool) *MyStructBuilder {
    x.obj.Oneway = value
    return x
}

func (x *MyStructBuilder) Readonly(value bool) *MyStructBuilder {
    x.obj.Readonly = value
    return x
}

func (x *MyStructBuilder) Idempotent(value bool) *MyStructBuilder {
    x.obj.Idempotent = value
    return x
}

func (x *MyStructBuilder) FloatSet(value []float32) *MyStructBuilder {
    x.obj.FloatSet = value
    return x
}

func (x *MyStructBuilder) NoHackCodegenField(value string) *MyStructBuilder {
    x.obj.NoHackCodegenField = value
    return x
}

func (x *MyStructBuilder) Emit() *MyStruct {
    var objCopy MyStruct = *x.obj
    return &objCopy
}

func (x *MyStruct) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("MyStruct"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := x.writeField1(p); err != nil {
        return err
    }

    if err := x.writeField2(p); err != nil {
        return err
    }

    if err := x.writeField3(p); err != nil {
        return err
    }

    if err := x.writeField4(p); err != nil {
        return err
    }

    if err := x.writeField5(p); err != nil {
        return err
    }

    if err := x.writeField6(p); err != nil {
        return err
    }

    if err := x.writeField7(p); err != nil {
        return err
    }

    if err := x.writeField8(p); err != nil {
        return err
    }

    if err := x.writeField9(p); err != nil {
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

func (x *MyStruct) Read(p thrift.Protocol) error {
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
        case 1:  // MyIntField
            if err := x.readField1(p); err != nil {
                return err
            }
        case 2:  // MyStringField
            if err := x.readField2(p); err != nil {
                return err
            }
        case 3:  // MyDataField
            if err := x.readField3(p); err != nil {
                return err
            }
        case 4:  // myEnum
            if err := x.readField4(p); err != nil {
                return err
            }
        case 5:  // oneway
            if err := x.readField5(p); err != nil {
                return err
            }
        case 6:  // readonly
            if err := x.readField6(p); err != nil {
                return err
            }
        case 7:  // idempotent
            if err := x.readField7(p); err != nil {
                return err
            }
        case 8:  // floatSet
            if err := x.readField8(p); err != nil {
                return err
            }
        case 9:  // no_hack_codegen_field
            if err := x.readField9(p); err != nil {
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


type MyDataItem struct {
}
// Compile time interface enforcer
var _ thrift.Struct = &MyDataItem{}

func NewMyDataItem() *MyDataItem {
    return (&MyDataItem{})
}

func (x *MyDataItem) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use MyDataItem.Set* methods instead or set the fields directly.
type MyDataItemBuilder struct {
    obj *MyDataItem
}

func NewMyDataItemBuilder() *MyDataItemBuilder {
    return &MyDataItemBuilder{
        obj: NewMyDataItem(),
    }
}

func (x *MyDataItemBuilder) Emit() *MyDataItem {
    var objCopy MyDataItem = *x.obj
    return &objCopy
}

func (x *MyDataItem) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("MyDataItem"); err != nil {
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

func (x *MyDataItem) Read(p thrift.Protocol) error {
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


type MyUnion struct {
    MyEnum *MyEnum `thrift:"myEnum,1" json:"myEnum" db:"myEnum"`
    MyStruct *MyStruct `thrift:"myStruct,2" json:"myStruct" db:"myStruct"`
    MyDataItem *MyDataItem `thrift:"myDataItem,3" json:"myDataItem" db:"myDataItem"`
    FloatSet []float32 `thrift:"floatSet,4" json:"floatSet" db:"floatSet"`
}
// Compile time interface enforcer
var _ thrift.Struct = &MyUnion{}

func NewMyUnion() *MyUnion {
    return (&MyUnion{}).
        SetMyEnum(0).
        SetMyStruct(*NewMyStruct()).
        SetMyDataItem(*NewMyDataItem()).
        SetFloatSet(make([]float32, 0))
}

// Deprecated: Use NewMyUnion().MyEnum instead.
var MyUnion_MyEnum_DEFAULT = NewMyUnion().MyEnum

// Deprecated: Use NewMyUnion().MyStruct instead.
var MyUnion_MyStruct_DEFAULT = NewMyUnion().MyStruct

// Deprecated: Use NewMyUnion().MyDataItem instead.
var MyUnion_MyDataItem_DEFAULT = NewMyUnion().MyDataItem

func (x *MyUnion) GetMyEnumNonCompat() *MyEnum {
    return x.MyEnum
}

func (x *MyUnion) GetMyEnum() MyEnum {
    if !x.IsSetMyEnum() {
        return 0
    }

    return *x.MyEnum
}

func (x *MyUnion) GetMyStructNonCompat() *MyStruct {
    return x.MyStruct
}

func (x *MyUnion) GetMyStruct() *MyStruct {
    if !x.IsSetMyStruct() {
        return NewMyStruct()
    }

    return x.MyStruct
}

func (x *MyUnion) GetMyDataItemNonCompat() *MyDataItem {
    return x.MyDataItem
}

func (x *MyUnion) GetMyDataItem() *MyDataItem {
    if !x.IsSetMyDataItem() {
        return NewMyDataItem()
    }

    return x.MyDataItem
}

func (x *MyUnion) GetFloatSetNonCompat() []float32 {
    return x.FloatSet
}

func (x *MyUnion) GetFloatSet() []float32 {
    if !x.IsSetFloatSet() {
        return make([]float32, 0)
    }

    return x.FloatSet
}

func (x *MyUnion) SetMyEnum(value MyEnum) *MyUnion {
    x.MyEnum = &value
    return x
}

func (x *MyUnion) SetMyStruct(value MyStruct) *MyUnion {
    x.MyStruct = &value
    return x
}

func (x *MyUnion) SetMyDataItem(value MyDataItem) *MyUnion {
    x.MyDataItem = &value
    return x
}

func (x *MyUnion) SetFloatSet(value []float32) *MyUnion {
    x.FloatSet = value
    return x
}

func (x *MyUnion) IsSetMyEnum() bool {
    return x.MyEnum != nil
}

func (x *MyUnion) IsSetMyStruct() bool {
    return x.MyStruct != nil
}

func (x *MyUnion) IsSetMyDataItem() bool {
    return x.MyDataItem != nil
}

func (x *MyUnion) IsSetFloatSet() bool {
    return x.FloatSet != nil
}

func (x *MyUnion) writeField1(p thrift.Protocol) error {  // MyEnum
    if !x.IsSetMyEnum() {
        return nil
    }

    if err := p.WriteFieldBegin("myEnum", thrift.I32, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := *x.GetMyEnumNonCompat()
    if err := p.WriteI32(int32(item)); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyUnion) writeField2(p thrift.Protocol) error {  // MyStruct
    if !x.IsSetMyStruct() {
        return nil
    }

    if err := p.WriteFieldBegin("myStruct", thrift.STRUCT, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetMyStructNonCompat()
    if err := item.Write(p); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyUnion) writeField3(p thrift.Protocol) error {  // MyDataItem
    if !x.IsSetMyDataItem() {
        return nil
    }

    if err := p.WriteFieldBegin("myDataItem", thrift.STRUCT, 3); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetMyDataItemNonCompat()
    if err := item.Write(p); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyUnion) writeField4(p thrift.Protocol) error {  // FloatSet
    if !x.IsSetFloatSet() {
        return nil
    }

    if err := p.WriteFieldBegin("floatSet", thrift.SET, 4); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetFloatSetNonCompat()
    if err := p.WriteSetBegin(thrift.FLOAT, len(item)); err != nil {
    return thrift.PrependError("error writing set begin: ", err)
}
for _, v := range item {
    {
        item := v
        if err := p.WriteFloat(item); err != nil {
    return err
}
    }
}
if err := p.WriteSetEnd(); err != nil {
    return thrift.PrependError("error writing set end: ", err)
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *MyUnion) readField1(p thrift.Protocol) error {  // MyEnum
    enumResult, err := p.ReadI32()
if err != nil {
    return err
}
result := MyEnum(enumResult)

    x.SetMyEnum(result)
    return nil
}

func (x *MyUnion) readField2(p thrift.Protocol) error {  // MyStruct
    result := *NewMyStruct()
err := result.Read(p)
if err != nil {
    return err
}

    x.SetMyStruct(result)
    return nil
}

func (x *MyUnion) readField3(p thrift.Protocol) error {  // MyDataItem
    result := *NewMyDataItem()
err := result.Read(p)
if err != nil {
    return err
}

    x.SetMyDataItem(result)
    return nil
}

func (x *MyUnion) readField4(p thrift.Protocol) error {  // FloatSet
    _ /* elemType */, size, err := p.ReadSetBegin()
if err != nil {
    return thrift.PrependError("error reading set begin: ", err)
}

setResult := make([]float32, 0, size)
for i := 0; i < size; i++ {
    var elem float32
    {
        result, err := p.ReadFloat()
if err != nil {
    return err
}
        elem = result
    }
    setResult = append(setResult, elem)
}

if err := p.ReadSetEnd(); err != nil {
    return thrift.PrependError("error reading set end: ", err)
}
result := setResult

    x.SetFloatSet(result)
    return nil
}

func (x *MyUnion) String() string {
    return fmt.Sprintf("%+v", x)
}

func (x *MyUnion) countSetFields() int {
    count := int(0)
    if (x.IsSetMyEnum()) {
        count++
    }
    if (x.IsSetMyStruct()) {
        count++
    }
    if (x.IsSetMyDataItem()) {
        count++
    }
    if (x.IsSetFloatSet()) {
        count++
    }
    return count
}


// Deprecated: Use MyUnion.Set* methods instead or set the fields directly.
type MyUnionBuilder struct {
    obj *MyUnion
}

func NewMyUnionBuilder() *MyUnionBuilder {
    return &MyUnionBuilder{
        obj: NewMyUnion(),
    }
}

func (x *MyUnionBuilder) MyEnum(value *MyEnum) *MyUnionBuilder {
    x.obj.MyEnum = value
    return x
}

func (x *MyUnionBuilder) MyStruct(value *MyStruct) *MyUnionBuilder {
    x.obj.MyStruct = value
    return x
}

func (x *MyUnionBuilder) MyDataItem(value *MyDataItem) *MyUnionBuilder {
    x.obj.MyDataItem = value
    return x
}

func (x *MyUnionBuilder) FloatSet(value []float32) *MyUnionBuilder {
    x.obj.FloatSet = value
    return x
}

func (x *MyUnionBuilder) Emit() *MyUnion {
    var objCopy MyUnion = *x.obj
    return &objCopy
}

func (x *MyUnion) Write(p thrift.Protocol) error {
    if countSet := x.countSetFields(); countSet > 1 {
        return fmt.Errorf("%T write union: no more than one field must be set (%d set).", x, countSet)
    }
    if err := p.WriteStructBegin("MyUnion"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := x.writeField1(p); err != nil {
        return err
    }

    if err := x.writeField2(p); err != nil {
        return err
    }

    if err := x.writeField3(p); err != nil {
        return err
    }

    if err := x.writeField4(p); err != nil {
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

func (x *MyUnion) Read(p thrift.Protocol) error {
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
        case 1:  // myEnum
            if err := x.readField1(p); err != nil {
                return err
            }
        case 2:  // myStruct
            if err := x.readField2(p); err != nil {
                return err
            }
        case 3:  // myDataItem
            if err := x.readField3(p); err != nil {
                return err
            }
        case 4:  // floatSet
            if err := x.readField4(p); err != nil {
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


type ReservedKeyword struct {
    ReservedField int32 `thrift:"reserved_field,1" json:"reserved_field" db:"reserved_field"`
}
// Compile time interface enforcer
var _ thrift.Struct = &ReservedKeyword{}

func NewReservedKeyword() *ReservedKeyword {
    return (&ReservedKeyword{}).
        SetReservedField(0)
}

func (x *ReservedKeyword) GetReservedFieldNonCompat() int32 {
    return x.ReservedField
}

func (x *ReservedKeyword) GetReservedField() int32 {
    return x.ReservedField
}

func (x *ReservedKeyword) SetReservedField(value int32) *ReservedKeyword {
    x.ReservedField = value
    return x
}

func (x *ReservedKeyword) writeField1(p thrift.Protocol) error {  // ReservedField
    if err := p.WriteFieldBegin("reserved_field", thrift.I32, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetReservedFieldNonCompat()
    if err := p.WriteI32(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *ReservedKeyword) readField1(p thrift.Protocol) error {  // ReservedField
    result, err := p.ReadI32()
if err != nil {
    return err
}

    x.SetReservedField(result)
    return nil
}

func (x *ReservedKeyword) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use ReservedKeyword.Set* methods instead or set the fields directly.
type ReservedKeywordBuilder struct {
    obj *ReservedKeyword
}

func NewReservedKeywordBuilder() *ReservedKeywordBuilder {
    return &ReservedKeywordBuilder{
        obj: NewReservedKeyword(),
    }
}

func (x *ReservedKeywordBuilder) ReservedField(value int32) *ReservedKeywordBuilder {
    x.obj.ReservedField = value
    return x
}

func (x *ReservedKeywordBuilder) Emit() *ReservedKeyword {
    var objCopy ReservedKeyword = *x.obj
    return &objCopy
}

func (x *ReservedKeyword) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("ReservedKeyword"); err != nil {
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

func (x *ReservedKeyword) Read(p thrift.Protocol) error {
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
        case 1:  // reserved_field
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


type UnionToBeRenamed struct {
    ReservedField *int32 `thrift:"reserved_field,1" json:"reserved_field" db:"reserved_field"`
}
// Compile time interface enforcer
var _ thrift.Struct = &UnionToBeRenamed{}

func NewUnionToBeRenamed() *UnionToBeRenamed {
    return (&UnionToBeRenamed{}).
        SetReservedField(0)
}

// Deprecated: Use NewUnionToBeRenamed().ReservedField instead.
var UnionToBeRenamed_ReservedField_DEFAULT = NewUnionToBeRenamed().ReservedField

func (x *UnionToBeRenamed) GetReservedFieldNonCompat() *int32 {
    return x.ReservedField
}

func (x *UnionToBeRenamed) GetReservedField() int32 {
    if !x.IsSetReservedField() {
        return 0
    }

    return *x.ReservedField
}

func (x *UnionToBeRenamed) SetReservedField(value int32) *UnionToBeRenamed {
    x.ReservedField = &value
    return x
}

func (x *UnionToBeRenamed) IsSetReservedField() bool {
    return x.ReservedField != nil
}

func (x *UnionToBeRenamed) writeField1(p thrift.Protocol) error {  // ReservedField
    if !x.IsSetReservedField() {
        return nil
    }

    if err := p.WriteFieldBegin("reserved_field", thrift.I32, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := *x.GetReservedFieldNonCompat()
    if err := p.WriteI32(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *UnionToBeRenamed) readField1(p thrift.Protocol) error {  // ReservedField
    result, err := p.ReadI32()
if err != nil {
    return err
}

    x.SetReservedField(result)
    return nil
}

func (x *UnionToBeRenamed) String() string {
    return fmt.Sprintf("%+v", x)
}

func (x *UnionToBeRenamed) countSetFields() int {
    count := int(0)
    if (x.IsSetReservedField()) {
        count++
    }
    return count
}


// Deprecated: Use UnionToBeRenamed.Set* methods instead or set the fields directly.
type UnionToBeRenamedBuilder struct {
    obj *UnionToBeRenamed
}

func NewUnionToBeRenamedBuilder() *UnionToBeRenamedBuilder {
    return &UnionToBeRenamedBuilder{
        obj: NewUnionToBeRenamed(),
    }
}

func (x *UnionToBeRenamedBuilder) ReservedField(value *int32) *UnionToBeRenamedBuilder {
    x.obj.ReservedField = value
    return x
}

func (x *UnionToBeRenamedBuilder) Emit() *UnionToBeRenamed {
    var objCopy UnionToBeRenamed = *x.obj
    return &objCopy
}

func (x *UnionToBeRenamed) Write(p thrift.Protocol) error {
    if countSet := x.countSetFields(); countSet > 1 {
        return fmt.Errorf("%T write union: no more than one field must be set (%d set).", x, countSet)
    }
    if err := p.WriteStructBegin("UnionToBeRenamed"); err != nil {
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

func (x *UnionToBeRenamed) Read(p thrift.Protocol) error {
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
        case 1:  // reserved_field
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

