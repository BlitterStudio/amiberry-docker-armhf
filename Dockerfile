# Image with the requirements to build Amiberry for armhf (32-bit)
# Author: Dimitris Panokostas
#
# Usage: docker run --rm -it -v <path-to-amiberry-sources>:/build amiberry-debian-armhf:latest
#

ARG debian_release=latest
FROM debian:${debian_release}

LABEL maintainer="Dimitris Panokostas <midwan@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/midwan/amiberry-docker-armhf"
LABEL org.opencontainers.image.description="Build environment for Amiberry armhf (32-bit) on Debian"

RUN dpkg --add-architecture armhf \
    && apt-get update \
    && apt-get dist-upgrade -fuy \
    && apt-get install -y --no-install-recommends \
        autoconf git build-essential cmake ninja-build \
        gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
        libsdl2-dev:armhf libsdl2-ttf-dev:armhf libsdl2-image-dev:armhf \
        libpng-dev:armhf libflac-dev:armhf libmpg123-dev:armhf libmpeg2-4-dev:armhf \
        libserialport-dev:armhf libportmidi-dev:armhf libenet-dev:armhf \
        pkgconf:armhf libpcap-dev:armhf libzstd-dev:armhf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ENV ARCH=arm-linux-gnueabihf
ENV AS=${ARCH}-as
ENV CC=${ARCH}-gcc
ENV CXX=${ARCH}-g++
ENV STRIP=${ARCH}-strip

CMD [ "bash" ]
