#!/usr/bin/env bash

set -Eeuo pipefail

CERT_DIR="$(cd "$(dirname "$0")/../certificates" && pwd)"

CA_CERT="$CERT_DIR/homelab-ca.crt"
CA_KEY="$CERT_DIR/private/homelab-ca.key"

echo "==> Checking CA certificate/key files"

if [[ ! -f "$CA_CERT" ]]; then
    echo "ERROR: missing $CA_CERT"
    exit 1
fi

if [[ ! -f "$CA_KEY" ]]; then
    echo "ERROR: missing $CA_KEY"
    exit 1
fi

echo " OK: CA certificate and private key exist"

echo
echo "==> Comparing CA certificate and private key"

CERT_HASH="$(
    openssl x509 \
        -in "$CA_CERT" \
        -pubkey \
        -noout |
    openssl pkey \
        -pubin \
        -outform DER |
    sha256sum |
    awk '{print $1}'
)"

KEY_HASH="$(
    openssl pkey \
        -in "$CA_KEY" \
        -pubout \
        -outform DER |
    sha256sum |
    awk '{print $1}'
)"

if [[ "$CERT_HASH" != "$KEY_HASH" ]]; then
    echo "ERROR: CA certificate does not match private key"
    exit 1
fi

echo " OK: CA certificate matches private key"

echo
echo "CA certificate/key validation successful."
