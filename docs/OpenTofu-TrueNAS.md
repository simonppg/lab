# TrueNAS + OpenTofu

## TLS

Generate the TrueNAS certificate with Ansible:

CN:  truenas.home.arpa
SAN: DNS:truenas.home.arpa, IP:192.168.1.232

Import `truenas.crt` + its private key into the TrueNAS GUI and select it as the GUI SSL certificate.

Verify:

openssl s_client -connect truenas.home.arpa:443 \
  -servername truenas.home.arpa </dev/null 2>/dev/null |
  openssl x509 -noout -subject -issuer -ext subjectAltName

The server certificate should be issued by `Home Lab Root CA`.

## Ubuntu CA trust

Install the CA certificate (`homelab-ca.crt`), not the server certificate:

sudo cp certificates/homelab-ca.crt \
  /usr/local/share/ca-certificates/homelab-ca.crt
sudo update-ca-certificates

Verify:

curl https://truenas.home.arpa/

It should successfully verify TLS.

## TrueNAS API token

Create an API key in the TrueNAS GUI and store it encrypted in:

secrets/truenas.sops.yaml

Example:

api_key: ENC[...]
username: ENC[...]

Export the values for OpenTofu:

export TF_VAR_truenas_url="https://truenas.home.arpa"

export TF_VAR_truenas_username="$(
  sops -d --extract '["username"]' ../secrets/truenas.sops.yaml
)"

export TF_VAR_truenas_api_key="$(
  sops -d --extract '["api_key"]' ../secrets/truenas.sops.yaml
)"

export TF_VAR_cinefilo_password="$(
  sops -d --extract '["cinefilo_password"]' ../secrets/truenas.sops.yaml
)"

OpenTofu automatically uses TF_VAR_* for matching variables.

Provider:

provider "truenas" {
  url      = var.truenas_url
  api_key  = var.truenas_api_key
  username = var.truenas_username
}

Run:

tofu init
tofu plan

## Import existing resources

Use data sources to discover existing infrastructure before managing it.

For example:

data "truenas_pools" "all" {}

The existing pool:

MyPool
ID: 1
Status: ONLINE
Path: /mnt/MyPool

Declare it as a resource:

resource "truenas_pool" "mypool" {
  name = "MyPool"
}

Import the existing pool instead of creating it:

tofu import truenas_pool.mypool 1

Then verify:

tofu plan

Expected:

No changes. Your infrastructure matches the configuration.

This confirms the existing TrueNAS resource is managed by OpenTofu without recreating it.

