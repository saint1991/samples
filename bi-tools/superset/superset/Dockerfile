FROM amancevice/superset:0.20.4

USER root
RUN apt-get install -y wget

ENV DOCKERIZE_VERSION "v0.5.0"
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY superset_config.py.tmpl /tmp/superset_config.py.tmpl

USER superset
ENV PYTHONPATH "/home/superset"
ENTRYPOINT [ "dockerize", "-template", "/tmp/superset_config.py.tmpl:/home/superset/superset_config.py", "superset" ]
CMD ["runserver"]
