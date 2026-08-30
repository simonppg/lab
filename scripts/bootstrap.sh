#!/usr/bin/env bash

set -euo pipefail

echo "==> Updating package lists"
sudo apt update

echo "==> Installing base packages"
sudo apt install -y \
    curl \
    wget \
    gnupg \
    git \
    age \
    python3 \
    python3-venv \
    pipx \
    jq \
    unzip \
    software-properties-common

echo "==> Installing Ansible"
if ! command -v ansible >/dev/null 2>&1; then
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
else
    echo "Ansible already installed: $(ansible --version | head -n 1)"
fi

echo "==> Installing OpenTofu"
if ! command -v tofu >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -fsSL \
        https://get.opentofu.org/install-opentofu.sh \
        -o /tmp/install-opentofu.sh

    chmod +x /tmp/install-opentofu.sh

    sudo /tmp/install-opentofu.sh --install-method deb

    rm -f /tmp/install-opentofu.sh
else
    echo "OpenTofu already installed: $(tofu version | head -n 1)"
fi

echo "==> Installing SOPS"
if ! command -v sops >/dev/null 2>&1; then
    SOPS_VERSION="$(curl -fsSL https://api.github.com/repos/getsops/sops/releases/latest | jq -r '.tag_name')"

    curl -fsSL \
        "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64" \
        -o /tmp/sops

    sudo install -m 0755 /tmp/sops /usr/local/bin/sops

    rm -f /tmp/sops
else
    echo "SOPS already installed: $(sops --version | head -n 1)"
fi

echo
echo "==> Bootstrap complete"
echo

echo "Git:"
git --version

echo
echo "Ansible:"
ansible --version | head -n 1

echo
echo "OpenTofu:"
tofu version | head -n 1

echo
echo "SOPS:"
sops --version | head -n 1

echo
echo "age:"
age --version
