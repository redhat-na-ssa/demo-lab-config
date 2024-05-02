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
  -v $(pwd):/var/lib/registry \
  docker.io/library/registry:2
```

```sh
# run oc-mirror from scratch area
oc-mirror \
  --config ../components/imageset/example/imageset-config.yaml \
  --dest-use-http docker://registry-mirror.svc:5000/disconnected \
  --ignore-history --skip-metadata-check
```
