// @generated by Thrift for [[[ program path ]]]
// This file is probably not the place you want to edit!

package module // [[[ program thrift source path ]]]


import (
    "context"
    "fmt"


    "thrift/lib/go/thrift"
)


// (needed to ensure safety because of naive import list construction)
var _ = context.Background
var _ = fmt.Printf
var _ = thrift.ZERO



type TestService interface {
    Init(ctx context.Context, int1 int64) (int64, error)
}

// Deprecated: Use TestService instead.
type TestServiceClientInterface interface {
    thrift.ClientInterface
    Init(int1 int64) (int64, error)
}

type TestServiceChannelClient struct {
    ch thrift.RequestChannel
}
// Compile time interface enforcer
var _ TestService = &TestServiceChannelClient{}

func NewTestServiceChannelClient(channel thrift.RequestChannel) *TestServiceChannelClient {
    return &TestServiceChannelClient{
        ch: channel,
    }
}

func (c *TestServiceChannelClient) Close() error {
    return c.ch.Close()
}

func (c *TestServiceChannelClient) IsOpen() bool {
    return c.ch.IsOpen()
}

func (c *TestServiceChannelClient) Open() error {
    return c.ch.Open()
}

// Deprecated: Use TestServiceChannelClient instead.
type TestServiceClient struct {
    chClient *TestServiceChannelClient
}
// Compile time interface enforcer
var _ TestServiceClientInterface = &TestServiceClient{}

// Deprecated: Use NewTestServiceChannelClient() instead.
func NewTestServiceClient(t thrift.Transport, iprot thrift.Protocol, oprot thrift.Protocol) *TestServiceClient {
    return &TestServiceClient{
        chClient: NewTestServiceChannelClient(
            thrift.NewSerialChannel(iprot),
        ),
    }
}

func (c *TestServiceClient) Close() error {
    return c.chClient.Close()
}

func (c *TestServiceClient) IsOpen() bool {
    return c.chClient.IsOpen()
}

func (c *TestServiceClient) Open() error {
    return c.chClient.Open()
}

// Deprecated: Use TestServiceChannelClient instead.
type TestServiceThreadsafeClient = TestServiceClient

// Deprecated: Use NewTestServiceChannelClient() instead.
func NewTestServiceThreadsafeClient(t thrift.Transport, iprot thrift.Protocol, oprot thrift.Protocol) *TestServiceThreadsafeClient {
    return NewTestServiceClient(t, iprot, oprot)
}

// Deprecated: Use NewTestServiceChannelClient() instead.
func NewTestServiceClientProtocol(prot thrift.Protocol) *TestServiceClient {
  return NewTestServiceClient(prot.Transport(), prot, prot)
}

// Deprecated: Use NewTestServiceChannelClient() instead.
func NewTestServiceThreadsafeClientProtocol(prot thrift.Protocol) *TestServiceClient {
  return NewTestServiceClient(prot.Transport(), prot, prot)
}

// Deprecated: Use NewTestServiceChannelClient() instead.
func NewTestServiceClientFactory(t thrift.Transport, pf thrift.ProtocolFactory) *TestServiceClient {
  iprot := pf.GetProtocol(t)
  oprot := pf.GetProtocol(t)
  return NewTestServiceClient(t, iprot, oprot)
}

// Deprecated: Use NewTestServiceChannelClient() instead.
func NewTestServiceThreadsafeClientFactory(t thrift.Transport, pf thrift.ProtocolFactory) *TestServiceThreadsafeClient {
  return NewTestServiceClientFactory(t, pf)
}


func (c *TestServiceChannelClient) Init(ctx context.Context, int1 int64) (int64, error) {
    in := &reqTestServiceInit{
        Int1: int1,
    }
    out := newRespTestServiceInit()
    err := c.ch.Call(ctx, "init", in, out)
    if err != nil {
        return out.Value, err
    }
    return out.Value, nil
}

func (c *TestServiceClient) Init(int1 int64) (int64, error) {
    return c.chClient.Init(nil, int1)
}


type reqTestServiceInit struct {
    Int1 int64 `thrift:"int1,1" json:"int1" db:"int1"`
}
// Compile time interface enforcer
var _ thrift.Struct = &reqTestServiceInit{}


func newReqTestServiceInit() *reqTestServiceInit {
    return (&reqTestServiceInit{})
}

func (x *reqTestServiceInit) GetInt1NonCompat() int64 {
    return x.Int1
}

func (x *reqTestServiceInit) GetInt1() int64 {
    return x.Int1
}

func (x *reqTestServiceInit) SetInt1(value int64) *reqTestServiceInit {
    x.Int1 = value
    return x
}

func (x *reqTestServiceInit) writeField1(p thrift.Protocol) error {  // Int1
    if err := p.WriteFieldBegin("int1", thrift.I64, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetInt1NonCompat()
    if err := p.WriteI64(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *reqTestServiceInit) readField1(p thrift.Protocol) error {  // Int1
    result, err := p.ReadI64()
if err != nil {
    return err
}

    x.SetInt1(result)
    return nil
}

func (x *reqTestServiceInit) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use reqTestServiceInit.Set* methods instead or set the fields directly.
type reqTestServiceInitBuilder struct {
    obj *reqTestServiceInit
}

func newReqTestServiceInitBuilder() *reqTestServiceInitBuilder {
    return &reqTestServiceInitBuilder{
        obj: newReqTestServiceInit(),
    }
}

func (x *reqTestServiceInitBuilder) Int1(value int64) *reqTestServiceInitBuilder {
    x.obj.Int1 = value
    return x
}

func (x *reqTestServiceInitBuilder) Emit() *reqTestServiceInit {
    var objCopy reqTestServiceInit = *x.obj
    return &objCopy
}

func (x *reqTestServiceInit) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("reqTestServiceInit"); err != nil {
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

func (x *reqTestServiceInit) Read(p thrift.Protocol) error {
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
        case 1:  // int1
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

type respTestServiceInit struct {
    Value int64 `thrift:"value,0" json:"value" db:"value"`
}
// Compile time interface enforcer
var _ thrift.Struct = &respTestServiceInit{}
var _ thrift.WritableResult = &respTestServiceInit{}


func newRespTestServiceInit() *respTestServiceInit {
    return (&respTestServiceInit{})
}

func (x *respTestServiceInit) GetValueNonCompat() int64 {
    return x.Value
}

func (x *respTestServiceInit) GetValue() int64 {
    return x.Value
}

func (x *respTestServiceInit) SetValue(value int64) *respTestServiceInit {
    x.Value = value
    return x
}

func (x *respTestServiceInit) writeField0(p thrift.Protocol) error {  // Value
    if err := p.WriteFieldBegin("value", thrift.I64, 0); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetValueNonCompat()
    if err := p.WriteI64(item); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *respTestServiceInit) readField0(p thrift.Protocol) error {  // Value
    result, err := p.ReadI64()
if err != nil {
    return err
}

    x.SetValue(result)
    return nil
}

func (x *respTestServiceInit) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use respTestServiceInit.Set* methods instead or set the fields directly.
type respTestServiceInitBuilder struct {
    obj *respTestServiceInit
}

func newRespTestServiceInitBuilder() *respTestServiceInitBuilder {
    return &respTestServiceInitBuilder{
        obj: newRespTestServiceInit(),
    }
}

func (x *respTestServiceInitBuilder) Value(value int64) *respTestServiceInitBuilder {
    x.obj.Value = value
    return x
}

func (x *respTestServiceInitBuilder) Emit() *respTestServiceInit {
    var objCopy respTestServiceInit = *x.obj
    return &objCopy
}

func (x *respTestServiceInit) Exception() thrift.WritableException {
    return nil
}

func (x *respTestServiceInit) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("respTestServiceInit"); err != nil {
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

func (x *respTestServiceInit) Read(p thrift.Protocol) error {
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



type TestServiceProcessor struct {
    processorMap       map[string]thrift.ProcessorFunction
    functionServiceMap map[string]string
    handler            TestService
}
// Compile time interface enforcer
var _ thrift.Processor = &TestServiceProcessor{}

func (p *TestServiceProcessor) AddToProcessorMap(key string, processor thrift.ProcessorFunction) {
    p.processorMap[key] = processor
}

func (p *TestServiceProcessor) AddToFunctionServiceMap(key, service string) {
    p.functionServiceMap[key] = service
}

func (p *TestServiceProcessor) GetProcessorFunction(key string) (processor thrift.ProcessorFunction, err error) {
    if processor, ok := p.processorMap[key]; ok {
        return processor, nil
    }
    return nil, nil
}

func (p *TestServiceProcessor) ProcessorMap() map[string]thrift.ProcessorFunction {
    return p.processorMap
}

func (p *TestServiceProcessor) FunctionServiceMap() map[string]string {
    return p.functionServiceMap
}

func NewTestServiceProcessor(handler TestService) *TestServiceProcessor {
    p := &TestServiceProcessor{
        handler:            handler,
        processorMap:       make(map[string]thrift.ProcessorFunction),
        functionServiceMap: make(map[string]string),
    }
    p.AddToProcessorMap("init", &procFuncTestServiceInit{handler: handler})
    p.AddToFunctionServiceMap("init", "TestService")

    return p
}


type procFuncTestServiceInit struct {
    handler TestService
}
// Compile time interface enforcer
var _ thrift.ProcessorFunction = &procFuncTestServiceInit{}

func (p *procFuncTestServiceInit) Read(iprot thrift.Protocol) (thrift.Struct, thrift.Exception) {
    args := newReqTestServiceInit()
    if err := args.Read(iprot); err != nil {
        return nil, err
    }
    iprot.ReadMessageEnd()
    return args, nil
}

func (p *procFuncTestServiceInit) Write(seqId int32, result thrift.WritableStruct, oprot thrift.Protocol) (err thrift.Exception) {
    var err2 error
    messageType := thrift.REPLY
    switch result.(type) {
    case thrift.ApplicationException:
        messageType = thrift.EXCEPTION
    }

    if err2 = oprot.WriteMessageBegin("Init", messageType, seqId); err2 != nil {
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

func (p *procFuncTestServiceInit) Run(reqStruct thrift.Struct) (thrift.WritableStruct, thrift.ApplicationException) {
    args := reqStruct.(*reqTestServiceInit)
    result := newRespTestServiceInit()
    retval, err := p.handler.Init(args.Int1)
    if err != nil {
        x := thrift.NewApplicationExceptionCause(thrift.INTERNAL_ERROR, "Internal error processing Init: " + err.Error(), err)
        return x, x
    }

    result.Value = retval
    return result, nil
}


