# Notes

## ACM Links

- https://role.rhu.redhat.com/rol-rhu/app/courses/do480-2.4/pages/ch08s04
- https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-acs-operator-central.yaml
- https://github.com/open-cluster-management-io/policy-collection/tree/main/community/CM-Configuration-Management

## Security Related Links

- https://docs.openshift.com/container-platform/4.14/security/index.html
- https://docs.openshift.com/container-platform/4.14/security/compliance_operator/co-overview.html

## List of Container Images

Run the following to regenerate the following lists into `scratch/mirror_media`

```sh
./scripts/wip/image_list.sh

cp scratch/mirror_media/*.txt docs/images/
```

- [OpenShift Platform Images](images/imageset-config-ocp-images.txt)
- [Operators - Red Hat Supported](images/imageset-config-redhat-images.txt)
- [Operators - Red Hat Certified Partners / Nvidia](images/imageset-config-certified-images.txt)
- [Run.ai](images/imageset-config-runai-images.txt)
