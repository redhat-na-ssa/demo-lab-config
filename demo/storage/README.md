# Post Bootstrap Notes

Default Storage Class

```
oc annotate sc ocs-storagecluster-cephfs storageclass.kubernetes.io/is-default-class="true"
```

Setup image registry

```
# check storage class
oc get sc

# setup registry operator
oc patch configs.imageregistry.operator.openshift.io/cluster --type=merge -p '{"spec":{"rolloutStrategy":"RollingUpdate","replicas":2}}'
oc patch configs.imageregistry.operator.openshift.io cluster --type merge -p '{"spec":{"managementState":"Managed"}}'
oc patch configs.imageregistry.operator.openshift.io cluster --type merge -p '{"spec":{"storage":{"pvc":{"claim": null}}}}'
```

Expose image registry

```
oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge

HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
echo ${HOST}
```
