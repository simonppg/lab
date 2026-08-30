# Secrets Management

The homelab uses SOPS with age to encrypt secrets that are stored in Git.

The important rule is:

- **Public age key:** stored in `.sops.yaml` and safe to commit.
- **Private age key:** stored only on the management workstation and must never be committed.
- **Encrypted secrets:** can be committed to Git.
- **Plaintext secrets:** must never be committed to Git.

## Files

The private age identity is stored at:

    ~/.config/sops/age/keys.txt

The repository stores the public age recipient in:

    .sops.yaml

The SOPS configuration determines which files are encrypted and which age recipient is used.

## Initial Setup

This setup is required when configuring a new management workstation.

The private age key is created locally and must never be committed to the repository.

### 1. Create the age key directory

    mkdir -p ~/.config/sops/age
    chmod 700 ~/.config/sops/age

### 2. Generate the private key

    age-keygen -o ~/.config/sops/age/keys.txt

Set the correct permissions:

    chmod 600 ~/.config/sops/age/keys.txt

### 3. Get the public key

    age-keygen -y ~/.config/sops/age/keys.txt

This prints the public age recipient.

The output will look similar to:

    age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

The public key is safe to store in Git.

### 4. Configure SOPS

Add the public key to `.sops.yaml`.

For example:

    creation_rules:
      - path_regex: \.sops\.(yaml|yml|json|env)$
        age: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

If `.sops.yaml` already contains an age recipient, do not replace it unless you intentionally created a new age identity.

## Verify the Setup

After creating the age key and configuring `.sops.yaml`, run the SOPS test:

    ./scripts/test-sops.sh

The test verifies that:

- SOPS is installed.
- The age private key exists.
- The private key has the correct permissions.
- `.sops.yaml` exists.
- SOPS can encrypt a test secret.
- The encrypted data does not contain the plaintext.
- SOPS can decrypt the test secret.
- The decrypted value matches the original.

The test uses temporary files and does not create test secrets in the repository.

A successful test ends with:

    ========================================
    SOPS TEST PASSED
    ========================================

## Creating an Encrypted Secret

Create secrets using a filename that matches the SOPS rules in `.sops.yaml`.

For example:

    sops secrets/example.sops.yaml

SOPS will open the file for editing. When you save it, SOPS encrypts the contents automatically.

To create an encrypted file from an existing plaintext file:

    sops encrypt --output secrets/example.sops.yaml /path/to/example.yaml

The encrypted file can be committed to Git.

Never commit the original plaintext file.

## Decrypting a Secret

To view a decrypted secret:

    sops decrypt secrets/example.sops.yaml

The decrypted secret is printed to the terminal and is not written to disk.

Avoid redirecting decrypted secrets into files unless necessary.

If you create a plaintext file temporarily, remove it immediately after use.

## Key Safety

The private age key is stored at:

    ~/.config/sops/age/keys.txt

This file is required to decrypt your secrets and must remain private.

Never:

- Commit the private key to Git.
- Put the private key in the repository.
- Put the private key in `.sops.yaml`.
- Paste the private key into chat, tickets, or other shared locations.
- Store the private key in an unencrypted public location.

The public age key is safe to commit to the repository.

If the private key is lost, encrypted secrets cannot be decrypted using that identity.

Keep a secure backup of the private key.

## New Workstation

When setting up a new management workstation:

1. Clone the repository.
2. Run the bootstrap script:

       ./scripts/bootstrap.sh

3. Create or restore the private age key:

       ~/.config/sops/age/keys.txt

4. Set the correct permissions:

       chmod 600 ~/.config/sops/age/keys.txt

5. Verify SOPS:

       ./scripts/test-sops.sh

Do not generate a new age key if you already have an existing identity that must be able to decrypt the repository's secrets.

Restore your existing private key instead.

## If the Private Key Is Lost

If the private age key is lost, the encrypted secrets cannot be decrypted using that identity.

There is no password reset or recovery mechanism for the age private key.

Keep a secure backup of:

    ~/.config/sops/age/keys.txt

If you intentionally create a new age identity, add the new public key to `.sops.yaml` and re-encrypt the existing secrets for the new recipient.

Do not delete the old key from `.sops.yaml` until all existing secrets have been successfully re-encrypted and verified with the new identity.
