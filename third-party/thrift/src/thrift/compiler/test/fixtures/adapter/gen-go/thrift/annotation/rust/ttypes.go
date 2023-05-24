// Autogenerated by Thrift Compiler (facebook)
// DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
// @generated

package rust

import (
	"bytes"
	"context"
	"sync"
	"fmt"
	thrift "github.com/facebook/fbthrift/thrift/lib/go/thrift"
)

// (needed to ensure safety because of naive import list construction.)
var _ = thrift.ZERO
var _ = fmt.Printf
var _ = sync.Mutex{}
var _ = bytes.Equal
var _ = context.Background

var GoUnusedProtection__ int;

// Attributes:
//  - Name
type Adapter struct {
  Name string `thrift:"name,1" db:"name" json:"name"`
}

func NewAdapter() *Adapter {
  return &Adapter{}
}


func (p *Adapter) GetName() string {
  return p.Name
}
type AdapterBuilder struct {
  obj *Adapter
}

func NewAdapterBuilder() *AdapterBuilder{
  return &AdapterBuilder{
    obj: NewAdapter(),
  }
}

func (p AdapterBuilder) Emit() *Adapter{
  return &Adapter{
    Name: p.obj.Name,
  }
}

func (a *AdapterBuilder) Name(name string) *AdapterBuilder {
  a.obj.Name = name
  return a
}

func (a *Adapter) SetName(name string) *Adapter {
  a.Name = name
  return a
}

func (p *Adapter) Read(iprot thrift.Protocol) error {
  if _, err := iprot.ReadStructBegin(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T read error: ", p), err)
  }


  for {
    _, fieldTypeId, fieldId, err := iprot.ReadFieldBegin()
    if err != nil {
      return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", p, fieldId), err)
    }
    if fieldTypeId == thrift.STOP { break; }
    switch fieldId {
    case 1:
      if err := p.ReadField1(iprot); err != nil {
        return err
      }
    default:
      if err := iprot.Skip(fieldTypeId); err != nil {
        return err
      }
    }
    if err := iprot.ReadFieldEnd(); err != nil {
      return err
    }
  }
  if err := iprot.ReadStructEnd(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T read struct end error: ", p), err)
  }
  return nil
}

func (p *Adapter)  ReadField1(iprot thrift.Protocol) error {
  if v, err := iprot.ReadString(); err != nil {
    return thrift.PrependError("error reading field 1: ", err)
  } else {
    p.Name = v
  }
  return nil
}

func (p *Adapter) Write(oprot thrift.Protocol) error {
  if err := oprot.WriteStructBegin("Adapter"); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", p), err) }
  if err := p.writeField1(oprot); err != nil { return err }
  if err := oprot.WriteFieldStop(); err != nil {
    return thrift.PrependError("write field stop error: ", err) }
  if err := oprot.WriteStructEnd(); err != nil {
    return thrift.PrependError("write struct stop error: ", err) }
  return nil
}

func (p *Adapter) writeField1(oprot thrift.Protocol) (err error) {
  if err := oprot.WriteFieldBegin("name", thrift.STRING, 1); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write field begin error 1:name: ", p), err) }
  if err := oprot.WriteString(string(p.Name)); err != nil {
  return thrift.PrependError(fmt.Sprintf("%T.name (1) field write error: ", p), err) }
  if err := oprot.WriteFieldEnd(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write field end error 1:name: ", p), err) }
  return err
}

func (p *Adapter) String() string {
  if p == nil {
    return "<nil>"
  }

  nameVal := fmt.Sprintf("%v", p.Name)
  return fmt.Sprintf("Adapter({Name:%s})", nameVal)
}

// Attributes:
//  - Derives
type Derive struct {
  Derives []string `thrift:"derives,1" db:"derives" json:"derives"`
}

func NewDerive() *Derive {
  return &Derive{}
}


func (p *Derive) GetDerives() []string {
  return p.Derives
}
type DeriveBuilder struct {
  obj *Derive
}

func NewDeriveBuilder() *DeriveBuilder{
  return &DeriveBuilder{
    obj: NewDerive(),
  }
}

func (p DeriveBuilder) Emit() *Derive{
  return &Derive{
    Derives: p.obj.Derives,
  }
}

func (d *DeriveBuilder) Derives(derives []string) *DeriveBuilder {
  d.obj.Derives = derives
  return d
}

func (d *Derive) SetDerives(derives []string) *Derive {
  d.Derives = derives
  return d
}

func (p *Derive) Read(iprot thrift.Protocol) error {
  if _, err := iprot.ReadStructBegin(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T read error: ", p), err)
  }


  for {
    _, fieldTypeId, fieldId, err := iprot.ReadFieldBegin()
    if err != nil {
      return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", p, fieldId), err)
    }
    if fieldTypeId == thrift.STOP { break; }
    switch fieldId {
    case 1:
      if err := p.ReadField1(iprot); err != nil {
        return err
      }
    default:
      if err := iprot.Skip(fieldTypeId); err != nil {
        return err
      }
    }
    if err := iprot.ReadFieldEnd(); err != nil {
      return err
    }
  }
  if err := iprot.ReadStructEnd(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T read struct end error: ", p), err)
  }
  return nil
}

func (p *Derive)  ReadField1(iprot thrift.Protocol) error {
  _, size, err := iprot.ReadListBegin()
  if err != nil {
    return thrift.PrependError("error reading list begin: ", err)
  }
  tSlice := make([]string, 0, size)
  p.Derives =  tSlice
  for i := 0; i < size; i ++ {
    var _elem0 string
    if v, err := iprot.ReadString(); err != nil {
      return thrift.PrependError("error reading field 0: ", err)
    } else {
      _elem0 = v
    }
    p.Derives = append(p.Derives, _elem0)
  }
  if err := iprot.ReadListEnd(); err != nil {
    return thrift.PrependError("error reading list end: ", err)
  }
  return nil
}

func (p *Derive) Write(oprot thrift.Protocol) error {
  if err := oprot.WriteStructBegin("Derive"); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", p), err) }
  if err := p.writeField1(oprot); err != nil { return err }
  if err := oprot.WriteFieldStop(); err != nil {
    return thrift.PrependError("write field stop error: ", err) }
  if err := oprot.WriteStructEnd(); err != nil {
    return thrift.PrependError("write struct stop error: ", err) }
  return nil
}

func (p *Derive) writeField1(oprot thrift.Protocol) (err error) {
  if err := oprot.WriteFieldBegin("derives", thrift.LIST, 1); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write field begin error 1:derives: ", p), err) }
  if err := oprot.WriteListBegin(thrift.STRING, len(p.Derives)); err != nil {
    return thrift.PrependError("error writing list begin: ", err)
  }
  for _, v := range p.Derives {
    if err := oprot.WriteString(string(v)); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T. (0) field write error: ", p), err) }
  }
  if err := oprot.WriteListEnd(); err != nil {
    return thrift.PrependError("error writing list end: ", err)
  }
  if err := oprot.WriteFieldEnd(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write field end error 1:derives: ", p), err) }
  return err
}

func (p *Derive) String() string {
  if p == nil {
    return "<nil>"
  }

  derivesVal := fmt.Sprintf("%v", p.Derives)
  return fmt.Sprintf("Derive({Derives:%s})", derivesVal)
}

// Attributes:
//  - AnyhowToApplicationExn
type ServiceExn struct {
  AnyhowToApplicationExn bool `thrift:"anyhow_to_application_exn,1" db:"anyhow_to_application_exn" json:"anyhow_to_application_exn"`
}

func NewServiceExn() *ServiceExn {
  return &ServiceExn{}
}


func (p *ServiceExn) GetAnyhowToApplicationExn() bool {
  return p.AnyhowToApplicationExn
}
type ServiceExnBuilder struct {
  obj *ServiceExn
}

func NewServiceExnBuilder() *ServiceExnBuilder{
  return &ServiceExnBuilder{
    obj: NewServiceExn(),
  }
}

func (p ServiceExnBuilder) Emit() *ServiceExn{
  return &ServiceExn{
    AnyhowToApplicationExn: p.obj.AnyhowToApplicationExn,
  }
}

func (s *ServiceExnBuilder) AnyhowToApplicationExn(anyhowToApplicationExn bool) *ServiceExnBuilder {
  s.obj.AnyhowToApplicationExn = anyhowToApplicationExn
  return s
}

func (s *ServiceExn) SetAnyhowToApplicationExn(anyhowToApplicationExn bool) *ServiceExn {
  s.AnyhowToApplicationExn = anyhowToApplicationExn
  return s
}

func (p *ServiceExn) Read(iprot thrift.Protocol) error {
  if _, err := iprot.ReadStructBegin(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T read error: ", p), err)
  }


  for {
    _, fieldTypeId, fieldId, err := iprot.ReadFieldBegin()
    if err != nil {
      return thrift.PrependError(fmt.Sprintf("%T field %d read error: ", p, fieldId), err)
    }
    if fieldTypeId == thrift.STOP { break; }
    switch fieldId {
    case 1:
      if err := p.ReadField1(iprot); err != nil {
        return err
      }
    default:
      if err := iprot.Skip(fieldTypeId); err != nil {
        return err
      }
    }
    if err := iprot.ReadFieldEnd(); err != nil {
      return err
    }
  }
  if err := iprot.ReadStructEnd(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T read struct end error: ", p), err)
  }
  return nil
}

func (p *ServiceExn)  ReadField1(iprot thrift.Protocol) error {
  if v, err := iprot.ReadBool(); err != nil {
    return thrift.PrependError("error reading field 1: ", err)
  } else {
    p.AnyhowToApplicationExn = v
  }
  return nil
}

func (p *ServiceExn) Write(oprot thrift.Protocol) error {
  if err := oprot.WriteStructBegin("ServiceExn"); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", p), err) }
  if err := p.writeField1(oprot); err != nil { return err }
  if err := oprot.WriteFieldStop(); err != nil {
    return thrift.PrependError("write field stop error: ", err) }
  if err := oprot.WriteStructEnd(); err != nil {
    return thrift.PrependError("write struct stop error: ", err) }
  return nil
}

func (p *ServiceExn) writeField1(oprot thrift.Protocol) (err error) {
  if err := oprot.WriteFieldBegin("anyhow_to_application_exn", thrift.BOOL, 1); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write field begin error 1:anyhow_to_application_exn: ", p), err) }
  if err := oprot.WriteBool(bool(p.AnyhowToApplicationExn)); err != nil {
  return thrift.PrependError(fmt.Sprintf("%T.anyhow_to_application_exn (1) field write error: ", p), err) }
  if err := oprot.WriteFieldEnd(); err != nil {
    return thrift.PrependError(fmt.Sprintf("%T write field end error 1:anyhow_to_application_exn: ", p), err) }
  return err
}

func (p *ServiceExn) String() string {
  if p == nil {
    return "<nil>"
  }

  anyhowToApplicationExnVal := fmt.Sprintf("%v", p.AnyhowToApplicationExn)
  return fmt.Sprintf("ServiceExn({AnyhowToApplicationExn:%s})", anyhowToApplicationExnVal)
}

