ARG BASE_IMAGE=golang:1.25.5-alpine

FROM ${BASE_IMAGE} AS local

WORKDIR /src

RUN mkdir -p /root/.aws

COPY ./aws.config /root/.aws/config

ENTRYPOINT [ "tail", "-f", "/dev/null" ]


FROM ${BASE_IMAGE} AS build

ARG BUILD_TARGET

WORKDIR /src/${BUILD_TARGET}

COPY ./src/${BUILD_TARGET} ./

RUN go mod tidy

RUN go build -a -o ./main


FROM alpine:3.23.3 AS prod

ARG BUILD_TARGET

WORKDIR /src

RUN apk update && \
apk add tzdata

RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN ls -1 /usr/share/zoneinfo/ | grep -vx Asia | xargs -I {} rm -r /usr/share/zoneinfo/{}

COPY --from=build /src/${BUILD_TARGET}/main ./

RUN chmod +x ./main
RUN adduser -D appuser
RUN chown -R appuser:appuser /src

USER appuser

ENTRYPOINT [ "./main" ]