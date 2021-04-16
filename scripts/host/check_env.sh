#! /bin/bash

function env_file_error {
cat >&2 << EOF

Operation failed. Please create an .env file at the project root 
with the following values:

THEME_NAME: The name for the theme that you are developing
DB_USER: Username for WordPress' MySql access
DB_PASS: Password for WordPress' MySql access
DB_NAME: Name for the schema that WordPress will use
DB_ROOT_PASS: MySql root user password

After creating the .env file, please rerun this script

EOF
}

# Error checking for whether the environment vars are defined
if ! test -f "${PWD}/.env"; then 
  env_file_error
  exit 1;
fi
