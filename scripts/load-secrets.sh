#!/usr/bin/env bash

SECRETS_DIR="secrets"

# TrueNAS
export TF_VAR_truenas_url="https://truenas.home.arpa"
export TF_VAR_truenas_username="$(
  sops -d --extract '["username"]' "$SECRETS_DIR/truenas.sops.yaml"
)"
export TF_VAR_truenas_api_key="$(
  sops -d --extract '["api_key"]' "$SECRETS_DIR/truenas.sops.yaml"
)"
export TF_VAR_cinefilo_password="$(
  sops -d --extract '["cinefilo_password"]' "$SECRETS_DIR/truenas.sops.yaml"
)"
export TF_VAR_truenas_ip="$(
  sops -d --extract '["truenas_ip"]' "$SECRETS_DIR/truenas.sops.yaml"
)"

# BBB
export TF_VAR_bbb_username="$(
  sops -d --extract '["username"]' "$SECRETS_DIR/bbb.sops.yaml"
)"
export TF_VAR_bbb_password="$(
  sops -d --extract '["password"]' "$SECRETS_DIR/bbb.sops.yaml"
)"
export TF_VAR_pihole_ip="$(
  sops -d --extract '["pihole_ip"]' "$SECRETS_DIR/bbb.sops.yaml"
)"
export TF_VAR_pihole_api_password="$(
  sops -d --extract '["pihole_api_password"]' "$SECRETS_DIR/bbb.sops.yaml"
)"

echo "Environment loaded."

# Validate that all expected variables are set
env | grep '^TF_VAR_' | sed 's/=.*$/=<set>/'