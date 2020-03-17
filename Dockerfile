
# https://alpinelinux.org
# https://github.com/gliderlabs/docker-alpine
# https://hub.docker.com/_/alpine

FROM golang:alpine as base

RUN set -ex \
    && apk add --no-cache --virtual .fetch-deps \
    gcc libc-dev curl wrk make

RUN mkdir -p /go/src

COPY . /zeta

WORKDIR /zeta

RUN set -ex \
    && export GOPROXY=https://goproxy.io \
    && make update \
    && make build

FROM alpine

COPY --from=base /zeta/bin/zeta /bin/zeta

WORKDIR /

EXPOSE 3721

ENTRYPOINT [ "/bin/zeta" ]
