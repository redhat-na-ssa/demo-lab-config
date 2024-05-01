#!/bin/bash
# shellcheck disable=SC2002,SC2013

check_images(){
  for image in $(cat docs/images/imageset-config-all-images.txt | sed '0,/Images/d')
  do
    printf '%s ' "${image}"
    if skopeo inspect docker://"${image}" > /dev/null 2>&1; then
      echo "[OK]"
    else
      echo "[ERROR]"
    fi
  done
}
