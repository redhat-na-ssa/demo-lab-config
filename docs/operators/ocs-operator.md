# ocs-operator

**Red Hat OpenShift Container Storage** deploys three operators.

### OpenShift Container Storage operator

The OpenShift Container Storage operator is the primary operator for OpenShift Container Storage. It serves to facilitate the other operators in OpenShift Container Storage by performing administrative tasks outside their scope as well as watching and configuring their CustomResources.

### Rook

[Rook][1] deploys and manages Ceph on OpenShift, which provides block and file storage.

# Core Capabilities

* **Self-managing service:** No matter which supported storage technologies you choose, OpenShift Container Storage ensures that resources can be deployed and managed automatically.

* **Hyper-scale or hyper-converged:** With OpenShift Container Storage you can either build dedicated storage clusters or hyper-converged clusters where your apps run alongside storage.

* **File, Block, and Object provided by OpenShift Container Storage:** OpenShift Container Storage integrates Ceph with multiple storage presentations including object storage (compatible with S3), block storage, and POSIX-compliant shared file system.

* **Your data, protected:** OpenShift Container Storage efficiently distributes and replicates your data across your cluster to minimize the risk of data loss. With snapshots, cloning, and versioning, no more losing sleep over your data.

* **Elastic storage in your datacenter:** Scale is now possible in your datacenter. Get started with a few terabytes, and easily scale up.

* **Simplified data management:** Easily create hybrid and multi-cloud data storage for your workloads, using a single namespace.

[1]: https://rook.io
