#!/bin/bash

source .env

if ! test -f ".env"; then 
  cat >&2 << EOF
Operation failed. This script requires the following properties from the .env file:

THEME_NAME: The name for the theme that you are developing

Please make sure that an .env file exists and the listed properties are set, 
and then rerun this script.
EOF
exit 1;
fi

echo "Running pruning for ${THEME_NAME}..."

if [[ "$@" =~ "--no-backup" ]]; then
  echo "Skipping db backup creation upon user command"
else
  bash ./db_backup.sh
fi

echo "Cleaning containers, volumes, and networks"

for command in 'stop' 'rm';
do
  docker container $command "${THEME_NAME}__wp" "${THEME_NAME}__db"  
done;  

repo_name="$(basename "$PWD")"
docker volume rm "${repo_name}_db"
docker network rm "${repo_name}_default"