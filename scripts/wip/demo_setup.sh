#!/bin/bash

# shellcheck disable=SC2120
genpass(){
    < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c"${1:-32}"
}

which htpasswd || return
which oc || return

HTPASSWD_FILE=scratch/htpasswd
KUBECONFIG_FILE=scratch/kubeconfig

htpasswd_add_user(){
  USER=${1:-admin}
  PASS=${2:-$(genpass)}

  echo "
    USERNAME: ${USER}
    PASSWORD: ${PASS}

    FILE: ${HTPASSWD_FILE}
  "

  touch "${HTPASSWD_FILE}"
  htpasswd -bB -C 10 "${HTPASSWD_FILE}" "${USER}" "${PASS}"
}

htpasswd_get_file(){
  oc -n openshift-config \
    extract secret/oauth-htpasswd \
    --keys=htpasswd \
    --to=scratch
}

htpasswd_set_file(){
  oc -n openshift-config \
    set data secret/oauth-htpasswd \
    --from-file=htpasswd="${HTPASSWD_FILE}"
}

htpasswd_set_ocp_admin(){
  USER=${1:-admin}
  OCP_ADMIN_GROUP=${2:-demo-admins}
  
  oc adm groups add-users \
  "${OCP_ADMIN_GROUP}" "${USER}"
}

ocp_setup_user(){
  USER=${1:-admin}
  PASS=${2:-$(genpass)}
  
  htpasswd_add_user "${USER}" "${PASS}"
  htpasswd_set_ocp_admin "${USER}" demo-admins

  echo "
    run: htpasswd_set_file
  "
}

which age || return

htpasswd_decrypt_file(){
  age --decrypt \
    -i ~/.ssh/id_ed25519 \
    -i ~/.ssh/id_rsa \
    -o "${HTPASSWD_FILE}" \
    htpasswd.age
}

htpasswd_encrypt_file(){
  age --encrypt --armor \
    -R authorized_keys \
    -o htpasswd.age \
    "${HTPASSWD_FILE}"
}

kubeconfig_decrypt_file(){
  age --decrypt \
    -i ~/.ssh/id_ed25519 \
    -i ~/.ssh/id_rsa \
    -o "${KUBECONFIG_FILE}" \
    kubeconfig.age
}

kubeconfig_encrypt_file(){
  age --encrypt --armor \
    -R authorized_keys \
    -o kubeconfig.age \
    "${KUBECONFIG_FILE}"
}
