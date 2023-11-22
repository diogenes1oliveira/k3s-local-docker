#!/bin/sh

set -eu

while ! kubectl -n default get ns 2> /dev/null; do
    echo >&2 "INFO: cluster not ready yet, checking again in 5s"
    sleep 5
done
