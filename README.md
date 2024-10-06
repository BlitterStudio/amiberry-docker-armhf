# amiberry-docker-armhf

A Dockerfile which creates an image, with the requirements to cross-compile Amiberry for the `armhf` (32-bit) platform (e.g. Raspberry Pi).
The image is based on Debian:latest and includes all Amiberry dependencies (e.g. SDL2, SDL2-image, etc)

The full image is available on DockerHub: <https://hub.docker.com/repository/docker/midwan/amiberry-debian-armhf>

## Usage
`docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-armhf:latest`

Then you can proceed to compile Amiberry with the relevant toolchain, e.g. `cmake -DCMAKE_TOOLCHAIN_FILE=cmake/Toolchain-arm-linux-gnueabihf.cmake -B build && cmake --build build`
