#!/usr/bin/env bash

set -Eeuo pipefail

CERT_DIR="$(cd "$(dirname "$0")/../certificates" && pwd)"

CA_CERT="$CERT_DIR/homelab-ca.crt"
TRUENAS_CERT="$CERT_DIR/truenas.crt"

echo "==> Checking certificate files"

if [[ ! -f "$CA_CERT" ]]; then
    echo "ERROR: missing $CA_CERT"
    exit 1
fi

if [[ ! -f "$TRUENAS_CERT" ]]; then
    echo "ERROR: missing $TRUENAS_CERT"
    exit 1
fi

echo " OK: certificate files exist"

echo
echo "==> Checking CA certificate"

if ! openssl x509 \
    -in "$CA_CERT" \
    -noout \
    -subject \
    -issuer \
    -dates
then
    echo "ERROR: invalid CA certificate"
    exit 1
fi

echo " OK: CA certificate"

echo
echo "==> Checking TrueNAS certificate"

if ! openssl x509 \
    -in "$TRUENAS_CERT" \
    -noout \
    -subject \
    -issuer \
    -dates
then
    echo "ERROR: invalid TrueNAS certificate"
    exit 1
fi

echo " OK: TrueNAS certificate"

echo
echo "==> Checking certificate chain"

if ! openssl verify \
    -CAfile "$CA_CERT" \
    "$TRUENAS_CERT"
then
    echo "ERROR: certificate chain is invalid"
    exit 1
fi

echo " OK: certificate chain"

echo
echo "==> Checking TrueNAS SANs"

SAN_FILE="$(mktemp)"
trap 'rm -f "$SAN_FILE"' EXIT

if ! openssl x509 \
    -in "$TRUENAS_CERT" \
    -noout \
    -ext subjectAltName \
    > "$SAN_FILE"
then
    echo "ERROR: unable to read SANs"
    exit 1
fi

cat "$SAN_FILE"

if ! grep -Fq "DNS:truenas.home.arpa" "$SAN_FILE"; then
    echo "ERROR: missing DNS SAN: truenas.home.arpa"
    exit 1
fi

echo " OK: DNS:truenas.home.arpa"

if ! grep -Fq "IP Address:192.168.1.232" "$SAN_FILE"; then
    echo "ERROR: missing IP SAN: 192.168.1.232"
    exit 1
fi

echo " OK: IP Address:192.168.1.232"

echo
echo "Certificate validation successful."