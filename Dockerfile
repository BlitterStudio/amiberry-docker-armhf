# Image with the requirements to build Amiberry for armhf (32-bit)
# Author: Dimitris Panokostas
#
# Usage: docker run --rm -it -v <path-to-amiberry-sources>:/build amiberry-debian-armhf:latest
#

ARG debian_release=latest
ARG sdl3_repo=https://github.com/libsdl-org/SDL.git
ARG sdl3_ref=release-3.2.x
ARG sdl3_image_repo=https://github.com/libsdl-org/SDL_image.git
ARG sdl3_image_ref=release-3.2.x
FROM debian:${debian_release}

ARG sdl3_repo
ARG sdl3_ref
ARG sdl3_image_repo
ARG sdl3_image_ref

LABEL maintainer="Dimitris Panokostas <midwan@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/midwan/amiberry-docker-armhf"
LABEL org.opencontainers.image.description="Build environment for Amiberry armhf (32-bit) on Debian"

RUN dpkg --add-architecture armhf \
    && apt-get update \
    && apt-get dist-upgrade -fuy \
    && apt-get install -y --no-install-recommends \
        autoconf ca-certificates git build-essential cmake file ninja-build pkgconf \
        gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
        libsdl2-dev:armhf libsdl2-ttf-dev:armhf libsdl2-image-dev:armhf \
        libpng-dev:armhf libflac-dev:armhf libmpg123-dev:armhf libmpeg2-4-dev:armhf \
        libserialport-dev:armhf libportmidi-dev:armhf libenet-dev:armhf \
        libpcap-dev:armhf libzstd-dev:armhf \
        libcurl4-openssl-dev:armhf nlohmann-json3-dev:armhf \
        libdbus-1-dev:armhf \
    && if ! apt-get install -y --no-install-recommends libsdl3-dev:armhf libsdl3-image-dev:armhf; then \
        sdl3_build_deps='libasound2-dev:armhf libdbus-1-dev:armhf libdrm-dev:armhf libegl1-mesa-dev:armhf libgbm-dev:armhf libgl1-mesa-dev:armhf libgles2-mesa-dev:armhf libglib2.0-dev:armhf libibus-1.0-dev:armhf libjpeg62-turbo-dev:armhf libpulse-dev:armhf libsamplerate0-dev:armhf libsndio-dev:armhf libtiff-dev:armhf libudev-dev:armhf libwayland-dev:armhf libwebp-dev:armhf libx11-dev:armhf libxcursor-dev:armhf libxext-dev:armhf libxfixes-dev:armhf libxi-dev:armhf libxinerama-dev:armhf libxkbcommon-dev:armhf libxrandr-dev:armhf libxrender-dev:armhf libxss-dev:armhf libxt-dev:armhf libxv-dev:armhf libxxf86vm-dev:armhf'; \
        for optional_pkg in libdecor-0-dev:armhf; do \
            if apt-cache show "$optional_pkg" > /dev/null 2>&1; then \
                sdl3_build_deps="$sdl3_build_deps $optional_pkg"; \
            fi; \
        done; \
        apt-get install -y --no-install-recommends $sdl3_build_deps; \
        printf '%s\n' \
            'set(CMAKE_SYSTEM_NAME Linux)' \
            'set(CMAKE_SYSTEM_PROCESSOR arm)' \
            'set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)' \
            'set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)' \
            'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)' \
            'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)' \
            'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)' \
            'set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)' \
            > /tmp/armhf-toolchain.cmake; \
        export PKG_CONFIG_PATH=/usr/local/lib/arm-linux-gnueabihf/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/arm-linux-gnueabihf/pkgconfig:/usr/share/pkgconfig; \
        export PKG_CONFIG_LIBDIR=$PKG_CONFIG_PATH; \
        git clone --depth 1 --branch ${sdl3_ref} ${sdl3_repo} /tmp/SDL; \
        cmake -S /tmp/SDL -B /tmp/SDL/build -G Ninja \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_TOOLCHAIN_FILE=/tmp/armhf-toolchain.cmake \
            -DCMAKE_INSTALL_PREFIX=/usr/local \
            -DCMAKE_INSTALL_LIBDIR=lib/arm-linux-gnueabihf \
            -DSDL_SHARED=ON \
            -DSDL_STATIC=OFF; \
        cmake --build /tmp/SDL/build; \
        cmake --install /tmp/SDL/build; \
        git clone --depth 1 --branch ${sdl3_image_ref} ${sdl3_image_repo} /tmp/SDL_image; \
        cmake -S /tmp/SDL_image -B /tmp/SDL_image/build -G Ninja \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_TOOLCHAIN_FILE=/tmp/armhf-toolchain.cmake \
            -DCMAKE_INSTALL_PREFIX=/usr/local \
            -DCMAKE_INSTALL_LIBDIR=lib/arm-linux-gnueabihf \
            -DSDLIMAGE_SAMPLES=OFF \
            -DSDLIMAGE_TESTS=OFF \
            -DSDLIMAGE_VENDORED=OFF; \
        cmake --build /tmp/SDL_image/build; \
        cmake --install /tmp/SDL_image/build; \
        rm -rf /tmp/SDL /tmp/SDL_image /tmp/armhf-toolchain.cmake; \
        ldconfig; \
    fi \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ENV ARCH=arm-linux-gnueabihf
ENV AS=${ARCH}-as
ENV CC=${ARCH}-gcc
ENV CXX=${ARCH}-g++
ENV STRIP=${ARCH}-strip
ENV PKG_CONFIG_PATH=/usr/local/lib/arm-linux-gnueabihf/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/arm-linux-gnueabihf/pkgconfig:/usr/share/pkgconfig
ENV PKG_CONFIG_LIBDIR=/usr/local/lib/arm-linux-gnueabihf/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/arm-linux-gnueabihf/pkgconfig:/usr/share/pkgconfig

CMD [ "bash" ]
