# MLflow

Install MLflow.

Do not use the `base` directory directly, as you will need to patch the `channel` based on the version of OpenShift you are using, or the version of the operator you want to use.

The current *overlays* available are for the following channels:

* [0.6.2](overlays/0.6.2)

## Usage

If you have cloned this repository, you can install MLflow based on the overlay of your choice by running from the root directory.

```
oc apply -k overlays/<channel>
```

Or, without cloning:

```
oc apply -k https://github.com/redhat-na-ssa/demo-lab-config/components/mlflow/overlays/<channel>
```

As part of a different overlay in your own GitOps repo:

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - https://github.com/redhat-na-ssa/demo-lab-config/components/mlflow/overlays/<<channel>?ref=main
```

## References

* [MLflow home page](https://mlflow.org)
* [AI on OpenShift how-to guide](https://ai-on-openshift.io/tools-and-applications/mlflow/mlflow/)