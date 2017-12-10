FROM scratch

COPY clock /clock

ENV GOROOT /usr/local/go
ADD https://github.com/golang/go/raw/master/lib/time/zoneinfo.zip /usr/local/go/lib/time/zoneinfo.zip

ENTRYPOINT ["/clock"]
