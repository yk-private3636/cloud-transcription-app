ARG BASE_IMAGE=golang:1.25.5-alpine

FROM ${BASE_IMAGE} AS dev

WORKDIR /src

ENTRYPOINT [ "tail", "-f", "/dev/null" ]


FROM ${BASE_IMAGE} AS build

ARG BUILD_TARGET

WORKDIR /src/${BUILD_TARGET}

COPY ./src/${BUILD_TARGET} ./

RUN go mod tidy

RUN go build -a -o ./main


# FROM busybox:1.37.0 AS prod
FROM ${BASE_IMAGE} AS prod

ARG BUILD_TARGET

WORKDIR /src

COPY --from=build /src/${BUILD_TARGET}/main ./

RUN chmod +x ./main
RUN adduser -D appuser
RUN chown -R appuser:appuser /src

USER appuser

ENTRYPOINT [ "./main" ]