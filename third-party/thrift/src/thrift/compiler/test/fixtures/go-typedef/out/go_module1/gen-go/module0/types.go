// @generated by Thrift for [[[ program path ]]]
// This file is probably not the place you want to edit!

package module0 // [[[ program thrift source path ]]]

import (
    "fmt"
    "strings"

    thrift "github.com/facebook/fbthrift/thrift/lib/go/thrift"
)

// (needed to ensure safety because of naive import list construction)
var _ = fmt.Printf
var _ = strings.Split
var _ = thrift.ZERO


type Accessory struct {
    InventoryId int32 `thrift:"InventoryId,1" json:"InventoryId" db:"InventoryId"`
    Name string `thrift:"Name,2" json:"Name" db:"Name"`
}
// Compile time interface enforcer
var _ thrift.Struct = (*Accessory)(nil)

func NewAccessory() *Accessory {
    return (&Accessory{}).
        SetInventoryIdNonCompat(0).
        SetNameNonCompat("")
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

func (x *Accessory) SetInventoryIdNonCompat(value int32) *Accessory {
    x.InventoryId = value
    return x
}

func (x *Accessory) SetInventoryId(value int32) *Accessory {
    x.InventoryId = value
    return x
}

func (x *Accessory) SetNameNonCompat(value string) *Accessory {
    x.Name = value
    return x
}

func (x *Accessory) SetName(value string) *Accessory {
    x.Name = value
    return x
}

func (x *Accessory) writeField1(p thrift.Format) error {  // InventoryId
    if err := p.WriteFieldBegin("InventoryId", thrift.I32, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.InventoryId
    if err := p.WriteI32(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Accessory) writeField2(p thrift.Format) error {  // Name
    if err := p.WriteFieldBegin("Name", thrift.STRING, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.Name
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *Accessory) readField1(p thrift.Format) error {  // InventoryId
    result, err := p.ReadI32()
if err != nil {
    return err
}

    x.InventoryId = result
    return nil
}

func (x *Accessory) readField2(p thrift.Format) error {  // Name
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.Name = result
    return nil
}

func (x *Accessory) toString1() string {  // InventoryId
    return fmt.Sprintf("%v", x.InventoryId)
}

func (x *Accessory) toString2() string {  // Name
    return fmt.Sprintf("%v", x.Name)
}



func (x *Accessory) Write(p thrift.Format) error {
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

func (x *Accessory) Read(p thrift.Format) error {
    if _, err := p.ReadStructBegin(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read error: ", x), err)
    }

    for {
        _, wireType, id, err := p.ReadFieldBegin()
        if err != nil {
            return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", x, id), err)
        }

        if wireType == thrift.STOP {
            break;
        }

        switch {
        case (id == 1 && wireType == thrift.Type(thrift.I32)):  // InventoryId
            if err := x.readField1(p); err != nil {
                return err
            }
        case (id == 2 && wireType == thrift.Type(thrift.STRING)):  // Name
            if err := x.readField2(p); err != nil {
                return err
            }
        default:
            if err := p.Skip(wireType); err != nil {
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

func (x *Accessory) String() string {
    if x == nil {
        return "<nil>"
    }

    var sb strings.Builder

    sb.WriteString("Accessory({")
    sb.WriteString(fmt.Sprintf("InventoryId:%s ", x.toString1()))
    sb.WriteString(fmt.Sprintf("Name:%s", x.toString2()))
    sb.WriteString("})")

    return sb.String()
}

type PartName struct {
    InventoryId int32 `thrift:"InventoryId,1" json:"InventoryId" db:"InventoryId"`
    Name string `thrift:"Name,2" json:"Name" db:"Name"`
}
// Compile time interface enforcer
var _ thrift.Struct = (*PartName)(nil)

func NewPartName() *PartName {
    return (&PartName{}).
        SetInventoryIdNonCompat(0).
        SetNameNonCompat("")
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

func (x *PartName) SetInventoryIdNonCompat(value int32) *PartName {
    x.InventoryId = value
    return x
}

func (x *PartName) SetInventoryId(value int32) *PartName {
    x.InventoryId = value
    return x
}

func (x *PartName) SetNameNonCompat(value string) *PartName {
    x.Name = value
    return x
}

func (x *PartName) SetName(value string) *PartName {
    x.Name = value
    return x
}

func (x *PartName) writeField1(p thrift.Format) error {  // InventoryId
    if err := p.WriteFieldBegin("InventoryId", thrift.I32, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.InventoryId
    if err := p.WriteI32(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *PartName) writeField2(p thrift.Format) error {  // Name
    if err := p.WriteFieldBegin("Name", thrift.STRING, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.Name
    if err := p.WriteString(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *PartName) readField1(p thrift.Format) error {  // InventoryId
    result, err := p.ReadI32()
if err != nil {
    return err
}

    x.InventoryId = result
    return nil
}

func (x *PartName) readField2(p thrift.Format) error {  // Name
    result, err := p.ReadString()
if err != nil {
    return err
}

    x.Name = result
    return nil
}

func (x *PartName) toString1() string {  // InventoryId
    return fmt.Sprintf("%v", x.InventoryId)
}

func (x *PartName) toString2() string {  // Name
    return fmt.Sprintf("%v", x.Name)
}



func (x *PartName) Write(p thrift.Format) error {
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

func (x *PartName) Read(p thrift.Format) error {
    if _, err := p.ReadStructBegin(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T read error: ", x), err)
    }

    for {
        _, wireType, id, err := p.ReadFieldBegin()
        if err != nil {
            return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", x, id), err)
        }

        if wireType == thrift.STOP {
            break;
        }

        switch {
        case (id == 1 && wireType == thrift.Type(thrift.I32)):  // InventoryId
            if err := x.readField1(p); err != nil {
                return err
            }
        case (id == 2 && wireType == thrift.Type(thrift.STRING)):  // Name
            if err := x.readField2(p); err != nil {
                return err
            }
        default:
            if err := p.Skip(wireType); err != nil {
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

func (x *PartName) String() string {
    if x == nil {
        return "<nil>"
    }

    var sb strings.Builder

    sb.WriteString("PartName({")
    sb.WriteString(fmt.Sprintf("InventoryId:%s ", x.toString1()))
    sb.WriteString(fmt.Sprintf("Name:%s", x.toString2()))
    sb.WriteString("})")

    return sb.String()
}

// RegisterTypes registers types found in this file that have a thrift_uri with the passed in registry.
func RegisterTypes(registry interface {
  RegisterType(name string, initializer func() any)
}) {

}
