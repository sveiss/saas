FROM debian:stretch-slim
LABEL maintainer="stephen@brokenbottle.net"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y libnss-ldap strace \
  && rm -rf /var/lib/apt/lists/*

COPY etc/* /etc/
