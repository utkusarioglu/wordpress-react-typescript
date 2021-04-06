#!/bin/bash

if ! test -f ".env"; then 
  cat << EOF
Operation failed. This script requires the following properties from the .env file:

THEME_NAME

Please make sure that an .env file exists and the listed properties are set, 
and then rerun this script.
EOF
exit 1;
fi

echo "Cleaning containers, volumes, networks created for this repo"

source .env

for c in 'stop' 'rm';
do
  docker container $c "${THEME_NAME}__wp" "${THEME_NAME}__db"  
done;  

docker volume rm wp_db
docker network rm wp_default