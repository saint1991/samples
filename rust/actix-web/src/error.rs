use actix_web::{HttpResponseBuilder, ResponseError};
use serde::{ser::SerializeStruct, Serialize};

#[derive(Clone, Debug, thiserror::Error)]
pub enum Error {
    #[error("Token not found")]
    TokenNotFound,

    #[error("Token expired")]
    TokenExpired,

    #[error("Token invalid")]
    TokenInvalid,
}

impl Error {
    pub fn code(&self) -> &'static str {
        match self {
            Error::TokenNotFound => "E40300",
            Error::TokenExpired => "E40301",
            Error::TokenInvalid => "E40302",
        }
    }
}

impl Serialize for Error {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        let mut state = serializer.serialize_struct("Error", 2)?;
        state.serialize_field("code", &self.code())?;
        state.serialize_field("message", &self.to_string())?;
        state.end()
    }
}

impl ResponseError for Error {
    fn status_code(&self) -> actix_web::http::StatusCode {
        actix_web::http::StatusCode::UNAUTHORIZED
    }

    fn error_response(&self) -> actix_web::HttpResponse {
        HttpResponseBuilder::new(self.status_code()).json(self)
    }
}

#[test]
fn test_serialize() {
    let err = Error::TokenNotFound;
    let json = serde_json::to_string(&err).unwrap();
    println!("{}", json)
}
