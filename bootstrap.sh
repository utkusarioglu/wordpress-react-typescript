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

source .env

THEME_DIR=theme/react-src

cd $THEME_DIR

sed -i "/homepage/c\  \"homepage\": \"\/wp-content\/themes\/$THEME_NAME\"," ./package.json

# Notice that this one doesn't add a comma at the end
sed -i "/homepage/c\  \"homepage\": \"\/wp-content\/themes\/$THEME_NAME\"" ./user.prod.json 

yarn

echo "Now, please open the repo inside the devcontainer"