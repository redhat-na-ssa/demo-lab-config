#!/bin/bash

# see https://ksingh7.medium.com/lets-automate-let-s-encrypt-tls-certs-for-openshift-4-211d6c081875

# export AWS_ACCESS_KEY_ID=ID
# export AWS_SECRET_ACCESS_KEY=KEY
export EMAIL=${EMAIL:-no-reply@github.com}

if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
  echo "Error:
    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=
  "
  exit 1
fi

SCRATCH=./scratch
ACME_DIR=${SCRATCH}/acme
CERT_DIR=${SCRATCH}/le-certs

# openshift env
LE_API=$(oc whoami --show-server | cut -f 2 -d ':' | cut -f 3 -d '/' | sed 's/-api././')
LE_WILDCARD=$(oc get ingresscontroller default -n openshift-ingress-operator -o jsonpath='{.status.domain}')

# setup acme.sh
[ ! -d "${ACME_DIR}" ] && git clone https://github.com/acmesh-official/acme.sh.git ${ACME_DIR}

# init acme
${ACME_DIR}/acme.sh \
  --register-account \
  -m "${EMAIL}"

${ACME_DIR}/acme.sh \
  --issue \
  -d "${LE_API}" \
  -d "*.${LE_WILDCARD}" \
  --dnssleep 60 \
  --dns dns_aws

# get certs
[ ! -d "${CERT_DIR}" ] && mkdir -p ${CERT_DIR}

${ACME_DIR}/acme.sh \
  --install-cert -d "${LE_API}" \
  -d "*.${LE_WILDCARD}" \
  --cert-file ${CERT_DIR}/cert.pem \
  --key-file ${CERT_DIR}/key.pem \
  --fullchain-file ${CERT_DIR}/fullchain.pem \
  --ca-file ${CERT_DIR}/ca.cer

# update router certs
oc -n openshift-ingress delete secret openshift-wildcard-certificate

oc create secret tls openshift-wildcard-certificate \
  --cert=${CERT_DIR}/fullchain.pem \
  --key=${CERT_DIR}/key.pem \
  -n openshift-ingress

if oc get secret openshift-wildcard-certificate -n openshift-ingress; then
  oc patch ingresscontroller default \
    -n openshift-ingress-operator \
    --type=merge \
    --patch='{"spec": { "defaultCertificate": { "name": "openshift-wildcard-certificate" }}}'
else
  echo "LE Setup: Error openshift-wildcard-certificate"
  exit 1
fi

# update api certs
oc -n openshift-config delete secret openshift-api-certificate

oc create secret tls openshift-api-certificate \
  --cert=${CERT_DIR}/fullchain.pem \
  --key=${CERT_DIR}/key.pem \
  -n openshift-config

if oc get secret openshift-api-certificate -n openshift-config; then
  oc patch apiserver cluster \
    --type=merge -p '{"spec":{"servingCerts": {"namedCertificates": [{"names": ["'"${LE_API}"'"], "servingCertificate": {"name": "openshift-api-certificate"}}]}}}'
else
  echo "LE Setup: Error openshift-api-certificate"
  exit 1
fi

sleep 6

oc get po -n openshift-ingress
