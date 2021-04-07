#!/bin/bash

source .env

if ! test -f ".env"; then 
  cat << EOF
Operation failed. This script requires the following properties from the .env file:

THEME_NAME: The name for the theme that you are developing

Please make sure that an .env file exists and the listed properties are set, 
and then rerun this script.
EOF
exit 1;
fi

echo "Cleaning containers, volumes, and networks created for ${THEME_NAME}"

for command in 'stop' 'rm';
do
  docker container $command "${THEME_NAME}__wp" "${THEME_NAME}__db"  
done;  

repo_name="$(basename "$PWD")"
docker volume rm "${repo_name}_db"
docker network rm "${repo_name}_default"