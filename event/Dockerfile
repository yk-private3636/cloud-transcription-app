ARG IMAGE=golang:1.25.4-alpine

FROM ${IMAGE} AS dev

WORKDIR /src

ENTRYPOINT [ "tail", "-f", "/dev/null" ]


FROM ${IMAGE} AS build

ARG BUILD_TARGET

WORKDIR /src/${BUILD_TARGET}

COPY ./src/${BUILD_TARGET} ./

RUN go mod tidy

RUN go build -a -o ./main


# FROM busybox:1.37.0 AS prod
FROM ${IMAGE} AS prod

ARG BUILD_TARGET

WORKDIR /src

COPY --from=build /src/${BUILD_TARGET}/main ./

ENTRYPOINT [ "./main" ]