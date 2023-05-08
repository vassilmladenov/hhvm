// @generated by Thrift for [[[ program path ]]]
// This file is probably not the place you want to edit!

package service // [[[ program thrift source path ]]]


import (
    "context"
    "fmt"

    module "module"
    includes "includes"

    "thrift/lib/go/thrift"
)

var _ = module.GoUnusedProtection__
var _ = includes.GoUnusedProtection__

// (needed to ensure safety because of naive import list construction)
var _ = context.Background
var _ = fmt.Printf
var _ = thrift.ZERO



type MyService interface {
    Query(ctx context.Context, s *module.MyStruct, i *includes.Included) (error)
    HasArgDocs(ctx context.Context, s *module.MyStruct, i *includes.Included) (error)
}

// Deprecated: Use MyService instead.
type MyServiceClientInterface interface {
    thrift.ClientInterface
    Query(s *module.MyStruct, i *includes.Included) (error)
    HasArgDocs(s *module.MyStruct, i *includes.Included) (error)
}

type MyServiceChannelClient struct {
    ch thrift.RequestChannel
}
// Compile time interface enforcer
var _ MyService = &MyServiceChannelClient{}

func NewMyServiceChannelClient(channel thrift.RequestChannel) *MyServiceChannelClient {
    return &MyServiceChannelClient{
        ch: channel,
    }
}

func (c *MyServiceChannelClient) Close() error {
    return c.ch.Close()
}

func (c *MyServiceChannelClient) IsOpen() bool {
    return c.ch.IsOpen()
}

func (c *MyServiceChannelClient) Open() error {
    return c.ch.Open()
}

// Deprecated: Use MyServiceChannelClient instead.
type MyServiceClient struct {
    chClient *MyServiceChannelClient
}
// Compile time interface enforcer
var _ MyServiceClientInterface = &MyServiceClient{}

// Deprecated: Use NewMyServiceChannelClient() instead.
func NewMyServiceClient(t thrift.Transport, iprot thrift.Protocol, oprot thrift.Protocol) *MyServiceClient {
    return &MyServiceClient{
        chClient: NewMyServiceChannelClient(
            thrift.NewSerialChannel(iprot),
        ),
    }
}

func (c *MyServiceClient) Close() error {
    return c.chClient.Close()
}

func (c *MyServiceClient) IsOpen() bool {
    return c.chClient.IsOpen()
}

func (c *MyServiceClient) Open() error {
    return c.chClient.Open()
}

// Deprecated: Use MyServiceChannelClient instead.
type MyServiceThreadsafeClient = MyServiceClient

// Deprecated: Use NewMyServiceChannelClient() instead.
func NewMyServiceThreadsafeClient(t thrift.Transport, iprot thrift.Protocol, oprot thrift.Protocol) *MyServiceThreadsafeClient {
    return NewMyServiceClient(t, iprot, oprot)
}

// Deprecated: Use NewMyServiceChannelClient() instead.
func NewMyServiceClientProtocol(prot thrift.Protocol) *MyServiceClient {
  return NewMyServiceClient(prot.Transport(), prot, prot)
}

// Deprecated: Use NewMyServiceChannelClient() instead.
func NewMyServiceThreadsafeClientProtocol(prot thrift.Protocol) *MyServiceClient {
  return NewMyServiceClient(prot.Transport(), prot, prot)
}

// Deprecated: Use NewMyServiceChannelClient() instead.
func NewMyServiceClientFactory(t thrift.Transport, pf thrift.ProtocolFactory) *MyServiceClient {
  iprot := pf.GetProtocol(t)
  oprot := pf.GetProtocol(t)
  return NewMyServiceClient(t, iprot, oprot)
}

// Deprecated: Use NewMyServiceChannelClient() instead.
func NewMyServiceThreadsafeClientFactory(t thrift.Transport, pf thrift.ProtocolFactory) *MyServiceThreadsafeClient {
  return NewMyServiceClientFactory(t, pf)
}


func (c *MyServiceChannelClient) Query(ctx context.Context, s *module.MyStruct, i *includes.Included) (error) {
    in := &reqMyServiceQuery{
        S: s,
        I: i,
    }
    out := newRespMyServiceQuery()
    err := c.ch.Call(ctx, "query", in, out)
    if err != nil {
        return err
    }
    return nil
}

func (c *MyServiceClient) Query(s *module.MyStruct, i *includes.Included) (error) {
    return c.chClient.Query(nil, s, i)
}


func (c *MyServiceChannelClient) HasArgDocs(ctx context.Context, s *module.MyStruct, i *includes.Included) (error) {
    in := &reqMyServiceHasArgDocs{
        S: s,
        I: i,
    }
    out := newRespMyServiceHasArgDocs()
    err := c.ch.Call(ctx, "has_arg_docs", in, out)
    if err != nil {
        return err
    }
    return nil
}

func (c *MyServiceClient) HasArgDocs(s *module.MyStruct, i *includes.Included) (error) {
    return c.chClient.HasArgDocs(nil, s, i)
}


type reqMyServiceQuery struct {
    S *module.MyStruct `thrift:"s,1" json:"s" db:"s"`
    I *includes.Included `thrift:"i,2" json:"i" db:"i"`
}
// Compile time interface enforcer
var _ thrift.Struct = &reqMyServiceQuery{}

func newReqMyServiceQuery() *reqMyServiceQuery {
    return (&reqMyServiceQuery{}).
        SetS(*module.NewMyStruct()).
        SetI(*includes.NewIncluded())
}

// Deprecated: Use newReqMyServiceQuery().S instead.
var reqMyServiceQuery_S_DEFAULT = newReqMyServiceQuery().S

// Deprecated: Use newReqMyServiceQuery().I instead.
var reqMyServiceQuery_I_DEFAULT = newReqMyServiceQuery().I

func (x *reqMyServiceQuery) GetSNonCompat() *module.MyStruct {
    return x.S
}

func (x *reqMyServiceQuery) GetS() *module.MyStruct {
    if !x.IsSetS() {
        return module.NewMyStruct()
    }

    return x.S
}

func (x *reqMyServiceQuery) GetINonCompat() *includes.Included {
    return x.I
}

func (x *reqMyServiceQuery) GetI() *includes.Included {
    if !x.IsSetI() {
        return includes.NewIncluded()
    }

    return x.I
}

func (x *reqMyServiceQuery) SetS(value module.MyStruct) *reqMyServiceQuery {
    x.S = &value
    return x
}

func (x *reqMyServiceQuery) SetI(value includes.Included) *reqMyServiceQuery {
    x.I = &value
    return x
}

func (x *reqMyServiceQuery) IsSetS() bool {
    return x.S != nil
}

func (x *reqMyServiceQuery) IsSetI() bool {
    return x.I != nil
}

func (x *reqMyServiceQuery) writeField1(p thrift.Protocol) error {  // S
    if !x.IsSetS() {
        return nil
    }

    if err := p.WriteFieldBegin("s", thrift.STRUCT, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetSNonCompat()
    if err := item.Write(p); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *reqMyServiceQuery) writeField2(p thrift.Protocol) error {  // I
    if !x.IsSetI() {
        return nil
    }

    if err := p.WriteFieldBegin("i", thrift.STRUCT, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetINonCompat()
    if err := item.Write(p); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *reqMyServiceQuery) readField1(p thrift.Protocol) error {  // S
    result := *module.NewMyStruct()
err := result.Read(p)
if err != nil {
    return err
}

    x.SetS(result)
    return nil
}

func (x *reqMyServiceQuery) readField2(p thrift.Protocol) error {  // I
    result := *includes.NewIncluded()
err := result.Read(p)
if err != nil {
    return err
}

    x.SetI(result)
    return nil
}

func (x *reqMyServiceQuery) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use reqMyServiceQuery.Set* methods instead or set the fields directly.
type reqMyServiceQueryBuilder struct {
    obj *reqMyServiceQuery
}

func newReqMyServiceQueryBuilder() *reqMyServiceQueryBuilder {
    return &reqMyServiceQueryBuilder{
        obj: newReqMyServiceQuery(),
    }
}

func (x *reqMyServiceQueryBuilder) S(value *module.MyStruct) *reqMyServiceQueryBuilder {
    x.obj.S = value
    return x
}

func (x *reqMyServiceQueryBuilder) I(value *includes.Included) *reqMyServiceQueryBuilder {
    x.obj.I = value
    return x
}

func (x *reqMyServiceQueryBuilder) Emit() *reqMyServiceQuery {
    var objCopy reqMyServiceQuery = *x.obj
    return &objCopy
}

func (x *reqMyServiceQuery) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("reqMyServiceQuery"); err != nil {
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

func (x *reqMyServiceQuery) Read(p thrift.Protocol) error {
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
        case 1:  // s
            if err := x.readField1(p); err != nil {
                return err
            }
        case 2:  // i
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

type respMyServiceQuery struct {
}
// Compile time interface enforcer
var _ thrift.Struct = &respMyServiceQuery{}
var _ thrift.WritableResult = &respMyServiceQuery{}

func newRespMyServiceQuery() *respMyServiceQuery {
    return (&respMyServiceQuery{})
}

func (x *respMyServiceQuery) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use respMyServiceQuery.Set* methods instead or set the fields directly.
type respMyServiceQueryBuilder struct {
    obj *respMyServiceQuery
}

func newRespMyServiceQueryBuilder() *respMyServiceQueryBuilder {
    return &respMyServiceQueryBuilder{
        obj: newRespMyServiceQuery(),
    }
}

func (x *respMyServiceQueryBuilder) Emit() *respMyServiceQuery {
    var objCopy respMyServiceQuery = *x.obj
    return &objCopy
}

func (x *respMyServiceQuery) Exception() thrift.WritableException {
    return nil
}

func (x *respMyServiceQuery) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("respMyServiceQuery"); err != nil {
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

func (x *respMyServiceQuery) Read(p thrift.Protocol) error {
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

type reqMyServiceHasArgDocs struct {
    S *module.MyStruct `thrift:"s,1" json:"s" db:"s"`
    I *includes.Included `thrift:"i,2" json:"i" db:"i"`
}
// Compile time interface enforcer
var _ thrift.Struct = &reqMyServiceHasArgDocs{}

func newReqMyServiceHasArgDocs() *reqMyServiceHasArgDocs {
    return (&reqMyServiceHasArgDocs{}).
        SetS(*module.NewMyStruct()).
        SetI(*includes.NewIncluded())
}

// Deprecated: Use newReqMyServiceHasArgDocs().S instead.
var reqMyServiceHasArgDocs_S_DEFAULT = newReqMyServiceHasArgDocs().S

// Deprecated: Use newReqMyServiceHasArgDocs().I instead.
var reqMyServiceHasArgDocs_I_DEFAULT = newReqMyServiceHasArgDocs().I

func (x *reqMyServiceHasArgDocs) GetSNonCompat() *module.MyStruct {
    return x.S
}

func (x *reqMyServiceHasArgDocs) GetS() *module.MyStruct {
    if !x.IsSetS() {
        return module.NewMyStruct()
    }

    return x.S
}

func (x *reqMyServiceHasArgDocs) GetINonCompat() *includes.Included {
    return x.I
}

func (x *reqMyServiceHasArgDocs) GetI() *includes.Included {
    if !x.IsSetI() {
        return includes.NewIncluded()
    }

    return x.I
}

func (x *reqMyServiceHasArgDocs) SetS(value module.MyStruct) *reqMyServiceHasArgDocs {
    x.S = &value
    return x
}

func (x *reqMyServiceHasArgDocs) SetI(value includes.Included) *reqMyServiceHasArgDocs {
    x.I = &value
    return x
}

func (x *reqMyServiceHasArgDocs) IsSetS() bool {
    return x.S != nil
}

func (x *reqMyServiceHasArgDocs) IsSetI() bool {
    return x.I != nil
}

func (x *reqMyServiceHasArgDocs) writeField1(p thrift.Protocol) error {  // S
    if !x.IsSetS() {
        return nil
    }

    if err := p.WriteFieldBegin("s", thrift.STRUCT, 1); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetSNonCompat()
    if err := item.Write(p); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *reqMyServiceHasArgDocs) writeField2(p thrift.Protocol) error {  // I
    if !x.IsSetI() {
        return nil
    }

    if err := p.WriteFieldBegin("i", thrift.STRUCT, 2); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field begin error: ", x), err)
    }

    item := x.GetINonCompat()
    if err := item.Write(p); err != nil {
    return err
}

    if err := p.WriteFieldEnd(); err != nil {
        return thrift.PrependError(fmt.Sprintf("%T write field end error: ", x), err)
    }
    return nil
}

func (x *reqMyServiceHasArgDocs) readField1(p thrift.Protocol) error {  // S
    result := *module.NewMyStruct()
err := result.Read(p)
if err != nil {
    return err
}

    x.SetS(result)
    return nil
}

func (x *reqMyServiceHasArgDocs) readField2(p thrift.Protocol) error {  // I
    result := *includes.NewIncluded()
err := result.Read(p)
if err != nil {
    return err
}

    x.SetI(result)
    return nil
}

func (x *reqMyServiceHasArgDocs) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use reqMyServiceHasArgDocs.Set* methods instead or set the fields directly.
type reqMyServiceHasArgDocsBuilder struct {
    obj *reqMyServiceHasArgDocs
}

func newReqMyServiceHasArgDocsBuilder() *reqMyServiceHasArgDocsBuilder {
    return &reqMyServiceHasArgDocsBuilder{
        obj: newReqMyServiceHasArgDocs(),
    }
}

func (x *reqMyServiceHasArgDocsBuilder) S(value *module.MyStruct) *reqMyServiceHasArgDocsBuilder {
    x.obj.S = value
    return x
}

func (x *reqMyServiceHasArgDocsBuilder) I(value *includes.Included) *reqMyServiceHasArgDocsBuilder {
    x.obj.I = value
    return x
}

func (x *reqMyServiceHasArgDocsBuilder) Emit() *reqMyServiceHasArgDocs {
    var objCopy reqMyServiceHasArgDocs = *x.obj
    return &objCopy
}

func (x *reqMyServiceHasArgDocs) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("reqMyServiceHasArgDocs"); err != nil {
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

func (x *reqMyServiceHasArgDocs) Read(p thrift.Protocol) error {
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
        case 1:  // s
            if err := x.readField1(p); err != nil {
                return err
            }
        case 2:  // i
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

type respMyServiceHasArgDocs struct {
}
// Compile time interface enforcer
var _ thrift.Struct = &respMyServiceHasArgDocs{}
var _ thrift.WritableResult = &respMyServiceHasArgDocs{}

func newRespMyServiceHasArgDocs() *respMyServiceHasArgDocs {
    return (&respMyServiceHasArgDocs{})
}

func (x *respMyServiceHasArgDocs) String() string {
    return fmt.Sprintf("%+v", x)
}


// Deprecated: Use respMyServiceHasArgDocs.Set* methods instead or set the fields directly.
type respMyServiceHasArgDocsBuilder struct {
    obj *respMyServiceHasArgDocs
}

func newRespMyServiceHasArgDocsBuilder() *respMyServiceHasArgDocsBuilder {
    return &respMyServiceHasArgDocsBuilder{
        obj: newRespMyServiceHasArgDocs(),
    }
}

func (x *respMyServiceHasArgDocsBuilder) Emit() *respMyServiceHasArgDocs {
    var objCopy respMyServiceHasArgDocs = *x.obj
    return &objCopy
}

func (x *respMyServiceHasArgDocs) Exception() thrift.WritableException {
    return nil
}

func (x *respMyServiceHasArgDocs) Write(p thrift.Protocol) error {
    if err := p.WriteStructBegin("respMyServiceHasArgDocs"); err != nil {
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

func (x *respMyServiceHasArgDocs) Read(p thrift.Protocol) error {
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



type MyServiceProcessor struct {
    processorMap       map[string]thrift.ProcessorFunction
    functionServiceMap map[string]string
    handler            MyService
}
// Compile time interface enforcer
var _ thrift.Processor = &MyServiceProcessor{}

func (p *MyServiceProcessor) AddToProcessorMap(key string, processor thrift.ProcessorFunction) {
    p.processorMap[key] = processor
}

func (p *MyServiceProcessor) AddToFunctionServiceMap(key, service string) {
    p.functionServiceMap[key] = service
}

func (p *MyServiceProcessor) GetProcessorFunction(key string) (processor thrift.ProcessorFunction, err error) {
    if processor, ok := p.processorMap[key]; ok {
        return processor, nil
    }
    return nil, nil
}

func (p *MyServiceProcessor) ProcessorMap() map[string]thrift.ProcessorFunction {
    return p.processorMap
}

func (p *MyServiceProcessor) FunctionServiceMap() map[string]string {
    return p.functionServiceMap
}

func NewMyServiceProcessor(handler MyService) *MyServiceProcessor {
    p := &MyServiceProcessor{
        handler:            handler,
        processorMap:       make(map[string]thrift.ProcessorFunction),
        functionServiceMap: make(map[string]string),
    }
    p.AddToProcessorMap("query", &procFuncMyServiceQuery{handler: handler})
    p.AddToProcessorMap("has_arg_docs", &procFuncMyServiceHasArgDocs{handler: handler})
    p.AddToFunctionServiceMap("query", "MyService")
    p.AddToFunctionServiceMap("has_arg_docs", "MyService")

    return p
}


type procFuncMyServiceQuery struct {
    handler MyService
}
// Compile time interface enforcer
var _ thrift.ProcessorFunction = &procFuncMyServiceQuery{}

func (p *procFuncMyServiceQuery) Read(iprot thrift.Protocol) (thrift.Struct, thrift.Exception) {
    args := newReqMyServiceQuery()
    if err := args.Read(iprot); err != nil {
        return nil, err
    }
    iprot.ReadMessageEnd()
    return args, nil
}

func (p *procFuncMyServiceQuery) Write(seqId int32, result thrift.WritableStruct, oprot thrift.Protocol) (err thrift.Exception) {
    var err2 error
    messageType := thrift.REPLY
    switch result.(type) {
    case thrift.ApplicationException:
        messageType = thrift.EXCEPTION
    }

    if err2 = oprot.WriteMessageBegin("Query", messageType, seqId); err2 != nil {
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

func (p *procFuncMyServiceQuery) Run(reqStruct thrift.Struct) (thrift.WritableStruct, thrift.ApplicationException) {
    args := reqStruct.(*reqMyServiceQuery)
    result := newRespMyServiceQuery()
    err := p.handler.Query(args.S, args.I)
    if err != nil {
        x := thrift.NewApplicationExceptionCause(thrift.INTERNAL_ERROR, "Internal error processing Query: " + err.Error(), err)
        return x, x
    }

    return result, nil
}


type procFuncMyServiceHasArgDocs struct {
    handler MyService
}
// Compile time interface enforcer
var _ thrift.ProcessorFunction = &procFuncMyServiceHasArgDocs{}

func (p *procFuncMyServiceHasArgDocs) Read(iprot thrift.Protocol) (thrift.Struct, thrift.Exception) {
    args := newReqMyServiceHasArgDocs()
    if err := args.Read(iprot); err != nil {
        return nil, err
    }
    iprot.ReadMessageEnd()
    return args, nil
}

func (p *procFuncMyServiceHasArgDocs) Write(seqId int32, result thrift.WritableStruct, oprot thrift.Protocol) (err thrift.Exception) {
    var err2 error
    messageType := thrift.REPLY
    switch result.(type) {
    case thrift.ApplicationException:
        messageType = thrift.EXCEPTION
    }

    if err2 = oprot.WriteMessageBegin("HasArgDocs", messageType, seqId); err2 != nil {
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

func (p *procFuncMyServiceHasArgDocs) Run(reqStruct thrift.Struct) (thrift.WritableStruct, thrift.ApplicationException) {
    args := reqStruct.(*reqMyServiceHasArgDocs)
    result := newRespMyServiceHasArgDocs()
    err := p.handler.HasArgDocs(args.S, args.I)
    if err != nil {
        x := thrift.NewApplicationExceptionCause(thrift.INTERNAL_ERROR, "Internal error processing HasArgDocs: " + err.Error(), err)
        return x, x
    }

    return result, nil
}


