/**
 * Autogenerated by Thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

#include <src/gen-py3/module/clients_wrapper.h>

namespace py3 {
namespace simple {


folly::Future<int32_t>
SimpleServiceClientWrapper::get_five(
    apache::thrift::RpcOptions& rpcOptions) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_five, channel_);
  try {
    client->get_five(
      rpcOptions,
      std::move(callback)
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::add_five(
    apache::thrift::RpcOptions& rpcOptions,
    int32_t arg_num) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_add_five, channel_);
  try {
    client->add_five(
      rpcOptions,
      std::move(callback),
      arg_num
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<folly::Unit>
SimpleServiceClientWrapper::do_nothing(
    apache::thrift::RpcOptions& rpcOptions) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<folly::Unit> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<folly::Unit>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_do_nothing, channel_);
  try {
    client->do_nothing(
      rpcOptions,
      std::move(callback)
    );
  } catch (...) {
    return folly::makeFuture<folly::Unit>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::string>
SimpleServiceClientWrapper::concat(
    apache::thrift::RpcOptions& rpcOptions,
    std::string arg_first,
    std::string arg_second) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::string> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::string>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_concat, channel_);
  try {
    client->concat(
      rpcOptions,
      std::move(callback),
      arg_first,
      arg_second
    );
  } catch (...) {
    return folly::makeFuture<std::string>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::get_value(
    apache::thrift::RpcOptions& rpcOptions,
    ::py3::simple::SimpleStruct arg_simple_struct) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_value, channel_);
  try {
    client->get_value(
      rpcOptions,
      std::move(callback),
      arg_simple_struct
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<bool>
SimpleServiceClientWrapper::negate(
    apache::thrift::RpcOptions& rpcOptions,
    bool arg_input) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<bool> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<bool>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_negate, channel_);
  try {
    client->negate(
      rpcOptions,
      std::move(callback),
      arg_input
    );
  } catch (...) {
    return folly::makeFuture<bool>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int8_t>
SimpleServiceClientWrapper::tiny(
    apache::thrift::RpcOptions& rpcOptions,
    int8_t arg_input) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int8_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int8_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_tiny, channel_);
  try {
    client->tiny(
      rpcOptions,
      std::move(callback),
      arg_input
    );
  } catch (...) {
    return folly::makeFuture<int8_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int16_t>
SimpleServiceClientWrapper::small(
    apache::thrift::RpcOptions& rpcOptions,
    int16_t arg_input) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int16_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int16_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_small, channel_);
  try {
    client->small(
      rpcOptions,
      std::move(callback),
      arg_input
    );
  } catch (...) {
    return folly::makeFuture<int16_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int64_t>
SimpleServiceClientWrapper::big(
    apache::thrift::RpcOptions& rpcOptions,
    int64_t arg_input) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int64_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int64_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_big, channel_);
  try {
    client->big(
      rpcOptions,
      std::move(callback),
      arg_input
    );
  } catch (...) {
    return folly::makeFuture<int64_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<double>
SimpleServiceClientWrapper::two(
    apache::thrift::RpcOptions& rpcOptions,
    double arg_input) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<double> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<double>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_two, channel_);
  try {
    client->two(
      rpcOptions,
      std::move(callback),
      arg_input
    );
  } catch (...) {
    return folly::makeFuture<double>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<folly::Unit>
SimpleServiceClientWrapper::expected_exception(
    apache::thrift::RpcOptions& rpcOptions) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<folly::Unit> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<folly::Unit>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_expected_exception, channel_);
  try {
    client->expected_exception(
      rpcOptions,
      std::move(callback)
    );
  } catch (...) {
    return folly::makeFuture<folly::Unit>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::unexpected_exception(
    apache::thrift::RpcOptions& rpcOptions) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_unexpected_exception, channel_);
  try {
    client->unexpected_exception(
      rpcOptions,
      std::move(callback)
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::sum_i16_list(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<int16_t> arg_numbers) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_sum_i16_list, channel_);
  try {
    client->sum_i16_list(
      rpcOptions,
      std::move(callback),
      arg_numbers
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::sum_i32_list(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<int32_t> arg_numbers) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_sum_i32_list, channel_);
  try {
    client->sum_i32_list(
      rpcOptions,
      std::move(callback),
      arg_numbers
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::sum_i64_list(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<int64_t> arg_numbers) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_sum_i64_list, channel_);
  try {
    client->sum_i64_list(
      rpcOptions,
      std::move(callback),
      arg_numbers
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::string>
SimpleServiceClientWrapper::concat_many(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<std::string> arg_words) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::string> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::string>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_concat_many, channel_);
  try {
    client->concat_many(
      rpcOptions,
      std::move(callback),
      arg_words
    );
  } catch (...) {
    return folly::makeFuture<std::string>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::count_structs(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<::py3::simple::SimpleStruct> arg_items) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_count_structs, channel_);
  try {
    client->count_structs(
      rpcOptions,
      std::move(callback),
      arg_items
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::sum_set(
    apache::thrift::RpcOptions& rpcOptions,
    std::set<int32_t> arg_numbers) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_sum_set, channel_);
  try {
    client->sum_set(
      rpcOptions,
      std::move(callback),
      arg_numbers
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<bool>
SimpleServiceClientWrapper::contains_word(
    apache::thrift::RpcOptions& rpcOptions,
    std::set<std::string> arg_words,
    std::string arg_word) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<bool> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<bool>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_contains_word, channel_);
  try {
    client->contains_word(
      rpcOptions,
      std::move(callback),
      arg_words,
      arg_word
    );
  } catch (...) {
    return folly::makeFuture<bool>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::string>
SimpleServiceClientWrapper::get_map_value(
    apache::thrift::RpcOptions& rpcOptions,
    std::map<std::string,std::string> arg_words,
    std::string arg_key) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::string> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::string>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_map_value, channel_);
  try {
    client->get_map_value(
      rpcOptions,
      std::move(callback),
      arg_words,
      arg_key
    );
  } catch (...) {
    return folly::makeFuture<std::string>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int16_t>
SimpleServiceClientWrapper::map_length(
    apache::thrift::RpcOptions& rpcOptions,
    std::map<std::string,::py3::simple::SimpleStruct> arg_items) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int16_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int16_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_map_length, channel_);
  try {
    client->map_length(
      rpcOptions,
      std::move(callback),
      arg_items
    );
  } catch (...) {
    return folly::makeFuture<int16_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int16_t>
SimpleServiceClientWrapper::sum_map_values(
    apache::thrift::RpcOptions& rpcOptions,
    std::map<std::string,int16_t> arg_items) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int16_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int16_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_sum_map_values, channel_);
  try {
    client->sum_map_values(
      rpcOptions,
      std::move(callback),
      arg_items
    );
  } catch (...) {
    return folly::makeFuture<int16_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::complex_sum_i32(
    apache::thrift::RpcOptions& rpcOptions,
    ::py3::simple::ComplexStruct arg_counter) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_complex_sum_i32, channel_);
  try {
    client->complex_sum_i32(
      rpcOptions,
      std::move(callback),
      arg_counter
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::string>
SimpleServiceClientWrapper::repeat_name(
    apache::thrift::RpcOptions& rpcOptions,
    ::py3::simple::ComplexStruct arg_counter) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::string> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::string>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_repeat_name, channel_);
  try {
    client->repeat_name(
      rpcOptions,
      std::move(callback),
      arg_counter
    );
  } catch (...) {
    return folly::makeFuture<std::string>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<::py3::simple::SimpleStruct>
SimpleServiceClientWrapper::get_struct(
    apache::thrift::RpcOptions& rpcOptions) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<::py3::simple::SimpleStruct> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<::py3::simple::SimpleStruct>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_struct, channel_);
  try {
    client->get_struct(
      rpcOptions,
      std::move(callback)
    );
  } catch (...) {
    return folly::makeFuture<::py3::simple::SimpleStruct>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::vector<int32_t>>
SimpleServiceClientWrapper::fib(
    apache::thrift::RpcOptions& rpcOptions,
    int16_t arg_n) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::vector<int32_t>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::vector<int32_t>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_fib, channel_);
  try {
    client->fib(
      rpcOptions,
      std::move(callback),
      arg_n
    );
  } catch (...) {
    return folly::makeFuture<std::vector<int32_t>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::set<std::string>>
SimpleServiceClientWrapper::unique_words(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<std::string> arg_words) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::set<std::string>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::set<std::string>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_unique_words, channel_);
  try {
    client->unique_words(
      rpcOptions,
      std::move(callback),
      arg_words
    );
  } catch (...) {
    return folly::makeFuture<std::set<std::string>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::map<std::string,int16_t>>
SimpleServiceClientWrapper::words_count(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<std::string> arg_words) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::map<std::string,int16_t>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::map<std::string,int16_t>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_words_count, channel_);
  try {
    client->words_count(
      rpcOptions,
      std::move(callback),
      arg_words
    );
  } catch (...) {
    return folly::makeFuture<std::map<std::string,int16_t>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<::py3::simple::AnEnum>
SimpleServiceClientWrapper::set_enum(
    apache::thrift::RpcOptions& rpcOptions,
    ::py3::simple::AnEnum arg_in_enum) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<::py3::simple::AnEnum> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<::py3::simple::AnEnum>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_set_enum, channel_);
  try {
    client->set_enum(
      rpcOptions,
      std::move(callback),
      arg_in_enum
    );
  } catch (...) {
    return folly::makeFuture<::py3::simple::AnEnum>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::vector<std::vector<int32_t>>>
SimpleServiceClientWrapper::list_of_lists(
    apache::thrift::RpcOptions& rpcOptions,
    int16_t arg_num_lists,
    int16_t arg_num_items) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::vector<std::vector<int32_t>>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::vector<std::vector<int32_t>>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_list_of_lists, channel_);
  try {
    client->list_of_lists(
      rpcOptions,
      std::move(callback),
      arg_num_lists,
      arg_num_items
    );
  } catch (...) {
    return folly::makeFuture<std::vector<std::vector<int32_t>>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::map<std::string,std::map<std::string,int32_t>>>
SimpleServiceClientWrapper::word_character_frequency(
    apache::thrift::RpcOptions& rpcOptions,
    std::string arg_sentence) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::map<std::string,std::map<std::string,int32_t>>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::map<std::string,std::map<std::string,int32_t>>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_word_character_frequency, channel_);
  try {
    client->word_character_frequency(
      rpcOptions,
      std::move(callback),
      arg_sentence
    );
  } catch (...) {
    return folly::makeFuture<std::map<std::string,std::map<std::string,int32_t>>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::vector<std::set<std::string>>>
SimpleServiceClientWrapper::list_of_sets(
    apache::thrift::RpcOptions& rpcOptions,
    std::string arg_some_words) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::vector<std::set<std::string>>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::vector<std::set<std::string>>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_list_of_sets, channel_);
  try {
    client->list_of_sets(
      rpcOptions,
      std::move(callback),
      arg_some_words
    );
  } catch (...) {
    return folly::makeFuture<std::vector<std::set<std::string>>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
SimpleServiceClientWrapper::nested_map_argument(
    apache::thrift::RpcOptions& rpcOptions,
    std::map<std::string,std::vector<::py3::simple::SimpleStruct>> arg_struct_map) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_nested_map_argument, channel_);
  try {
    client->nested_map_argument(
      rpcOptions,
      std::move(callback),
      arg_struct_map
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::string>
SimpleServiceClientWrapper::make_sentence(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<std::vector<std::string>> arg_word_chars) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::string> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::string>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_make_sentence, channel_);
  try {
    client->make_sentence(
      rpcOptions,
      std::move(callback),
      arg_word_chars
    );
  } catch (...) {
    return folly::makeFuture<std::string>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::set<int32_t>>
SimpleServiceClientWrapper::get_union(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<std::set<int32_t>> arg_sets) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::set<int32_t>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::set<int32_t>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_union, channel_);
  try {
    client->get_union(
      rpcOptions,
      std::move(callback),
      arg_sets
    );
  } catch (...) {
    return folly::makeFuture<std::set<int32_t>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::set<std::string>>
SimpleServiceClientWrapper::get_keys(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<std::map<std::string,std::string>> arg_string_map) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::set<std::string>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::set<std::string>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_keys, channel_);
  try {
    client->get_keys(
      rpcOptions,
      std::move(callback),
      arg_string_map
    );
  } catch (...) {
    return folly::makeFuture<std::set<std::string>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<double>
SimpleServiceClientWrapper::lookup_double(
    apache::thrift::RpcOptions& rpcOptions,
    int32_t arg_key) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<double> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<double>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_lookup_double, channel_);
  try {
    client->lookup_double(
      rpcOptions,
      std::move(callback),
      arg_key
    );
  } catch (...) {
    return folly::makeFuture<double>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::string>
SimpleServiceClientWrapper::retrieve_binary(
    apache::thrift::RpcOptions& rpcOptions,
    std::string arg_something) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::string> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::string>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_retrieve_binary, channel_);
  try {
    client->retrieve_binary(
      rpcOptions,
      std::move(callback),
      arg_something
    );
  } catch (...) {
    return folly::makeFuture<std::string>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::set<std::string>>
SimpleServiceClientWrapper::contain_binary(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<std::string> arg_binaries) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::set<std::string>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::set<std::string>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_contain_binary, channel_);
  try {
    client->contain_binary(
      rpcOptions,
      std::move(callback),
      arg_binaries
    );
  } catch (...) {
    return folly::makeFuture<std::set<std::string>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<std::vector<::py3::simple::AnEnum>>
SimpleServiceClientWrapper::contain_enum(
    apache::thrift::RpcOptions& rpcOptions,
    std::vector<::py3::simple::AnEnum> arg_the_enum) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<std::vector<::py3::simple::AnEnum>> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<std::vector<::py3::simple::AnEnum>>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_contain_enum, channel_);
  try {
    client->contain_enum(
      rpcOptions,
      std::move(callback),
      arg_the_enum
    );
  } catch (...) {
    return folly::makeFuture<std::vector<::py3::simple::AnEnum>>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<::py3::simple::BinaryUnionStruct>
SimpleServiceClientWrapper::get_binary_union_struct(
    apache::thrift::RpcOptions& rpcOptions,
    ::py3::simple::BinaryUnion arg_u) {
  auto* client = static_cast<::py3::simple::SimpleServiceAsyncClient*>(async_client_.get());
  folly::Promise<::py3::simple::BinaryUnionStruct> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<::py3::simple::BinaryUnionStruct>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_binary_union_struct, channel_);
  try {
    client->get_binary_union_struct(
      rpcOptions,
      std::move(callback),
      arg_u
    );
  } catch (...) {
    return folly::makeFuture<::py3::simple::BinaryUnionStruct>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
DerivedServiceClientWrapper::get_six(
    apache::thrift::RpcOptions& rpcOptions) {
  auto* client = static_cast<::py3::simple::DerivedServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_six, channel_);
  try {
    client->get_six(
      rpcOptions,
      std::move(callback)
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

folly::Future<int32_t>
RederivedServiceClientWrapper::get_seven(
    apache::thrift::RpcOptions& rpcOptions) {
  auto* client = static_cast<::py3::simple::RederivedServiceAsyncClient*>(async_client_.get());
  folly::Promise<int32_t> _promise;
  auto _future = _promise.getFuture();
  auto callback = std::make_unique<::thrift::py3::FutureCallback<int32_t>>(
    std::move(_promise), rpcOptions, client->recv_wrapped_get_seven, channel_);
  try {
    client->get_seven(
      rpcOptions,
      std::move(callback)
    );
  } catch (...) {
    return folly::makeFuture<int32_t>(folly::exception_wrapper(
      std::current_exception()
    ));
  }
  return _future;
}

} // namespace py3
} // namespace simple
