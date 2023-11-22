#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="$1"
ENDPOINT="$2"
META="(endpoint=$ENDPOINT namespace=$NAMESPACE)"

main() {
    while ! get_statuses; do
        echo >&2 "... Waiting 10 seconds to check again"
        sleep 10
    done

    echo >&2
}

get_statuses() {
    status="$(kubectl -n "$NAMESPACE" get endpoints "$ENDPOINT" -ojsonpath='{..subsets[*].addresses[?(@.targetRef.kind=="Pod")]}')"

    if [ -z "$status" ]; then
        echo -n >&2 "INFO: endpoint isn't ready ($META)"
        return 1
    else
        echo -n >&2 "INFO: endpoint is ready ($META)"
    fi
}

main
