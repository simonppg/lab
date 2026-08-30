#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

KEY_FILE="$HOME/.config/sops/age/keys.txt"
SOPS_CONFIG="$REPO_ROOT/.sops.yaml"
TEST_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TEST_DIR"
}

trap cleanup EXIT

echo "==> Checking SOPS installation"

if ! command -v sops >/dev/null 2>&1; then
    echo "ERROR: SOPS is not installed."
    exit 1
fi

echo "    $(sops --version | head -n 1)"

echo
echo "==> Checking age private key"

if [[ ! -f "$KEY_FILE" ]]; then
    echo "ERROR: age private key not found:"
    echo "       $KEY_FILE"
    exit 1
fi

if [[ "$(stat -c '%a' "$KEY_FILE")" != "600" ]]; then
    echo "ERROR: age private key permissions should be 600:"
    echo "       $KEY_FILE"
    exit 1
fi

echo "    Key exists with correct permissions."

echo
echo "==> Checking SOPS configuration"

if [[ ! -f "$SOPS_CONFIG" ]]; then
    echo "ERROR: .sops.yaml not found:"
    echo "       $SOPS_CONFIG"
    exit 1
fi

echo "    Found $SOPS_CONFIG"

echo
echo "==> Creating temporary test secret"

PLAINTEXT="$TEST_DIR/test.sops.yaml"
ENCRYPTED="$TEST_DIR/test.encrypted.sops.yaml"

cat > "$PLAINTEXT" <<'EOF'
test_secret: homelab-sops-test
EOF

echo "    Temporary test directory:"
echo "    $TEST_DIR"

echo
echo "==> Encrypting test secret"

sops encrypt "$PLAINTEXT" > "$ENCRYPTED"

echo "    Encryption successful."

echo
echo "==> Checking that plaintext is not present"

if grep -q "homelab-sops-test" "$ENCRYPTED"; then
    echo "ERROR: plaintext secret was found in encrypted output."
    exit 1
fi

echo "    Plaintext is not present."

echo
echo "==> Decrypting test secret"

DECRYPTED="$(sops decrypt "$ENCRYPTED")"

EXPECTED="homelab-sops-test"
ACTUAL="$(printf '%s\n' "$DECRYPTED" | sed -n 's/^test_secret: *//p' | tr -d '"' | xargs)"

if [[ "$ACTUAL" != "$EXPECTED" ]]; then
    echo "ERROR: decrypted value does not match expected value."
    echo
    echo "Expected: $EXPECTED"
    echo "Received: $ACTUAL"
    exit 1
fi

echo "    Decryption successful."

echo
echo "========================================"
echo "SOPS TEST PASSED"
echo "========================================"
echo
echo "SOPS can:"
echo "  ✓ access the age private key"
echo "  ✓ read .sops.yaml"
echo "  ✓ encrypt secrets"
echo "  ✓ keep plaintext out of encrypted files"
echo "  ✓ decrypt secrets"
echo "  ✓ recover the original secret"
echo
echo "No test files were created in the repository."
