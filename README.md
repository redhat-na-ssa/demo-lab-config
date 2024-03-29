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

## Development

The following cli tools will be useful:

- `bash`
- `git`
- `sops`
- `age`

`age` secrets

```
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

```
scripts/lint.sh
```
