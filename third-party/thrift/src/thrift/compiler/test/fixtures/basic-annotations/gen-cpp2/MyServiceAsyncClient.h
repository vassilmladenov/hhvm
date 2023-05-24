/**
 * Autogenerated by Thrift for thrift/compiler/test/fixtures/basic-annotations/src/module.thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated @nocommit
 */
#pragma once

#include <thrift/lib/cpp2/gen/client_h.h>

#include "thrift/compiler/test/fixtures/basic-annotations/gen-cpp2/module_types.h"

namespace apache { namespace thrift {
  class Cpp2RequestContext;
  namespace detail { namespace ac { struct ClientRequestContext; }}
  namespace transport { class THeader; }
}}

namespace cpp2 {
class MyService;
} // cpp2
namespace apache::thrift {

template <>
class Client<::cpp2::MyService> : public apache::thrift::GeneratedAsyncClient {
 public:
  using apache::thrift::GeneratedAsyncClient::GeneratedAsyncClient;

  char const* getServiceName() const noexcept override {
    return "MyService";
  }


  virtual void ping(std::unique_ptr<apache::thrift::RequestCallback> callback);
  virtual void ping(apache::thrift::RpcOptions& rpcOptions, std::unique_ptr<apache::thrift::RequestCallback> callback);
 protected:
  void pingImpl(apache::thrift::RpcOptions& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, bool stealRpcOptions = false);
 public:

  virtual void sync_ping();
  virtual void sync_ping(apache::thrift::RpcOptions& rpcOptions);

  virtual folly::Future<folly::Unit> future_ping();
  virtual folly::SemiFuture<folly::Unit> semifuture_ping();
  virtual folly::Future<folly::Unit> future_ping(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::SemiFuture<folly::Unit> semifuture_ping(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::Future<std::pair<folly::Unit, std::unique_ptr<apache::thrift::transport::THeader>>> header_future_ping(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::SemiFuture<std::pair<folly::Unit, std::unique_ptr<apache::thrift::transport::THeader>>> header_semifuture_ping(apache::thrift::RpcOptions& rpcOptions);

#if FOLLY_HAS_COROUTINES
#if __clang__
  template <int = 0>
  folly::coro::Task<void> co_ping() {
    return co_ping<false>(nullptr);
  }
  template <int = 0>
  folly::coro::Task<void> co_ping(apache::thrift::RpcOptions& rpcOptions) {
    return co_ping<true>(&rpcOptions);
  }
#else
  folly::coro::Task<void> co_ping() {
    co_await folly::coro::detachOnCancel(semifuture_ping());
  }
  folly::coro::Task<void> co_ping(apache::thrift::RpcOptions& rpcOptions) {
    co_await folly::coro::detachOnCancel(semifuture_ping(rpcOptions));
  }
#endif
 private:
  template <bool hasRpcOptions>
  folly::coro::Task<void> co_ping(apache::thrift::RpcOptions* rpcOptions) {
    const folly::CancellationToken& cancelToken =
        co_await folly::coro::co_current_cancellation_token;
    const bool cancellable = cancelToken.canBeCancelled();
    apache::thrift::ClientReceiveState returnState;
    apache::thrift::ClientCoroCallback<false> callback(&returnState, co_await folly::coro::co_current_executor);
    auto protocolId = apache::thrift::GeneratedAsyncClient::getChannel()->getProtocolId();
    auto [ctx, header] = pingCtx(rpcOptions);
    using CancellableCallback = apache::thrift::CancellableRequestClientCallback<false>;
    auto cancellableCallback = cancellable ? CancellableCallback::create(&callback, channel_) : nullptr;
    static apache::thrift::RpcOptions* defaultRpcOptions = new apache::thrift::RpcOptions();
    auto wrappedCallback = apache::thrift::RequestClientCallback::Ptr(cancellableCallback ? (apache::thrift::RequestClientCallback*)cancellableCallback.get() : &callback);
    if constexpr (hasRpcOptions) {
      pingImpl(*rpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback));
    } else {
      pingImpl(*defaultRpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback));
    }
    if (cancellable) {
      folly::CancellationCallback cb(cancelToken, [&] { CancellableCallback::cancel(std::move(cancellableCallback)); });
      co_await callback.co_waitUntilDone();
    } else {
      co_await callback.co_waitUntilDone();
    }
    if (returnState.isException()) {
      co_yield folly::coro::co_error(std::move(returnState.exception()));
    }
    returnState.resetProtocolId(protocolId);
    returnState.resetCtx(std::move(ctx));
    SCOPE_EXIT {
      if (hasRpcOptions && returnState.header()) {
        auto* rheader = returnState.header();
        if (!rheader->getHeaders().empty()) {
          rpcOptions->setReadHeaders(rheader->releaseHeaders());
        }
        rpcOptions->setRoutingData(rheader->releaseRoutingData());
      }
    };
    if (auto ew = recv_wrapped_ping(returnState)) {
      co_yield folly::coro::co_error(std::move(ew));
    }
  }
 public:
#endif // FOLLY_HAS_COROUTINES

  virtual void ping(folly::Function<void (::apache::thrift::ClientReceiveState&&)> callback);


  static folly::exception_wrapper recv_wrapped_ping(::apache::thrift::ClientReceiveState& state);
  static void recv_ping(::apache::thrift::ClientReceiveState& state);
  // Mock friendly virtual instance method
  virtual void recv_instance_ping(::apache::thrift::ClientReceiveState& state);
  virtual folly::exception_wrapper recv_instance_wrapped_ping(::apache::thrift::ClientReceiveState& state);
 private:
  template <typename Protocol_, typename RpcOptions>
  void pingT(Protocol_* prot, RpcOptions&& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback);
  std::pair<::apache::thrift::ContextStack::UniquePtr, std::shared_ptr<::apache::thrift::transport::THeader>> pingCtx(apache::thrift::RpcOptions* rpcOptions);
 public:
  virtual void getRandomData(std::unique_ptr<apache::thrift::RequestCallback> callback);
  virtual void getRandomData(apache::thrift::RpcOptions& rpcOptions, std::unique_ptr<apache::thrift::RequestCallback> callback);
 protected:
  void getRandomDataImpl(apache::thrift::RpcOptions& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, bool stealRpcOptions = false);
 public:

  virtual void sync_getRandomData(::std::string& _return);
  virtual void sync_getRandomData(apache::thrift::RpcOptions& rpcOptions, ::std::string& _return);

  virtual folly::Future<::std::string> future_getRandomData();
  virtual folly::SemiFuture<::std::string> semifuture_getRandomData();
  virtual folly::Future<::std::string> future_getRandomData(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::SemiFuture<::std::string> semifuture_getRandomData(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::Future<std::pair<::std::string, std::unique_ptr<apache::thrift::transport::THeader>>> header_future_getRandomData(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::SemiFuture<std::pair<::std::string, std::unique_ptr<apache::thrift::transport::THeader>>> header_semifuture_getRandomData(apache::thrift::RpcOptions& rpcOptions);

#if FOLLY_HAS_COROUTINES
#if __clang__
  template <int = 0>
  folly::coro::Task<::std::string> co_getRandomData() {
    return co_getRandomData<false>(nullptr);
  }
  template <int = 0>
  folly::coro::Task<::std::string> co_getRandomData(apache::thrift::RpcOptions& rpcOptions) {
    return co_getRandomData<true>(&rpcOptions);
  }
#else
  folly::coro::Task<::std::string> co_getRandomData() {
    co_return co_await folly::coro::detachOnCancel(semifuture_getRandomData());
  }
  folly::coro::Task<::std::string> co_getRandomData(apache::thrift::RpcOptions& rpcOptions) {
    co_return co_await folly::coro::detachOnCancel(semifuture_getRandomData(rpcOptions));
  }
#endif
 private:
  template <bool hasRpcOptions>
  folly::coro::Task<::std::string> co_getRandomData(apache::thrift::RpcOptions* rpcOptions) {
    const folly::CancellationToken& cancelToken =
        co_await folly::coro::co_current_cancellation_token;
    const bool cancellable = cancelToken.canBeCancelled();
    apache::thrift::ClientReceiveState returnState;
    apache::thrift::ClientCoroCallback<false> callback(&returnState, co_await folly::coro::co_current_executor);
    auto protocolId = apache::thrift::GeneratedAsyncClient::getChannel()->getProtocolId();
    auto [ctx, header] = getRandomDataCtx(rpcOptions);
    using CancellableCallback = apache::thrift::CancellableRequestClientCallback<false>;
    auto cancellableCallback = cancellable ? CancellableCallback::create(&callback, channel_) : nullptr;
    static apache::thrift::RpcOptions* defaultRpcOptions = new apache::thrift::RpcOptions();
    auto wrappedCallback = apache::thrift::RequestClientCallback::Ptr(cancellableCallback ? (apache::thrift::RequestClientCallback*)cancellableCallback.get() : &callback);
    if constexpr (hasRpcOptions) {
      getRandomDataImpl(*rpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback));
    } else {
      getRandomDataImpl(*defaultRpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback));
    }
    if (cancellable) {
      folly::CancellationCallback cb(cancelToken, [&] { CancellableCallback::cancel(std::move(cancellableCallback)); });
      co_await callback.co_waitUntilDone();
    } else {
      co_await callback.co_waitUntilDone();
    }
    if (returnState.isException()) {
      co_yield folly::coro::co_error(std::move(returnState.exception()));
    }
    returnState.resetProtocolId(protocolId);
    returnState.resetCtx(std::move(ctx));
    SCOPE_EXIT {
      if (hasRpcOptions && returnState.header()) {
        auto* rheader = returnState.header();
        if (!rheader->getHeaders().empty()) {
          rpcOptions->setReadHeaders(rheader->releaseHeaders());
        }
        rpcOptions->setRoutingData(rheader->releaseRoutingData());
      }
    };
    ::std::string _return;
    if (auto ew = recv_wrapped_getRandomData(_return, returnState)) {
      co_yield folly::coro::co_error(std::move(ew));
    }
    co_return _return;
  }
 public:
#endif // FOLLY_HAS_COROUTINES

  virtual void getRandomData(folly::Function<void (::apache::thrift::ClientReceiveState&&)> callback);


  static folly::exception_wrapper recv_wrapped_getRandomData(::std::string& _return, ::apache::thrift::ClientReceiveState& state);
  static void recv_getRandomData(::std::string& _return, ::apache::thrift::ClientReceiveState& state);
  // Mock friendly virtual instance method
  virtual void recv_instance_getRandomData(::std::string& _return, ::apache::thrift::ClientReceiveState& state);
  virtual folly::exception_wrapper recv_instance_wrapped_getRandomData(::std::string& _return, ::apache::thrift::ClientReceiveState& state);
 private:
  template <typename Protocol_, typename RpcOptions>
  void getRandomDataT(Protocol_* prot, RpcOptions&& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback);
  std::pair<::apache::thrift::ContextStack::UniquePtr, std::shared_ptr<::apache::thrift::transport::THeader>> getRandomDataCtx(apache::thrift::RpcOptions* rpcOptions);
 public:
  virtual void hasDataById(std::unique_ptr<apache::thrift::RequestCallback> callback, ::std::int64_t p_id);
  virtual void hasDataById(apache::thrift::RpcOptions& rpcOptions, std::unique_ptr<apache::thrift::RequestCallback> callback, ::std::int64_t p_id);
 protected:
  void hasDataByIdImpl(apache::thrift::RpcOptions& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, ::std::int64_t p_id, bool stealRpcOptions = false);
 public:

  virtual bool sync_hasDataById(::std::int64_t p_id);
  virtual bool sync_hasDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);

  virtual folly::Future<bool> future_hasDataById(::std::int64_t p_id);
  virtual folly::SemiFuture<bool> semifuture_hasDataById(::std::int64_t p_id);
  virtual folly::Future<bool> future_hasDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);
  virtual folly::SemiFuture<bool> semifuture_hasDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);
  virtual folly::Future<std::pair<bool, std::unique_ptr<apache::thrift::transport::THeader>>> header_future_hasDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);
  virtual folly::SemiFuture<std::pair<bool, std::unique_ptr<apache::thrift::transport::THeader>>> header_semifuture_hasDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);

#if FOLLY_HAS_COROUTINES
#if __clang__
  template <int = 0>
  folly::coro::Task<bool> co_hasDataById(::std::int64_t p_id) {
    return co_hasDataById<false>(nullptr, p_id);
  }
  template <int = 0>
  folly::coro::Task<bool> co_hasDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id) {
    return co_hasDataById<true>(&rpcOptions, p_id);
  }
#else
  folly::coro::Task<bool> co_hasDataById(::std::int64_t p_id) {
    co_return co_await folly::coro::detachOnCancel(semifuture_hasDataById(p_id));
  }
  folly::coro::Task<bool> co_hasDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id) {
    co_return co_await folly::coro::detachOnCancel(semifuture_hasDataById(rpcOptions, p_id));
  }
#endif
 private:
  template <bool hasRpcOptions>
  folly::coro::Task<bool> co_hasDataById(apache::thrift::RpcOptions* rpcOptions, ::std::int64_t p_id) {
    const folly::CancellationToken& cancelToken =
        co_await folly::coro::co_current_cancellation_token;
    const bool cancellable = cancelToken.canBeCancelled();
    apache::thrift::ClientReceiveState returnState;
    apache::thrift::ClientCoroCallback<false> callback(&returnState, co_await folly::coro::co_current_executor);
    auto protocolId = apache::thrift::GeneratedAsyncClient::getChannel()->getProtocolId();
    auto [ctx, header] = hasDataByIdCtx(rpcOptions);
    using CancellableCallback = apache::thrift::CancellableRequestClientCallback<false>;
    auto cancellableCallback = cancellable ? CancellableCallback::create(&callback, channel_) : nullptr;
    static apache::thrift::RpcOptions* defaultRpcOptions = new apache::thrift::RpcOptions();
    auto wrappedCallback = apache::thrift::RequestClientCallback::Ptr(cancellableCallback ? (apache::thrift::RequestClientCallback*)cancellableCallback.get() : &callback);
    if constexpr (hasRpcOptions) {
      hasDataByIdImpl(*rpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback), p_id);
    } else {
      hasDataByIdImpl(*defaultRpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback), p_id);
    }
    if (cancellable) {
      folly::CancellationCallback cb(cancelToken, [&] { CancellableCallback::cancel(std::move(cancellableCallback)); });
      co_await callback.co_waitUntilDone();
    } else {
      co_await callback.co_waitUntilDone();
    }
    if (returnState.isException()) {
      co_yield folly::coro::co_error(std::move(returnState.exception()));
    }
    returnState.resetProtocolId(protocolId);
    returnState.resetCtx(std::move(ctx));
    SCOPE_EXIT {
      if (hasRpcOptions && returnState.header()) {
        auto* rheader = returnState.header();
        if (!rheader->getHeaders().empty()) {
          rpcOptions->setReadHeaders(rheader->releaseHeaders());
        }
        rpcOptions->setRoutingData(rheader->releaseRoutingData());
      }
    };
    bool _return;
    if (auto ew = recv_wrapped_hasDataById(_return, returnState)) {
      co_yield folly::coro::co_error(std::move(ew));
    }
    co_return _return;
  }
 public:
#endif // FOLLY_HAS_COROUTINES

  virtual void hasDataById(folly::Function<void (::apache::thrift::ClientReceiveState&&)> callback, ::std::int64_t p_id);


  static folly::exception_wrapper recv_wrapped_hasDataById(bool& _return, ::apache::thrift::ClientReceiveState& state);
  static bool recv_hasDataById(::apache::thrift::ClientReceiveState& state);
  // Mock friendly virtual instance method
  virtual bool recv_instance_hasDataById(::apache::thrift::ClientReceiveState& state);
  virtual folly::exception_wrapper recv_instance_wrapped_hasDataById(bool& _return, ::apache::thrift::ClientReceiveState& state);
 private:
  template <typename Protocol_, typename RpcOptions>
  void hasDataByIdT(Protocol_* prot, RpcOptions&& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, ::std::int64_t p_id);
  std::pair<::apache::thrift::ContextStack::UniquePtr, std::shared_ptr<::apache::thrift::transport::THeader>> hasDataByIdCtx(apache::thrift::RpcOptions* rpcOptions);
 public:
  virtual void getDataById(std::unique_ptr<apache::thrift::RequestCallback> callback, ::std::int64_t p_id);
  virtual void getDataById(apache::thrift::RpcOptions& rpcOptions, std::unique_ptr<apache::thrift::RequestCallback> callback, ::std::int64_t p_id);
 protected:
  void getDataByIdImpl(apache::thrift::RpcOptions& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, ::std::int64_t p_id, bool stealRpcOptions = false);
 public:

  virtual void sync_getDataById(::std::string& _return, ::std::int64_t p_id);
  virtual void sync_getDataById(apache::thrift::RpcOptions& rpcOptions, ::std::string& _return, ::std::int64_t p_id);

  virtual folly::Future<::std::string> future_getDataById(::std::int64_t p_id);
  virtual folly::SemiFuture<::std::string> semifuture_getDataById(::std::int64_t p_id);
  virtual folly::Future<::std::string> future_getDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);
  virtual folly::SemiFuture<::std::string> semifuture_getDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);
  virtual folly::Future<std::pair<::std::string, std::unique_ptr<apache::thrift::transport::THeader>>> header_future_getDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);
  virtual folly::SemiFuture<std::pair<::std::string, std::unique_ptr<apache::thrift::transport::THeader>>> header_semifuture_getDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id);

#if FOLLY_HAS_COROUTINES
#if __clang__
  template <int = 0>
  folly::coro::Task<::std::string> co_getDataById(::std::int64_t p_id) {
    return co_getDataById<false>(nullptr, p_id);
  }
  template <int = 0>
  folly::coro::Task<::std::string> co_getDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id) {
    return co_getDataById<true>(&rpcOptions, p_id);
  }
#else
  folly::coro::Task<::std::string> co_getDataById(::std::int64_t p_id) {
    co_return co_await folly::coro::detachOnCancel(semifuture_getDataById(p_id));
  }
  folly::coro::Task<::std::string> co_getDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id) {
    co_return co_await folly::coro::detachOnCancel(semifuture_getDataById(rpcOptions, p_id));
  }
#endif
 private:
  template <bool hasRpcOptions>
  folly::coro::Task<::std::string> co_getDataById(apache::thrift::RpcOptions* rpcOptions, ::std::int64_t p_id) {
    const folly::CancellationToken& cancelToken =
        co_await folly::coro::co_current_cancellation_token;
    const bool cancellable = cancelToken.canBeCancelled();
    apache::thrift::ClientReceiveState returnState;
    apache::thrift::ClientCoroCallback<false> callback(&returnState, co_await folly::coro::co_current_executor);
    auto protocolId = apache::thrift::GeneratedAsyncClient::getChannel()->getProtocolId();
    auto [ctx, header] = getDataByIdCtx(rpcOptions);
    using CancellableCallback = apache::thrift::CancellableRequestClientCallback<false>;
    auto cancellableCallback = cancellable ? CancellableCallback::create(&callback, channel_) : nullptr;
    static apache::thrift::RpcOptions* defaultRpcOptions = new apache::thrift::RpcOptions();
    auto wrappedCallback = apache::thrift::RequestClientCallback::Ptr(cancellableCallback ? (apache::thrift::RequestClientCallback*)cancellableCallback.get() : &callback);
    if constexpr (hasRpcOptions) {
      getDataByIdImpl(*rpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback), p_id);
    } else {
      getDataByIdImpl(*defaultRpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback), p_id);
    }
    if (cancellable) {
      folly::CancellationCallback cb(cancelToken, [&] { CancellableCallback::cancel(std::move(cancellableCallback)); });
      co_await callback.co_waitUntilDone();
    } else {
      co_await callback.co_waitUntilDone();
    }
    if (returnState.isException()) {
      co_yield folly::coro::co_error(std::move(returnState.exception()));
    }
    returnState.resetProtocolId(protocolId);
    returnState.resetCtx(std::move(ctx));
    SCOPE_EXIT {
      if (hasRpcOptions && returnState.header()) {
        auto* rheader = returnState.header();
        if (!rheader->getHeaders().empty()) {
          rpcOptions->setReadHeaders(rheader->releaseHeaders());
        }
        rpcOptions->setRoutingData(rheader->releaseRoutingData());
      }
    };
    ::std::string _return;
    if (auto ew = recv_wrapped_getDataById(_return, returnState)) {
      co_yield folly::coro::co_error(std::move(ew));
    }
    co_return _return;
  }
 public:
#endif // FOLLY_HAS_COROUTINES

  virtual void getDataById(folly::Function<void (::apache::thrift::ClientReceiveState&&)> callback, ::std::int64_t p_id);


  static folly::exception_wrapper recv_wrapped_getDataById(::std::string& _return, ::apache::thrift::ClientReceiveState& state);
  static void recv_getDataById(::std::string& _return, ::apache::thrift::ClientReceiveState& state);
  // Mock friendly virtual instance method
  virtual void recv_instance_getDataById(::std::string& _return, ::apache::thrift::ClientReceiveState& state);
  virtual folly::exception_wrapper recv_instance_wrapped_getDataById(::std::string& _return, ::apache::thrift::ClientReceiveState& state);
 private:
  template <typename Protocol_, typename RpcOptions>
  void getDataByIdT(Protocol_* prot, RpcOptions&& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, ::std::int64_t p_id);
  std::pair<::apache::thrift::ContextStack::UniquePtr, std::shared_ptr<::apache::thrift::transport::THeader>> getDataByIdCtx(apache::thrift::RpcOptions* rpcOptions);
 public:
  virtual void putDataById(std::unique_ptr<apache::thrift::RequestCallback> callback, ::std::int64_t p_id, const ::std::string& p_data);
  virtual void putDataById(apache::thrift::RpcOptions& rpcOptions, std::unique_ptr<apache::thrift::RequestCallback> callback, ::std::int64_t p_id, const ::std::string& p_data);
 protected:
  void putDataByIdImpl(apache::thrift::RpcOptions& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, ::std::int64_t p_id, const ::std::string& p_data, bool stealRpcOptions = false);
 public:

  virtual void sync_putDataById(::std::int64_t p_id, const ::std::string& p_data);
  virtual void sync_putDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_data);

  virtual folly::Future<folly::Unit> future_putDataById(::std::int64_t p_id, const ::std::string& p_data);
  virtual folly::SemiFuture<folly::Unit> semifuture_putDataById(::std::int64_t p_id, const ::std::string& p_data);
  virtual folly::Future<folly::Unit> future_putDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_data);
  virtual folly::SemiFuture<folly::Unit> semifuture_putDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_data);
  virtual folly::Future<std::pair<folly::Unit, std::unique_ptr<apache::thrift::transport::THeader>>> header_future_putDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_data);
  virtual folly::SemiFuture<std::pair<folly::Unit, std::unique_ptr<apache::thrift::transport::THeader>>> header_semifuture_putDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_data);

#if FOLLY_HAS_COROUTINES
#if __clang__
  template <int = 0>
  folly::coro::Task<void> co_putDataById(::std::int64_t p_id, const ::std::string& p_data) {
    return co_putDataById<false>(nullptr, p_id, p_data);
  }
  template <int = 0>
  folly::coro::Task<void> co_putDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_data) {
    return co_putDataById<true>(&rpcOptions, p_id, p_data);
  }
#else
  folly::coro::Task<void> co_putDataById(::std::int64_t p_id, const ::std::string& p_data) {
    co_await folly::coro::detachOnCancel(semifuture_putDataById(p_id, p_data));
  }
  folly::coro::Task<void> co_putDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_data) {
    co_await folly::coro::detachOnCancel(semifuture_putDataById(rpcOptions, p_id, p_data));
  }
#endif
 private:
  template <bool hasRpcOptions>
  folly::coro::Task<void> co_putDataById(apache::thrift::RpcOptions* rpcOptions, ::std::int64_t p_id, const ::std::string& p_data) {
    const folly::CancellationToken& cancelToken =
        co_await folly::coro::co_current_cancellation_token;
    const bool cancellable = cancelToken.canBeCancelled();
    apache::thrift::ClientReceiveState returnState;
    apache::thrift::ClientCoroCallback<false> callback(&returnState, co_await folly::coro::co_current_executor);
    auto protocolId = apache::thrift::GeneratedAsyncClient::getChannel()->getProtocolId();
    auto [ctx, header] = putDataByIdCtx(rpcOptions);
    using CancellableCallback = apache::thrift::CancellableRequestClientCallback<false>;
    auto cancellableCallback = cancellable ? CancellableCallback::create(&callback, channel_) : nullptr;
    static apache::thrift::RpcOptions* defaultRpcOptions = new apache::thrift::RpcOptions();
    auto wrappedCallback = apache::thrift::RequestClientCallback::Ptr(cancellableCallback ? (apache::thrift::RequestClientCallback*)cancellableCallback.get() : &callback);
    if constexpr (hasRpcOptions) {
      putDataByIdImpl(*rpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback), p_id, p_data);
    } else {
      putDataByIdImpl(*defaultRpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback), p_id, p_data);
    }
    if (cancellable) {
      folly::CancellationCallback cb(cancelToken, [&] { CancellableCallback::cancel(std::move(cancellableCallback)); });
      co_await callback.co_waitUntilDone();
    } else {
      co_await callback.co_waitUntilDone();
    }
    if (returnState.isException()) {
      co_yield folly::coro::co_error(std::move(returnState.exception()));
    }
    returnState.resetProtocolId(protocolId);
    returnState.resetCtx(std::move(ctx));
    SCOPE_EXIT {
      if (hasRpcOptions && returnState.header()) {
        auto* rheader = returnState.header();
        if (!rheader->getHeaders().empty()) {
          rpcOptions->setReadHeaders(rheader->releaseHeaders());
        }
        rpcOptions->setRoutingData(rheader->releaseRoutingData());
      }
    };
    if (auto ew = recv_wrapped_putDataById(returnState)) {
      co_yield folly::coro::co_error(std::move(ew));
    }
  }
 public:
#endif // FOLLY_HAS_COROUTINES

  virtual void putDataById(folly::Function<void (::apache::thrift::ClientReceiveState&&)> callback, ::std::int64_t p_id, const ::std::string& p_data);


  static folly::exception_wrapper recv_wrapped_putDataById(::apache::thrift::ClientReceiveState& state);
  static void recv_putDataById(::apache::thrift::ClientReceiveState& state);
  // Mock friendly virtual instance method
  virtual void recv_instance_putDataById(::apache::thrift::ClientReceiveState& state);
  virtual folly::exception_wrapper recv_instance_wrapped_putDataById(::apache::thrift::ClientReceiveState& state);
 private:
  template <typename Protocol_, typename RpcOptions>
  void putDataByIdT(Protocol_* prot, RpcOptions&& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, ::std::int64_t p_id, const ::std::string& p_data);
  std::pair<::apache::thrift::ContextStack::UniquePtr, std::shared_ptr<::apache::thrift::transport::THeader>> putDataByIdCtx(apache::thrift::RpcOptions* rpcOptions);
 public:
  virtual void lobDataById(std::unique_ptr<apache::thrift::RequestCallback> callback, ::std::int64_t p_id, const ::std::string& p_dataStr);
  virtual void lobDataById(apache::thrift::RpcOptions& rpcOptions, std::unique_ptr<apache::thrift::RequestCallback> callback, ::std::int64_t p_id, const ::std::string& p_dataStr);
 protected:
  void lobDataByIdImpl(apache::thrift::RpcOptions& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, ::std::int64_t p_id, const ::std::string& p_dataStr, bool stealRpcOptions = false);
 public:

  virtual void sync_lobDataById(::std::int64_t p_id, const ::std::string& p_dataStr);
  virtual void sync_lobDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_dataStr);

  virtual folly::Future<folly::Unit> future_lobDataById(::std::int64_t p_id, const ::std::string& p_dataStr);
  virtual folly::SemiFuture<folly::Unit> semifuture_lobDataById(::std::int64_t p_id, const ::std::string& p_dataStr);
  virtual folly::Future<folly::Unit> future_lobDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_dataStr);
  virtual folly::SemiFuture<folly::Unit> semifuture_lobDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_dataStr);

#if FOLLY_HAS_COROUTINES
#if __clang__
  template <int = 0>
  folly::coro::Task<void> co_lobDataById(::std::int64_t p_id, const ::std::string& p_dataStr) {
    return co_lobDataById<false>(nullptr, p_id, p_dataStr);
  }
  template <int = 0>
  folly::coro::Task<void> co_lobDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_dataStr) {
    return co_lobDataById<true>(&rpcOptions, p_id, p_dataStr);
  }
#else
  folly::coro::Task<void> co_lobDataById(::std::int64_t p_id, const ::std::string& p_dataStr) {
    co_await folly::coro::detachOnCancel(semifuture_lobDataById(p_id, p_dataStr));
  }
  folly::coro::Task<void> co_lobDataById(apache::thrift::RpcOptions& rpcOptions, ::std::int64_t p_id, const ::std::string& p_dataStr) {
    co_await folly::coro::detachOnCancel(semifuture_lobDataById(rpcOptions, p_id, p_dataStr));
  }
#endif
 private:
  template <bool hasRpcOptions>
  folly::coro::Task<void> co_lobDataById(apache::thrift::RpcOptions* rpcOptions, ::std::int64_t p_id, const ::std::string& p_dataStr) {
    const folly::CancellationToken& cancelToken =
        co_await folly::coro::co_current_cancellation_token;
    const bool cancellable = cancelToken.canBeCancelled();
    apache::thrift::ClientReceiveState returnState;
    apache::thrift::ClientCoroCallback<true> callback(&returnState, co_await folly::coro::co_current_executor);
    auto [ctx, header] = lobDataByIdCtx(rpcOptions);
    using CancellableCallback = apache::thrift::CancellableRequestClientCallback<true>;
    auto cancellableCallback = cancellable ? CancellableCallback::create(&callback, channel_) : nullptr;
    static apache::thrift::RpcOptions* defaultRpcOptions = new apache::thrift::RpcOptions();
    auto wrappedCallback = apache::thrift::RequestClientCallback::Ptr(cancellableCallback ? (apache::thrift::RequestClientCallback*)cancellableCallback.get() : &callback);
    if constexpr (hasRpcOptions) {
      lobDataByIdImpl(*rpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback), p_id, p_dataStr);
    } else {
      lobDataByIdImpl(*defaultRpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback), p_id, p_dataStr);
    }
    if (cancellable) {
      folly::CancellationCallback cb(cancelToken, [&] { CancellableCallback::cancel(std::move(cancellableCallback)); });
      co_await callback.co_waitUntilDone();
    } else {
      co_await callback.co_waitUntilDone();
    }
    if (returnState.isException()) {
      co_yield folly::coro::co_error(std::move(returnState.exception()));
    }
  }
 public:
#endif // FOLLY_HAS_COROUTINES

  virtual void lobDataById(folly::Function<void (::apache::thrift::ClientReceiveState&&)> callback, ::std::int64_t p_id, const ::std::string& p_dataStr);


 private:
  template <typename Protocol_, typename RpcOptions>
  void lobDataByIdT(Protocol_* prot, RpcOptions&& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, ::std::int64_t p_id, const ::std::string& p_dataStr);
  std::pair<::apache::thrift::ContextStack::UniquePtr, std::shared_ptr<::apache::thrift::transport::THeader>> lobDataByIdCtx(apache::thrift::RpcOptions* rpcOptions);
 public:
  virtual void cppDoNothing(std::unique_ptr<apache::thrift::RequestCallback> callback);
  virtual void cppDoNothing(apache::thrift::RpcOptions& rpcOptions, std::unique_ptr<apache::thrift::RequestCallback> callback);
 protected:
  void cppDoNothingImpl(apache::thrift::RpcOptions& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback, bool stealRpcOptions = false);
 public:

  virtual void sync_cppDoNothing();
  virtual void sync_cppDoNothing(apache::thrift::RpcOptions& rpcOptions);

  virtual folly::Future<folly::Unit> future_cppDoNothing();
  virtual folly::SemiFuture<folly::Unit> semifuture_cppDoNothing();
  virtual folly::Future<folly::Unit> future_cppDoNothing(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::SemiFuture<folly::Unit> semifuture_cppDoNothing(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::Future<std::pair<folly::Unit, std::unique_ptr<apache::thrift::transport::THeader>>> header_future_cppDoNothing(apache::thrift::RpcOptions& rpcOptions);
  virtual folly::SemiFuture<std::pair<folly::Unit, std::unique_ptr<apache::thrift::transport::THeader>>> header_semifuture_cppDoNothing(apache::thrift::RpcOptions& rpcOptions);

#if FOLLY_HAS_COROUTINES
#if __clang__
  template <int = 0>
  folly::coro::Task<void> co_cppDoNothing() {
    return co_cppDoNothing<false>(nullptr);
  }
  template <int = 0>
  folly::coro::Task<void> co_cppDoNothing(apache::thrift::RpcOptions& rpcOptions) {
    return co_cppDoNothing<true>(&rpcOptions);
  }
#else
  folly::coro::Task<void> co_cppDoNothing() {
    co_await folly::coro::detachOnCancel(semifuture_cppDoNothing());
  }
  folly::coro::Task<void> co_cppDoNothing(apache::thrift::RpcOptions& rpcOptions) {
    co_await folly::coro::detachOnCancel(semifuture_cppDoNothing(rpcOptions));
  }
#endif
 private:
  template <bool hasRpcOptions>
  folly::coro::Task<void> co_cppDoNothing(apache::thrift::RpcOptions* rpcOptions) {
    const folly::CancellationToken& cancelToken =
        co_await folly::coro::co_current_cancellation_token;
    const bool cancellable = cancelToken.canBeCancelled();
    apache::thrift::ClientReceiveState returnState;
    apache::thrift::ClientCoroCallback<false> callback(&returnState, co_await folly::coro::co_current_executor);
    auto protocolId = apache::thrift::GeneratedAsyncClient::getChannel()->getProtocolId();
    auto [ctx, header] = cppDoNothingCtx(rpcOptions);
    using CancellableCallback = apache::thrift::CancellableRequestClientCallback<false>;
    auto cancellableCallback = cancellable ? CancellableCallback::create(&callback, channel_) : nullptr;
    static apache::thrift::RpcOptions* defaultRpcOptions = new apache::thrift::RpcOptions();
    auto wrappedCallback = apache::thrift::RequestClientCallback::Ptr(cancellableCallback ? (apache::thrift::RequestClientCallback*)cancellableCallback.get() : &callback);
    if constexpr (hasRpcOptions) {
      cppDoNothingImpl(*rpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback));
    } else {
      cppDoNothingImpl(*defaultRpcOptions, std::move(header), ctx.get(), std::move(wrappedCallback));
    }
    if (cancellable) {
      folly::CancellationCallback cb(cancelToken, [&] { CancellableCallback::cancel(std::move(cancellableCallback)); });
      co_await callback.co_waitUntilDone();
    } else {
      co_await callback.co_waitUntilDone();
    }
    if (returnState.isException()) {
      co_yield folly::coro::co_error(std::move(returnState.exception()));
    }
    returnState.resetProtocolId(protocolId);
    returnState.resetCtx(std::move(ctx));
    SCOPE_EXIT {
      if (hasRpcOptions && returnState.header()) {
        auto* rheader = returnState.header();
        if (!rheader->getHeaders().empty()) {
          rpcOptions->setReadHeaders(rheader->releaseHeaders());
        }
        rpcOptions->setRoutingData(rheader->releaseRoutingData());
      }
    };
    if (auto ew = recv_wrapped_cppDoNothing(returnState)) {
      co_yield folly::coro::co_error(std::move(ew));
    }
  }
 public:
#endif // FOLLY_HAS_COROUTINES

  virtual void cppDoNothing(folly::Function<void (::apache::thrift::ClientReceiveState&&)> callback);


  static folly::exception_wrapper recv_wrapped_cppDoNothing(::apache::thrift::ClientReceiveState& state);
  static void recv_cppDoNothing(::apache::thrift::ClientReceiveState& state);
  // Mock friendly virtual instance method
  virtual void recv_instance_cppDoNothing(::apache::thrift::ClientReceiveState& state);
  virtual folly::exception_wrapper recv_instance_wrapped_cppDoNothing(::apache::thrift::ClientReceiveState& state);
 private:
  template <typename Protocol_, typename RpcOptions>
  void cppDoNothingT(Protocol_* prot, RpcOptions&& rpcOptions, std::shared_ptr<apache::thrift::transport::THeader> header, apache::thrift::ContextStack* contextStack, apache::thrift::RequestClientCallback::Ptr callback);
  std::pair<::apache::thrift::ContextStack::UniquePtr, std::shared_ptr<::apache::thrift::transport::THeader>> cppDoNothingCtx(apache::thrift::RpcOptions* rpcOptions);
 public:
};

} // namespace apache::thrift

namespace cpp2 {
using MyServiceAsyncClient [[deprecated("Use apache::thrift::Client<MyService> instead")]] = ::apache::thrift::Client<MyService>;
} // cpp2
