#!/bin/sh
# shellcheck disable=SC2148,SC3009,SC2086

LOGIN="redhat:Redhat@123!"

redfish_action(){
ACTION=${1:-On}
URL_PATH='redfish/v1/Systems/System.Embedded.1/Actions/ComputerSystem.Reset'

for ${DRAC} in 172.29.134.8{1..3} 172.29.170.21{6..9}
do
  curl -si -u "redhat:Redhat@123!" \
    -k -X POST \
    --header 'Content-Type: application/json' \
    --header 'Accept: application/json' \
    -d '{"Action":"Reset","ResetType":"'"${ACTION}"'"}' \
    "https://$${DRAC}/${URL_PATH}"
done
}

media_eject(){
URL_PATH='redfish/v1/Managers/iDRAC.Embedded.1/VirtualMedia/CD/Actions/VirtualMedia.EjectMedia'

for ${DRAC} in 172.29.134.8{1..3} 172.29.170.21{6..9}
do
    curl -si -u "${LOGIN}" \
    -H 'Content-Type: application/json' \
    -d '{}' \
    -k -X POST \
    https://$${DRAC}/${URL_PATH}
done
}

power_on(){
  redfish_action On
}

power_off(){
  redfish_action ForceOff
}
