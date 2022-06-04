# Image with the requirements to build Amiberry for armhf (32-bit)
# Author: Dimitris Panokostas
# Version: 1.0
# Date: 2022-06-04
#
# Usage: docker run --rm -it -v <path-to-amiberry-sources>:/build amiberry-docker-armhf:latest
#
FROM debian:latest

RUN dpkg --add-architecture armhf
RUN apt-get update && apt-get install -y autoconf git build-essential gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf g++-arm-linux-gnueabihf libsdl2-dev:armhf libsdl2-ttf-dev:armhf libsdl2-image-dev:armhf libpng-dev:armhf libflac-dev:armhf libmpg123-dev:armhf libmpeg2-4-dev:armhf

WORKDIR /build

ENV ARCH=arm-linux-gnueabihf
ENV AS=${ARCH}-as
ENV CC=${ARCH}-gcc
ENV CXX=${ARCH}-g++
ENV STRIP=${ARCH}-strip

CMD [ "bash"]