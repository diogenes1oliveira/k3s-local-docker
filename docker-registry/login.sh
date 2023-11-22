#!/usr/bin/env bash

set -euo pipefail

DOCKER_REGISTRY="$CLUSTER_HOSTNAME:$DOCKER_REGISTRY_PORT"

DOCKER_USERNAME="$(
    kubectl -n docker-registry get secret cluster-docker-registry-pull \
        -o 'go-template={{ .data.DOCKER_USERNAME | base64decode }}'
)"

DOCKER_PASSWORD="$(
    kubectl -n docker-registry get secret cluster-docker-registry-pull \
        -o 'go-template={{ .data.DOCKER_PASSWORD | base64decode }}'
)"

docker login -u "$DOCKER_USERNAME" "$DOCKER_REGISTRY" --password-stdin <<< "$DOCKER_PASSWORD"
