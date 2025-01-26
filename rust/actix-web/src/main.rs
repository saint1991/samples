mod error;
mod middleware;

use actix_web::{get, App, HttpResponse, HttpServer, Responder};

#[get("/health")]
async fn health() -> impl Responder {
    println!("Health check");
    HttpResponse::Ok()
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .wrap(middleware::JwtVerificationMiddlewareFactory::default())
            .service(health)
    })
    .bind(("0.0.0.0", 10080))?
    .run()
    .await
}
