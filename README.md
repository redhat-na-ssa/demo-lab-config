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

## Repo Structure
```
.
├── bootstrap                             # used to for initial provisioning
├── clusters                              # used to define a running configuration
├── components                            # configurations in Kustomize and YAML
├── demo                                  # install and prepare for demo of software
│   ├── 00-cluster-one-time
│   ├── 01-cluster-rbac
│   ├── 02-cluster-storage
│   ├── 03-cluster-config
│   ├── run-acm
│   ├── run-acs
│   ├── run-devspaces
│   ├── run-kubeflow
│   ├── run-mlflow
│   └── run-tests
├── docs                                  # various documentation, software groups
│   ├── images
│   └── operators
├── notebooks                             # notebooks to demo software
├── scratch                               # excluded from git
└── scripts                               # scripts to automate, list list-images.sh
```