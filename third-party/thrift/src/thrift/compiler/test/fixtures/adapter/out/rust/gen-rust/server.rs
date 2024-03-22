// @generated by Thrift for thrift/compiler/test/fixtures/adapter/src/module.thrift
// This file is probably not the place you want to edit!

//! Server definitions for `module`.

#![recursion_limit = "100000000"]
#![allow(non_camel_case_types, non_snake_case, non_upper_case_globals, unused_crate_dependencies, unused_imports, clippy::all)]

#[doc(inline)]
pub use :: as types;

pub mod errors {
    #[doc(inline)]
    pub use ::::services::service;
    #[doc(inline)]
    #[allow(ambiguous_glob_reexports)]
    pub use ::::services::service::*;

    #[doc(inline)]
    pub use ::::services::adapter_service;
    #[doc(inline)]
    #[allow(ambiguous_glob_reexports)]
    pub use ::::services::adapter_service::*;
}

pub(crate) use crate as server;
pub(crate) use ::::services;


#[::async_trait::async_trait]
pub trait Service: ::std::marker::Send + ::std::marker::Sync + 'static {
    async fn func(
        &self,
        _arg1: crate::types::StringWithAdapter_7208,
        _arg2: ::std::string::String,
        _arg3: crate::types::Foo,
    ) -> ::std::result::Result<crate::types::MyI32_4873, crate::services::service::FuncExn> {
        ::std::result::Result::Err(crate::services::service::FuncExn::ApplicationException(
            ::fbthrift::ApplicationException::unimplemented_method(
                "Service",
                "func",
            ),
        ))
    }
}

#[::async_trait::async_trait]
impl<T> Service for ::std::boxed::Box<T>
where
    T: Service + Send + Sync + ?Sized,
{
    async fn func(
        &self,
        arg1: crate::types::StringWithAdapter_7208,
        arg2: ::std::string::String,
        arg3: crate::types::Foo,
    ) -> ::std::result::Result<crate::types::MyI32_4873, crate::services::service::FuncExn> {
        (**self).func(
            arg1,
            arg2,
            arg3,
        ).await
    }
}

#[::async_trait::async_trait]
impl<T> Service for ::std::sync::Arc<T>
where
    T: Service + Send + Sync + ?Sized,
{
    async fn func(
        &self,
        arg1: crate::types::StringWithAdapter_7208,
        arg2: ::std::string::String,
        arg3: crate::types::Foo,
    ) -> ::std::result::Result<crate::types::MyI32_4873, crate::services::service::FuncExn> {
        (**self).func(
            arg1,
            arg2,
            arg3,
        ).await
    }
}


/// Processor for Service's methods.
#[derive(Clone, Debug)]
pub struct ServiceProcessor<P, H, R, RS> {
    service: H,
    supa: ::fbthrift::NullServiceProcessor<P, R, RS>,
    _phantom: ::std::marker::PhantomData<(P, H, R, RS)>,
}

struct Args_Service_func {
    arg1: <crate::types::adapters::StringWithAdapter as ::fbthrift::adapter::ThriftAdapter>::AdaptedType,
    arg2: ::std::string::String,
    arg3: crate::types::Foo,
}

impl<P: ::fbthrift::ProtocolReader> ::fbthrift::Deserialize<P> for self::Args_Service_func {
    #[inline]
    #[::tracing::instrument(skip_all, level = "trace", name = "deserialize_args", fields(method = "Service.func"))]
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        static ARGS: &[::fbthrift::Field] = &[
            ::fbthrift::Field::new("arg1", ::fbthrift::TType::String, 1),
            ::fbthrift::Field::new("arg2", ::fbthrift::TType::String, 2),
            ::fbthrift::Field::new("arg3", ::fbthrift::TType::Struct, 3),
        ];
        let mut field_arg1 = ::std::option::Option::None;
        let mut field_arg2 = ::std::option::Option::None;
        let mut field_arg3 = ::std::option::Option::None;
        let _ = p.read_struct_begin(|_| ())?;
        loop {
            let (_, fty, fid) = p.read_field_begin(|_| (), ARGS)?;
            match (fty, fid as ::std::primitive::i32) {
                (::fbthrift::TType::Stop, _) => break,
                (::fbthrift::TType::String, 1) => field_arg1 = ::std::option::Option::Some(<crate::types::adapters::StringWithAdapter as ::fbthrift::adapter::ThriftAdapter>::from_thrift_field::<fbthrift::metadata::NoThriftAnnotations>(::fbthrift::Deserialize::read(p)?, 1)?),
                (::fbthrift::TType::String, 2) => field_arg2 = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (::fbthrift::TType::Struct, 3) => field_arg3 = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (fty, _) => p.skip(fty)?,
            }
            p.read_field_end()?;
        }
        p.read_struct_end()?;
        ::std::result::Result::Ok(Self {
            arg1: field_arg1.ok_or_else(|| ::anyhow::anyhow!("`{}` missing arg `{}`", "Service.func", "arg1"))?,
            arg2: field_arg2.ok_or_else(|| ::anyhow::anyhow!("`{}` missing arg `{}`", "Service.func", "arg2"))?,
            arg3: field_arg3.ok_or_else(|| ::anyhow::anyhow!("`{}` missing arg `{}`", "Service.func", "arg3"))?,
        })
    }
}


impl<P, H, R, RS> ServiceProcessor<P, H, R, RS>
where
    P: ::fbthrift::Protocol + ::std::marker::Send + ::std::marker::Sync + 'static,
    P::Frame: ::std::marker::Send + 'static,
    P::Deserializer: ::std::marker::Send,
    H: Service,
    R: ::fbthrift::RequestContext<Name = ::std::ffi::CStr> + ::std::marker::Send + ::std::marker::Sync + 'static,
    RS: ::fbthrift::ReplyState<P::Frame, RequestContext = R> + ::std::marker::Send + ::std::marker::Sync + 'static,
    <R as ::fbthrift::RequestContext>::ContextStack: ::fbthrift::ContextStack<Name = R::Name, Frame = <P as ::fbthrift::Protocol>::Frame>
        + ::std::marker::Send + ::std::marker::Sync,
    ::fbthrift::ProtocolDecoded<P>: ::std::clone::Clone,
    ::fbthrift::ProtocolEncodedFinal<P>: ::std::clone::Clone + ::fbthrift::BufExt,
{
    pub fn new(service: H) -> Self {
        Self {
            service,
            supa: ::fbthrift::NullServiceProcessor::new(),
            _phantom: ::std::marker::PhantomData,
        }
    }

    pub fn into_inner(self) -> H {
        self.service
    }

    #[::tracing::instrument(skip_all, name = "handler", fields(method = "Service.func"))]
    async fn handle_func<'a>(
        &'a self,
        p: &'a mut P::Deserializer,
        req: ::fbthrift::ProtocolDecoded<P>,
        req_ctxt: &R,
        reply_state: ::std::sync::Arc<::std::sync::Mutex<RS>>,
        _seqid: ::std::primitive::u32,
    ) -> ::anyhow::Result<()> {
        use ::const_cstr::const_cstr;
        use ::futures::FutureExt as _;

        const_cstr! {
            SERVICE_NAME = "Service";
            METHOD_NAME = "func";
            SERVICE_METHOD_NAME = "Service.func";
        }
        let mut ctx_stack = req_ctxt.get_context_stack(
            SERVICE_NAME.as_cstr(),
            SERVICE_METHOD_NAME.as_cstr(),
        )?;
        ::fbthrift::ContextStack::pre_read(&mut ctx_stack)?;
        let _args: self::Args_Service_func = ::fbthrift::Deserialize::read(p)?;
        let bytes_read = ::fbthrift::help::buf_len(&req)?;
        ::fbthrift::ContextStack::on_read_data(&mut ctx_stack, ::fbthrift::SerializedMessage {
            protocol: P::PROTOCOL_ID,
            method_name: METHOD_NAME.as_cstr(),
            buffer: req,
        })?;
        ::fbthrift::ContextStack::post_read(&mut ctx_stack, bytes_read)?;

        let res = ::std::panic::AssertUnwindSafe(
            self.service.func(
                _args.arg1,
                _args.arg2,
                _args.arg3,
            )
        )
        .catch_unwind()
        .await;

        // nested results - panic catch on the outside, method on the inside
        let res = match res {
            ::std::result::Result::Ok(::std::result::Result::Ok(res)) => {
                ::tracing::trace!(method = "Service.func", "success");
                crate::services::service::FuncExn::Success(res)
            }
            ::std::result::Result::Ok(::std::result::Result::Err(crate::services::service::FuncExn::Success(_))) => {
                panic!(
                    "{} attempted to return success via error",
                    "func",
                )
            }
            ::std::result::Result::Ok(::std::result::Result::Err(exn)) => {
                ::tracing::info!(method = "Service.func", exception = ?exn);
                exn
            }
            ::std::result::Result::Err(exn) => {
                let aexn = ::fbthrift::ApplicationException::handler_panic("Service.func", exn);
                ::tracing::error!(method = "Service.func", panic = ?aexn);
                crate::services::service::FuncExn::ApplicationException(aexn)
            }
        };

        let env = ::fbthrift::help::serialize_result_envelope::<P, R, _>(
            "func",
            METHOD_NAME.as_cstr(),
            _seqid,
            req_ctxt,
            &mut ctx_stack,
            res
        )?;
        reply_state.lock().unwrap().send_reply(env);
        Ok(())
    }
}

#[::async_trait::async_trait]
impl<P, H, R, RS> ::fbthrift::ServiceProcessor<P> for ServiceProcessor<P, H, R, RS>
where
    P: ::fbthrift::Protocol + ::std::marker::Send + ::std::marker::Sync + 'static,
    P::Deserializer: ::std::marker::Send,
    H: Service,
    P::Frame: ::std::marker::Send + 'static,
    R: ::fbthrift::RequestContext<Name = ::std::ffi::CStr> + ::std::marker::Send + ::std::marker::Sync + 'static,
    <R as ::fbthrift::RequestContext>::ContextStack: ::fbthrift::ContextStack<Name = R::Name, Frame = <P as ::fbthrift::Protocol>::Frame>
        + ::std::marker::Send + ::std::marker::Sync + 'static,
    RS: ::fbthrift::ReplyState<P::Frame, RequestContext = R> + ::std::marker::Send + ::std::marker::Sync + 'static,
    ::fbthrift::ProtocolDecoded<P>: ::std::clone::Clone,
    ::fbthrift::ProtocolEncodedFinal<P>: ::std::clone::Clone + ::fbthrift::BufExt,
{
    type RequestContext = R;
    type ReplyState = RS;

    #[inline]
    fn method_idx(&self, name: &[::std::primitive::u8]) -> ::std::result::Result<::std::primitive::usize, ::fbthrift::ApplicationException> {
        match name {
            b"func" => ::std::result::Result::Ok(0usize),
            _ => ::std::result::Result::Err(::fbthrift::ApplicationException::unknown_method()),
        }
    }

    #[allow(clippy::match_single_binding)]
    async fn handle_method(
        &self,
        idx: ::std::primitive::usize,
        _p: &mut P::Deserializer,
        _req: ::fbthrift::ProtocolDecoded<P>,
        _req_ctxt: &R,
        _reply_state: ::std::sync::Arc<::std::sync::Mutex<RS>>,
        _seqid: ::std::primitive::u32,
    ) -> ::anyhow::Result<()> {
        match idx {
            0usize => {
                self.handle_func(_p, _req, _req_ctxt, _reply_state, _seqid).await
            }
            bad => panic!(
                "{}: unexpected method idx {}",
                "ServiceProcessor",
                bad
            ),
        }
    }

    #[allow(clippy::match_single_binding)]
    #[inline]
    fn create_interaction_idx(&self, name: &str) -> ::anyhow::Result<::std::primitive::usize> {
        match name {
            _ => ::anyhow::bail!("Unknown interaction"),
        }
    }

    #[allow(clippy::match_single_binding)]
    fn handle_create_interaction(
        &self,
        idx: ::std::primitive::usize,
    ) -> ::anyhow::Result<
        ::std::sync::Arc<dyn ::fbthrift::ThriftService<P::Frame, Handler = (), RequestContext = Self::RequestContext, ReplyState = Self::ReplyState> + ::std::marker::Send + 'static>
    > {
        match idx {
            bad => panic!(
                "{}: unexpected method idx {}",
                "ServiceProcessor",
                bad
            ),
        }
    }

    async fn handle_on_termination(&self) {
    }
}

#[::async_trait::async_trait]
impl<P, H, R, RS> ::fbthrift::ThriftService<P::Frame> for ServiceProcessor<P, H, R, RS>
where
    P: ::fbthrift::Protocol + ::std::marker::Send + ::std::marker::Sync + 'static,
    P::Deserializer: ::std::marker::Send,
    P::Frame: ::std::marker::Send + 'static,
    H: Service,
    R: ::fbthrift::RequestContext<Name = ::std::ffi::CStr> + ::std::marker::Send + ::std::marker::Sync + 'static,
    <R as ::fbthrift::RequestContext>::ContextStack: ::fbthrift::ContextStack<Name = R::Name, Frame = <P as ::fbthrift::Protocol>::Frame>
        + ::std::marker::Send + ::std::marker::Sync + 'static,
    RS: ::fbthrift::ReplyState<P::Frame, RequestContext = R> + ::std::marker::Send + ::std::marker::Sync + 'static,
    ::fbthrift::ProtocolDecoded<P>: ::std::clone::Clone,
    ::fbthrift::ProtocolEncodedFinal<P>: ::std::clone::Clone + ::fbthrift::BufExt,
{
    type Handler = H;
    type RequestContext = R;
    type ReplyState = RS;

    #[tracing::instrument(level="trace", skip_all, fields(service = "Service"))]
    async fn call(
        &self,
        req: ::fbthrift::ProtocolDecoded<P>,
        req_ctxt: &R,
        reply_state: ::std::sync::Arc<::std::sync::Mutex<RS>>,
    ) -> ::anyhow::Result<()> {
        use ::fbthrift::{ProtocolReader as _, ServiceProcessor as _};
        let mut p = P::deserializer(req.clone());
        let (idx, mty, seqid) = p.read_message_begin(|name| self.method_idx(name))?;
        if mty != ::fbthrift::MessageType::Call {
            return ::std::result::Result::Err(::std::convert::From::from(::fbthrift::ApplicationException::new(
                ::fbthrift::ApplicationExceptionErrorCode::InvalidMessageType,
                format!("message type {:?} not handled", mty)
            )));
        }
        let idx = match idx {
            ::std::result::Result::Ok(idx) => idx,
            ::std::result::Result::Err(_) => {
                return self.supa.call(req, req_ctxt, reply_state).await;
            }
        };
        self.handle_method(idx, &mut p, req, req_ctxt, reply_state, seqid).await?;
        p.read_message_end()?;

        Ok(())
    }

    fn create_interaction(
        &self,
        name: &str,
    ) -> ::anyhow::Result<
        ::std::sync::Arc<dyn ::fbthrift::ThriftService<P::Frame, Handler = (), RequestContext = R, ReplyState = RS> + ::std::marker::Send + 'static>
    > {
        use ::fbthrift::{ServiceProcessor as _};
        let idx = self.create_interaction_idx(name);
        let idx = match idx {
            ::anyhow::Result::Ok(idx) => idx,
            ::anyhow::Result::Err(_) => {
                return self.supa.create_interaction(name);
            }
        };
        self.handle_create_interaction(idx)
    }

    fn get_method_names(&self) -> &'static [&'static str] {
        &[
                // from Service
                "func",
        ]
    }

    async fn on_termination(&self) {
        use ::fbthrift::{ServiceProcessor as _};
        self.handle_on_termination().await
    }
}

/// Construct a new instance of a Service service.
///
/// This is called when a new instance of a Thrift service Processor
/// is needed for a particular Thrift protocol.
#[::tracing::instrument(level="debug", skip_all, fields(proto = ?proto))]
pub fn make_Service_server<F, H, R, RS>(
    proto: ::fbthrift::ProtocolID,
    handler: H,
) -> ::std::result::Result<::std::boxed::Box<dyn ::fbthrift::ThriftService<F, Handler = H, RequestContext = R, ReplyState = RS> + ::std::marker::Send + 'static>, ::fbthrift::ApplicationException>
where
    F: ::fbthrift::Framing + ::std::marker::Send + ::std::marker::Sync + 'static,
    H: Service,
    R: ::fbthrift::RequestContext<Name = ::std::ffi::CStr> + ::std::marker::Send + ::std::marker::Sync + 'static,
    <R as ::fbthrift::RequestContext>::ContextStack: ::fbthrift::ContextStack<Name = R::Name, Frame = F> + ::std::marker::Send + ::std::marker::Sync + 'static,
    RS: ::fbthrift::ReplyState<F, RequestContext = R> + ::std::marker::Send + ::std::marker::Sync + 'static,
    ::fbthrift::FramingDecoded<F>: ::std::clone::Clone,
    ::fbthrift::FramingEncodedFinal<F>: ::std::clone::Clone + ::fbthrift::BufExt,
{
    match proto {
        ::fbthrift::ProtocolID::BinaryProtocol => {
            ::std::result::Result::Ok(::std::boxed::Box::new(ServiceProcessor::<::fbthrift::BinaryProtocol<F>, H, R, RS>::new(handler)))
        }
        ::fbthrift::ProtocolID::CompactProtocol => {
            ::std::result::Result::Ok(::std::boxed::Box::new(ServiceProcessor::<::fbthrift::CompactProtocol<F>, H, R, RS>::new(handler)))
        }
        bad => {
            ::tracing::error!(method = "Service.", invalid_protocol = ?bad);
            ::std::result::Result::Err(::fbthrift::ApplicationException::invalid_protocol(bad))
        }
    }
}

#[::async_trait::async_trait]
pub trait AdapterService: ::std::marker::Send + ::std::marker::Sync + 'static {
    async fn count(
        &self,
    ) -> ::std::result::Result<crate::types::CountingStruct, crate::services::adapter_service::CountExn> {
        ::std::result::Result::Err(crate::services::adapter_service::CountExn::ApplicationException(
            ::fbthrift::ApplicationException::unimplemented_method(
                "AdapterService",
                "count",
            ),
        ))
    }
    async fn adaptedTypes(
        &self,
        _arg: crate::types::HeapAllocated,
    ) -> ::std::result::Result<crate::types::HeapAllocated, crate::services::adapter_service::AdaptedTypesExn> {
        ::std::result::Result::Err(crate::services::adapter_service::AdaptedTypesExn::ApplicationException(
            ::fbthrift::ApplicationException::unimplemented_method(
                "AdapterService",
                "adaptedTypes",
            ),
        ))
    }
}

#[::async_trait::async_trait]
impl<T> AdapterService for ::std::boxed::Box<T>
where
    T: AdapterService + Send + Sync + ?Sized,
{
    async fn count(
        &self,
    ) -> ::std::result::Result<crate::types::CountingStruct, crate::services::adapter_service::CountExn> {
        (**self).count(
        ).await
    }
    async fn adaptedTypes(
        &self,
        arg: crate::types::HeapAllocated,
    ) -> ::std::result::Result<crate::types::HeapAllocated, crate::services::adapter_service::AdaptedTypesExn> {
        (**self).adaptedTypes(
            arg,
        ).await
    }
}

#[::async_trait::async_trait]
impl<T> AdapterService for ::std::sync::Arc<T>
where
    T: AdapterService + Send + Sync + ?Sized,
{
    async fn count(
        &self,
    ) -> ::std::result::Result<crate::types::CountingStruct, crate::services::adapter_service::CountExn> {
        (**self).count(
        ).await
    }
    async fn adaptedTypes(
        &self,
        arg: crate::types::HeapAllocated,
    ) -> ::std::result::Result<crate::types::HeapAllocated, crate::services::adapter_service::AdaptedTypesExn> {
        (**self).adaptedTypes(
            arg,
        ).await
    }
}


/// Processor for AdapterService's methods.
#[derive(Clone, Debug)]
pub struct AdapterServiceProcessor<P, H, R, RS> {
    service: H,
    supa: ::fbthrift::NullServiceProcessor<P, R, RS>,
    _phantom: ::std::marker::PhantomData<(P, H, R, RS)>,
}

struct Args_AdapterService_count {
}

impl<P: ::fbthrift::ProtocolReader> ::fbthrift::Deserialize<P> for self::Args_AdapterService_count {
    #[inline]
    #[::tracing::instrument(skip_all, level = "trace", name = "deserialize_args", fields(method = "AdapterService.count"))]
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        static ARGS: &[::fbthrift::Field] = &[
        ];
        let _ = p.read_struct_begin(|_| ())?;
        loop {
            let (_, fty, fid) = p.read_field_begin(|_| (), ARGS)?;
            match (fty, fid as ::std::primitive::i32) {
                (::fbthrift::TType::Stop, _) => break,
                (fty, _) => p.skip(fty)?,
            }
            p.read_field_end()?;
        }
        p.read_struct_end()?;
        ::std::result::Result::Ok(Self {
        })
    }
}

struct Args_AdapterService_adaptedTypes {
    arg: crate::types::HeapAllocated,
}

impl<P: ::fbthrift::ProtocolReader> ::fbthrift::Deserialize<P> for self::Args_AdapterService_adaptedTypes {
    #[inline]
    #[::tracing::instrument(skip_all, level = "trace", name = "deserialize_args", fields(method = "AdapterService.adaptedTypes"))]
    fn read(p: &mut P) -> ::anyhow::Result<Self> {
        static ARGS: &[::fbthrift::Field] = &[
            ::fbthrift::Field::new("arg", ::fbthrift::TType::Struct, 1),
        ];
        let mut field_arg = ::std::option::Option::None;
        let _ = p.read_struct_begin(|_| ())?;
        loop {
            let (_, fty, fid) = p.read_field_begin(|_| (), ARGS)?;
            match (fty, fid as ::std::primitive::i32) {
                (::fbthrift::TType::Stop, _) => break,
                (::fbthrift::TType::Struct, 1) => field_arg = ::std::option::Option::Some(::fbthrift::Deserialize::read(p)?),
                (fty, _) => p.skip(fty)?,
            }
            p.read_field_end()?;
        }
        p.read_struct_end()?;
        ::std::result::Result::Ok(Self {
            arg: field_arg.ok_or_else(|| ::anyhow::anyhow!("`{}` missing arg `{}`", "AdapterService.adaptedTypes", "arg"))?,
        })
    }
}


impl<P, H, R, RS> AdapterServiceProcessor<P, H, R, RS>
where
    P: ::fbthrift::Protocol + ::std::marker::Send + ::std::marker::Sync + 'static,
    P::Frame: ::std::marker::Send + 'static,
    P::Deserializer: ::std::marker::Send,
    H: AdapterService,
    R: ::fbthrift::RequestContext<Name = ::std::ffi::CStr> + ::std::marker::Send + ::std::marker::Sync + 'static,
    RS: ::fbthrift::ReplyState<P::Frame, RequestContext = R> + ::std::marker::Send + ::std::marker::Sync + 'static,
    <R as ::fbthrift::RequestContext>::ContextStack: ::fbthrift::ContextStack<Name = R::Name, Frame = <P as ::fbthrift::Protocol>::Frame>
        + ::std::marker::Send + ::std::marker::Sync,
    ::fbthrift::ProtocolDecoded<P>: ::std::clone::Clone,
    ::fbthrift::ProtocolEncodedFinal<P>: ::std::clone::Clone + ::fbthrift::BufExt,
{
    pub fn new(service: H) -> Self {
        Self {
            service,
            supa: ::fbthrift::NullServiceProcessor::new(),
            _phantom: ::std::marker::PhantomData,
        }
    }

    pub fn into_inner(self) -> H {
        self.service
    }

    #[::tracing::instrument(skip_all, name = "handler", fields(method = "AdapterService.count"))]
    async fn handle_count<'a>(
        &'a self,
        p: &'a mut P::Deserializer,
        req: ::fbthrift::ProtocolDecoded<P>,
        req_ctxt: &R,
        reply_state: ::std::sync::Arc<::std::sync::Mutex<RS>>,
        _seqid: ::std::primitive::u32,
    ) -> ::anyhow::Result<()> {
        use ::const_cstr::const_cstr;
        use ::futures::FutureExt as _;

        const_cstr! {
            SERVICE_NAME = "AdapterService";
            METHOD_NAME = "count";
            SERVICE_METHOD_NAME = "AdapterService.count";
        }
        let mut ctx_stack = req_ctxt.get_context_stack(
            SERVICE_NAME.as_cstr(),
            SERVICE_METHOD_NAME.as_cstr(),
        )?;
        ::fbthrift::ContextStack::pre_read(&mut ctx_stack)?;
        let _args: self::Args_AdapterService_count = ::fbthrift::Deserialize::read(p)?;
        let bytes_read = ::fbthrift::help::buf_len(&req)?;
        ::fbthrift::ContextStack::on_read_data(&mut ctx_stack, ::fbthrift::SerializedMessage {
            protocol: P::PROTOCOL_ID,
            method_name: METHOD_NAME.as_cstr(),
            buffer: req,
        })?;
        ::fbthrift::ContextStack::post_read(&mut ctx_stack, bytes_read)?;

        let res = ::std::panic::AssertUnwindSafe(
            self.service.count(
            )
        )
        .catch_unwind()
        .await;

        // nested results - panic catch on the outside, method on the inside
        let res = match res {
            ::std::result::Result::Ok(::std::result::Result::Ok(res)) => {
                ::tracing::trace!(method = "AdapterService.count", "success");
                crate::services::adapter_service::CountExn::Success(res)
            }
            ::std::result::Result::Ok(::std::result::Result::Err(crate::services::adapter_service::CountExn::Success(_))) => {
                panic!(
                    "{} attempted to return success via error",
                    "count",
                )
            }
            ::std::result::Result::Ok(::std::result::Result::Err(exn)) => {
                ::tracing::info!(method = "AdapterService.count", exception = ?exn);
                exn
            }
            ::std::result::Result::Err(exn) => {
                let aexn = ::fbthrift::ApplicationException::handler_panic("AdapterService.count", exn);
                ::tracing::error!(method = "AdapterService.count", panic = ?aexn);
                crate::services::adapter_service::CountExn::ApplicationException(aexn)
            }
        };

        let env = ::fbthrift::help::serialize_result_envelope::<P, R, _>(
            "count",
            METHOD_NAME.as_cstr(),
            _seqid,
            req_ctxt,
            &mut ctx_stack,
            res
        )?;
        reply_state.lock().unwrap().send_reply(env);
        Ok(())
    }

    #[::tracing::instrument(skip_all, name = "handler", fields(method = "AdapterService.adaptedTypes"))]
    async fn handle_adaptedTypes<'a>(
        &'a self,
        p: &'a mut P::Deserializer,
        req: ::fbthrift::ProtocolDecoded<P>,
        req_ctxt: &R,
        reply_state: ::std::sync::Arc<::std::sync::Mutex<RS>>,
        _seqid: ::std::primitive::u32,
    ) -> ::anyhow::Result<()> {
        use ::const_cstr::const_cstr;
        use ::futures::FutureExt as _;

        const_cstr! {
            SERVICE_NAME = "AdapterService";
            METHOD_NAME = "adaptedTypes";
            SERVICE_METHOD_NAME = "AdapterService.adaptedTypes";
        }
        let mut ctx_stack = req_ctxt.get_context_stack(
            SERVICE_NAME.as_cstr(),
            SERVICE_METHOD_NAME.as_cstr(),
        )?;
        ::fbthrift::ContextStack::pre_read(&mut ctx_stack)?;
        let _args: self::Args_AdapterService_adaptedTypes = ::fbthrift::Deserialize::read(p)?;
        let bytes_read = ::fbthrift::help::buf_len(&req)?;
        ::fbthrift::ContextStack::on_read_data(&mut ctx_stack, ::fbthrift::SerializedMessage {
            protocol: P::PROTOCOL_ID,
            method_name: METHOD_NAME.as_cstr(),
            buffer: req,
        })?;
        ::fbthrift::ContextStack::post_read(&mut ctx_stack, bytes_read)?;

        let res = ::std::panic::AssertUnwindSafe(
            self.service.adaptedTypes(
                _args.arg,
            )
        )
        .catch_unwind()
        .await;

        // nested results - panic catch on the outside, method on the inside
        let res = match res {
            ::std::result::Result::Ok(::std::result::Result::Ok(res)) => {
                ::tracing::trace!(method = "AdapterService.adaptedTypes", "success");
                crate::services::adapter_service::AdaptedTypesExn::Success(res)
            }
            ::std::result::Result::Ok(::std::result::Result::Err(crate::services::adapter_service::AdaptedTypesExn::Success(_))) => {
                panic!(
                    "{} attempted to return success via error",
                    "adaptedTypes",
                )
            }
            ::std::result::Result::Ok(::std::result::Result::Err(exn)) => {
                ::tracing::info!(method = "AdapterService.adaptedTypes", exception = ?exn);
                exn
            }
            ::std::result::Result::Err(exn) => {
                let aexn = ::fbthrift::ApplicationException::handler_panic("AdapterService.adaptedTypes", exn);
                ::tracing::error!(method = "AdapterService.adaptedTypes", panic = ?aexn);
                crate::services::adapter_service::AdaptedTypesExn::ApplicationException(aexn)
            }
        };

        let env = ::fbthrift::help::serialize_result_envelope::<P, R, _>(
            "adaptedTypes",
            METHOD_NAME.as_cstr(),
            _seqid,
            req_ctxt,
            &mut ctx_stack,
            res
        )?;
        reply_state.lock().unwrap().send_reply(env);
        Ok(())
    }
}

#[::async_trait::async_trait]
impl<P, H, R, RS> ::fbthrift::ServiceProcessor<P> for AdapterServiceProcessor<P, H, R, RS>
where
    P: ::fbthrift::Protocol + ::std::marker::Send + ::std::marker::Sync + 'static,
    P::Deserializer: ::std::marker::Send,
    H: AdapterService,
    P::Frame: ::std::marker::Send + 'static,
    R: ::fbthrift::RequestContext<Name = ::std::ffi::CStr> + ::std::marker::Send + ::std::marker::Sync + 'static,
    <R as ::fbthrift::RequestContext>::ContextStack: ::fbthrift::ContextStack<Name = R::Name, Frame = <P as ::fbthrift::Protocol>::Frame>
        + ::std::marker::Send + ::std::marker::Sync + 'static,
    RS: ::fbthrift::ReplyState<P::Frame, RequestContext = R> + ::std::marker::Send + ::std::marker::Sync + 'static,
    ::fbthrift::ProtocolDecoded<P>: ::std::clone::Clone,
    ::fbthrift::ProtocolEncodedFinal<P>: ::std::clone::Clone + ::fbthrift::BufExt,
{
    type RequestContext = R;
    type ReplyState = RS;

    #[inline]
    fn method_idx(&self, name: &[::std::primitive::u8]) -> ::std::result::Result<::std::primitive::usize, ::fbthrift::ApplicationException> {
        match name {
            b"count" => ::std::result::Result::Ok(0usize),
            b"adaptedTypes" => ::std::result::Result::Ok(1usize),
            _ => ::std::result::Result::Err(::fbthrift::ApplicationException::unknown_method()),
        }
    }

    #[allow(clippy::match_single_binding)]
    async fn handle_method(
        &self,
        idx: ::std::primitive::usize,
        _p: &mut P::Deserializer,
        _req: ::fbthrift::ProtocolDecoded<P>,
        _req_ctxt: &R,
        _reply_state: ::std::sync::Arc<::std::sync::Mutex<RS>>,
        _seqid: ::std::primitive::u32,
    ) -> ::anyhow::Result<()> {
        match idx {
            0usize => {
                self.handle_count(_p, _req, _req_ctxt, _reply_state, _seqid).await
            }
            1usize => {
                self.handle_adaptedTypes(_p, _req, _req_ctxt, _reply_state, _seqid).await
            }
            bad => panic!(
                "{}: unexpected method idx {}",
                "AdapterServiceProcessor",
                bad
            ),
        }
    }

    #[allow(clippy::match_single_binding)]
    #[inline]
    fn create_interaction_idx(&self, name: &str) -> ::anyhow::Result<::std::primitive::usize> {
        match name {
            _ => ::anyhow::bail!("Unknown interaction"),
        }
    }

    #[allow(clippy::match_single_binding)]
    fn handle_create_interaction(
        &self,
        idx: ::std::primitive::usize,
    ) -> ::anyhow::Result<
        ::std::sync::Arc<dyn ::fbthrift::ThriftService<P::Frame, Handler = (), RequestContext = Self::RequestContext, ReplyState = Self::ReplyState> + ::std::marker::Send + 'static>
    > {
        match idx {
            bad => panic!(
                "{}: unexpected method idx {}",
                "AdapterServiceProcessor",
                bad
            ),
        }
    }

    async fn handle_on_termination(&self) {
    }
}

#[::async_trait::async_trait]
impl<P, H, R, RS> ::fbthrift::ThriftService<P::Frame> for AdapterServiceProcessor<P, H, R, RS>
where
    P: ::fbthrift::Protocol + ::std::marker::Send + ::std::marker::Sync + 'static,
    P::Deserializer: ::std::marker::Send,
    P::Frame: ::std::marker::Send + 'static,
    H: AdapterService,
    R: ::fbthrift::RequestContext<Name = ::std::ffi::CStr> + ::std::marker::Send + ::std::marker::Sync + 'static,
    <R as ::fbthrift::RequestContext>::ContextStack: ::fbthrift::ContextStack<Name = R::Name, Frame = <P as ::fbthrift::Protocol>::Frame>
        + ::std::marker::Send + ::std::marker::Sync + 'static,
    RS: ::fbthrift::ReplyState<P::Frame, RequestContext = R> + ::std::marker::Send + ::std::marker::Sync + 'static,
    ::fbthrift::ProtocolDecoded<P>: ::std::clone::Clone,
    ::fbthrift::ProtocolEncodedFinal<P>: ::std::clone::Clone + ::fbthrift::BufExt,
{
    type Handler = H;
    type RequestContext = R;
    type ReplyState = RS;

    #[tracing::instrument(level="trace", skip_all, fields(service = "AdapterService"))]
    async fn call(
        &self,
        req: ::fbthrift::ProtocolDecoded<P>,
        req_ctxt: &R,
        reply_state: ::std::sync::Arc<::std::sync::Mutex<RS>>,
    ) -> ::anyhow::Result<()> {
        use ::fbthrift::{ProtocolReader as _, ServiceProcessor as _};
        let mut p = P::deserializer(req.clone());
        let (idx, mty, seqid) = p.read_message_begin(|name| self.method_idx(name))?;
        if mty != ::fbthrift::MessageType::Call {
            return ::std::result::Result::Err(::std::convert::From::from(::fbthrift::ApplicationException::new(
                ::fbthrift::ApplicationExceptionErrorCode::InvalidMessageType,
                format!("message type {:?} not handled", mty)
            )));
        }
        let idx = match idx {
            ::std::result::Result::Ok(idx) => idx,
            ::std::result::Result::Err(_) => {
                return self.supa.call(req, req_ctxt, reply_state).await;
            }
        };
        self.handle_method(idx, &mut p, req, req_ctxt, reply_state, seqid).await?;
        p.read_message_end()?;

        Ok(())
    }

    fn create_interaction(
        &self,
        name: &str,
    ) -> ::anyhow::Result<
        ::std::sync::Arc<dyn ::fbthrift::ThriftService<P::Frame, Handler = (), RequestContext = R, ReplyState = RS> + ::std::marker::Send + 'static>
    > {
        use ::fbthrift::{ServiceProcessor as _};
        let idx = self.create_interaction_idx(name);
        let idx = match idx {
            ::anyhow::Result::Ok(idx) => idx,
            ::anyhow::Result::Err(_) => {
                return self.supa.create_interaction(name);
            }
        };
        self.handle_create_interaction(idx)
    }

    fn get_method_names(&self) -> &'static [&'static str] {
        &[
                // from AdapterService
                "count",
                "adaptedTypes",
        ]
    }

    async fn on_termination(&self) {
        use ::fbthrift::{ServiceProcessor as _};
        self.handle_on_termination().await
    }
}

/// Construct a new instance of a AdapterService service.
///
/// This is called when a new instance of a Thrift service Processor
/// is needed for a particular Thrift protocol.
#[::tracing::instrument(level="debug", skip_all, fields(proto = ?proto))]
pub fn make_AdapterService_server<F, H, R, RS>(
    proto: ::fbthrift::ProtocolID,
    handler: H,
) -> ::std::result::Result<::std::boxed::Box<dyn ::fbthrift::ThriftService<F, Handler = H, RequestContext = R, ReplyState = RS> + ::std::marker::Send + 'static>, ::fbthrift::ApplicationException>
where
    F: ::fbthrift::Framing + ::std::marker::Send + ::std::marker::Sync + 'static,
    H: AdapterService,
    R: ::fbthrift::RequestContext<Name = ::std::ffi::CStr> + ::std::marker::Send + ::std::marker::Sync + 'static,
    <R as ::fbthrift::RequestContext>::ContextStack: ::fbthrift::ContextStack<Name = R::Name, Frame = F> + ::std::marker::Send + ::std::marker::Sync + 'static,
    RS: ::fbthrift::ReplyState<F, RequestContext = R> + ::std::marker::Send + ::std::marker::Sync + 'static,
    ::fbthrift::FramingDecoded<F>: ::std::clone::Clone,
    ::fbthrift::FramingEncodedFinal<F>: ::std::clone::Clone + ::fbthrift::BufExt,
{
    match proto {
        ::fbthrift::ProtocolID::BinaryProtocol => {
            ::std::result::Result::Ok(::std::boxed::Box::new(AdapterServiceProcessor::<::fbthrift::BinaryProtocol<F>, H, R, RS>::new(handler)))
        }
        ::fbthrift::ProtocolID::CompactProtocol => {
            ::std::result::Result::Ok(::std::boxed::Box::new(AdapterServiceProcessor::<::fbthrift::CompactProtocol<F>, H, R, RS>::new(handler)))
        }
        bad => {
            ::tracing::error!(method = "AdapterService.", invalid_protocol = ?bad);
            ::std::result::Result::Err(::fbthrift::ApplicationException::invalid_protocol(bad))
        }
    }
}
