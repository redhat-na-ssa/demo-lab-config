# devworkspace-operator

The DevWorkspace Operator enables cluster-level support for the
[Devfile 2.0 spec](https://docs.devfile.io), enabling static, reproducible
configurations for launching cloud-based editors and IDEs in OpenShift and
Kubernetes clusters.

Leveraging the language server protocol and the Eclipse Theia web IDE, the
DevWorkspace operator provides easy configuration of full development
environments on the cloud with support for a wide variety of languages and
technologies, including Go, Java, Typescript/Javascript, Python, and more.

The DevWorkspace Operator is also used in the Web Terminal Operator to
automatically provision Web Terminal environments.

## Installing the operator
The DevWorkspace Operator can be installed directly from the OperatorHub UI and
will be available in all namespaces on the cluster. DevWorkspace creation is
driven by the DevWorkspace custom resource, which can be created in any
namespace to provision a full development environment. To get started, browse
the DevWorkspace [spec](https://docs.devfile.io/devfile/2.1.0/user-guide/api-reference.html).

Once a DevWorkspace is started, it can be accessed via the URL in its
`.status.mainUrl` field.

It's recommended to install the DevWorkspace Operator to the
`openshift-operators` namespace for compatibility.

## Uninstalling the operator
The DevWorkspace Operator utilizes finalizers on resources it creates and
webhooks to restrict access to development resources. As a result, manual steps
are required in uninstalling the operator. See the
[documentation](https://github.com/devfile/devworkspace-operator/blob/main/docs/uninstall.md)
for details.
