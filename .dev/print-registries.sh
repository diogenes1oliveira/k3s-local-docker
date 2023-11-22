#!/bin/sh

set -eu

if [ -n "${DOCKER_IO_MIRROR:-}" ]; then

cat <<EOF
mirrors:
  docker.io:
    endpoint:
      - https://$DOCKER_IO_MIRROR
  registry.k8s.io:
    endpoint:
      - https://$DOCKER_IO_MIRROR
  quay.io:
    endpoint:
      - https://$DOCKER_IO_MIRROR
configs:
  $DOCKER_IO_MIRROR:
    tls:
      insecure_skip_verify: true
  $CLUSTER_HOSTNAME:$DOCKER_REGISTRY_PORT:
    tls:
      insecure_skip_verify: true

EOF

else

cat <<EOF
configs:
  $CLUSTER_HOSTNAME:$DOCKER_REGISTRY_PORT:
    tls:
      insecure_skip_verify: true

EOF

fi