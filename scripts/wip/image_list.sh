#!/bin/bash

get_mapping(){
  IMAGE_SET_FILE=${1:-components/imageset/imageset-config-ocp.yaml}

  oc mirror \
    -c "${IMAGE_SET_FILE}" \
    --dry-run file://scratch/mirror_media
  
  FILE=$(basename -- ${IMAGE_SET_FILE%.yaml}).map
  MAPPING=scratch/mirror_media/${FILE}

  cp scratch/mirror_media/oc-mirror-workspace/mapping.txt "${MAPPING}"

  echo "============ Registries ============" > "${MAPPING%.map}-images.txt"  
  get_list_registry "${MAPPING}" | tee -a "${MAPPING%.map}-images.txt"

  echo "============== Images ==============" >> "${MAPPING%.map}-images.txt"
  get_list_images_for_humans "${MAPPING}" | tee -a "${MAPPING%.map}-images.txt"

}

get_list_registry(){
  FILE=${1:-scratch/mirror_media/oc-mirror-workspace/mapping.txt}
  sed 's#/.*##' "${FILE}" | sort -u
}

get_list_images_for_humans(){
  FILE=${1:-scratch/mirror_media/oc-mirror-workspace/mapping.txt}
  sed 's#@sha256.*=file://.*:#:#' "${FILE}" | sort
}

main(){
  get_mapping components/imageset/imageset-config-ocp.yaml
  get_mapping components/imageset/imageset-config-runai.yaml
}

main