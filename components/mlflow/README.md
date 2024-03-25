# MLflow

Install MLflow.

Do not use the `base` directory directly, as you will need to patch the `channel` based on the version of OpenShift you are using, or the version of the operator you want to use.

The current *overlays* available are for the following channels:

* [0.6.2](overlays/0.6.2)

## Pre-requisites

* Install the "Crunchy Postgres for Kubernetes" operator, which is used to store the MLflow config. This can be manually installed from Operator Hub in OpenShift web console, or using a GitOps overlay such as [crunchy-postgres-operator](https://github.com/redhat-cop/gitops-catalog/tree/main/crunchy-postgres-operator).

## Usage

If you have cloned this repository, you can install MLflow based on the overlay of your choice by running from the root directory.

```sh
oc apply -k overlays/<channel>
```

Or, without cloning:

```sh
oc apply -k https://github.com/redhat-na-ssa/demo-lab-config/components/mlflow/overlays/<channel>
```

As part of a different overlay in your own GitOps repo:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - https://github.com/redhat-na-ssa/demo-lab-config/components/mlflow/overlays/<<channel>?ref=main
```
### Configuration

Define the following in the OpenShift namespace:

```yaml
kind: Secret
apiVersion: v1
metadata:
  name: mlflow-server
  namespace: mlflow
data:
  AWS_ACCESS_KEY_ID: ''
  AWS_SECRET_ACCESS_KEY: ''
type: Opaque
```

and

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: mlflow-server
  namespace: mlflow
immutable: false
data:
  BUCKET_NAME: ''
  S3_ENDPOINT_URL: ''
```

### Utilizing MLFlow from Outside the Cluster with OAuth

When accessing MLFlow from outside of the cluster with OAuth enabled, the route is secured by an OpenShift OAuth Proxy.  This OAuth proxy by default will only allow users to access MLFlow using the UI. 

If you wish to run training processes from outside of the cluster that write to MLFlow you must set `enableBearerTokenAccess: true`.  This option requires additional permissions to be granted to the MLFlow Service Account which requires cluster admin privileges.

Once this option is enabled you can set the following environment variable in your training environment and MLFlow will automatically pass your Bearer Token to the OpenShift OAuth Proxy and authenticate any API calls MLFlow makes to the server.

```
MLFLOW_TRACKING_TOKEN
```

To retrieve your token from openshift run the following command:

```sh
oc whoami --show-token
```

### Demonstration Code

* [Credit Card Fraud App](https://ai-on-openshift.io/demos/credit-card-fraud-detection-mlflow/credit-card-fraud/) which uses MLflow to track and store experiments
* [sklearn-wine](https://github.com/strangiato/mlflow-server/blob/main/examples/sklearn-wine/train.ipynb) that shows a Jupyter notebook containing code to interact with MLflow for model tracking
* Example of A[MLflow logging in YOLOv8 training workflow](https://github.com/ultralytics/ultralytics/issues/8134#issuecomment-1938006808)

## References

* [MLflow home page](https://mlflow.org)
* [AI on OpenShift how-to guide](https://ai-on-openshift.io/tools-and-applications/mlflow/mlflow/)
* MLflow container [source code](https://github.com/strangiato/mlflow-server/)