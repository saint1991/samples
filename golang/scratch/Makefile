
IMAGE = clock:latest

.PHONY: build
build:
	GOOS=linux CGO_ENABLED=0 go build -a -o clock

.PHONY: docker
docker: build
	docker build -t $(IMAGE) .
