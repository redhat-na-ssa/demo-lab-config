#!/bin/bash

ask_api(){
  ENDPOINT='https://test-llama2-autoscale-runai-llm-training1.apps.cluster1.sandbox284.opentlc.com/api/chat'
  # MODEL='{"id":"NousResearch/Llama-2-7b-chat-hf","name":"NousResearch/Llama-2-7b-chat-hf"}'
  MODEL=$(get_first_model)
  PROMPT=${1:-How long does it take to install OpenShift}

  echo "PROMPT: ${PROMPT}"
  
  echo "DEBUG: ON"
  set -x
  curl -s "${ENDPOINT}" \
    -H 'Content-Type: application/json' \
    -d $'{"model":'"${MODEL}"',"messages":[{"role":"user","content":"'"${PROMPT}"'"}]}'
  set +x
}

get_first_model(){
  ENDPOINT='https://test-llama2-autoscale-runai-llm-training1.apps.cluster1.sandbox284.opentlc.com/api/models'
  curl -s "${ENDPOINT}" \
    -H 'Content-Type: application/json' \
    -d $'{"key": ""}' | jq .[0] | sed 's/ //g' | tr -d '\n'
}
