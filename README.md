# tquin/ansible

## Requirements

When you clone this repo, you need to add a few things manually:
* A `vault.key` file in the root of the repo. This allows decryption of the `secrets.yaml` file.

Run the below to install all of the third-party dependencies from Galaxy:
```
ansible-galaxy install -r requirements.yaml
```