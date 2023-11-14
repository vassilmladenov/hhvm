// Copyright (c) Meta Platforms, Inc. and affiliates.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the "hack" directory of this source tree.

use oxidized::file_info::SiAddendum;
use oxidized_by_ref::direct_decl_parser::ParsedFileWithHashes;

/// From a `ParsedFileWithHashes<'a>` generated by some decl parse, collect all
/// the necessary information to update the symbol index.
pub fn get_si_addenda<'a>(with_hashes: &ParsedFileWithHashes<'a>) -> Vec<SiAddendum> {
    with_hashes
        .iter()
        .filter_map(|(name, decl, _hash)| {
            use oxidized::file_info::SiKind::*;
            use oxidized_by_ref::shallow_decl_defs::Decl;
            let kind = match decl {
                Decl::Class(class) => {
                    use oxidized::ast_defs::ClassishKind::*;
                    match class.kind {
                        Cclass(_) => SIClass,
                        Cinterface => SIInterface,
                        Ctrait => SITrait,
                        Cenum | CenumClass(_) => SIEnum,
                    }
                }
                Decl::Fun(_) => SIFunction,
                Decl::Typedef(_) => SITypedef,
                Decl::Const(_) => SIGlobalConstant,
                Decl::Module(_) => {
                    // TODO: SymbolIndex doesn't currently represent modules
                    return None;
                }
            };
            let (is_abstract, is_final) = match decl {
                Decl::Class(class) => (class.abstract_, class.final_),
                _ => (false, false),
            };

            Some(SiAddendum {
                name: core_utils_rust::strip_ns(name).to_owned(),
                kind,
                is_abstract,
                is_final,
            })
        })
        .collect()
}
