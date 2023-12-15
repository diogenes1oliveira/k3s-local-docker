#!/bin/sh

if [ -n "${K3S_HTTP_PROXY:-}" ]; then
    echo >&2 "INFO: using HTTP proxy from \$K3S_HTTP_PROXY"
    export http_proxy="$K3S_HTTP_PROXY"
    export https_proxy="$K3S_HTTP_PROXY"
    export HTTP_PROXY="$K3S_HTTP_PROXY"
    export HTTPS_PROXY="$K3S_HTTP_PROXY"
fi

if [ -n "${K3S_NO_PROXY:-}" ]; then
    echo >&2 "INFO: using no proxy list from \$K3S_NO_PROXY"
    export no_proxy="$K3S_NO_PROXY"
    export NO_PROXY="$K3S_NO_PROXY"
fi
