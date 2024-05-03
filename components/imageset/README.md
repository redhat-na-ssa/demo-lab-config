# Raw Notes

```sh
# run on registry-mirror.svc

# open port 5000 
firewall-cmd --add-port=5000/tcp --permanent
firewall-cmd --add-port=5000/tcp

# start registry
podman run -d \
  --name registry \
  -p 5000:5000 \
  -v $(pwd)/registry:/var/lib/registry:z \
  docker.io/library/registry:2
```

```sh
cp pull-secret.txt ${XDG_RUNTIME_DIR}/containers/auth.json

# run oc-mirror from scratch area
oc-mirror \
  --config ../components/imageset/imageset-config-all.yaml \
  --dest-use-http docker://registry-mirror.svc:5000/disconnected \
  --ignore-history --skip-metadata-check

# Error: Source image rejected: Invalid GPG signature
# see https://access.redhat.com/solutions/6542281
```

```sh
# disable default operatorhub catlog sources
oc patch OperatorHub cluster --type json -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'

cat < YAML | oc apply -f -
apiVersion: config.openshift.io/v1
kind: OperatorHub
metadata:
  annotations:
    capability.openshift.io/name: marketplace
    include.release.openshift.io/ibm-cloud-managed: 'true'
    include.release.openshift.io/self-managed-high-availability: 'true'
    include.release.openshift.io/single-node-developer: 'true'
    release.openshift.io/create-only: 'true'
  name: cluster
spec:
  sources:
    - disabled: true
      name: certified-operators
    - disabled: true
      name: community-operators
    - disabled: true
      name: redhat-marketplace
    - disabled: true
      name: redhat-operators
YAML

```

```sh
sed -n '/source:/{s/.*source://p}' imageContentSourcePolicy.yaml | sort -u > registry-list.txt
```
