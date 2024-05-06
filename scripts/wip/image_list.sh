#!/bin/bash

check_git_root(){
  [ -n "${GIT_ROOT}" ] && return

  if [ -d .git ] && [ -d scripts ]; then
    GIT_ROOT=$(pwd)
    export GIT_ROOT
    echo "GIT_ROOT: ${GIT_ROOT}"
    return
  else
    echo "Please run this script from the root of the git repo"
    exit
  fi
}

setup_bin_path(){
  [ -z ${GIT_ROOT+x} ] && return 1
  BIN_PATH="${GIT_ROOT}/scratch/bin"

  mkdir -p "${BIN_PATH}"
  echo "${PATH}" | grep -q "${BIN_PATH}" || \
    PATH="${BIN_PATH}:${PATH}"
    export PATH
}

ocp_mirror_get_pull_secret(){
  export DOCKER_CONFIG="${GIT_ROOT}/scratch"

  [ -e "${DOCKER_CONFIG}/config.json" ] && return

  oc -n openshift-config \
    extract secret/pull-secret \
    --to=- | tee "${GIT_ROOT}/scratch/pull-secret" > "${DOCKER_CONFIG}/config.json"
  
  # cat scratch/pull-secret | jq .
}

download_oc(){
  BIN_VERSION=4.12
  DOWNLOAD_URL=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-${BIN_VERSION}/openshift-client-linux.tar.gz
  curl "${DOWNLOAD_URL}" -sL | tar zx -C "${BIN_PATH}/" oc kubectl
}

download_oc-mirror(){
  BIN_VERSION=stable
  DOWNLOAD_URL=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${BIN_VERSION}/oc-mirror.tar.gz
  curl "${DOWNLOAD_URL}" -sL | tar zx -C "${BIN_PATH}/"
  chmod +x "${BIN_PATH}/oc-mirror"
}

bin_check(){
  name=${1:-oc}

  # OS="$(uname | tr '[:upper:]' '[:lower:]')"
  # ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"

  which "${name}" || download_"${name}"
 
  case ${name} in
    helm|kustomize|krew|kubectl-operator|oc|oc-mirror|odo|openshift-install|opm|s2i|tkn)
      echo "auto-complete: . <(${name} completion bash)"
      
      # shellcheck source=/dev/null
      . <(${name} completion bash)
      ${name} completion bash > "${BIN_PATH}/${name}.bash"
      
      ${name} version 2>&1 || ${name} --version
      ;;
    restic)
      restic generate --bash-completion "${BIN_PATH}/restic.bash"
      restic version
      ;;
    *)
      echo
      ${name} --version
      ;;
  esac
  sleep 2
}

check_git_root
setup_bin_path
bin_check oc
bin_check oc-mirror
ocp_mirror_get_pull_secret

pushd scratch || return

# =================================

check_images(){
  for image in $(cat ../docs/images/imageset-config-only-ocp-images.txt | sed '0,/Images/d; /quay.io/d; /registry.redhat.io/d; /registry.connect.redhat.com/d')
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
  for image in $(cat ../docs/images/imageset-config-only-ocp.map | sed 's/=file.*//')
  do
    # podman --log-level debug pull "${image}"

    skopeo inspect --raw docker://"${image}" | jq .config.digest
  done
}

get_list_registry(){
  FILE=${1:-mirror_media/oc-mirror-workspace/mapping.txt}
  sed 's#/[^/]*@.*$##' "${FILE}" | sort -u
}

get_list_images_for_humans(){
  FILE=${1:-mirror_media/oc-mirror-workspace/mapping.txt}
  sed 's#@sha256.*=.*:#:#' "${FILE}" | sort -u
}

get_mapping(){
  IMAGESET=${1:-../components/imageset/imageset-config-only-ocp.yaml}  
  BASENAME=$(basename -- "${IMAGESET%.yaml}")
  BASENAME=${BASENAME##imageset-config-}
  DEST=../components/imageset/${BASENAME}

  echo "
    IMAGESET: ${IMAGESET}
    DEST:     ${DEST}
    BASENAME: ${BASENAME}
  "

  [ -d "${DEST}" ] || mkdir -p "${DEST}"

  oc mirror \
    -c "${IMAGESET}" \
    file://mirror_media \
    --dry-run \
    --ignore-history \
    --skip-metadata-check

  mv -f .oc-mirror.log  "${BASENAME}-output.txt"

  [ -e "mirror_media/oc-mirror-workspace/mapping.txt" ] || return
  sort -u mirror_media/oc-mirror-workspace/mapping.txt > "${DEST}/mapping.txt"

  # echo "============ Registries ============" > "${DEST}/registries.txt"  
  get_list_registry "${MAPPING}" | tee "${DEST}/registries.txt"

  # echo "============== Images ==============" > "${DEST}/images-tagged.txt"
  get_list_images_for_humans "${MAPPING}" | tee "${DEST}/images-tagged.txt"
}

get_mapping_all(){

  # get_mapping

  for i in ../components/imageset/imageset-config-*
  do
    [ -e ../components/imageset/test ] || mkdir -p test
    get_mapping "${i}"
  done
}

get_mapping_all

popd || return
