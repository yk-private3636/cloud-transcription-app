ARG BASE_IMAGE=hashicorp/terraform:1.13.5

FROM ${BASE_IMAGE}

WORKDIR /opt/terraform/infra/envs

RUN apk update && \
    apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/*

RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN ls -1 /usr/share/zoneinfo/ | grep -vx Asia | xargs -I {} rm -r /usr/share/zoneinfo/{}

ENTRYPOINT [ "tail", "-f", "/dev/null" ]