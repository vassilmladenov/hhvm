/**
 * Autogenerated by Thrift for thrift/compiler/test/fixtures/basic/src/module.thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated @nocommit
 */
#pragma once

#include <thrift/lib/cpp2/gen/service_h.h>

#include "thrift/compiler/test/fixtures/basic/gen-cpp2/FB303ServiceAsyncClient.h"
#include "thrift/compiler/test/fixtures/basic/gen-cpp2/module_types.h"

namespace folly {
  class IOBuf;
  class IOBufQueue;
}
namespace apache { namespace thrift {
  class Cpp2RequestContext;
  class BinaryProtocolReader;
  class CompactProtocolReader;
  namespace transport { class THeader; }
}}

namespace test { namespace fixtures { namespace basic {
class FB303Service;
class FB303ServiceAsyncProcessor;

class FB303ServiceServiceInfoHolder : public apache::thrift::ServiceInfoHolder {
  public:
   apache::thrift::ServiceRequestInfoMap const& requestInfoMap() const override;
   static apache::thrift::ServiceRequestInfoMap staticRequestInfoMap();
};
}}} // test::fixtures::basic

namespace apache::thrift {
template <>
class ServiceHandler<::test::fixtures::basic::FB303Service> : public apache::thrift::ServerInterface {
 public:
  std::string_view getGeneratedName() const override { return "FB303Service"; }

  static const char* __fbthrift_thrift_uri() {
    return "test.dev/fixtures/basic/FB303Service";
  }

  typedef ::test::fixtures::basic::FB303ServiceAsyncProcessor ProcessorType;
  std::unique_ptr<apache::thrift::AsyncProcessor> getProcessor() override;
  CreateMethodMetadataResult createMethodMetadata() override;
 private:
  std::optional<std::reference_wrapper<apache::thrift::ServiceRequestInfoMap const>> getServiceRequestInfoMap() const;
 public:

  virtual void sync_simple_rpc(::test::fixtures::basic::ReservedKeyword& /*_return*/, ::std::int32_t /*int_parameter*/);
  [[deprecated("Use sync_simple_rpc instead")]] virtual void simple_rpc(::test::fixtures::basic::ReservedKeyword& /*_return*/, ::std::int32_t /*int_parameter*/);
  virtual folly::Future<std::unique_ptr<::test::fixtures::basic::ReservedKeyword>> future_simple_rpc(::std::int32_t p_int_parameter);
  virtual folly::SemiFuture<std::unique_ptr<::test::fixtures::basic::ReservedKeyword>> semifuture_simple_rpc(::std::int32_t p_int_parameter);
#if FOLLY_HAS_COROUTINES
  virtual folly::coro::Task<std::unique_ptr<::test::fixtures::basic::ReservedKeyword>> co_simple_rpc(::std::int32_t p_int_parameter);
  virtual folly::coro::Task<std::unique_ptr<::test::fixtures::basic::ReservedKeyword>> co_simple_rpc(apache::thrift::RequestParams params, ::std::int32_t p_int_parameter);
#endif
  virtual void async_tm_simple_rpc(std::unique_ptr<apache::thrift::HandlerCallback<std::unique_ptr<::test::fixtures::basic::ReservedKeyword>>> callback, ::std::int32_t p_int_parameter);
 private:
  static ::test::fixtures::basic::FB303ServiceServiceInfoHolder __fbthrift_serviceInfoHolder;
  std::atomic<apache::thrift::detail::si::InvocationType> __fbthrift_invocation_simple_rpc{apache::thrift::detail::si::InvocationType::AsyncTm};
};

} // namespace apache::thrift

namespace test { namespace fixtures { namespace basic {
using FB303ServiceSvIf [[deprecated("Use apache::thrift::ServiceHandler<FB303Service> instead")]] = ::apache::thrift::ServiceHandler<FB303Service>;
}}} // test::fixtures::basic
namespace test { namespace fixtures { namespace basic {
class FB303ServiceSvNull : public ::apache::thrift::ServiceHandler<FB303Service> {
 public:
  void simple_rpc(::test::fixtures::basic::ReservedKeyword& /*_return*/, ::std::int32_t /*int_parameter*/) override;
};

class FB303ServiceAsyncProcessor : public ::apache::thrift::GeneratedAsyncProcessorBase {
 public:
  const char* getServiceName() override;
  void getServiceMetadata(apache::thrift::metadata::ThriftServiceMetadataResponse& response) override;
  using BaseAsyncProcessor = void;
 protected:
  ::apache::thrift::ServiceHandler<::test::fixtures::basic::FB303Service>* iface_;
 public:
  void processSerializedCompressedRequestWithMetadata(apache::thrift::ResponseChannelRequest::UniquePtr req, apache::thrift::SerializedCompressedRequest&& serializedRequest, const apache::thrift::AsyncProcessorFactory::MethodMetadata& methodMetadata, apache::thrift::protocol::PROTOCOL_TYPES protType, apache::thrift::Cpp2RequestContext* context, folly::EventBase* eb, apache::thrift::concurrency::ThreadManager* tm) override;
  void executeRequest(apache::thrift::ServerRequest&& serverRequest, const apache::thrift::AsyncProcessorFactory::MethodMetadata& methodMetadata) override;
 public:
  using ProcessFuncs = GeneratedAsyncProcessorBase::ProcessFuncs<FB303ServiceAsyncProcessor>;
  using ProcessMap = GeneratedAsyncProcessorBase::ProcessMap<ProcessFuncs>;
  static const FB303ServiceAsyncProcessor::ProcessMap& getOwnProcessMap();
 private:
  static const FB303ServiceAsyncProcessor::ProcessMap kOwnProcessMap_;
 private:
  template <typename ProtocolIn_, typename ProtocolOut_>
  void setUpAndProcess_simple_rpc(apache::thrift::ResponseChannelRequest::UniquePtr req, apache::thrift::SerializedCompressedRequest&& serializedRequest, apache::thrift::Cpp2RequestContext* ctx, folly::EventBase* eb, apache::thrift::concurrency::ThreadManager* tm);
  template <typename ProtocolIn_, typename ProtocolOut_>
  void executeRequest_simple_rpc(apache::thrift::ServerRequest&& serverRequest);
  template <class ProtocolIn_, class ProtocolOut_>
  static apache::thrift::SerializedResponse return_simple_rpc(apache::thrift::ContextStack* ctx, ::test::fixtures::basic::ReservedKeyword const& _return);
  template <class ProtocolIn_, class ProtocolOut_>
  static void throw_wrapped_simple_rpc(apache::thrift::ResponseChannelRequest::UniquePtr req,int32_t protoSeqId,apache::thrift::ContextStack* ctx,folly::exception_wrapper ew,apache::thrift::Cpp2RequestContext* reqCtx);
 public:
  FB303ServiceAsyncProcessor(::apache::thrift::ServiceHandler<::test::fixtures::basic::FB303Service>* iface) :
      iface_(iface) {}
  ~FB303ServiceAsyncProcessor() override {}
};

}}} // test::fixtures::basic
