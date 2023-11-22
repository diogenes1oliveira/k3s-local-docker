#!/usr/bin/env bash

set -euo pipefail

# Check mkcert
if ! mkcert -version > /dev/null; then
    echo >&2 "ERROR: mkcert doesn't seem to be installed"
    exit 1
fi

# Check curl
if ! curl --version > /dev/null; then
    echo >&2 "ERROR: curl doesn't seem to be installed"
    exit 1
fi

# Get the CA to install
CA_PATH="${1:--}"
if [ "$CA_PATH" = '-' ]; then
    CA_CONTENT="$(cat)"
elif [ -f "$CA_PATH" ]; then
    CA_CONTENT="$(cat "$CA_PATH")"
elif [[ "$CA_PATH" = http://* ]] || [[ "$CA_PATH" = https://* ]]; then
    CA_CONTENT="$(curl -svf "$CA_PATH")"
else
    echo >&2 "ERROR: certificate '$CA_PATH' not found"
    exit 1
fi

# set $CAROOT to a temporary directory so it doesn't interfere with existing ones
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
export CAROOT="$TMPDIR"

# Finally, do install it
cat > "$CAROOT/rootCA.pem" <<<"$CA_CONTENT"
mkcert -install
