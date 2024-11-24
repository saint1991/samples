use actix_web::{get, web, App, HttpResponse, HttpServer, Responder};

#[get("/health")]
async fn health() -> impl Responder {
    HttpResponse::Ok()
}

#[get("/tasks/{task_id}/result")]
async fn hello(params: web::Path<String>) -> impl Responder {
    let task_id = params.into_inner();

    let host = hostname::get()
        .map(|name| name.to_string_lossy().to_owned().to_string())
        .unwrap_or_else(|_| String::from("unknown"));

    HttpResponse::Ok().body(format!("Hello {} from {}", task_id, host))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().service(hello))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}
