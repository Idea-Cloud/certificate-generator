# Self-Signed Certificate generator

## Prerequisites
* Docker version > 19.03.6
* GNU Make > 4.2.1

## Setup (build image)
```bash
make build
```

## Generate certificates
```bash
DOMAIN=<my.domain.com> make generate
```
* Generated certificates will be in `cert` folder

## Clean
```bash
make clean
```

## Publish image (if you want)
```bash
TARGET_DOCKER_REGISTRY=<my.docker.registry> make publish
```
