# Secrets Management

## Overview

The homelab uses SOPS with age for encrypted secrets that need to be stored in Git.

The age private key remains on the management workstation and is never committed to the repository.

## Components

### SOPS

SOPS encrypts secret values while allowing the encrypted files to remain in Git.

### age

age provides the encryption keys.

The public age key is stored in `.sops.yaml`.

The private age key is stored on the management workstation:

```text
~/.config/sops/age/keys.txt
