#!/usr/bin/env bash

set -euo pipefail

# go to repo root
cd "$(realpath "$(dirname "$0")")"
cd ..

CLUSTER_LOCAL_PATH="$(realpath "${CLUSTER_LOCAL_PATH:-./.local}")"
DOCKER_IO_MIRROR="${DOCKER_IO_MIRROR:-docker.io}"

docker run --rm -it \
    -v "$CLUSTER_LOCAL_PATH/etc/rancher:/app/etc/rancher" \
    -v "$CLUSTER_LOCAL_PATH/var/lib:/app/var/lib" \
    -v "$CLUSTER_LOCAL_PATH/run:/app/run" \
    -v "$CLUSTER_LOCAL_PATH/.secret/:/app/.secret/" \
    --entrypoint /bin/sh \
    --workdir /app \
    "$DOCKER_IO_MIRROR/library/python:3.9" \
    -c '
        set -eux
        rm -rf etc/rancher/* var/lib/* run/*
        rm -rf .secret/kubeconfig
    '
