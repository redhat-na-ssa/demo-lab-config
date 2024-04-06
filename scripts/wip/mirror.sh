#!/bin/bash

[ -d scratch ] || mkdir -p scratch

ocp_mirror_dry_run(){
  # https://docs.openshift.com/container-platform/4.14/installing/disconnected_install/installing-mirroring-installation-images.html
  # https://mirror.openshift.com/pub/openshift-v4/

  TIME_STAMP=$()

  LOCAL_SECRET_JSON=${1:-scratch/pull-secret}
  PRODUCT_REPO=${2:-openshift-release-dev}
  RELEASE_NAME=${3:-ocp-release}
  OCP_RELEASE=${4:-4.14.20}
  ARCHITECTURE=${5:-x86_64}

  LOCAL_REGISTRY=${6:-localhost:5000}
  LOCAL_REPOSITORY=${7:-ocp4/openshift4}

  REMOVABLE_MEDIA_PATH=scratch/mirror_media

  oc adm release mirror \
    -a ${LOCAL_SECRET_JSON}  \
    --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} \
    --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} \
    --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE} \
    --dry-run | tee scratch/dry_run

  # sed '0,/use the following/d ; /^$/d' scratch/dry_run
}

ocp_mirror_get_pull_secret(){
  oc -n openshift-config \
    extract secret/pull-secret \
    --to=- | tee scratch/pull-secret | jq .
}
