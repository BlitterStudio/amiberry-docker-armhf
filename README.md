# amiberry-docker-armhf

A Dockerfile which creates an image, with the requirements to build Amiberry for the `armhf` (32-bit) platform (e.g. Raspberry Pi).
The image is based on Debian:latest and includes all Amiberry dependencies (e.g. SDL2, SDL2-image, etc)

No Dispmanx is supported in this image, only 32-bit SDL2 versions.

The full image is available on DockerHub: <https://hub.docker.com/repository/docker/midwan/amiberry-debian-armhf>

## Usage
`docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-armhf:latest`

Then you can proceed to compile Amiberry as usual, e.g. `make -j8 PLATFORM=rpi4-sdl2`
