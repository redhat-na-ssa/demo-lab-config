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

# =================================

get_mapping(){
  IMAGE_SET_FILE=${1:-components/imageset/imageset-config-ocp.yaml}  
  FILE=$(basename -- "${IMAGE_SET_FILE%.yaml}").map
  MAPPING=scratch/mirror_media/${FILE}

  oc mirror \
    -c "${IMAGE_SET_FILE}" \
    --dry-run file://scratch/mirror_media > "${MAPPING%.map}-output.txt" 2>&1

  [ -e "scratch/mirror_media/oc-mirror-workspace/mapping.txt" ] || return
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
  get_mapping components/imageset/imageset-config-nvidia-only.yaml
  # get_mapping components/imageset/imageset-config-mvp.yaml
  get_mapping components/imageset/imageset-config-all.yaml
  get_mapping components/imageset/imageset-config-ocp.yaml
  get_mapping components/imageset/imageset-config-ocp-upgrade.yaml
  get_mapping components/imageset/imageset-config-redhat.yaml
  get_mapping components/imageset/imageset-config-certified.yaml
  get_mapping components/imageset/imageset-config-runai.yaml
}

main