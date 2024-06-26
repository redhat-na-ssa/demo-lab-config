# OpenShift Registries

- https://access.redhat.com/RegistryAuthentication

```sh
# OpenShift platform registries
quay.io/openshift-release-dev

# Red Hat operators
registry.redhat.io

# Certified Partner operators
registry.connect.redhat.com

# operator indexes
registry.redhat.io/redhat
```

## Disconnected Notes

`ImageContentSourcePolicy` allows images referenced by image digests in pods to be pulled from alternative mirrored repository locations. This is specifically useful to disconnected environments. Only image pull specifications that have an image digest will have this behavior applied to them - tags will continue to be pulled from the specified repository in the pull spec.

Using an `ImageContentSourcePolicy` (ICSP) object to configure repository mirroring is a deprecated feature. ICSP objects are being replaced by `ImageDigestMirrorSet` and `ImageTagMirrorSet` objects to configure repository mirroring.

View docs [here](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.14/html/images/image-configuration#images-configuration-registry-mirror_image-configuration).

Converting ICSPs see [here](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.14/html/images/image-configuration#images-configuration-registry-mirror-convert_image-configuration)

`ImageContentPolicy` is the same as above but you can allow mirrors to use tags to pull images. Pulling images by tag can potentially yield different images, depending on which endpoint we pull from. Forcing digest-pulls for mirrors avoids that issue.

Example: [ImageDigestMirrorSet](images/ImageDigestMirrorSet.yaml)
Example: [ImageTagMirrorSet](images/ImageTagMirrorSet.yaml)

```sh
# registries mapping translated from email
#
# ?   = need to confirm
# ??  = unknown
# container-proxy = FQDN for container registry
#
# PUBLIC                          => PASSTHROUGH
#
# authentication: no
#
# docker.io                       => container-proxy/docker-hub-perf
# gcr.io                          => container-proxy/gcr-io
# ghcr.io                         => container-proxy/docker-ghcr-io
# nvcr.io                         => container-proxy/docker-nvcr-remote
# quay.io                         => container-proxy/quay-docker-remote
# registry.access.redhat.com      => container-proxy/redhat-docker-remote
# registry.k8s.io                 => container-proxy/docker-kube-state-metrics

#
# authentication: yes
#
# you can login to the following registries with the pull-secret
# the login is base64 encoded in the auth field
# 
# quay.io/openshift-release-dev   => container-proxy/docker-openshift-private-remote
# registry.connect.redhat.com     => container-proxy/docker-openshift-redhat-connect-remote
# registry.redhat.io              => container-proxy/docker-openshift-rh-io-remote
```

```sh
# test tag list for each image
scripts/wip/tag_list.sh
```

## Recommendations

It may be helpful to rename the following registries to help avoid confusion and maintain consistency.

Example:

```sh
quay.io/openshift-release-dev   => container-proxy/docker-ocp-private-remote
registry.access.redhat.com      => container-proxy/docker-rh-access-remote
registry.connect.redhat.com     => container-proxy/docker-rh-connect-remote
registry.redhat.io              => container-proxy/docker-rh-io-remote
```
