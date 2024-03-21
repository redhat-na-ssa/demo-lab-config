#!/bin/sh
# NOTE: install to /usr/local/bin

PUBLIC_IP=18.116.38.68
LAB_IP=143.166.117.0/24
OCP_API_IP=172.29.172.200
OCP_APP_IP=172.29.172.201
OCP_DNS_NAME=cluster1.wf.edgelab.online

kludge_tunnel(){
  echo "Setup your private dns to resolve:

  *.apps.${OCP_DNS_NAME}  ${OCP_APP_IP}
  api.${OCP_DNS_NAME}     ${OCP_API_IP}
  "
  echo "Setup your public dns to resolve:

  *.apps.${OCP_DNS_NAME}  ${PUBLIC_IP}
  api.${OCP_DNS_NAME}     ${PUBLIC_IP}
  "

  ssh -N -p 443 \
    root@"${PUBLIC_IP}" \
    -R 0.0.0.0:80:"${OCP_APP_IP}":80 \
    -R 0.0.0.0:443:"${OCP_APP_IP}":443 \
    -R 0.0.0.0:6443:"${OCP_API_IP}":6443 \
    -R 0.0.0.0:2222:localhost:22
}

kludge_test(){
  curl -k \
    --connect-to "${PUBLIC_IP}":443:example.apps.cluster1.example.com:443 \
    https://example.apps.cluster1.example.com
}

kludge_iptables(){
  iptables -t nat \
    -I PREROUTING -s "${LAB_IP}" -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 22
  iptables -t nat \
    -I PREROUTING -s "${LAB_IP}" -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 22
}

kludge_tunnel
