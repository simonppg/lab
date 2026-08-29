# Homelab

Infrastructure and configuration for my self-hosted homelab.

## Principles

- Git is the source of truth.
- Infrastructure is managed declaratively.
- Secrets are never committed to Git.
- Prefer open-source and self-hosted solutions.
- Changes should be reproducible from a clean machine.

## Architecture

Documentation will be maintained in `docs/`.

## Repository Structure

- `infrastructure/` — Infrastructure as Code
- `ansible/` — Operating-system and system configuration
- `kubernetes/` — Kubernetes manifests and configuration
- `scripts/` — Helper and bootstrap scripts
- `docs/` — Architecture and operational documentation 
