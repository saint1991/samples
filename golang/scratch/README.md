# FROM scratch Docker sample to execute Go binary

## Build
```bash
$ make docker
```

## Run
```bash
$ docker run -p 8080:8080 clock
$ curl "localhost:8080/time?tz=Asia/Tokyo"                            
```