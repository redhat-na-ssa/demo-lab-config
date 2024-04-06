# Notes

## List of Container Images

Operational Examples

- [All for Disconnected](images/imageset-config-all.txt) - [[ImageSet Config](../components/imageset/imageset-config-all.yaml)]
- [OpensShift Upgrade - 4.13 to 4.14 (Platform Only)](images/imageset-config-ocp-upgrade-images.txt) - [[ImageSet Config](../components/imageset/imageset-config-ocp-upgrade.yaml)]

Grouped Components

- [OpenShift - Platform](images/imageset-config-ocp-images.txt) - [[ImageSet Config](../components/imageset/imageset-config-ocp.yaml)]
- [Operators - Red Hat Supported](images/imageset-config-redhat-images.txt) - [[ImageSet Config](../components/imageset/imageset-config-redhat.yaml)]
- [Operators - Red Hat Certified Partners / Nvidia](images/imageset-config-certified-images.txt) - [[ImageSet Config](../components/imageset/imageset-config-certified.yaml)]
- [Run.ai - Platform](images/imageset-config-runai-images.txt) - [[ImageSet Config](../components/imageset/imageset-config-runai.yaml)]

Regenerate the lists above into `scratch/mirror_media` using the following command:

```sh
./scripts/wip/image_list.sh
cp scratch/mirror_media/*images.txt docs/images/
```

## ACM Links

- https://role.rhu.redhat.com/rol-rhu/app/courses/do480-2.4/pages/ch08s04
- https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-acs-operator-central.yaml
- https://github.com/open-cluster-management-io/policy-collection/tree/main/community/CM-Configuration-Management

## Security Related Links

- https://docs.openshift.com/container-platform/4.14/security/index.html
- https://docs.openshift.com/container-platform/4.14/security/compliance_operator/co-overview.html
