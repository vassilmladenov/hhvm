// Copyright (c) Meta Platforms, Inc. and affiliates.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the "hack" directory of this source tree.

use std::ops::ControlFlow;

use oxidized::aast_defs::Expr_;

use crate::config::Config;
use crate::Pass;

#[derive(Clone, Copy, Default)]
pub struct GuardInvalidPass;

impl Pass for GuardInvalidPass {
    #[allow(non_snake_case)]
    fn on_ty_expr__top_down<Ex: Default, En>(
        &mut self,
        elem: &mut Expr_<Ex, En>,
        _cfg: &Config,
    ) -> ControlFlow<(), ()> {
        if matches!(elem, Expr_::Invalid(..)) {
            ControlFlow::Break(())
        } else {
            ControlFlow::Continue(())
        }
    }
}

#[cfg(test)]
mod tests {

    use oxidized::aast_defs::Expr;
    use oxidized::aast_defs::Expr_;
    use oxidized::ast_defs::Bop;
    use oxidized::tast::Pos;

    use super::*;
    use crate::Pass;
    use crate::Transform;

    #[derive(Clone)]
    pub struct RewriteZero;
    impl Pass for RewriteZero {
        fn on_ty_expr__bottom_up<Ex: Default, En>(
            &mut self,
            elem: &mut Expr_<Ex, En>,
            _cfg: &Config,
        ) -> ControlFlow<(), ()> {
            match elem {
                Expr_::Int(..) => *elem = Expr_::Int("0".to_string()),
                _ => (),
            }
            ControlFlow::Continue(())
        }
    }

    #[test]
    fn test() {
        let cfg = Config::default();

        let mut pass = passes![GuardInvalidPass, RewriteZero];

        let mut elem: Expr_<(), ()> = Expr_::Binop(Box::new((
            Bop::Lt,
            Expr(
                (),
                Pos::NONE,
                Expr_::Invalid(Box::new(Some(Expr(
                    (),
                    Pos::NONE,
                    Expr_::Int("42".to_string()),
                )))),
            ),
            Expr((), Pos::NONE, Expr_::Int("43".to_string())),
        )));

        elem.transform(&cfg, &mut pass);

        assert!(match elem {
            Expr_::Binop(inner) => {
                let (_, e1, e2) = *inner;
                let e1_ok = match e1.2 {
                    Expr_::Invalid(inner) => inner.is_some_and(|expr| match expr.2 {
                        Expr_::Int(n) => n == "42",
                        _ => false,
                    }),
                    _ => false,
                };
                let e2_ok = match e2.2 {
                    Expr_::Int(n) => n == "0",
                    _ => false,
                };
                e1_ok && e2_ok
            }
            _ => false,
        })
    }
}
