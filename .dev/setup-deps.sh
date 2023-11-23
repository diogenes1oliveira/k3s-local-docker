#!/usr/bin/env bash

set -euo pipefail

if [ -n "${K3S_HTTP_PROXY:-}" ]; then
    export http_proxy="$K3S_HTTP_PROXY"
    export https_proxy="$K3S_HTTP_PROXY"
    export HTTP_PROXY="$K3S_HTTP_PROXY"
    export HTTPS_PROXY="$K3S_HTTP_PROXY"
fi

if [ -n "${K3S_NO_PROXY:-}" ]; then
    export no_proxy="$K3S_NO_PROXY"
    export NO_PROXY="$K3S_NO_PROXY"
fi

OUTPUT="${1:-}"

if ! [ -d "$OUTPUT" ]; then
    echo >&2 "ERROR: '$OUTPUT' is not a directory"
    exit 1
fi

cd "$OUTPUT"

curl -fLv https://github.com/helmfile/helmfile/releases/download/v0.158.1/helmfile_0.158.1_linux_amd64.tar.gz | tar xzv helmfile
curl -fLv https://get.helm.sh/helm-v3.13.2-linux-amd64.tar.gz | tar xzv --strip-components=1 linux-amd64/helm
curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl"

chmod +x helmfile helm kubectl

helmfile init
