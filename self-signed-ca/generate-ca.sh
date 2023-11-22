#!/usr/bin/env bash

set -euo pipefail

cd "$(realpath "$(dirname "$0")")"

if [ -f .secret/tls.crt ] && [ -f .secret/tls.key ]; then
    echo >&2 "INFO: CA files already exist, nothing to do"
    exit 0
fi

rm -rf .secret/tls.crt .secret/tls.key

openssl genrsa -out .secret/tls.key 2048
( yes '' || true ) | openssl req -x509 -new -nodes -key .secret/tls.key -sha256 -out .secret/tls.crt -config ./openssl.ca.cnf

echo >&2 "INFO: generated new CA"
