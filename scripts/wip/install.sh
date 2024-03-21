#!/bin/bash -x
rm -rf /home/redhat/clusterconfigs/cluster1/ && mkdir -p /home/redhat/clusterconfigs/cluster1/ && cp install-config.yaml /home/redhat/clusterconfigs/cluster1/ && openshift-baremetal-install --dir /home/redhat/clusterconfigs/cluster1/ create cluster --log-level debug
