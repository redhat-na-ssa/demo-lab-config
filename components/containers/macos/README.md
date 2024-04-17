# oc-mirror container

On macOS, you can run a Red Hat container with oc-mirror that will allow you mirror images for disconnected registries.

```
# search for oc-mirror images
podman search registry.redhat.io/oc-mirror

# run the oc-mirror container - change the entrypoint
podman run -it --rm --name oc-mirror-0 --entrypoint bash registry.redhat.io/openshift4/oc-mirror-plugin-rhel9:latest

# from the container run oc-mirror command
oc-mirror
```