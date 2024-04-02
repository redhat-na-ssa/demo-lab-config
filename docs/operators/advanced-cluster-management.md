# advanced-cluster-management

Red Hat Advanced Cluster Management for Kubernetes provides the multicluster hub, a central management console for managing multiple Kubernetes-based clusters across data centers, public clouds, and private clouds. You can use the hub to create Red Hat OpenShift Container Platform clusters on selected providers, or import existing Kubernetes-based clusters. After the clusters are managed, you can set compliance requirements to ensure that the clusters maintain the specified security requirements. You can also deploy business applications across your clusters.

## How to install
Use of this Red Hat product requires a licensing and subscription agreement.

Install the Red Hat Advanced Cluster Management for Kubernetes operator by following instructions presented when you click the `Install` button. After installing the operator, create an instance of the `MultiClusterHub` resource to install the hub.

Note that if you will be using the hub to manage non-OpenShift 4.x clusters, you will need to create a Kubernetes `Secret` resource containing your OpenShift pull secret and specify this `Secret` in the `MultiClusterHub` resource, as described in the install documentation.
### Special considerations for disconnected network environments
If you are installing Red Hat Advanced Cluster Management for Kubernetes in a disconnected network environment, there are some special install and upgrade requirements.
#### Include multicluster engine for Kubernetes in mirrored catalog
Installing an OLM operator in a disconnected network environment involves the use of a local mirrored operator catalog and image registry. Red Hat Advanced Cluster Management for Kubernetes requires (and automatically installs) the multicluster engine for Kuberenetes operator so this operator package is needed in your local mirrored operator catalog in addition to the one for Red Hat Advanced Cluster Management for Kubernetes.

if you are using a full mirror of the Red Hat operators catalog, no special action is needed when creating the mirror catalog.

If you are using a filtered (rather than full) mirror of the OLM catalog, be sure to include both the `advanced-cluster-management` **and** `multicluster-engine` packages in your mirrored catalog when creating it.
#### Add annotation to MultiClusterHub resource
If you are installing or upgrading to a Red Hat Advanced Cluster Management for Kubernetes release prior to release 2.7, an `mce-subscription-spec` annotation is required in the instance of the `MultiClusterHub` resource you create to set up your hub. This annotation identifies the catalog source for your local mirrored operator catalog and is required when installing releases prior to release 2.7 regardless of whether your local mirrored operator catalog is a full mirror or a filtered one.

The `mce-subscription-spec` annotation is not usually needed, and thus can usually be omitted, when installing or upgrading to release 2.7 or a later release. Starting with release 2.7, the Red Hat Advanced Cluster Management for Kubernetes operator is able to automatically determine the catalog source to use in typical scenarios.

The following is an example of the `mce-subscription-spec` annotation:

```
 apiVersion: operator.open-cluster-management.io/v1
 kind: MultiClusterHub
 metadata:
 	annotations:
 		installer.open-cluster-management.io/mce-subscription-spec: '{"source": "my-catalog-source"}'
 spec: {}

```

Replace `my-catalog-source` with the name of your catalog source.

If you are creating the `MultiClusterHub` resource using the OperatorHub UI, switch to the YAML view for the resource in order to insert the annotation.
#### Upgrading from release 2.4
The special considerations described above also apply when upgrading from Red Hat Advanced Cluster Management for Kubernetes release 2.4.
- If you are using a filtered mirror catalog, update your catalog-building procedures to ensure that the `multicluster-engine` package is included in your mirror catalog.
- Before changing the update channel to trigger the update, edit your existing `MultiClusterHub` resource to add the `mce-subscription-spec` annotation as shown in the example above so that the upgraded version of the Red Hat Advanced Cluster Management for Kubernetes knows the correct catalog source to use to find the `multicluster-engine` package.
### Where to find more installation information
You can find additional installation guidance in the [install documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.9/html/install/installing). 