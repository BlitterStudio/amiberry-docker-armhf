# Image with the requirements to build Amiberry for armhf (32-bit)
# Author: Dimitris Panokostas
#
# Usage: docker run --rm -it -v <path-to-amiberry-sources>:/build amiberry-debian-armhf:latest
#

# If no arg is provided, default to latest
ARG debian_release=latest
FROM debian:${debian_release}

RUN dpkg --add-architecture armhf
RUN apt-get update && apt dist-upgrade -fuy && apt-get install -y autoconf git build-essential gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf g++-arm-linux-gnueabihf libsdl2-dev:armhf libsdl2-ttf-dev:armhf libsdl2-image-dev:armhf libpng-dev:armhf libflac-dev:armhf libmpg123-dev:armhf libmpeg2-4-dev:armhf libserialport-dev:armhf libportmidi-dev:armhf pkgconf:armhf

WORKDIR /build

ENV ARCH=arm-linux-gnueabihf
ENV AS=${ARCH}-as
ENV CC=${ARCH}-gcc
ENV CXX=${ARCH}-g++
ENV STRIP=${ARCH}-strip

CMD [ "bash"]
