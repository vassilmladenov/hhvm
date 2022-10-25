/**
 * Autogenerated by Thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

package test.fixtures.stream;

import static com.facebook.swift.service.SwiftConstants.STICKY_HASH_KEY;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import org.apache.thrift.protocol.*;
import org.apache.thrift.ClientPushMetadata;
import org.apache.thrift.InteractionCreate;
import org.apache.thrift.InteractionTerminate;
import com.facebook.thrift.client.ResponseWrapper;
import com.facebook.thrift.client.RpcOptions;
import com.facebook.thrift.util.Readers;

public class PubSubStreamingServiceReactiveClient 
  implements PubSubStreamingService.Reactive {
  private static final AtomicLong _interactionCounter = new AtomicLong(0);

  protected final org.apache.thrift.ProtocolId _protocolId;
  protected final reactor.core.publisher.Mono<? extends com.facebook.thrift.client.RpcClient> _rpcClient;
  protected final Map<String, String> _headers;
  protected final Map<String, String> _persistentHeaders;
  protected final Set<Long> _activeInteractions;

  private static final TField _returnstream_I32_FROM_FIELD_DESC = new TField("i32_from", TType.I32, (short)1);
  private static final TField _returnstream_I32_TO_FIELD_DESC = new TField("i32_to", TType.I32, (short)2);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _returnstream_EXCEPTION_READERS = java.util.Collections.emptyMap();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _returnstream_STREAM_EXCEPTION_READERS = java.util.Collections.emptyMap();
  private static final TField _streamthrows_FOO_FIELD_DESC = new TField("foo", TType.I32, (short)1);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _streamthrows_EXCEPTION_READERS = java.util.Collections.emptyMap();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _streamthrows_STREAM_EXCEPTION_READERS = new HashMap<>();
  private static final com.facebook.thrift.payload.Reader _streamthrows_STREAM_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooStreamEx.asReader());
  private static final TField _servicethrows_FOO_FIELD_DESC = new TField("foo", TType.I32, (short)1);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _servicethrows_EXCEPTION_READERS = new HashMap<>();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _servicethrows_STREAM_EXCEPTION_READERS = java.util.Collections.emptyMap();
  private static final com.facebook.thrift.payload.Reader _servicethrows_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooEx.asReader());
  private static final TField _servicethrows2_FOO_FIELD_DESC = new TField("foo", TType.I32, (short)1);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _servicethrows2_EXCEPTION_READERS = new HashMap<>();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _servicethrows2_STREAM_EXCEPTION_READERS = java.util.Collections.emptyMap();
  private static final com.facebook.thrift.payload.Reader _servicethrows2_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooEx.asReader());
  private static final com.facebook.thrift.payload.Reader _servicethrows2_EXCEPTION_READER1 = Readers.wrap(test.fixtures.stream.FooEx2.asReader());
  private static final TField _boththrows_FOO_FIELD_DESC = new TField("foo", TType.I32, (short)1);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _boththrows_EXCEPTION_READERS = new HashMap<>();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _boththrows_STREAM_EXCEPTION_READERS = new HashMap<>();
  private static final com.facebook.thrift.payload.Reader _boththrows_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooEx.asReader());
  private static final com.facebook.thrift.payload.Reader _boththrows_STREAM_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooStreamEx.asReader());
  private static final TField _responseandstreamstreamthrows_FOO_FIELD_DESC = new TField("foo", TType.I32, (short)1);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _responseandstreamstreamthrows_EXCEPTION_READERS = java.util.Collections.emptyMap();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _responseandstreamstreamthrows_STREAM_EXCEPTION_READERS = new HashMap<>();
  private static final com.facebook.thrift.payload.Reader _responseandstreamstreamthrows_STREAM_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooStreamEx.asReader());
  private static final TField _responseandstreamservicethrows_FOO_FIELD_DESC = new TField("foo", TType.I32, (short)1);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _responseandstreamservicethrows_EXCEPTION_READERS = new HashMap<>();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _responseandstreamservicethrows_STREAM_EXCEPTION_READERS = java.util.Collections.emptyMap();
  private static final com.facebook.thrift.payload.Reader _responseandstreamservicethrows_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooEx.asReader());
  private static final TField _responseandstreamboththrows_FOO_FIELD_DESC = new TField("foo", TType.I32, (short)1);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _responseandstreamboththrows_EXCEPTION_READERS = new HashMap<>();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _responseandstreamboththrows_STREAM_EXCEPTION_READERS = new HashMap<>();
  private static final com.facebook.thrift.payload.Reader _responseandstreamboththrows_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooEx.asReader());
  private static final com.facebook.thrift.payload.Reader _responseandstreamboththrows_STREAM_EXCEPTION_READER0 = Readers.wrap(test.fixtures.stream.FooStreamEx.asReader());
  private static final TField _returnstreamFast_I32_FROM_FIELD_DESC = new TField("i32_from", TType.I32, (short)1);
  private static final TField _returnstreamFast_I32_TO_FIELD_DESC = new TField("i32_to", TType.I32, (short)2);
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _returnstreamFast_EXCEPTION_READERS = java.util.Collections.emptyMap();
  private static final java.util.Map<Short, com.facebook.thrift.payload.Reader> _returnstreamFast_STREAM_EXCEPTION_READERS = java.util.Collections.emptyMap();

  static {
    _streamthrows_STREAM_EXCEPTION_READERS.put((short)1, _streamthrows_STREAM_EXCEPTION_READER0);
    _servicethrows_EXCEPTION_READERS.put((short)1, _servicethrows_EXCEPTION_READER0);
    _servicethrows2_EXCEPTION_READERS.put((short)1, _servicethrows2_EXCEPTION_READER0);
    _servicethrows2_EXCEPTION_READERS.put((short)2, _servicethrows2_EXCEPTION_READER1);
    _boththrows_EXCEPTION_READERS.put((short)1, _boththrows_EXCEPTION_READER0);
    _boththrows_STREAM_EXCEPTION_READERS.put((short)1, _boththrows_STREAM_EXCEPTION_READER0);
    _responseandstreamstreamthrows_STREAM_EXCEPTION_READERS.put((short)1, _responseandstreamstreamthrows_STREAM_EXCEPTION_READER0);
    _responseandstreamservicethrows_EXCEPTION_READERS.put((short)1, _responseandstreamservicethrows_EXCEPTION_READER0);
    _responseandstreamboththrows_EXCEPTION_READERS.put((short)1, _responseandstreamboththrows_EXCEPTION_READER0);
    _responseandstreamboththrows_STREAM_EXCEPTION_READERS.put((short)1, _responseandstreamboththrows_STREAM_EXCEPTION_READER0);
  }

  public PubSubStreamingServiceReactiveClient(org.apache.thrift.ProtocolId _protocolId, reactor.core.publisher.Mono<? extends com.facebook.thrift.client.RpcClient> _rpcClient) {
    
    this._protocolId = _protocolId;
    this._rpcClient = _rpcClient;
    this._headers = java.util.Collections.emptyMap();
    this._persistentHeaders = java.util.Collections.emptyMap();
    this._activeInteractions = ConcurrentHashMap.newKeySet();
  }

  public PubSubStreamingServiceReactiveClient(org.apache.thrift.ProtocolId _protocolId, reactor.core.publisher.Mono<? extends com.facebook.thrift.client.RpcClient> _rpcClient, Map<String, String> _headers, Map<String, String> _persistentHeaders) {
    this(_protocolId, _rpcClient, _headers, _persistentHeaders, new AtomicLong(), ConcurrentHashMap.newKeySet());
  }

  public PubSubStreamingServiceReactiveClient(org.apache.thrift.ProtocolId _protocolId, reactor.core.publisher.Mono<? extends com.facebook.thrift.client.RpcClient> _rpcClient, Map<String, String> _headers, Map<String, String> _persistentHeaders, AtomicLong interactionCounter, Set<Long> activeInteractions) {
    
    this._protocolId = _protocolId;
    this._rpcClient = _rpcClient;
    this._headers = _headers;
    this._persistentHeaders = _persistentHeaders;
    this._activeInteractions = activeInteractions;
  }

  @java.lang.Override
  public void dispose() {}

  private com.facebook.thrift.payload.Writer _createreturnstreamWriter(final int i32From, final int i32To) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_returnstream_I32_FROM_FIELD_DESC);

          int _iter0 = i32From;

          oprot.writeI32(i32From);
          oprot.writeFieldEnd();
        }

        {
          oprot.writeFieldBegin(_returnstream_I32_TO_FIELD_DESC);

          int _iter0 = i32To;

          oprot.writeI32(i32To);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _returnstream_READER = Readers.i32Reader();


  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<Integer>> returnstreamWrapper(final int i32From, final int i32To,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("returnstream")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createreturnstreamWriter(i32From, i32To),
                    _returnstream_READER,
                    _returnstream_EXCEPTION_READERS,
                    _returnstream_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .filter((_p) -> ((com.facebook.thrift.model.StreamResponse)_p.getData()).isSetData())
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Void, Integer>)_p.getData()).getData(), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> returnstream(final int i32From, final int i32To,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return returnstreamWrapper(i32From, i32To,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> returnstream(final int i32From, final int i32To) {
    return returnstream(i32From, i32To,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }

  private com.facebook.thrift.payload.Writer _createstreamthrowsWriter(final int foo) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_streamthrows_FOO_FIELD_DESC);

          int _iter0 = foo;

          oprot.writeI32(foo);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _streamthrows_READER = Readers.i32Reader();


  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<Integer>> streamthrowsWrapper(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("streamthrows")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createstreamthrowsWriter(foo),
                    _streamthrows_READER,
                    _streamthrows_EXCEPTION_READERS,
                    _streamthrows_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .filter((_p) -> ((com.facebook.thrift.model.StreamResponse)_p.getData()).isSetData())
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Void, Integer>)_p.getData()).getData(), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> streamthrows(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return streamthrowsWrapper(foo,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> streamthrows(final int foo) {
    return streamthrows(foo,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }

  private com.facebook.thrift.payload.Writer _createservicethrowsWriter(final int foo) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_servicethrows_FOO_FIELD_DESC);

          int _iter0 = foo;

          oprot.writeI32(foo);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _servicethrows_READER = Readers.i32Reader();


  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<Integer>> servicethrowsWrapper(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("servicethrows")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createservicethrowsWriter(foo),
                    _servicethrows_READER,
                    _servicethrows_EXCEPTION_READERS,
                    _servicethrows_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .filter((_p) -> ((com.facebook.thrift.model.StreamResponse)_p.getData()).isSetData())
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Void, Integer>)_p.getData()).getData(), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> servicethrows(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return servicethrowsWrapper(foo,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> servicethrows(final int foo) {
    return servicethrows(foo,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }

  private com.facebook.thrift.payload.Writer _createservicethrows2Writer(final int foo) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_servicethrows2_FOO_FIELD_DESC);

          int _iter0 = foo;

          oprot.writeI32(foo);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _servicethrows2_READER = Readers.i32Reader();


  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<Integer>> servicethrows2Wrapper(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("servicethrows2")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createservicethrows2Writer(foo),
                    _servicethrows2_READER,
                    _servicethrows2_EXCEPTION_READERS,
                    _servicethrows2_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .filter((_p) -> ((com.facebook.thrift.model.StreamResponse)_p.getData()).isSetData())
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Void, Integer>)_p.getData()).getData(), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> servicethrows2(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return servicethrows2Wrapper(foo,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> servicethrows2(final int foo) {
    return servicethrows2(foo,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }

  private com.facebook.thrift.payload.Writer _createboththrowsWriter(final int foo) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_boththrows_FOO_FIELD_DESC);

          int _iter0 = foo;

          oprot.writeI32(foo);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _boththrows_READER = Readers.i32Reader();


  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<Integer>> boththrowsWrapper(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("boththrows")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createboththrowsWriter(foo),
                    _boththrows_READER,
                    _boththrows_EXCEPTION_READERS,
                    _boththrows_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .filter((_p) -> ((com.facebook.thrift.model.StreamResponse)_p.getData()).isSetData())
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Void, Integer>)_p.getData()).getData(), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> boththrows(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return boththrowsWrapper(foo,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> boththrows(final int foo) {
    return boththrows(foo,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }

  private com.facebook.thrift.payload.Writer _createresponseandstreamstreamthrowsWriter(final int foo) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_responseandstreamstreamthrows_FOO_FIELD_DESC);

          int _iter0 = foo;

          oprot.writeI32(foo);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _responseandstreamstreamthrows_READER = Readers.i32Reader();

  private static final com.facebook.thrift.payload.Reader _responseandstreamstreamthrows_FIRST_READER = Readers.i32Reader();

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<com.facebook.thrift.model.StreamResponse<Integer,Integer>>> responseandstreamstreamthrowsWrapper(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("responseandstreamstreamthrows")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createresponseandstreamstreamthrowsWriter(foo),
                    _responseandstreamstreamthrows_READER,
                    _responseandstreamstreamthrows_FIRST_READER,
                    _responseandstreamstreamthrows_EXCEPTION_READERS,
                    _responseandstreamstreamthrows_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Integer,Integer>)_p.getData()), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.model.StreamResponse<Integer,Integer>> responseandstreamstreamthrows(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return responseandstreamstreamthrowsWrapper(foo,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.model.StreamResponse<Integer,Integer>> responseandstreamstreamthrows(final int foo) {
    return responseandstreamstreamthrows(foo,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }

  private com.facebook.thrift.payload.Writer _createresponseandstreamservicethrowsWriter(final int foo) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_responseandstreamservicethrows_FOO_FIELD_DESC);

          int _iter0 = foo;

          oprot.writeI32(foo);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _responseandstreamservicethrows_READER = Readers.i32Reader();

  private static final com.facebook.thrift.payload.Reader _responseandstreamservicethrows_FIRST_READER = Readers.i32Reader();

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<com.facebook.thrift.model.StreamResponse<Integer,Integer>>> responseandstreamservicethrowsWrapper(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("responseandstreamservicethrows")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createresponseandstreamservicethrowsWriter(foo),
                    _responseandstreamservicethrows_READER,
                    _responseandstreamservicethrows_FIRST_READER,
                    _responseandstreamservicethrows_EXCEPTION_READERS,
                    _responseandstreamservicethrows_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Integer,Integer>)_p.getData()), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.model.StreamResponse<Integer,Integer>> responseandstreamservicethrows(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return responseandstreamservicethrowsWrapper(foo,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.model.StreamResponse<Integer,Integer>> responseandstreamservicethrows(final int foo) {
    return responseandstreamservicethrows(foo,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }

  private com.facebook.thrift.payload.Writer _createresponseandstreamboththrowsWriter(final int foo) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_responseandstreamboththrows_FOO_FIELD_DESC);

          int _iter0 = foo;

          oprot.writeI32(foo);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _responseandstreamboththrows_READER = Readers.i32Reader();

  private static final com.facebook.thrift.payload.Reader _responseandstreamboththrows_FIRST_READER = Readers.i32Reader();

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<com.facebook.thrift.model.StreamResponse<Integer,Integer>>> responseandstreamboththrowsWrapper(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("responseandstreamboththrows")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createresponseandstreamboththrowsWriter(foo),
                    _responseandstreamboththrows_READER,
                    _responseandstreamboththrows_FIRST_READER,
                    _responseandstreamboththrows_EXCEPTION_READERS,
                    _responseandstreamboththrows_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Integer,Integer>)_p.getData()), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.model.StreamResponse<Integer,Integer>> responseandstreamboththrows(final int foo,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return responseandstreamboththrowsWrapper(foo,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.model.StreamResponse<Integer,Integer>> responseandstreamboththrows(final int foo) {
    return responseandstreamboththrows(foo,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }

  private com.facebook.thrift.payload.Writer _createreturnstreamFastWriter(final int i32From, final int i32To) {
    return oprot -> {
      try {
        {
          oprot.writeFieldBegin(_returnstreamFast_I32_FROM_FIELD_DESC);

          int _iter0 = i32From;

          oprot.writeI32(i32From);
          oprot.writeFieldEnd();
        }

        {
          oprot.writeFieldBegin(_returnstreamFast_I32_TO_FIELD_DESC);

          int _iter0 = i32To;

          oprot.writeI32(i32To);
          oprot.writeFieldEnd();
        }


      } catch (Throwable _e) {
        throw reactor.core.Exceptions.propagate(_e);
      }
    };
  }

  private static final com.facebook.thrift.payload.Reader _returnstreamFast_READER = Readers.i32Reader();


  @java.lang.Override
  public reactor.core.publisher.Flux<com.facebook.thrift.client.ResponseWrapper<Integer>> returnstreamFastWrapper(final int i32From, final int i32To,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
    return _rpcClient
      .flatMapMany(_rpc -> {
        org.apache.thrift.RequestRpcMetadata _metadata = new org.apache.thrift.RequestRpcMetadata.Builder()
                .setName("returnstreamFast")
                .setKind(org.apache.thrift.RpcKind.SINGLE_REQUEST_STREAMING_RESPONSE)
                .setOtherMetadata(getHeaders(rpcOptions))
                .setProtocol(_protocolId)
                .build();

            com.facebook.thrift.payload.ClientRequestPayload<Integer> _crp =
                com.facebook.thrift.payload.ClientRequestPayload.create(
                    "PubSubStreamingService",
                    _createreturnstreamFastWriter(i32From, i32To),
                    _returnstreamFast_READER,
                    _returnstreamFast_EXCEPTION_READERS,
                    _returnstreamFast_STREAM_EXCEPTION_READERS,
                    _metadata,
                    java.util.Collections.emptyMap());

            return _rpc
                .singleRequestStreamingResponse(_crp, rpcOptions)
                .doOnNext(_p -> {if(_p.getException() != null) throw reactor.core.Exceptions.propagate(_p.getException());})
                .filter((_p) -> ((com.facebook.thrift.model.StreamResponse)_p.getData()).isSetData())
                .map(_p -> ResponseWrapper.create(((com.facebook.thrift.model.StreamResponse<Void, Integer>)_p.getData()).getData(), _p.getHeaders(), _p.getBinaryHeaders()));
      });
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> returnstreamFast(final int i32From, final int i32To,  final com.facebook.thrift.client.RpcOptions rpcOptions) {
      return returnstreamFastWrapper(i32From, i32To,  rpcOptions).map(_p -> _p.getData());
  }

  @java.lang.Override
  public reactor.core.publisher.Flux<Integer> returnstreamFast(final int i32From, final int i32To) {
    return returnstreamFast(i32From, i32To,  com.facebook.thrift.client.RpcOptions.EMPTY);
  }



  private Map<String, String> getHeaders(com.facebook.thrift.client.RpcOptions rpcOptions) {
      Map<String, String> headers = new HashMap<>();
      if (rpcOptions.getRequestHeaders() != null && !rpcOptions.getRequestHeaders().isEmpty()) {
          headers.putAll(rpcOptions.getRequestHeaders());
      }
      if (_headers != null && !_headers.isEmpty()) {
          headers.putAll(_headers);
      }
      if (_persistentHeaders != null && !_persistentHeaders.isEmpty()) {
          headers.putAll(_persistentHeaders);
      }
      return headers;
  }
}
