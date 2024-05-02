#!/bin/bash
# shellcheck disable=SC2002,SC2013

check_images(){
  for image in $(cat docs/images/imageset-config-all-images.txt | sed '0,/Images/d; /quay.io/d; /registry.redhat.io/d; /registry.connect.redhat.com/d')
  do
    printf '%s ' "${image}"
    if skopeo inspect --raw docker://"${image}" > /dev/null 2>&1; then
      echo "[OK]"
    else
      echo "[ERROR]"
    fi
  done
}

check_images_from_map(){
  for image in $(cat docs/images/imageset-config-all.map | sed 's/=file.*//')
  do
    # podman --log-level debug pull "${image}"

    skopeo inspect --raw docker://"${image}" | jq .config.digest
  done
}
