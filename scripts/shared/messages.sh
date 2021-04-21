function unsupported_flag_error {
  cat >&2 << EOF

Operation failed. "$1" is not a supported flag. 
Please review your options below:

EOF
}

function unsupported_command_error {
  cat >&2 << EOF

Operation failed. "$1" is not a supported command. 
Please review your options below:

EOF
}

function env_file_error {
cat >&2 << EOF

Operation failed. Please create an .env file at the project root 
with the following values:

  THEME_NAME      The name for the theme that you are developing
  DB_USER         Username for WordPress' MySql access
  DB_PASS         Password for WordPress' MySql access
  DB_NAME         Name for the schema that WordPress will use
  DB_ROOT_PASS    MySql root user password

After creating the .env file, please rerun this script

EOF
}

function env_file_value_check_error {
cat >&2 << EOF

Operation failed. $1. 
Please update your .env file and then rerun this script

EOF
}

function missing_argument_error {
  echo "Error: Argument for $1 is missing" >&2
}

function running_inside_container_error {
cat >&2 << EOF

Operation failed. You cannot run this script while inside the devcointainer.
Please start a separate terminal, and run this script from the host.

EOF
}

function nonexistent_file_error {
cat >&2 << EOF

Operation failed. The file "$1" cannot be found in $2.
Please make sure that you have specified the correct file name and try again.

EOF
}

function title_template {
    cat << EOF

$1 for Wordpress - React - Typescript (wrt)

EOF
}

function theme_built_message {
  cat << EOF 

Build complete. You can find your theme in "build".

EOF
}

function theme_cleaned_message {
  cat << EOF

All non-essential files have been removed from the theme directory.
You can run bootstrap.sh to restore dependencies and other runtime files.

EOF
}

function theme_packaged_message {
  cat << EOF

Theme packaging complete.
You can find your packaged theme in <root>/dist.zip

EOF
}

function bootstrap_complete_message {
  cat << EOF

Bootstrapping complete. Now you can press ctrl + shift + p and select 
"Remote-Containers: Reopen in Container" to open the repo in a devcontainer.

EOF
}