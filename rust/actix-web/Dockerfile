ARG RUST_VERSION=1.82

FROM rust:${RUST_VERSION}-slim-bookworm AS builder

COPY . /home/actix
WORKDIR /home/actix
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/home/actix/target \
    cargo build --release \
 && mkdir /dist \
 && cp /home/actix/target/release/actix /dist

 FROM debian:bookworm-slim

 COPY --from=builder /dist/actix /actix
 ENV RUST_LOG=info RUST_BACKTRACE=1

 ENTRYPOINT [ "/actix" ]