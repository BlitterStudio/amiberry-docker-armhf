# amiberry-docker-armhf

A Dockerfile which creates an image, with the requirements to build Amiberry for the `armhf` (32-bit) platform (e.g. Raspberry Pi).
No Dispmanx is supported in this image, only SDL2 versions.

The image is based on Debian:latest and includes all Amiberry dependencies (e.g. SDL2, SDL2-image, etc)
