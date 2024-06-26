/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree.
 */

#include <fizz/crypto/Crypto.h>

#if __cplusplus < 201703L
constexpr folly::StringPiece fizz::Sha256::BlankHash;
constexpr folly::StringPiece fizz::Sha384::BlankHash;
constexpr folly::StringPiece fizz::Sha512::BlankHash;
#endif
