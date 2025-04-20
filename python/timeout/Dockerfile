FROM python:3.13.3-slim-bullseye

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /home
COPY . /home
RUN uv sync --frozen

ENTRYPOINT ["/bin/bash"]