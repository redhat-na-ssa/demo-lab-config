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

`ImageContentSourcePolicy` allows aliasing public container registries with disconnected environments. View docs [here](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.14/html/images/image-configuration#images-configuration-registry-mirror_image-configuration).

Example: [ImageContentSourcePolicy](images/ImageContentSourcePolicy.yaml)

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
# nvcr.io                         => container-proxy/docker-nvcr-remote
# quay.io                         => container-proxy/quay-docker-remote
# registry.access.redhat.com      => container-proxy/redhat-docker-remote

#
# authentication: yes
#
# you can login to the following registries with the pull-secret
# the login is base64 encoded in the auth field
# 
# quay.io/openshift-release-dev   => container-proxy/docker-openshift-private-remote
# registry.connect.redhat.com     => container-proxy/docker-openshift-redhat-connect-remote
# registry.redhat.io              => container-proxy/docker-redhat-registry-remote
```

## Recommendations

It may be helpful to rename the following registries to help avoid confusion and maintain consistency.

Example:

```sh
quay.io/openshift-release-dev   => container-proxy/docker-ocp-private-remote
registry.access.redhat.com      => container-proxy/docker-rh-access-remote?
registry.connect.redhat.com     => container-proxy/docker-rh-connect-remote?
registry.redhat.io              => container-proxy/docker-rh-io-remote?
```
