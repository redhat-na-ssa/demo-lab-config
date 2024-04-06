#!/bin/sh
# shellcheck disable=SC2148,SC3009,SC2086

for addr in 172.29.134.8{1..3} 172.29.170.21{6..9}
do curl -si -u "redhat:Redhat@123!" \
  -k -X POST --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  -d '{"Action":"Reset","ResetType":"ForceOff"}' \
  https://$addr/redfish/v1/Systems/System.Embedded.1/Actions/ComputerSystem.Reset; done
