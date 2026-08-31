#!/usr/bin/env bash

set -Eeuo pipefail

CERT_DIR="$(cd "$(dirname "$0")/../certificates" && pwd)"

CA_CERT="$CERT_DIR/homelab-ca.crt"
TRUENAS_CERT="$CERT_DIR/truenas.crt"

echo "==> Checking CA certificate usage"

CA_EXTENSIONS="$(
    openssl x509 \
        -in "$CA_CERT" \
        -noout \
        -text
)"

if ! grep -q "CA:TRUE" <<< "$CA_EXTENSIONS"; then
    echo "ERROR: CA certificate does not have CA:TRUE"
    exit 1
fi

echo " OK: CA:TRUE"

if ! grep -q "Certificate Sign" <<< "$CA_EXTENSIONS"; then
    echo "ERROR: CA certificate is missing Certificate Sign key usage"
    exit 1
fi

echo " OK: Certificate Sign key usage"

echo
echo "==> Checking TrueNAS certificate usage"

TRUENAS_EXTENSIONS="$(
    openssl x509 \
        -in "$TRUENAS_CERT" \
        -noout \
        -text
)"

if ! grep -q "CA:FALSE" <<< "$TRUENAS_EXTENSIONS"; then
    echo "ERROR: TrueNAS certificate does not have CA:FALSE"
    exit 1
fi

echo " OK: CA:FALSE"

if ! grep -q "TLS Web Server Authentication" <<< "$TRUENAS_EXTENSIONS"; then
    echo "ERROR: TrueNAS certificate is missing TLS Web Server Authentication"
    exit 1
fi

echo " OK: TLS Web Server Authentication"

echo
echo "Certificate usage validation successful."
