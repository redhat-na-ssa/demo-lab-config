# multicluster-engine

Multicluster engine for Kubernetes provides the foundational components that are necessary for the centralized management of multiple Kubernetes-based clusters across data centers, public clouds, and private clouds. You can use the engine to create Red Hat OpenShift Container Platform clusters on selected providers, or import existing Kubernetes-based clusters. After the clusters are managed, you can use the APIs that are provided by the engine to distribute configuration based on placement policy. Placement policy is a significant part of creating sophisticated multicluster management applications because you can select the applicable clusters.
## Installing
Install the multicluster engine for Kubernetes operator by following instructions that display when you click the `Install` button. After installing the operator, create an instance of the `MultiClusterEngine` resource to install the engine components that provide the management APIs. Note: If you are using the engine to manage non-OpenShift Container Platform 4.x clusters, you need to create a Kubernetes `Secret` resource that contains your OpenShift Container Platform pull secret. Specify this `Secret` in the `MultiClusterEngine` resource, as described in the install documentation.
You can find additional installation guidance in the [documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.7/html/clusters/multicluster_engine_overview#mce-install-intro). 