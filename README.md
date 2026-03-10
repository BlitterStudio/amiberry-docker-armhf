# amiberry-docker-armhf

A Dockerfile which creates an image with all requirements to cross-compile Amiberry for the `armhf` platform (e.g. Raspberry Pi 32-bit) on an x86_64 host.

The image is based on Debian and includes all Amiberry dependencies (e.g. SDL2, SDL2-image, SDL3, SDL3_image, etc). Supported Debian versions: `bookworm`, `trixie` (see tags below).

The full image is available on DockerHub: <https://hub.docker.com/repository/docker/midwan/amiberry-debian-armhf>

## Usage

To use the latest Trixie-based image:

```bash
docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-armhf:latest
```

To use a specific Debian version:

```bash
docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-armhf:bookworm

docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-armhf:trixie
```

Then you can proceed to compile Amiberry with the relevant toolchain file, e.g.:

```bash
cmake -DCMAKE_TOOLCHAIN_FILE=cmake/Toolchain-armhf-linux-gnu.cmake -B build && cmake --build build
```

## Building the image locally

To build the image yourself for a specific Debian release:

```bash
docker build --build-arg debian_release=bookworm -t amiberry-debian-armhf:bookworm .
```

## CI/CD

Images are automatically built and pushed to DockerHub via GitHub Actions on every push to `main` and on a daily schedule.
