# Raw Notes

```sh
cp pull-secret.txt ${XDG_RUNTIME_DIR}/containers/auth.json

# run oc-mirror from scratch area
oc-mirror \
  --config ../components/imageset/imageset-config-lab.yaml \
  --dest-use-http docker://172.29.172.84:5000/disconnected \
  --ignore-history --skip-metadata-check

# Error: Source image rejected: Invalid GPG signature
# see https://access.redhat.com/solutions/6542281
```

```sh
# disable default operatorhub catalog sources
oc patch OperatorHub cluster --type json -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'
```

```sh
sed -n '/source:/{s/.*source://p}' imageContentSourcePolicy.yaml | sort -u > registry-list.txt
```

## Links

- [Old Guide](https://www.redhat.com/en/blog/openshift-private-registry)
