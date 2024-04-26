#!/bin/bash

usage(){
  echo "usage: 
  
  ask_api \"Your Question Here\"
  "
}

is_sourced(){
  if [ -n "$ZSH_VERSION" ]; then
      case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
  else  # Add additional POSIX-compatible shell names here, if needed.
      case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
  fi
  return 1  # NOT sourced.
}

kludgebot_get_first_model(){
  ENDPOINT='https://test-llama2-autoscale-runai-llm-training1.apps.cluster1.sandbox284.opentlc.com'
  curl -s "${ENDPOINT}/api/models" \
    -H 'Content-Type: application/json' \
    -d $'{"key": ""}' | jq .[0] | sed 's/ //g' | tr -d '\n'
}

ask_api(){
  ENDPOINT='https://test-llama2-autoscale-runai-llm-training1.apps.cluster1.sandbox284.opentlc.com'
  MODEL='{"id":"NousResearch/Llama-2-7b-chat-hf","name":"NousResearch/Llama-2-7b-chat-hf"}'
  PROMPT=${1:-How long does it take to install OpenShift}

  # use jq if you got it
  which jq >/dev/null 2>&1 && MODEL=$(kludgebot_get_first_model)

  echo "
  ENDPOINT: ${ENDPOINT}
  MODEL: ${MODEL}
  PROMPT: ${PROMPT}
  "
  
  # set -x
  curl -sk "${ENDPOINT}/api/chat" \
    -H 'Content-Type: application/json' \
    -d $'{"model":'"${MODEL}"',"messages":[{"role":"user","content":"'"${PROMPT}"'"}]}'
  # set +x
}

is_sourced || usage
