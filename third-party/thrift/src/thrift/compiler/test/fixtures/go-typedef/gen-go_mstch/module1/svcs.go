// @generated by Thrift for [[[ program path ]]]
// This file is probably not the place you want to edit!

package module1 // [[[ program thrift source path ]]]


import (
    "context"
    "fmt"

    module0 "module0"

    "thrift/lib/go/thrift"
)

var _ = module0.GoUnusedProtection__

// (needed to ensure safety because of naive import list construction)
var _ = context.Background
var _ = fmt.Printf
var _ = thrift.ZERO



type Finder interface {
    ByPlate(ctx context.Context, plate Plate) (*Automobile, error)
    AliasByPlate(ctx context.Context, plate Plate) (*Car, error)
    PreviousPlate(ctx context.Context, plate Plate) (Plate, error)
}

// Deprecated: Use Finder instead.
type FinderClientInterface interface {
    thrift.ClientInterface
    ByPlate(plate Plate) (*Automobile, error)
    AliasByPlate(plate Plate) (*Car, error)
    PreviousPlate(plate Plate) (Plate, error)
}

type FinderChannelClient struct {
    ch thrift.RequestChannel
}
// Compile time interface enforcer
var _ Finder = &FinderChannelClient{}

func NewFinderChannelClient(channel thrift.RequestChannel) *FinderChannelClient {
    return &FinderChannelClient{
        ch: channel,
    }
}

func (c *FinderChannelClient) Close() error {
    return c.ch.Close()
}

func (c *FinderChannelClient) IsOpen() bool {
    return c.ch.IsOpen()
}

func (c *FinderChannelClient) Open() error {
    return c.ch.Open()
}

// Deprecated: Use FinderChannelClient instead.
type FinderClient struct {
    chClient *FinderChannelClient
}
// Compile time interface enforcer
var _ FinderClientInterface = &FinderClient{}

// Deprecated: Use NewFinderChannelClient() instead.
func NewFinderClient(t thrift.Transport, iprot thrift.Protocol, oprot thrift.Protocol) *FinderClient {
    return &FinderClient{
        chClient: NewFinderChannelClient(
            thrift.NewSerialChannel(iprot),
        ),
    }
}

func (c *FinderClient) Close() error {
    return c.chClient.Close()
}

func (c *FinderClient) IsOpen() bool {
    return c.chClient.IsOpen()
}

func (c *FinderClient) Open() error {
    return c.chClient.Open()
}

// Deprecated: Use FinderChannelClient instead.
type FinderThreadsafeClient = FinderClient

// Deprecated: Use NewFinderChannelClient() instead.
func NewFinderThreadsafeClient(t thrift.Transport, iprot thrift.Protocol, oprot thrift.Protocol) *FinderThreadsafeClient {
    return NewFinderClient(t, iprot, oprot)
}

// Deprecated: Use NewFinderChannelClient() instead.
func NewFinderClientProtocol(prot thrift.Protocol) *FinderClient {
  return NewFinderClient(prot.Transport(), prot, prot)
}

// Deprecated: Use NewFinderChannelClient() instead.
func NewFinderThreadsafeClientProtocol(prot thrift.Protocol) *FinderClient {
  return NewFinderClient(prot.Transport(), prot, prot)
}

// Deprecated: Use NewFinderChannelClient() instead.
func NewFinderClientFactory(t thrift.Transport, pf thrift.ProtocolFactory) *FinderClient {
  iprot := pf.GetProtocol(t)
  oprot := pf.GetProtocol(t)
  return NewFinderClient(t, iprot, oprot)
}

// Deprecated: Use NewFinderChannelClient() instead.
func NewFinderThreadsafeClientFactory(t thrift.Transport, pf thrift.ProtocolFactory) *FinderThreadsafeClient {
  return NewFinderClientFactory(t, pf)
}


func (c *FinderChannelClient) ByPlate(ctx context.Context, plate Plate) (*Automobile, error) {
    in := &reqFinderByPlate{
        Plate: plate,
    }
    out := newRespFinderByPlate()
    err := c.ch.Call(ctx, "byPlate", in, out)
    if err != nil {
        return out.Value, err
    }
    return out.Value, nil
}

func (c *FinderClient) ByPlate(plate Plate) (*Automobile, error) {
    return c.chClient.ByPlate(nil, plate)
}


func (c *FinderChannelClient) AliasByPlate(ctx context.Context, plate Plate) (*Car, error) {
    in := &reqFinderAliasByPlate{
        Plate: plate,
    }
    out := newRespFinderAliasByPlate()
    err := c.ch.Call(ctx, "aliasByPlate", in, out)
    if err != nil {
        return out.Value, err
    }
    return out.Value, nil
}

func (c *FinderClient) AliasByPlate(plate Plate) (*Car, error) {
    return c.chClient.AliasByPlate(nil, plate)
}


func (c *FinderChannelClient) PreviousPlate(ctx context.Context, plate Plate) (Plate, error) {
    in := &reqFinderPreviousPlate{
        Plate: plate,
    }
    out := newRespFinderPreviousPlate()
    err := c.ch.Call(ctx, "previousPlate", in, out)
    if err != nil {
        return out.Value, err
    }
    return out.Value, nil
}

func (c *FinderClient) PreviousPlate(plate Plate) (Plate, error) {
    return c.chClient.PreviousPlate(nil, plate)
}


type reqFinderByPlate struct {
    Plate Plate `thrift:"plate,1" json:"plate" db:"plate"`
}
// Compile time interface enforcer
var _ thrift.Struct = &reqFinderByPlate{}


func newReqFinderByPlate() *reqFinderByPlate {
    return (&reqFinderByPlate{})
}

func (x *reqFinderByPlate) GetPlateNonCompat() Plate {
    return x.Plate
}

func (x *reqFinderByPlate) GetPlate() Plate {
    return x.Plate
}

func (x *reqFinderByPlate) SetPlate(value Plate) *reqFinderByPlate {
    x.Plate = value
    return x
}


func (x *reqFinderByPlate) writeField1(p thrift.Protocol) error {  // Plate
    if err := p.WriteFieldBegin("plate", thrift.STRING, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetPlateNonCompat()
    err := WritePlate(item, p)
if err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *reqFinderByPlate) readField1(p thrift.Protocol) error {  // Plate
    result, err := ReadPlate(p)
if err != nil {
    return err
}

    x.SetPlate(result)
    return nil
}

func (x *reqFinderByPlate) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use reqFinderByPlate.Set* methods instead or set the fields directly.
type reqFinderByPlateBuilder struct {
    obj *reqFinderByPlate
}

func newReqFinderByPlateBuilder() *reqFinderByPlateBuilder {
    return &reqFinderByPlateBuilder{
        obj: newReqFinderByPlate(),
    }
}

func (x *reqFinderByPlateBuilder) Plate(value Plate) *reqFinderByPlateBuilder {
    x.obj.Plate = value
    return x
}

func (x *reqFinderByPlateBuilder) Emit() *reqFinderByPlate {
    var objCopy reqFinderByPlate = *x.obj
    return &objCopy
}

func (x *reqFinderByPlate) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("reqFinderByPlate"); err != nil {
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

func (x *reqFinderByPlate) Read(p thrift.Protocol) error {
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
        case 1:  // plate
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

type respFinderByPlate struct {
    Value *Automobile `thrift:"value,0" json:"value" db:"value"`
}
// Compile time interface enforcer
var _ thrift.Struct = &respFinderByPlate{}
var _ thrift.WritableResult = &respFinderByPlate{}


func newRespFinderByPlate() *respFinderByPlate {
    return (&respFinderByPlate{})
}

// Deprecated: Use newRespFinderByPlate().Value instead.
var respFinderByPlate_Value_DEFAULT = newRespFinderByPlate().Value

func (x *respFinderByPlate) GetValueNonCompat() *Automobile {
    return x.Value
}

func (x *respFinderByPlate) GetValue() *Automobile {
    if !x.IsSetValue() {
      return NewAutomobile()
    }

    return x.Value
}

func (x *respFinderByPlate) SetValue(value Automobile) *respFinderByPlate {
    x.Value = &value
    return x
}

func (x *respFinderByPlate) IsSetValue() bool {
    return x.Value != nil
}

func (x *respFinderByPlate) writeField0(p thrift.Protocol) error {  // Value
    if !x.IsSetValue() {
        return nil
    }

    if err := p.WriteFieldBegin("value", thrift.STRUCT, 0); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetValueNonCompat()
    if err := item.Write(p); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *respFinderByPlate) readField0(p thrift.Protocol) error {  // Value
    result := *NewAutomobile()
err := result.Read(p)
if err != nil {
    return err
}

    x.SetValue(result)
    return nil
}

func (x *respFinderByPlate) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use respFinderByPlate.Set* methods instead or set the fields directly.
type respFinderByPlateBuilder struct {
    obj *respFinderByPlate
}

func newRespFinderByPlateBuilder() *respFinderByPlateBuilder {
    return &respFinderByPlateBuilder{
        obj: newRespFinderByPlate(),
    }
}

func (x *respFinderByPlateBuilder) Value(value *Automobile) *respFinderByPlateBuilder {
    x.obj.Value = value
    return x
}

func (x *respFinderByPlateBuilder) Emit() *respFinderByPlate {
    var objCopy respFinderByPlate = *x.obj
    return &objCopy
}

func (x *respFinderByPlate) Exception() thrift.WritableException {
    return nil
}

func (x *respFinderByPlate) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("respFinderByPlate"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := x.writeField0(p); err != nil {
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

func (x *respFinderByPlate) Read(p thrift.Protocol) error {
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
        case 0:  // value
            if err := x.readField0(p); err != nil {
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

type reqFinderAliasByPlate struct {
    Plate Plate `thrift:"plate,1" json:"plate" db:"plate"`
}
// Compile time interface enforcer
var _ thrift.Struct = &reqFinderAliasByPlate{}


func newReqFinderAliasByPlate() *reqFinderAliasByPlate {
    return (&reqFinderAliasByPlate{})
}

func (x *reqFinderAliasByPlate) GetPlateNonCompat() Plate {
    return x.Plate
}

func (x *reqFinderAliasByPlate) GetPlate() Plate {
    return x.Plate
}

func (x *reqFinderAliasByPlate) SetPlate(value Plate) *reqFinderAliasByPlate {
    x.Plate = value
    return x
}


func (x *reqFinderAliasByPlate) writeField1(p thrift.Protocol) error {  // Plate
    if err := p.WriteFieldBegin("plate", thrift.STRING, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetPlateNonCompat()
    err := WritePlate(item, p)
if err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *reqFinderAliasByPlate) readField1(p thrift.Protocol) error {  // Plate
    result, err := ReadPlate(p)
if err != nil {
    return err
}

    x.SetPlate(result)
    return nil
}

func (x *reqFinderAliasByPlate) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use reqFinderAliasByPlate.Set* methods instead or set the fields directly.
type reqFinderAliasByPlateBuilder struct {
    obj *reqFinderAliasByPlate
}

func newReqFinderAliasByPlateBuilder() *reqFinderAliasByPlateBuilder {
    return &reqFinderAliasByPlateBuilder{
        obj: newReqFinderAliasByPlate(),
    }
}

func (x *reqFinderAliasByPlateBuilder) Plate(value Plate) *reqFinderAliasByPlateBuilder {
    x.obj.Plate = value
    return x
}

func (x *reqFinderAliasByPlateBuilder) Emit() *reqFinderAliasByPlate {
    var objCopy reqFinderAliasByPlate = *x.obj
    return &objCopy
}

func (x *reqFinderAliasByPlate) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("reqFinderAliasByPlate"); err != nil {
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

func (x *reqFinderAliasByPlate) Read(p thrift.Protocol) error {
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
        case 1:  // plate
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

type respFinderAliasByPlate struct {
    Value *Car `thrift:"value,0" json:"value" db:"value"`
}
// Compile time interface enforcer
var _ thrift.Struct = &respFinderAliasByPlate{}
var _ thrift.WritableResult = &respFinderAliasByPlate{}


func newRespFinderAliasByPlate() *respFinderAliasByPlate {
    return (&respFinderAliasByPlate{})
}

// Deprecated: Use newRespFinderAliasByPlate().Value instead.
var respFinderAliasByPlate_Value_DEFAULT = newRespFinderAliasByPlate().Value

func (x *respFinderAliasByPlate) GetValueNonCompat() *Car {
    return x.Value
}

func (x *respFinderAliasByPlate) GetValue() *Car {
    if !x.IsSetValue() {
      return NewCar()
    }

    return x.Value
}

func (x *respFinderAliasByPlate) SetValue(value Car) *respFinderAliasByPlate {
    x.Value = &value
    return x
}

func (x *respFinderAliasByPlate) IsSetValue() bool {
    return x.Value != nil
}

func (x *respFinderAliasByPlate) writeField0(p thrift.Protocol) error {  // Value
    if !x.IsSetValue() {
        return nil
    }

    if err := p.WriteFieldBegin("value", thrift.STRUCT, 0); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetValueNonCompat()
    err := WriteCar(item, p)
if err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *respFinderAliasByPlate) readField0(p thrift.Protocol) error {  // Value
    result, err := ReadCar(p)
if err != nil {
    return err
}

    x.SetValue(result)
    return nil
}

func (x *respFinderAliasByPlate) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use respFinderAliasByPlate.Set* methods instead or set the fields directly.
type respFinderAliasByPlateBuilder struct {
    obj *respFinderAliasByPlate
}

func newRespFinderAliasByPlateBuilder() *respFinderAliasByPlateBuilder {
    return &respFinderAliasByPlateBuilder{
        obj: newRespFinderAliasByPlate(),
    }
}

func (x *respFinderAliasByPlateBuilder) Value(value *Car) *respFinderAliasByPlateBuilder {
    x.obj.Value = value
    return x
}

func (x *respFinderAliasByPlateBuilder) Emit() *respFinderAliasByPlate {
    var objCopy respFinderAliasByPlate = *x.obj
    return &objCopy
}

func (x *respFinderAliasByPlate) Exception() thrift.WritableException {
    return nil
}

func (x *respFinderAliasByPlate) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("respFinderAliasByPlate"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := x.writeField0(p); err != nil {
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

func (x *respFinderAliasByPlate) Read(p thrift.Protocol) error {
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
        case 0:  // value
            if err := x.readField0(p); err != nil {
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

type reqFinderPreviousPlate struct {
    Plate Plate `thrift:"plate,1" json:"plate" db:"plate"`
}
// Compile time interface enforcer
var _ thrift.Struct = &reqFinderPreviousPlate{}


func newReqFinderPreviousPlate() *reqFinderPreviousPlate {
    return (&reqFinderPreviousPlate{})
}

func (x *reqFinderPreviousPlate) GetPlateNonCompat() Plate {
    return x.Plate
}

func (x *reqFinderPreviousPlate) GetPlate() Plate {
    return x.Plate
}

func (x *reqFinderPreviousPlate) SetPlate(value Plate) *reqFinderPreviousPlate {
    x.Plate = value
    return x
}


func (x *reqFinderPreviousPlate) writeField1(p thrift.Protocol) error {  // Plate
    if err := p.WriteFieldBegin("plate", thrift.STRING, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetPlateNonCompat()
    err := WritePlate(item, p)
if err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *reqFinderPreviousPlate) readField1(p thrift.Protocol) error {  // Plate
    result, err := ReadPlate(p)
if err != nil {
    return err
}

    x.SetPlate(result)
    return nil
}

func (x *reqFinderPreviousPlate) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use reqFinderPreviousPlate.Set* methods instead or set the fields directly.
type reqFinderPreviousPlateBuilder struct {
    obj *reqFinderPreviousPlate
}

func newReqFinderPreviousPlateBuilder() *reqFinderPreviousPlateBuilder {
    return &reqFinderPreviousPlateBuilder{
        obj: newReqFinderPreviousPlate(),
    }
}

func (x *reqFinderPreviousPlateBuilder) Plate(value Plate) *reqFinderPreviousPlateBuilder {
    x.obj.Plate = value
    return x
}

func (x *reqFinderPreviousPlateBuilder) Emit() *reqFinderPreviousPlate {
    var objCopy reqFinderPreviousPlate = *x.obj
    return &objCopy
}

func (x *reqFinderPreviousPlate) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("reqFinderPreviousPlate"); err != nil {
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

func (x *reqFinderPreviousPlate) Read(p thrift.Protocol) error {
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
        case 1:  // plate
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

type respFinderPreviousPlate struct {
    Value Plate `thrift:"value,0" json:"value" db:"value"`
}
// Compile time interface enforcer
var _ thrift.Struct = &respFinderPreviousPlate{}
var _ thrift.WritableResult = &respFinderPreviousPlate{}


func newRespFinderPreviousPlate() *respFinderPreviousPlate {
    return (&respFinderPreviousPlate{})
}

func (x *respFinderPreviousPlate) GetValueNonCompat() Plate {
    return x.Value
}

func (x *respFinderPreviousPlate) GetValue() Plate {
    return x.Value
}

func (x *respFinderPreviousPlate) SetValue(value Plate) *respFinderPreviousPlate {
    x.Value = value
    return x
}


func (x *respFinderPreviousPlate) writeField0(p thrift.Protocol) error {  // Value
    if err := p.WriteFieldBegin("value", thrift.STRING, 0); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetValueNonCompat()
    err := WritePlate(item, p)
if err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *respFinderPreviousPlate) readField0(p thrift.Protocol) error {  // Value
    result, err := ReadPlate(p)
if err != nil {
    return err
}

    x.SetValue(result)
    return nil
}

func (x *respFinderPreviousPlate) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use respFinderPreviousPlate.Set* methods instead or set the fields directly.
type respFinderPreviousPlateBuilder struct {
    obj *respFinderPreviousPlate
}

func newRespFinderPreviousPlateBuilder() *respFinderPreviousPlateBuilder {
    return &respFinderPreviousPlateBuilder{
        obj: newRespFinderPreviousPlate(),
    }
}

func (x *respFinderPreviousPlateBuilder) Value(value Plate) *respFinderPreviousPlateBuilder {
    x.obj.Value = value
    return x
}

func (x *respFinderPreviousPlateBuilder) Emit() *respFinderPreviousPlate {
    var objCopy respFinderPreviousPlate = *x.obj
    return &objCopy
}

func (x *respFinderPreviousPlate) Exception() thrift.WritableException {
    return nil
}

func (x *respFinderPreviousPlate) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("respFinderPreviousPlate"); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write struct begin error: ", x), err)
    }

    if err := x.writeField0(p); err != nil {
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

func (x *respFinderPreviousPlate) Read(p thrift.Protocol) error {
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
        case 0:  // value
            if err := x.readField0(p); err != nil {
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



type FinderProcessor struct {
    processorMap       map[string]thrift.ProcessorFunction
    functionServiceMap map[string]string
    handler            Finder
}
// Compile time interface enforcer
var _ thrift.Processor = &FinderProcessor{}

func (p *FinderProcessor) AddToProcessorMap(key string, processor thrift.ProcessorFunction) {
    p.processorMap[key] = processor
}

func (p *FinderProcessor) AddToFunctionServiceMap(key, service string) {
    p.functionServiceMap[key] = service
}

func (p *FinderProcessor) GetProcessorFunction(key string) (processor thrift.ProcessorFunction, err error) {
    if processor, ok := p.processorMap[key]; ok {
        return processor, nil
    }
    return nil, nil
}

func (p *FinderProcessor) ProcessorMap() map[string]thrift.ProcessorFunction {
    return p.processorMap
}

func (p *FinderProcessor) FunctionServiceMap() map[string]string {
    return p.functionServiceMap
}

func NewFinderProcessor(handler Finder) *FinderProcessor {
    p := &FinderProcessor{
        handler:            handler,
        processorMap:       make(map[string]thrift.ProcessorFunction),
        functionServiceMap: make(map[string]string),
    }
    p.AddToProcessorMap("byPlate", &procFuncFinderByPlate{handler: handler})
    p.AddToProcessorMap("aliasByPlate", &procFuncFinderAliasByPlate{handler: handler})
    p.AddToProcessorMap("previousPlate", &procFuncFinderPreviousPlate{handler: handler})
    p.AddToFunctionServiceMap("byPlate", "Finder")
    p.AddToFunctionServiceMap("aliasByPlate", "Finder")
    p.AddToFunctionServiceMap("previousPlate", "Finder")

    return p
}


type procFuncFinderByPlate struct {
    handler Finder
}
// Compile time interface enforcer
var _ thrift.ProcessorFunction = &procFuncFinderByPlate{}

func (p *procFuncFinderByPlate) Read(iprot thrift.Protocol) (thrift.Struct, thrift.Exception) {
    args := newReqFinderByPlate()
    if err := args.Read(iprot); err != nil {
        return nil, err
    }
    iprot.ReadMessageEnd()
    return args, nil
}

func (p *procFuncFinderByPlate) Write(seqId int32, result thrift.WritableStruct, oprot thrift.Protocol) (err thrift.Exception) {
    var err2 error
    messageType := thrift.REPLY
    switch result.(type) {
    case thrift.ApplicationException:
        messageType = thrift.EXCEPTION
    }

    if err2 = oprot.WriteMessageBegin("ByPlate", messageType, seqId); err2 != nil {
        err = err2
    }
    if err2 = result.Write(oprot); err == nil && err2 != nil {
        err = err2
    }
    if err2 = oprot.WriteMessageEnd(); err == nil && err2 != nil {
        err = err2
    }
    if err2 = oprot.Flush(); err == nil && err2 != nil {
        err = err2
    }
    return err
}

func (p *procFuncFinderByPlate) Run(reqStruct thrift.Struct) (thrift.WritableStruct, thrift.ApplicationException) {
    args := reqStruct.(*reqFinderByPlate)
    result := newRespFinderByPlate()
    retval, err := p.handler.ByPlate(args.Plate)
    if err != nil {
        x := thrift.NewApplicationExceptionCause(thrift.INTERNAL_ERROR, "Internal error processing ByPlate: " + err.Error(), err)
        return x, x
    }

    result.Value = retval
    return result, nil
}


type procFuncFinderAliasByPlate struct {
    handler Finder
}
// Compile time interface enforcer
var _ thrift.ProcessorFunction = &procFuncFinderAliasByPlate{}

func (p *procFuncFinderAliasByPlate) Read(iprot thrift.Protocol) (thrift.Struct, thrift.Exception) {
    args := newReqFinderAliasByPlate()
    if err := args.Read(iprot); err != nil {
        return nil, err
    }
    iprot.ReadMessageEnd()
    return args, nil
}

func (p *procFuncFinderAliasByPlate) Write(seqId int32, result thrift.WritableStruct, oprot thrift.Protocol) (err thrift.Exception) {
    var err2 error
    messageType := thrift.REPLY
    switch result.(type) {
    case thrift.ApplicationException:
        messageType = thrift.EXCEPTION
    }

    if err2 = oprot.WriteMessageBegin("AliasByPlate", messageType, seqId); err2 != nil {
        err = err2
    }
    if err2 = result.Write(oprot); err == nil && err2 != nil {
        err = err2
    }
    if err2 = oprot.WriteMessageEnd(); err == nil && err2 != nil {
        err = err2
    }
    if err2 = oprot.Flush(); err == nil && err2 != nil {
        err = err2
    }
    return err
}

func (p *procFuncFinderAliasByPlate) Run(reqStruct thrift.Struct) (thrift.WritableStruct, thrift.ApplicationException) {
    args := reqStruct.(*reqFinderAliasByPlate)
    result := newRespFinderAliasByPlate()
    retval, err := p.handler.AliasByPlate(args.Plate)
    if err != nil {
        x := thrift.NewApplicationExceptionCause(thrift.INTERNAL_ERROR, "Internal error processing AliasByPlate: " + err.Error(), err)
        return x, x
    }

    result.Value = retval
    return result, nil
}


type procFuncFinderPreviousPlate struct {
    handler Finder
}
// Compile time interface enforcer
var _ thrift.ProcessorFunction = &procFuncFinderPreviousPlate{}

func (p *procFuncFinderPreviousPlate) Read(iprot thrift.Protocol) (thrift.Struct, thrift.Exception) {
    args := newReqFinderPreviousPlate()
    if err := args.Read(iprot); err != nil {
        return nil, err
    }
    iprot.ReadMessageEnd()
    return args, nil
}

func (p *procFuncFinderPreviousPlate) Write(seqId int32, result thrift.WritableStruct, oprot thrift.Protocol) (err thrift.Exception) {
    var err2 error
    messageType := thrift.REPLY
    switch result.(type) {
    case thrift.ApplicationException:
        messageType = thrift.EXCEPTION
    }

    if err2 = oprot.WriteMessageBegin("PreviousPlate", messageType, seqId); err2 != nil {
        err = err2
    }
    if err2 = result.Write(oprot); err == nil && err2 != nil {
        err = err2
    }
    if err2 = oprot.WriteMessageEnd(); err == nil && err2 != nil {
        err = err2
    }
    if err2 = oprot.Flush(); err == nil && err2 != nil {
        err = err2
    }
    return err
}

func (p *procFuncFinderPreviousPlate) Run(reqStruct thrift.Struct) (thrift.WritableStruct, thrift.ApplicationException) {
    args := reqStruct.(*reqFinderPreviousPlate)
    result := newRespFinderPreviousPlate()
    retval, err := p.handler.PreviousPlate(args.Plate)
    if err != nil {
        x := thrift.NewApplicationExceptionCause(thrift.INTERNAL_ERROR, "Internal error processing PreviousPlate: " + err.Error(), err)
        return x, x
    }

    result.Value = retval
    return result, nil
}


