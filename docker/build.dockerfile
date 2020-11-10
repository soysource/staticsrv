FROM golang:1.15-alpine
RUN apk update && \
    apk --no-cache add \
        ca-certificates \
        tzdata \
        git \
        upx

ENV CGO_ENABLED "0"
ENV GO_OUT "/build/staticsrv"
ENV GO_IN "/repo"

COPY . ${GO_IN}
WORKDIR ${GO_IN}
RUN /repo/docker/build.sh

FROM alpine:latest
RUN apk update && \
    apk --no-cache add \
	ca-certificates \
	tzdata

WORKDIR /
COPY --from=0 /build/staticsrv /bin/staticsrv
RUN mkdir -p /srv/www

ONBUILD WORKDIR /srv/www
ONBUILD EXPOSE 8080:8080
ONBUILD EXPOSE 9090:9090
ONBUILD CMD ["/bin/staticsrv", "-enable-metrics"]