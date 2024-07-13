FROM postgres:16.3-bullseye

RUN apt-get update -y \
 && apt-get install -y build-essential ca-certificates postgresql-server-dev-all

COPY udf.sql /docker-entrypoint-initdb.d

COPY error_safe.c /
COPY Makefile /
RUN make && make install
