#!/bin/bash

source scripts/host/check_env.sh
source .env
source scripts/host/vars.sh

echo "Setting theme name as ${THEME_NAME}..."
cd $THEME_DIR
sed -i "/homepage/c\  \"homepage\": \"\/wp-content\/themes\/$THEME_NAME\"," ./package.json
# Notice that this one doesn't add a comma at the end
sed -i "/homepage/c\  \"homepage\": \"\/wp-content\/themes\/$THEME_NAME\"" ./user.prod.json 

ECHO "Installing NPM packages using Yarn..."
yarn

cat << EOF

Bootstrapping complete. Now you can press ctrl + shift + p and select 
"Remote-Containers: Reopen in Container" to open the repo in a devcontainer.

EOF