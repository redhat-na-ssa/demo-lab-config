#!/bin/bash

ENDPOINT=${ENDPOINT:-https://test-llama2-autoscale-runai-llm-training1.apps.cluster1.sandbox284.opentlc.com}
export ENDPOINT

usage(){
  echo "usage:
  . "${0}"
  
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
  curl -s "${ENDPOINT}/api/models" \
    -H 'Content-Type: application/json' \
    -d $'{"key": ""}' | jq .[0] | sed 's/ //g' | tr -d '\n'
}

ask_api(){

  MODEL='{"id":"NousResearch/Llama-2-7b-chat-hf","name":"NousResearch/Llama-2-7b-chat-hf"}'
  MESSAGE=${1:-How long does it take to install OpenShift}
  PROMPT='You are ChatGPT, a large language model trained by OpenAI. Follow the user instructions carefully. Respond using markdown.'
  TEMP='0.8'

  # use jq if you got it
  which jq >/dev/null 2>&1 && MODEL=$(kludgebot_get_first_model)

  echo "
  ENDPOINT: ${ENDPOINT}
  MODEL: ${MODEL}
  MESSAGE: ${MESSAGE}
  "
  
  # set -x
  curl -sk "${ENDPOINT}/api/chat" \
    -H 'Content-Type: application/json' \
    -d $'{"model":'"${MODEL}"',"messages":[{"role":"user","content":"'"${MESSAGE}"'"}],"prompt":"'"${PROMPT}"'","temperature":'"${TEMP}"'}'
  # set +x
}

is_sourced || usage
