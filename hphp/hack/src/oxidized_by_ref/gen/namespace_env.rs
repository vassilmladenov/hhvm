// Copyright (c) Facebook, Inc. and its affiliates.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the "hack" directory of this source tree.
//
// @generated SignedSource<<e44126b5d9f553f0eb1d7b1623c2e100>>
//
// To regenerate this file, run:
//   hphp/hack/src/oxidized_regen.sh

use arena_trait::TrivialDrop;
use no_pos_hash::NoPosHash;
use ocamlrep_derive::FromOcamlRepIn;
use ocamlrep_derive::ToOcamlRep;
use serde::Deserialize;
use serde::Serialize;

#[allow(unused_imports)]
use crate::*;

#[derive(
    Clone,
    Debug,
    Deserialize,
    Eq,
    FromOcamlRepIn,
    Hash,
    NoPosHash,
    Ord,
    PartialEq,
    PartialOrd,
    Serialize,
    ToOcamlRep
)]
#[rust_to_ocaml(prefix = "ns")]
#[repr(C)]
pub struct Env<'a> {
    #[serde(deserialize_with = "arena_deserializer::arena", borrow)]
    pub ns_uses: s_map::SMap<'a, &'a str>,
    #[serde(deserialize_with = "arena_deserializer::arena", borrow)]
    pub class_uses: s_map::SMap<'a, &'a str>,
    #[serde(deserialize_with = "arena_deserializer::arena", borrow)]
    pub fun_uses: s_map::SMap<'a, &'a str>,
    #[serde(deserialize_with = "arena_deserializer::arena", borrow)]
    pub const_uses: s_map::SMap<'a, &'a str>,
    #[serde(deserialize_with = "arena_deserializer::arena", borrow)]
    pub name: Option<&'a str>,
    #[serde(deserialize_with = "arena_deserializer::arena", borrow)]
    pub auto_ns_map: &'a [(&'a str, &'a str)],
    pub is_codegen: bool,
    pub disable_xhp_element_mangling: bool,
}
impl<'a> TrivialDrop for Env<'a> {}
arena_deserializer::impl_deserialize_in_arena!(Env<'arena>);
