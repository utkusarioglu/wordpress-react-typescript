#!/bin/bash

if ! test -f ".env"; then 
  cat >&2 << EOF
Operation failed. This script requires the following properties from the .env file:

THEME_NAME: The name for the theme that you are developing

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

cat << EOF

Bootstrapping complete.

Now, you can open the repo in a devcontainer. But before that, please make 
sure that you have the following variables defined in your .env file:

THEME_NAME: The name for the theme that you are developing
DB_USER: Username for wp's mysql access
DB_PASS: Password for wp's mysql access
DB_NAME: Name for the schema that wp will use
DB_ROOT_PASS: Mysql root user password

After defining these values, you can press ctrl + shift + p and select 
"Remote-Containers: Reopen in Container" to open the repo in a devcontainer.

EOF