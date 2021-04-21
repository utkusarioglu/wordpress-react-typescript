#! /bin/bash

source scripts/shared/messages.sh
source .env

# Error checking for whether the environment vars are defined
if ! test -f "${PWD}/.env"; then 
  env_file_error
  exit 1;
fi


if [ -z $THEME_NAME ]; then
  env_file_value_check_error '.env/THEME_NAME cannot be empty'
  exit 1
fi

if ! [[ $THEME_NAME =~ ^[a-zA-Z0-9]+$ ]]; then
  env_file_value_check_error '.env/THEME_NAME can only contain alphanumeric characters'
  exit 1
fi

if [ -z $DB_USER ]; then
  env_file_value_check_error '.env/DB_USER cannot be empty'
  exit 1
fi

if [ -z $DB_PASS ]; then
  env_file_value_check_error '.env/DB_PASS cannot be empty'
  exit 1
fi

if [ -z $DB_NAME ]; then
  env_file_value_check_error '.env/DB_NAME cannot be empty'
  exit 1
fi

if [ -z $DB_ROOT_PASS ]; then
  env_file_value_check_error '.env/DB_ROOT_PASS cannot be empty'
  exit 1
fi