use actix_web::body::EitherBody;
use actix_web::body::MessageBody;
use actix_web::dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform};
use actix_web::web::ReqData;
use actix_web::{Error, Result};
use actix_web_middleware_keycloak_auth::{
    AlwaysPassPolicy, AuthError, DecodingKey, KeycloakAuth, KeycloakAuthMiddleware,
    KeycloakAuthStatus,
};

const KEYCLOAK_PK: &str = "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvcOW0sCM9P9liqawHSd7wBi9L7bv42q+w7999HTBEWCX+1ofOwjSVTn//RPTbB42ak48QEtBqj8gBmr5KrFnpenF+sXbG7C4Qeef19n/0q6HjjrEK20695DE4y/a5QUdcxhepLGUmy55rDXS12oELfRJqD4HW6FqYnF0VSBAf6SxuR06de4toI5G2rPqfm2OveWLQel9JuHEte9D8IWJtG8va67XtwpHRIgRa+6CAHGFKWhZbwXOS55YuOL0er0XWnkdVJDTcdaPEvbvXfmQvHfP42JUrN0ZyIqyfo5X6XvfIEX5avLGvUdKd/9zKp4O9tL0Cg9OQWpXSNElquv+8wIDAQAB\n-----END PUBLIC KEY-----";

struct HandlerMiddlewareFactory;

impl<S, B> Transform<S, ServiceRequest> for HandlerMiddlewareFactory
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: MessageBody + 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type InitError = ();
    type Transform = HandlerMiddleware<S>;
    type Future = std::future::Ready<std::result::Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        std::future::ready(Ok(HandlerMiddleware { service }))
    }
}

pub struct HandlerMiddleware<S> {
    service: S,
}

impl<S, B> Service<ServiceRequest> for HandlerMiddleware<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Future = std::pin::Pin<Box<dyn std::future::Future<Output = Result<Self::Response>>>>;

    forward_ready!(service);

    fn call(&self, mut req: ServiceRequest) -> Self::Future {
        let status = req
            .extract::<ReqData<KeycloakAuthStatus>>()
            .into_inner()
            .map(|status| status.into_inner())
            .unwrap();

        match status {
            KeycloakAuthStatus::Success => Box::pin(self.service.call(req)),
            KeycloakAuthStatus::Failure(auth_err) => {
                let err = match auth_err {
                    AuthError::NoAuthorizationHeader => crate::error::Error::TokenNotFound,
                    AuthError::DecodeError(ref message) if message == "ExpiredSignature" => {
                        crate::error::Error::TokenExpired
                    }
                    _ => crate::error::Error::TokenInvalid,
                };
                Box::pin(std::future::ready(Err(Error::from(err))))
            }
        }
    }
}

pub struct JwtVerificationMiddlewareFactory {
    keycloak_auth: KeycloakAuth<AlwaysPassPolicy>,
}

impl Default for JwtVerificationMiddlewareFactory {
    fn default() -> Self {
        JwtVerificationMiddlewareFactory {
            keycloak_auth: KeycloakAuth {
                detailed_responses: true,
                keycloak_oid_public_key: DecodingKey::from_rsa_pem(KEYCLOAK_PK.as_bytes()).unwrap(),
                required_roles: vec![],
                passthrough_policy: AlwaysPassPolicy,
            },
        }
    }
}

impl<S, B> Transform<S, ServiceRequest> for JwtVerificationMiddlewareFactory
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: MessageBody + 'static,
{
    type Response = ServiceResponse<EitherBody<B>>;
    type Error = Error;
    type InitError = ();
    type Transform = JwtVerificationMiddleware<HandlerMiddleware<S>>;
    type Future = std::future::Ready<std::result::Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        let inner_service = HandlerMiddlewareFactory
            .new_transform(service)
            .into_inner()
            .unwrap();

        let middleware = self
            .keycloak_auth
            .new_transform(inner_service)
            .into_inner()
            .map(|kc| JwtVerificationMiddleware { service: kc });

        std::future::ready(middleware)
    }
}

pub struct JwtVerificationMiddleware<S> {
    service: KeycloakAuthMiddleware<AlwaysPassPolicy, S>,
}

impl<S, B> Service<ServiceRequest> for JwtVerificationMiddleware<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: MessageBody + 'static,
{
    type Response = ServiceResponse<EitherBody<B>>;
    type Error = Error;
    type Future = std::pin::Pin<Box<dyn std::future::Future<Output = Result<Self::Response>>>>;

    forward_ready!(service);

    fn call(&self, req: ServiceRequest) -> Self::Future {
        self.service.call(req)
    }
}
