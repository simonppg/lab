# Workstation Bootstrap

The workstation bootstrap installs the tools required to manage the homelab.

## Purpose

The bootstrap process prepares a fresh Ubuntu workstation for homelab administration.

## Tools

- Git — source control
- Ansible — system configuration
- OpenTofu — infrastructure as code
- age — encryption
- SOPS — encrypted secrets

## Principles

- Bootstrap should be safe to run multiple times.
- Existing installations should not be unnecessarily replaced.
- Secrets must never be stored in plaintext in the repository.
- The bootstrap script is only responsible for preparing the management workstation.
- Ansible is responsible for ongoing workstation configuration.

## Usage

From the repository root:

```bash
./scripts/bootstrap.sh
