#!/usr/bin/env bash

set -Eeuo pipefail

CERT_DIR="$(cd "$(dirname "$0")/../certificates" && pwd)"

TRUENAS_CERT="$CERT_DIR/truenas.crt"
TRUENAS_KEY="$CERT_DIR/private/truenas.key"

echo "==> Checking TrueNAS certificate/key files"

if [[ ! -f "$TRUENAS_CERT" ]]; then
    echo "ERROR: missing $TRUENAS_CERT"
    exit 1
fi

if [[ ! -f "$TRUENAS_KEY" ]]; then
    echo "ERROR: missing $TRUENAS_KEY"
    exit 1
fi

echo " OK: certificate and private key exist"

echo
echo "==> Comparing TrueNAS certificate and private key"

CERT_HASH="$(
    openssl x509 \
        -in "$TRUENAS_CERT" \
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
        -in "$TRUENAS_KEY" \
        -pubout \
        -outform DER |
    sha256sum |
    awk '{print $1}'
)"

if [[ "$CERT_HASH" != "$KEY_HASH" ]]; then
    echo "ERROR: TrueNAS certificate does not match private key"
    exit 1
fi

echo " OK: TrueNAS certificate matches private key"

echo
echo "Certificate/key validation successful."