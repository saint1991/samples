use std::boxed::Box;
use std::pin::Pin;

use tokio_stream::Stream;

use crate::proto;
use crate::proto::sample_service_server as grpc;

#[derive(Debug)]
pub struct GrpcWebService {}

#[tonic::async_trait]
impl grpc::SampleService for GrpcWebService {
    type ServerStreamStream = 
        Pin<Box<dyn Stream<Item = Result<proto::Response, tonic::Status>> + Send + 'static>>;

    async fn server_stream(
        &self,
        request: tonic::Request<proto::Request>,
    ) -> Result<tonic::Response<Self::ServerStreamStream>, tonic::Status> {
        let req = request.into_inner();
        let name = req.name;

        let output = async_stream::stream! {
            for progress in 0..100 {
                yield Ok(proto::Response {
                    res: Some(proto::response::Res::Progress(proto::Progress { percent: progress } ))
                });
                std::thread::sleep(std::time::Duration::from_millis(1000));
            }
            yield Ok(proto::Response {
                res: Some(proto::response::Res::Result(proto::Result { message: format!("Hello, {}!", name) } ))
            });
        };

        Ok(tonic::Response::new(
            Box::pin(output) as Self::ServerStreamStream
        ))
    }
}

impl GrpcWebService {
    pub fn new() -> Self {
        Self {}
    }

    pub fn new_server() -> grpc::SampleServiceServer<GrpcWebService> {
        grpc::SampleServiceServer::new(GrpcWebService::new())
    }
}
