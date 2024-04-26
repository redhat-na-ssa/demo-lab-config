#!/bin/bash

kludgebot_get_first_model(){
  ENDPOINT='https://test-llama2-autoscale-runai-llm-training1.apps.cluster1.sandbox284.opentlc.com'
  curl -s "${ENDPOINT}/api/models" \
    -H 'Content-Type: application/json' \
    -d $'{"key": ""}' | jq .[0] | sed 's/ //g' | tr -d '\n'
}

ask_api(){
  ENDPOINT='https://test-llama2-autoscale-runai-llm-training1.apps.cluster1.sandbox284.opentlc.com'
  MODEL=$(kludgebot_get_first_model)
  PROMPT=${1:-How long does it take to install OpenShift}

  echo "
  ENDPOINT: ${ENDPOINT}
  MODEL: ${MODEL}
  PROMPT: ${PROMPT}
  
  DEBUG: ON
  "
  
  set -x
  curl -s "${ENDPOINT}/api/chat" \
    -H 'Content-Type: application/json' \
    -d $'{"model":'"${MODEL}"',"messages":[{"role":"user","content":"'"${PROMPT}"'"}]}'
  set +x
}
