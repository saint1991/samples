FROM postgres:16.10-trixie AS pg

# Install build dependencies
RUN apt-get update -y \
 && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    libssl-dev \
    pkg-config \
    postgresql-server-dev-16 \
 && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Build and install pg_parquet
ENV CARGO_PGRX_VERSION=0.16.0
ENV PG_MAJOR=16

RUN cargo install --locked cargo-pgrx@"${CARGO_PGRX_VERSION}"

RUN git clone https://github.com/CrunchyData/pg_parquet.git /tmp/pg_parquet \
 && cd /tmp/pg_parquet \
 && cargo pgrx init --pg"${PG_MAJOR}" $(which pg_config) \
 && cargo pgrx install --release --features pg"${PG_MAJOR}" \
 && cd / \
 && rm -rf /tmp/pg_parquet 

COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg-parquet-init.sql /docker-entrypoint-initdb.d/01-pg-parquet-init.sql

# Copy initialization scripts
# COPY udf.sql /docker-entrypoint-initdb.d/01-udf.sql
# COPY parquet_init.sql /docker-entrypoint-initdb.d/02-parquet.sql

# Build and install custom UDF
# COPY error_safe.c /
# COPY Makefile /
# RUN make && make install && rm error_safe.c Makefile
