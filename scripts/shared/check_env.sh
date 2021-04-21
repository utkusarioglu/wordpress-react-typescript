#! /bin/bash

source scripts/shared/messages.sh

# Error checking for whether the environment vars are defined
if ! test -f "${PWD}/.env"; then 
  env_file_error
  exit 1;
fi
