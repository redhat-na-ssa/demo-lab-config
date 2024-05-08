#!/bin/bash
# shellcheck disable=SC2013

tags_list(){
  DEBUG_OUTPUT=debug.json

  skopeo list-tags docker://registry.redhat.io/redhat/certified-operator-index > debug.json

  for image in $(sort -u < ../components/imageset/lab/images-tagged.txt | grep -E -v 'ocp-v4.0-art-dev')
  # for image in $(cat ../components/imageset/lab/images-tagged.txt | egrep 'redhat' | sort -u )
  do
    IMAGE=${image%:*}
    # echo "${IMAGE}" && continue
    skopeo list-tags docker://"${IMAGE}" --authfile pull-secret >> "${DEBUG_OUTPUT}" 2>&1 || echo "${IMAGE} - [ERROR]"
  done
}

pushd scratch || return
tags_list
popd || return