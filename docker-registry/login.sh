#!/usr/bin/env bash

set -euo pipefail

export DOCKER_REGISTRY="$CLUSTER_HOSTNAME:$DOCKER_REGISTRY_PORT"

echo >&2 "INFO: getting Docker username"

DOCKER_USERNAME="$(
    kubectl -n docker-registry get secret cluster-docker-registry-pull \
        -o 'go-template={{ .data.DOCKER_USERNAME | base64decode }}'
)"

echo >&2 "INFO: getting Docker password"

DOCKER_PASSWORD="$(
    kubectl -n docker-registry get secret cluster-docker-registry-pull \
        -o 'go-template={{ .data.DOCKER_PASSWORD | base64decode }}'
)"

echo >&2 "INFO: logging to Docker registry $DOCKER_REGISTRY"
docker login -u "$DOCKER_USERNAME" "$DOCKER_REGISTRY" --password-stdin <<< "$DOCKER_PASSWORD"
