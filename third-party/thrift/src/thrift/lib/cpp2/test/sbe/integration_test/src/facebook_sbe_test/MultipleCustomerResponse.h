/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* Generated SBE (Simple Binary Encoding) message codec */
#ifndef _FACEBOOK_SBE_TEST_MULTIPLECUSTOMERRESPONSE_CXX_H_
#define _FACEBOOK_SBE_TEST_MULTIPLECUSTOMERRESPONSE_CXX_H_

#if __cplusplus >= 201103L
#define SBE_CONSTEXPR constexpr
#define SBE_NOEXCEPT noexcept
#else
#define SBE_CONSTEXPR
#define SBE_NOEXCEPT
#endif

#if __cplusplus >= 201703L
#include <string_view>
#define SBE_NODISCARD [[nodiscard]]
#else
#define SBE_NODISCARD
#endif

#if !defined(__STDC_LIMIT_MACROS)
#define __STDC_LIMIT_MACROS 1
#endif

#include <cstdint>
#include <cstring>
#include <iomanip>
#include <limits>
#include <ostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <tuple>
#include <vector>

#if defined(WIN32) || defined(_WIN32)
#define SBE_BIG_ENDIAN_ENCODE_16(v) _byteswap_ushort(v)
#define SBE_BIG_ENDIAN_ENCODE_32(v) _byteswap_ulong(v)
#define SBE_BIG_ENDIAN_ENCODE_64(v) _byteswap_uint64(v)
#define SBE_LITTLE_ENDIAN_ENCODE_16(v) (v)
#define SBE_LITTLE_ENDIAN_ENCODE_32(v) (v)
#define SBE_LITTLE_ENDIAN_ENCODE_64(v) (v)
#elif __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#define SBE_BIG_ENDIAN_ENCODE_16(v) __builtin_bswap16(v)
#define SBE_BIG_ENDIAN_ENCODE_32(v) __builtin_bswap32(v)
#define SBE_BIG_ENDIAN_ENCODE_64(v) __builtin_bswap64(v)
#define SBE_LITTLE_ENDIAN_ENCODE_16(v) (v)
#define SBE_LITTLE_ENDIAN_ENCODE_32(v) (v)
#define SBE_LITTLE_ENDIAN_ENCODE_64(v) (v)
#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
#define SBE_LITTLE_ENDIAN_ENCODE_16(v) __builtin_bswap16(v)
#define SBE_LITTLE_ENDIAN_ENCODE_32(v) __builtin_bswap32(v)
#define SBE_LITTLE_ENDIAN_ENCODE_64(v) __builtin_bswap64(v)
#define SBE_BIG_ENDIAN_ENCODE_16(v) (v)
#define SBE_BIG_ENDIAN_ENCODE_32(v) (v)
#define SBE_BIG_ENDIAN_ENCODE_64(v) (v)
#else
#error \
    "Byte Ordering of platform not determined. Set __BYTE_ORDER__ manually before including this file."
#endif

#if !defined(SBE_BOUNDS_CHECK_EXPECT)
#if defined(SBE_NO_BOUNDS_CHECK)
#define SBE_BOUNDS_CHECK_EXPECT(exp, c) (false)
#elif defined(_MSC_VER)
#define SBE_BOUNDS_CHECK_EXPECT(exp, c) (exp)
#else
#define SBE_BOUNDS_CHECK_EXPECT(exp, c) (__builtin_expect(exp, c))
#endif

#endif

#define SBE_FLOAT_NAN std::numeric_limits<float>::quiet_NaN()
#define SBE_DOUBLE_NAN std::numeric_limits<double>::quiet_NaN()
#define SBE_NULLVALUE_INT8 (std::numeric_limits<std::int8_t>::min)()
#define SBE_NULLVALUE_INT16 (std::numeric_limits<std::int16_t>::min)()
#define SBE_NULLVALUE_INT32 (std::numeric_limits<std::int32_t>::min)()
#define SBE_NULLVALUE_INT64 (std::numeric_limits<std::int64_t>::min)()
#define SBE_NULLVALUE_UINT8 (std::numeric_limits<std::uint8_t>::max)()
#define SBE_NULLVALUE_UINT16 (std::numeric_limits<std::uint16_t>::max)()
#define SBE_NULLVALUE_UINT32 (std::numeric_limits<std::uint32_t>::max)()
#define SBE_NULLVALUE_UINT64 (std::numeric_limits<std::uint64_t>::max)()

#include "ByteVarStringEncoding.h"
#include "GroupSizeEncoding.h"
#include "MessageHeader.h"
#include "ShortVarDataEncoding.h"
#include "ShortVarStringEncoding.h"

namespace facebook {
namespace sbe {
namespace test {

class MultipleCustomerResponse {
 private:
  /**
   * The states in which a encoder/decoder/codec can live.
   *
   * <p>The state machine diagram below, encoded in the dot language, describes
   * the valid state transitions according to the order in which fields may be
   * accessed safely. Tools such as PlantUML and Graphviz can render it.
   *
   * <pre>{@code
   *   digraph G {
   *       NOT_WRAPPED -> V0_BLOCK [label="  wrap(version=0)  "];
   *       V0_BLOCK -> V0_CUSTOMERRESPONSES_DONE [label="
   * CustomerResponsesCount(0)  "]; V0_BLOCK -> V0_CUSTOMERRESPONSES_N [label="
   * CustomerResponsesCount(>0)  "]; V0_CUSTOMERRESPONSES_N_BLOCK ->
   * V0_CUSTOMERRESPONSES_N_BLOCK [label="
   * CustomerResponses.CustomerResponseLength()  "];
   *       V0_CUSTOMERRESPONSES_1_BLOCK -> V0_CUSTOMERRESPONSES_1_BLOCK [label="
   * CustomerResponses.CustomerResponseLength()  "];
   *       V0_CUSTOMERRESPONSES_N_BLOCK ->
   * V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE [label="
   * CustomerResponses.CustomerResponse(?)  "]; V0_CUSTOMERRESPONSES_1_BLOCK ->
   * V0_CUSTOMERRESPONSES_1_CUSTOMERRESPONSE_DONE [label="
   * CustomerResponses.CustomerResponse(?)  "]; V0_CUSTOMERRESPONSES_N ->
   * V0_CUSTOMERRESPONSES_N_BLOCK [label="  CustomerResponses.next()\n  where
   * count - newIndex > 1  "]; V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE ->
   * V0_CUSTOMERRESPONSES_N_BLOCK [label="  CustomerResponses.next()\n  where
   * count - newIndex > 1  "]; V0_CUSTOMERRESPONSES_N ->
   * V0_CUSTOMERRESPONSES_1_BLOCK [label="  CustomerResponses.next()\n  where
   * count - newIndex == 1  "]; V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE ->
   * V0_CUSTOMERRESPONSES_1_BLOCK [label="  CustomerResponses.next()\n  where
   * count - newIndex == 1  "]; V0_CUSTOMERRESPONSES_DONE ->
   * V0_CUSTOMERRESPONSES_DONE [label="  CustomerResponses.resetCountToIndex()
   * "]; V0_CUSTOMERRESPONSES_1_CUSTOMERRESPONSE_DONE ->
   * V0_CUSTOMERRESPONSES_DONE [label="  CustomerResponses.resetCountToIndex()
   * "]; V0_CUSTOMERRESPONSES_N -> V0_CUSTOMERRESPONSES_DONE [label="
   * CustomerResponses.resetCountToIndex()  "];
   *       V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE ->
   * V0_CUSTOMERRESPONSES_DONE [label="  CustomerResponses.resetCountToIndex()
   * "];
   *   }
   * }</pre>
   */
  enum class CodecState {
    NOT_WRAPPED = 0,
    V0_BLOCK = 1,
    V0_CUSTOMERRESPONSES_N = 2,
    V0_CUSTOMERRESPONSES_N_BLOCK = 3,
    V0_CUSTOMERRESPONSES_1_BLOCK = 4,
    V0_CUSTOMERRESPONSES_DONE = 5,
    V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE = 6,
    V0_CUSTOMERRESPONSES_1_CUSTOMERRESPONSE_DONE = 7,
  };

  static const std::string STATE_NAME_LOOKUP[8];
  static const std::string STATE_TRANSITIONS_LOOKUP[8];

  static std::string codecStateName(CodecState state) {
    return STATE_NAME_LOOKUP[static_cast<int>(state)];
  }

  static std::string codecStateTransitions(CodecState state) {
    return STATE_TRANSITIONS_LOOKUP[static_cast<int>(state)];
  }

  char* m_buffer = nullptr;
  std::uint64_t m_bufferLength = 0;
  std::uint64_t m_offset = 0;
  std::uint64_t m_position = 0;
  std::uint64_t m_actingBlockLength = 0;
  std::uint64_t m_actingVersion = 0;
  CodecState m_codecState = CodecState::NOT_WRAPPED;

  CodecState codecState() const { return m_codecState; }

  CodecState* codecStatePtr() { return &m_codecState; }

  void codecState(CodecState newState) { m_codecState = newState; }

  inline std::uint64_t* sbePositionPtr() SBE_NOEXCEPT { return &m_position; }

 public:
  static constexpr std::uint16_t SBE_BLOCK_LENGTH =
      static_cast<std::uint16_t>(0);
  static constexpr std::uint16_t SBE_TEMPLATE_ID =
      static_cast<std::uint16_t>(4);
  static constexpr std::uint16_t SBE_SCHEMA_ID = static_cast<std::uint16_t>(1);
  static constexpr std::uint16_t SBE_SCHEMA_VERSION =
      static_cast<std::uint16_t>(0);
  static constexpr const char* SBE_SEMANTIC_VERSION = "5.2";

  enum MetaAttribute { EPOCH, TIME_UNIT, SEMANTIC_TYPE, PRESENCE };

  union sbe_float_as_uint_u {
    float fp_value;
    std::uint32_t uint_value;
  };

  union sbe_double_as_uint_u {
    double fp_value;
    std::uint64_t uint_value;
  };

  using messageHeader = MessageHeader;

  class AccessOrderError : public std::logic_error {
   public:
    explicit AccessOrderError(const std::string& msg) : std::logic_error(msg) {}
  };

  MultipleCustomerResponse() = default;

  MultipleCustomerResponse(
      char* buffer,
      const std::uint64_t offset,
      const std::uint64_t bufferLength,
      const std::uint64_t actingBlockLength,
      const std::uint64_t actingVersion,
      CodecState codecState)
      : m_buffer(buffer),
        m_bufferLength(bufferLength),
        m_offset(offset),
        m_position(sbeCheckPosition(offset + actingBlockLength)),
        m_actingBlockLength(actingBlockLength),
        m_actingVersion(actingVersion),
        m_codecState(codecState) {}

  MultipleCustomerResponse(
      char* buffer,
      const std::uint64_t offset,
      const std::uint64_t bufferLength,
      const std::uint64_t actingBlockLength,
      const std::uint64_t actingVersion)
      : m_buffer(buffer),
        m_bufferLength(bufferLength),
        m_offset(offset),
        m_position(sbeCheckPosition(offset + actingBlockLength)),
        m_actingBlockLength(actingBlockLength),
        m_actingVersion(actingVersion) {}

  MultipleCustomerResponse(char* buffer, const std::uint64_t bufferLength)
      : MultipleCustomerResponse(
            buffer, 0, bufferLength, sbeBlockLength(), sbeSchemaVersion()) {}

  MultipleCustomerResponse(
      char* buffer,
      const std::uint64_t bufferLength,
      const std::uint64_t actingBlockLength,
      const std::uint64_t actingVersion)
      : MultipleCustomerResponse(
            buffer, 0, bufferLength, actingBlockLength, actingVersion) {}

  SBE_NODISCARD static SBE_CONSTEXPR std::uint16_t sbeBlockLength()
      SBE_NOEXCEPT {
    return static_cast<std::uint16_t>(0);
  }

  SBE_NODISCARD static SBE_CONSTEXPR std::uint64_t sbeBlockAndHeaderLength()
      SBE_NOEXCEPT {
    return messageHeader::encodedLength() + sbeBlockLength();
  }

  SBE_NODISCARD static SBE_CONSTEXPR std::uint16_t sbeTemplateId()
      SBE_NOEXCEPT {
    return static_cast<std::uint16_t>(4);
  }

  SBE_NODISCARD static SBE_CONSTEXPR std::uint16_t sbeSchemaId() SBE_NOEXCEPT {
    return static_cast<std::uint16_t>(1);
  }

  SBE_NODISCARD static SBE_CONSTEXPR std::uint16_t sbeSchemaVersion()
      SBE_NOEXCEPT {
    return static_cast<std::uint16_t>(0);
  }

  SBE_NODISCARD static const char* sbeSemanticVersion() SBE_NOEXCEPT {
    return "5.2";
  }

  SBE_NODISCARD static SBE_CONSTEXPR const char* sbeSemanticType()
      SBE_NOEXCEPT {
    return "";
  }

  SBE_NODISCARD std::uint64_t offset() const SBE_NOEXCEPT { return m_offset; }

  MultipleCustomerResponse& wrapForEncode(
      char* buffer,
      const std::uint64_t offset,
      const std::uint64_t bufferLength) {
    m_buffer = buffer;
    m_bufferLength = bufferLength;
    m_offset = offset;
    m_actingBlockLength = sbeBlockLength();
    m_actingVersion = sbeSchemaVersion();
    m_position = sbeCheckPosition(m_offset + m_actingBlockLength);
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
    codecState(CodecState::V0_BLOCK);
#endif
    return *this;
  }

  MultipleCustomerResponse& wrapAndApplyHeader(
      char* buffer,
      const std::uint64_t offset,
      const std::uint64_t bufferLength) {
    messageHeader hdr(buffer, offset, bufferLength, sbeSchemaVersion());

    hdr.blockLength(sbeBlockLength())
        .templateId(sbeTemplateId())
        .schemaId(sbeSchemaId())
        .version(sbeSchemaVersion());

    m_buffer = buffer;
    m_bufferLength = bufferLength;
    m_offset = offset + messageHeader::encodedLength();
    m_actingBlockLength = sbeBlockLength();
    m_actingVersion = sbeSchemaVersion();
    m_position = sbeCheckPosition(m_offset + m_actingBlockLength);
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
    codecState(CodecState::V0_BLOCK);
#endif
    return *this;
  }

  MultipleCustomerResponse& wrapForDecode(
      char* buffer,
      const std::uint64_t offset,
      const std::uint64_t actingBlockLength,
      const std::uint64_t actingVersion,
      const std::uint64_t bufferLength) {
    m_buffer = buffer;
    m_bufferLength = bufferLength;
    m_offset = offset;
    m_actingBlockLength = actingBlockLength;
    m_actingVersion = actingVersion;
    m_position = sbeCheckPosition(m_offset + m_actingBlockLength);
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
    codecState(CodecState::V0_BLOCK);
#endif
    return *this;
  }

  MultipleCustomerResponse& sbeRewind() {
    return wrapForDecode(
        m_buffer,
        m_offset,
        m_actingBlockLength,
        m_actingVersion,
        m_bufferLength);
  }

  SBE_NODISCARD std::uint64_t sbePosition() const SBE_NOEXCEPT {
    return m_position;
  }

  // NOLINTNEXTLINE(readability-convert-member-functions-to-static)
  std::uint64_t sbeCheckPosition(const std::uint64_t position) {
    if (SBE_BOUNDS_CHECK_EXPECT((position > m_bufferLength), false)) {
      throw std::runtime_error("buffer too short [E100]");
    }
    return position;
  }

  void sbePosition(const std::uint64_t position) {
    m_position = sbeCheckPosition(position);
  }

  SBE_NODISCARD std::uint64_t encodedLength() const SBE_NOEXCEPT {
    return sbePosition() - m_offset;
  }

  SBE_NODISCARD std::uint64_t decodeLength() const {
    MultipleCustomerResponse skipper(
        m_buffer,
        m_offset,
        m_bufferLength,
        sbeBlockLength(),
        m_actingVersion,
        m_codecState);
    skipper.skip();
    return skipper.encodedLength();
  }

  SBE_NODISCARD const char* buffer() const SBE_NOEXCEPT { return m_buffer; }

  SBE_NODISCARD char* buffer() SBE_NOEXCEPT { return m_buffer; }

  SBE_NODISCARD std::uint64_t bufferLength() const SBE_NOEXCEPT {
    return m_bufferLength;
  }

  SBE_NODISCARD std::uint64_t actingVersion() const SBE_NOEXCEPT {
    return m_actingVersion;
  }

  void checkEncodingIsComplete() {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
    switch (m_codecState) {
      case CodecState::V0_CUSTOMERRESPONSES_DONE:
        return;
      case CodecState::V0_CUSTOMERRESPONSES_1_CUSTOMERRESPONSE_DONE:
        return;
      default:
        throw AccessOrderError(
            std::string("Not fully encoded, current state: ") +
            codecStateName(m_codecState) +
            ", allowed transitions: " + codecStateTransitions(m_codecState));
    }
#endif
  }

  class CustomerResponses {
   private:
    char* m_buffer = nullptr;
    std::uint64_t m_bufferLength = 0;
    std::uint64_t m_initialPosition = 0;
    std::uint64_t* m_positionPtr = nullptr;
    std::uint64_t m_blockLength = 0;
    std::uint64_t m_count = 0;
    std::uint64_t m_index = 0;
    std::uint64_t m_offset = 0;
    std::uint64_t m_actingVersion = 0;

    SBE_NODISCARD std::uint64_t* sbePositionPtr() SBE_NOEXCEPT {
      return m_positionPtr;
    }

    CodecState* m_codecStatePtr = nullptr;

    CodecState codecState() const SBE_NOEXCEPT { return *m_codecStatePtr; }

    CodecState* codecStatePtr() { return m_codecStatePtr; }

    void codecState(CodecState codecState) { *m_codecStatePtr = codecState; }

   public:
    CustomerResponses() = default;

    inline void wrapForDecode(
        char* buffer,
        std::uint64_t* pos,
        const std::uint64_t actingVersion,
        const std::uint64_t bufferLength,
        CodecState* codecState) {
      GroupSizeEncoding dimensions(buffer, *pos, bufferLength, actingVersion);
      m_buffer = buffer;
      m_bufferLength = bufferLength;
      m_blockLength = dimensions.blockLength();
      m_count = dimensions.numInGroup();
      m_index = 0;
      m_actingVersion = actingVersion;
      m_initialPosition = *pos;
      m_positionPtr = pos;
      *m_positionPtr = *m_positionPtr + 4;
      m_codecStatePtr = codecState;
    }

    inline void wrapForEncode(
        char* buffer,
        const std::uint16_t count,
        std::uint64_t* pos,
        const std::uint64_t actingVersion,
        const std::uint64_t bufferLength,
        CodecState* codecState) {
#if defined(__GNUG__) && !defined(__clang__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wtype-limits"
#endif
      if (count > 65534) {
        throw std::runtime_error("count outside of allowed range [E110]");
      }
#if defined(__GNUG__) && !defined(__clang__)
#pragma GCC diagnostic pop
#endif
      m_buffer = buffer;
      m_bufferLength = bufferLength;
      GroupSizeEncoding dimensions(buffer, *pos, bufferLength, actingVersion);
      dimensions.blockLength(static_cast<std::uint16_t>(0));
      dimensions.numInGroup(static_cast<std::uint16_t>(count));
      m_index = 0;
      m_count = count;
      m_blockLength = 0;
      m_actingVersion = actingVersion;
      m_initialPosition = *pos;
      m_positionPtr = pos;
      *m_positionPtr = *m_positionPtr + 4;
      m_codecStatePtr = codecState;
    }

   private:
    void onNextElementAccessed() {
      std::uint64_t remaining = m_count - m_index;
      if (remaining > 1) {
        switch (codecState()) {
          case CodecState::V0_CUSTOMERRESPONSES_N:
          case CodecState::V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE:
            codecState(CodecState::V0_CUSTOMERRESPONSES_N_BLOCK);
            break;
          default:
            throw AccessOrderError(
                std::string("Illegal field access order. ") +
                "Cannot access next element in repeating group \"CustomerResponses\" in state: " +
                codecStateName(codecState()) +
                ". Expected one of these transitions: [" +
                codecStateTransitions(codecState()) +
                "]. Please see the diagram in the docs of the enum MultipleCustomerResponse::CodecState.");
        }
      } else if (1 == remaining) {
        switch (codecState()) {
          case CodecState::V0_CUSTOMERRESPONSES_N:
          case CodecState::V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE:
            codecState(CodecState::V0_CUSTOMERRESPONSES_1_BLOCK);
            break;
          default:
            throw AccessOrderError(
                std::string("Illegal field access order. ") +
                "Cannot access next element in repeating group \"CustomerResponses\" in state: " +
                codecStateName(codecState()) +
                ". Expected one of these transitions: [" +
                codecStateTransitions(codecState()) +
                "]. Please see the diagram in the docs of the enum MultipleCustomerResponse::CodecState.");
        }
      }
    }

    void onResetCountToIndex() {
      switch (codecState()) {
        case CodecState::V0_CUSTOMERRESPONSES_DONE:
        case CodecState::V0_CUSTOMERRESPONSES_1_CUSTOMERRESPONSE_DONE:
        case CodecState::V0_CUSTOMERRESPONSES_N:
        case CodecState::V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE:
          codecState(CodecState::V0_CUSTOMERRESPONSES_DONE);
          break;
        default:
          throw AccessOrderError(
              std::string("Illegal field access order. ") +
              "Cannot reset count of repeating group \"CustomerResponses\" in state: " +
              codecStateName(codecState()) +
              ". Expected one of these transitions: [" +
              codecStateTransitions(codecState()) +
              "]. Please see the diagram in the docs of the enum MultipleCustomerResponse::CodecState.");
      }
    }

   public:
    static SBE_CONSTEXPR std::uint64_t sbeHeaderSize() SBE_NOEXCEPT {
      return 4;
    }

    static SBE_CONSTEXPR std::uint64_t sbeBlockLength() SBE_NOEXCEPT {
      return 0;
    }

    SBE_NODISCARD std::uint64_t sbeActingBlockLength() SBE_NOEXCEPT {
      return m_blockLength;
    }

    SBE_NODISCARD std::uint64_t sbePosition() const SBE_NOEXCEPT {
      return *m_positionPtr;
    }

    // NOLINTNEXTLINE(readability-convert-member-functions-to-static)
    std::uint64_t sbeCheckPosition(const std::uint64_t position) {
      if (SBE_BOUNDS_CHECK_EXPECT((position > m_bufferLength), false)) {
        throw std::runtime_error("buffer too short [E100]");
      }
      return position;
    }

    void sbePosition(const std::uint64_t position) {
      *m_positionPtr = sbeCheckPosition(position);
    }

    SBE_NODISCARD inline std::uint64_t count() const SBE_NOEXCEPT {
      return m_count;
    }

    SBE_NODISCARD inline bool hasNext() const SBE_NOEXCEPT {
      return m_index < m_count;
    }

    inline CustomerResponses& next() {
      if (m_index >= m_count) {
        throw std::runtime_error("index >= count [E108]");
      }
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onNextElementAccessed();
#endif
      m_offset = *m_positionPtr;
      if (SBE_BOUNDS_CHECK_EXPECT(
              ((m_offset + m_blockLength) > m_bufferLength), false)) {
        throw std::runtime_error(
            "buffer too short for next group index [E108]");
      }
      *m_positionPtr = m_offset + m_blockLength;
      ++m_index;

      return *this;
    }

    inline std::uint64_t resetCountToIndex() {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onResetCountToIndex();
#endif
      m_count = m_index;
      GroupSizeEncoding dimensions(
          m_buffer, m_initialPosition, m_bufferLength, m_actingVersion);
      dimensions.numInGroup(static_cast<std::uint16_t>(m_count));
      return m_count;
    }

    template <class Func>
    inline void forEach(Func&& func) {
      while (hasNext()) {
        next();
        func(*this);
      }
    }

    SBE_NODISCARD static const char* CustomerResponseMetaAttribute(
        const MetaAttribute metaAttribute) SBE_NOEXCEPT {
      switch (metaAttribute) {
        case MetaAttribute::PRESENCE:
          return "required";
        default:
          return "";
      }
    }

    static const char* customerResponseCharacterEncoding() SBE_NOEXCEPT {
      return "null";
    }

    static SBE_CONSTEXPR std::uint64_t customerResponseSinceVersion()
        SBE_NOEXCEPT {
      return 0;
    }

    bool customerResponseInActingVersion() SBE_NOEXCEPT { return true; }

    static SBE_CONSTEXPR std::uint16_t customerResponseId() SBE_NOEXCEPT {
      return 2;
    }

    static SBE_CONSTEXPR std::uint64_t customerResponseHeaderLength()
        SBE_NOEXCEPT {
      return 2;
    }

   private:
    void onCustomerResponseLengthAccessed() const {
      switch (codecState()) {
        case CodecState::V0_CUSTOMERRESPONSES_N_BLOCK:
          break;
        case CodecState::V0_CUSTOMERRESPONSES_1_BLOCK:
          break;
        default:
          throw AccessOrderError(
              std::string("Illegal field access order. ") +
              "Cannot decode length of var data \"CustomerResponses.CustomerResponse\" in state: " +
              codecStateName(codecState()) +
              ". Expected one of these transitions: [" +
              codecStateTransitions(codecState()) +
              "]. Please see the diagram in the docs of the enum MultipleCustomerResponse::CodecState.");
      }
    }

   public:
    SBE_NODISCARD std::uint16_t customerResponseLength() const {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseLengthAccessed();
#endif
      std::uint16_t length;
      std::memcpy(&length, m_buffer + sbePosition(), sizeof(std::uint16_t));
      return SBE_LITTLE_ENDIAN_ENCODE_16(length);
    }

   private:
    void onCustomerResponseAccessed() {
      switch (codecState()) {
        case CodecState::V0_CUSTOMERRESPONSES_N_BLOCK:
          codecState(CodecState::V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE);
          break;
        case CodecState::V0_CUSTOMERRESPONSES_1_BLOCK:
          codecState(CodecState::V0_CUSTOMERRESPONSES_1_CUSTOMERRESPONSE_DONE);
          break;
        default:
          throw AccessOrderError(
              std::string("Illegal field access order. ") +
              "Cannot access field \"CustomerResponses.CustomerResponse\" in state: " +
              codecStateName(codecState()) +
              ". Expected one of these transitions: [" +
              codecStateTransitions(codecState()) +
              "]. Please see the diagram in the docs of the enum MultipleCustomerResponse::CodecState.");
      }
    }

   public:
    std::uint64_t skipCustomerResponse() {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseAccessed();
#endif
      std::uint64_t lengthOfLengthField = 2;
      std::uint64_t lengthPosition = sbePosition();
      std::uint16_t lengthFieldValue;
      std::memcpy(
          &lengthFieldValue, m_buffer + lengthPosition, sizeof(std::uint16_t));
      std::uint64_t dataLength = SBE_LITTLE_ENDIAN_ENCODE_16(lengthFieldValue);
      sbePosition(lengthPosition + lengthOfLengthField + dataLength);
      return dataLength;
    }

    SBE_NODISCARD const char* customerResponse() {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseAccessed();
#endif
      std::uint16_t lengthFieldValue;
      std::memcpy(
          &lengthFieldValue, m_buffer + sbePosition(), sizeof(std::uint16_t));
      const char* fieldPtr = m_buffer + sbePosition() + 2;
      sbePosition(
          sbePosition() + 2 + SBE_LITTLE_ENDIAN_ENCODE_16(lengthFieldValue));
      return fieldPtr;
    }

    std::uint64_t getCustomerResponse(char* dst, const std::uint64_t length) {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseAccessed();
#endif
      std::uint64_t lengthOfLengthField = 2;
      std::uint64_t lengthPosition = sbePosition();
      sbePosition(lengthPosition + lengthOfLengthField);
      std::uint16_t lengthFieldValue;
      std::memcpy(
          &lengthFieldValue, m_buffer + lengthPosition, sizeof(std::uint16_t));
      std::uint64_t dataLength = SBE_LITTLE_ENDIAN_ENCODE_16(lengthFieldValue);
      std::uint64_t bytesToCopy = length < dataLength ? length : dataLength;
      std::uint64_t pos = sbePosition();
      sbePosition(pos + dataLength);
      std::memcpy(dst, m_buffer + pos, static_cast<std::size_t>(bytesToCopy));
      return bytesToCopy;
    }

    char* putCustomerResponse(const std::uint16_t length) {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseAccessed();
#endif
      std::uint64_t lengthOfLengthField = 2;
      std::uint64_t lengthPosition = sbePosition();
      std::uint16_t lengthFieldValue = SBE_LITTLE_ENDIAN_ENCODE_16(length);
      sbePosition(lengthPosition + lengthOfLengthField);
      std::memcpy(
          m_buffer + lengthPosition, &lengthFieldValue, sizeof(std::uint16_t));
      if (length != std::uint16_t(0)) {
        std::uint64_t pos = sbePosition();
        sbePosition(pos + length);
        return m_buffer + pos;
      }
      return nullptr;
    }

    CustomerResponses& putCustomerResponse(
        const char* src, const std::uint16_t length) {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseAccessed();
#endif
      std::uint64_t lengthOfLengthField = 2;
      std::uint64_t lengthPosition = sbePosition();
      std::uint16_t lengthFieldValue = SBE_LITTLE_ENDIAN_ENCODE_16(length);
      sbePosition(lengthPosition + lengthOfLengthField);
      std::memcpy(
          m_buffer + lengthPosition, &lengthFieldValue, sizeof(std::uint16_t));
      if (length != std::uint16_t(0)) {
        std::uint64_t pos = sbePosition();
        sbePosition(pos + length);
        std::memcpy(m_buffer + pos, src, length);
      }
      return *this;
    }

    std::string getCustomerResponseAsString() {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseAccessed();
#endif
      std::uint64_t lengthOfLengthField = 2;
      std::uint64_t lengthPosition = sbePosition();
      sbePosition(lengthPosition + lengthOfLengthField);
      std::uint16_t lengthFieldValue;
      std::memcpy(
          &lengthFieldValue, m_buffer + lengthPosition, sizeof(std::uint16_t));
      std::uint64_t dataLength = SBE_LITTLE_ENDIAN_ENCODE_16(lengthFieldValue);
      std::uint64_t pos = sbePosition();
      const std::string result(m_buffer + pos, dataLength);
      sbePosition(pos + dataLength);
      return result;
    }

    std::string getCustomerResponseAsJsonEscapedString() {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseAccessed();
#endif
      std::ostringstream oss;
      std::string s = getCustomerResponseAsString();

      for (const auto c : s) {
        switch (c) {
          case '"':
            oss << "\\\"";
            break;
          case '\\':
            oss << "\\\\";
            break;
          case '\b':
            oss << "\\b";
            break;
          case '\f':
            oss << "\\f";
            break;
          case '\n':
            oss << "\\n";
            break;
          case '\r':
            oss << "\\r";
            break;
          case '\t':
            oss << "\\t";
            break;

          default:
            if ('\x00' <= c && c <= '\x1f') {
              oss << "\\u" << std::hex << std::setw(4) << std::setfill('0')
                  << (int)(c);
            } else {
              oss << c;
            }
        }
      }

      return oss.str();
    }

#if __cplusplus >= 201703L
    std::string_view getCustomerResponseAsStringView() {
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
      onCustomerResponseAccessed();
#endif
      std::uint64_t lengthOfLengthField = 2;
      std::uint64_t lengthPosition = sbePosition();
      sbePosition(lengthPosition + lengthOfLengthField);
      std::uint16_t lengthFieldValue;
      std::memcpy(
          &lengthFieldValue, m_buffer + lengthPosition, sizeof(std::uint16_t));
      std::uint64_t dataLength = SBE_LITTLE_ENDIAN_ENCODE_16(lengthFieldValue);
      std::uint64_t pos = sbePosition();
      const std::string_view result(m_buffer + pos, dataLength);
      sbePosition(pos + dataLength);
      return result;
    }
#endif

    CustomerResponses& putCustomerResponse(const std::string& str) {
      if (str.length() > 65534) {
        throw std::runtime_error("std::string too long for length type [E109]");
      }
      return putCustomerResponse(
          str.data(), static_cast<std::uint16_t>(str.length()));
    }

#if __cplusplus >= 201703L
    CustomerResponses& putCustomerResponse(const std::string_view str) {
      if (str.length() > 65534) {
        throw std::runtime_error("std::string too long for length type [E109]");
      }
      return putCustomerResponse(
          str.data(), static_cast<std::uint16_t>(str.length()));
    }
#endif

    template <typename CharT, typename Traits>
    friend std::basic_ostream<CharT, Traits>& operator<<(
        std::basic_ostream<CharT, Traits>& builder, CustomerResponses& writer) {
      builder << '{';
      builder << R"("CustomerResponse": )";
      builder << '"' << writer.skipCustomerResponse() << " bytes of raw data\"";
      builder << '}';

      return builder;
    }

    void skip() { skipCustomerResponse(); }

    SBE_NODISCARD static SBE_CONSTEXPR bool isConstLength() SBE_NOEXCEPT {
      return false;
    }

    SBE_NODISCARD static std::size_t computeLength(
        std::size_t customerResponseLength = 0) {
#if defined(__GNUG__) && !defined(__clang__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wtype-limits"
#endif
      std::size_t length = sbeBlockLength();

      length += customerResponseHeaderLength();
      if (customerResponseLength > 65534LL) {
        throw std::runtime_error(
            "customerResponseLength too long for length type [E109]");
      }
      length += customerResponseLength;

      return length;
#if defined(__GNUG__) && !defined(__clang__)
#pragma GCC diagnostic pop
#endif
    }
  };

 private:
  CustomerResponses m_customerResponses;

 public:
  SBE_NODISCARD static SBE_CONSTEXPR std::uint16_t CustomerResponsesId()
      SBE_NOEXCEPT {
    return 1;
  }

 private:
  void onCustomerResponsesAccessed(
      std::uint64_t remaining, std::string action) {
    if (0 == remaining) {
      switch (codecState()) {
        case CodecState::V0_BLOCK:
          codecState(CodecState::V0_CUSTOMERRESPONSES_DONE);
          break;
        default:
          throw AccessOrderError(
              std::string("Illegal field access order. ") + "Cannot " + action +
              " count of repeating group \"CustomerResponses\" in state: " +
              codecStateName(codecState()) +
              ". Expected one of these transitions: [" +
              codecStateTransitions(codecState()) +
              "]. Please see the diagram in the docs of the enum MultipleCustomerResponse::CodecState.");
      }
    } else {
      switch (codecState()) {
        case CodecState::V0_BLOCK:
          codecState(CodecState::V0_CUSTOMERRESPONSES_N);
          break;
        default:
          throw AccessOrderError(
              std::string("Illegal field access order. ") + "Cannot " + action +
              " count of repeating group \"CustomerResponses\" in state: " +
              codecStateName(codecState()) +
              ". Expected one of these transitions: [" +
              codecStateTransitions(codecState()) +
              "]. Please see the diagram in the docs of the enum MultipleCustomerResponse::CodecState.");
      }
    }
  }

 public:
  SBE_NODISCARD inline CustomerResponses& customerResponses() {
    m_customerResponses.wrapForDecode(
        m_buffer,
        sbePositionPtr(),
        m_actingVersion,
        m_bufferLength,
        codecStatePtr());
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
    onCustomerResponsesAccessed(m_customerResponses.count(), "decode");
#endif
    return m_customerResponses;
  }

  CustomerResponses& customerResponsesCount(const std::uint16_t count) {
    m_customerResponses.wrapForEncode(
        m_buffer,
        count,
        sbePositionPtr(),
        m_actingVersion,
        m_bufferLength,
        codecStatePtr());
#if defined(SBE_ENABLE_PRECEDENCE_CHECKS)
    onCustomerResponsesAccessed(count, "encode");
#endif
    return m_customerResponses;
  }

  SBE_NODISCARD static SBE_CONSTEXPR std::uint64_t
  customerResponsesSinceVersion() SBE_NOEXCEPT {
    return 0;
  }

  SBE_NODISCARD bool customerResponsesInActingVersion() const SBE_NOEXCEPT {
    return true;
  }

  template <typename CharT, typename Traits>
  friend std::basic_ostream<CharT, Traits>& operator<<(
      std::basic_ostream<CharT, Traits>& builder,
      const MultipleCustomerResponse& _writer) {
    MultipleCustomerResponse writer(
        _writer.m_buffer,
        _writer.m_offset,
        _writer.m_bufferLength,
        _writer.m_actingBlockLength,
        _writer.m_actingVersion);

    builder << '{';
    builder << R"("Name": "MultipleCustomerResponse", )";
    builder << R"("sbeTemplateId": )";
    builder << writer.sbeTemplateId();
    builder << ", ";

    {
      bool atLeastOne = false;
      builder << R"("CustomerResponses": [)";
      writer.customerResponses().forEach(
          [&](CustomerResponses& customerResponses) {
            if (atLeastOne) {
              builder << ", ";
            }
            atLeastOne = true;
            builder << customerResponses;
          });
      builder << ']';
    }

    builder << '}';

    return builder;
  }

  void skip() {
    auto& customerResponsesGroup{customerResponses()};
    while (customerResponsesGroup.hasNext()) {
      customerResponsesGroup.next().skip();
    }
  }

  SBE_NODISCARD static SBE_CONSTEXPR bool isConstLength() SBE_NOEXCEPT {
    return false;
  }

  SBE_NODISCARD static std::size_t computeLength(
      const std::vector<std::tuple<std::size_t>>& customerResponsesItemLengths =
          {}) {
#if defined(__GNUG__) && !defined(__clang__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wtype-limits"
#endif
    std::size_t length = sbeBlockLength();

    length += CustomerResponses::sbeHeaderSize();
    if (customerResponsesItemLengths.size() > 65534LL) {
      throw std::runtime_error(
          "customerResponsesItemLengths.size() outside of allowed range [E110]");
    }

    for (const auto& e : customerResponsesItemLengths) {
#if __cplusplus >= 201703L
      length += std::apply(CustomerResponses::computeLength, e);
#else
      length += CustomerResponses::computeLength(std::get<0>(e));
#endif
    }

    return length;
#if defined(__GNUG__) && !defined(__clang__)
#pragma GCC diagnostic pop
#endif
  }
};
#if SBE_ENABLE_PRECEDENCE_CHECKS
const std::string MultipleCustomerResponse::STATE_NAME_LOOKUP[8] = {
    "NOT_WRAPPED",
    "V0_BLOCK",
    "V0_CUSTOMERRESPONSES_N",
    "V0_CUSTOMERRESPONSES_N_BLOCK",
    "V0_CUSTOMERRESPONSES_1_BLOCK",
    "V0_CUSTOMERRESPONSES_DONE",
    "V0_CUSTOMERRESPONSES_N_CUSTOMERRESPONSE_DONE",
    "V0_CUSTOMERRESPONSES_1_CUSTOMERRESPONSE_DONE",
};

const std::string MultipleCustomerResponse::STATE_TRANSITIONS_LOOKUP[8] = {
    "\"wrap(version=0)\"",
    "\"CustomerResponsesCount(0)\", \"CustomerResponsesCount(>0)\"",
    "\"CustomerResponses.next()\", \"CustomerResponses.resetCountToIndex()\"",
    "\"CustomerResponses.CustomerResponseLength()\", \"CustomerResponses.CustomerResponse(?)\"",
    "\"CustomerResponses.CustomerResponseLength()\", \"CustomerResponses.CustomerResponse(?)\"",
    "\"CustomerResponses.resetCountToIndex()\"",
    "\"CustomerResponses.next()\", \"CustomerResponses.resetCountToIndex()\"",
    "\"CustomerResponses.resetCountToIndex()\"",
};
#endif
} // namespace test
} // namespace sbe
} // namespace facebook
#endif
