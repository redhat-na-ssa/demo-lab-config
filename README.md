# Dell Lab Demo

[![Check Spelling](https://github.com/redhat-na-ssa/demo-lab-config/actions/workflows/spellcheck.yaml/badge.svg)](https://github.com/redhat-na-ssa/demo-lab-config/actions/workflows/spellcheck.yaml)

[![Linting](https://github.com/redhat-na-ssa/demo-lab-config/actions/workflows/linting.yaml/badge.svg)](https://github.com/redhat-na-ssa/demo-lab-config/actions/workflows/linting.yaml)

## Summary

This repo contains artifacts for deploying Dell lab Hardware.

This repo aids in the deployment of operators for day 2 operations and uses:

- [Kustomize](https://kustomize.io/)
- [Helm](https://helm.sh/)

This is often used in the following tools:

- ArgoCD
- `kubectl apply -k`
- `oc apply -k`

## General Notes

- [Notes](docs)

## Various Commands

Setup cluster users

```sh
. scripts/wip/setup_user.sh

htpasswd_get_file
ocp_setup_user
```

## Development

The following cli tools will be useful:

- `bash`
- `git`
- `sops`
- `age`

`age` secrets

```sh
# encrypt
age --encrypt --armor \
  -R authorized_keys \
  -o htpasswd.age \
  scratch/htpasswd

# decrypt
age --decrypt \
  -i ~/.ssh/id_ed25519 \
  -i ~/.ssh/id_rsa \
  -o scratch/htpasswd \
  htpasswd.age
```

```sh
scripts/lint.sh
```
