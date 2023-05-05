// @generated by Thrift for [[[ program path ]]]
// This file is probably not the place you want to edit!

package module0 // [[[ program thrift source path ]]]

import (
    "fmt"

    thrift "github.com/facebook/fbthrift/thrift/lib/go/thrift"
)


// (needed to ensure safety because of naive import list construction)
var _ = fmt.Printf
var _ = thrift.ZERO


type Accessory struct {
    InventoryId int32 `thrift:"InventoryId,1" json:"InventoryId" db:"InventoryId"`
    Name string `thrift:"Name,2" json:"Name" db:"Name"`
}
// Compile time interface enforcer
var _ thrift.Struct = &Accessory{}


func NewAccessory() *Accessory {
    return (&Accessory{})
}

func (x *Accessory) GetInventoryIdNonCompat() int32 {
    return x.InventoryId
}

func (x *Accessory) GetInventoryId() int32 {
    return x.InventoryId
}

func (x *Accessory) GetNameNonCompat() string {
    return x.Name
}

func (x *Accessory) GetName() string {
    return x.Name
}

func (x *Accessory) SetInventoryId(value int32) *Accessory {
    x.InventoryId = value
    return x
}

func (x *Accessory) SetName(value string) *Accessory {
    x.Name = value
    return x
}

func (x *Accessory) writeField1(p thrift.Protocol) error {  // InventoryId
    if err := p.WriteFieldBegin("InventoryId", thrift.I32, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetInventoryIdNonCompat()
    if err := p.WriteI32(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Accessory) writeField2(p thrift.Protocol) error {  // Name
    if err := p.WriteFieldBegin("Name", thrift.STRING, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetNameNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Accessory) readField1(p thrift.Protocol) error {  // InventoryId
    result, err := p.ReadI32()
if err != nil {
    return err
}

    x.SetInventoryId(result)
    return nil
}

func (x *Accessory) readField2(p thrift.Protocol) error {  // Name
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetName(result)
    return nil
}

func (x *Accessory) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use Accessory.Set* methods instead or set the fields directly.
type AccessoryBuilder struct {
    obj *Accessory
}

func NewAccessoryBuilder() *AccessoryBuilder {
    return &AccessoryBuilder{
        obj: NewAccessory(),
    }
}

func (x *AccessoryBuilder) InventoryId(value int32) *AccessoryBuilder {
    x.obj.InventoryId = value
    return x
}

func (x *AccessoryBuilder) Name(value string) *AccessoryBuilder {
    x.obj.Name = value
    return x
}

func (x *AccessoryBuilder) Emit() *Accessory {
    var objCopy Accessory = *x.obj
    return &objCopy
}

func (x *Accessory) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("Accessory"); err != nil {
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

func (x *Accessory) Read(p thrift.Protocol) error {
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
        case 1:  // InventoryId
            if err := x.readField1(p); err != nil {
                return err
            }
        case 2:  // Name
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


type PartName struct {
    InventoryId int32 `thrift:"InventoryId,1" json:"InventoryId" db:"InventoryId"`
    Name string `thrift:"Name,2" json:"Name" db:"Name"`
}
// Compile time interface enforcer
var _ thrift.Struct = &PartName{}


func NewPartName() *PartName {
    return (&PartName{})
}

func (x *PartName) GetInventoryIdNonCompat() int32 {
    return x.InventoryId
}

func (x *PartName) GetInventoryId() int32 {
    return x.InventoryId
}

func (x *PartName) GetNameNonCompat() string {
    return x.Name
}

func (x *PartName) GetName() string {
    return x.Name
}

func (x *PartName) SetInventoryId(value int32) *PartName {
    x.InventoryId = value
    return x
}

func (x *PartName) SetName(value string) *PartName {
    x.Name = value
    return x
}

func (x *PartName) writeField1(p thrift.Protocol) error {  // InventoryId
    if err := p.WriteFieldBegin("InventoryId", thrift.I32, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetInventoryIdNonCompat()
    if err := p.WriteI32(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *PartName) writeField2(p thrift.Protocol) error {  // Name
    if err := p.WriteFieldBegin("Name", thrift.STRING, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetNameNonCompat()
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *PartName) readField1(p thrift.Protocol) error {  // InventoryId
    result, err := p.ReadI32()
if err != nil {
    return err
}

    x.SetInventoryId(result)
    return nil
}

func (x *PartName) readField2(p thrift.Protocol) error {  // Name
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.SetName(result)
    return nil
}

func (x *PartName) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use PartName.Set* methods instead or set the fields directly.
type PartNameBuilder struct {
    obj *PartName
}

func NewPartNameBuilder() *PartNameBuilder {
    return &PartNameBuilder{
        obj: NewPartName(),
    }
}

func (x *PartNameBuilder) InventoryId(value int32) *PartNameBuilder {
    x.obj.InventoryId = value
    return x
}

func (x *PartNameBuilder) Name(value string) *PartNameBuilder {
    x.obj.Name = value
    return x
}

func (x *PartNameBuilder) Emit() *PartName {
    var objCopy PartName = *x.obj
    return &objCopy
}

func (x *PartName) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("PartName"); err != nil {
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

func (x *PartName) Read(p thrift.Protocol) error {
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
        case 1:  // InventoryId
            if err := x.readField1(p); err != nil {
                return err
            }
        case 2:  // Name
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

