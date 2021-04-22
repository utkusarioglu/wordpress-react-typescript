#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Bootstrap Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt bootstrap [options]

Commands:
  (none)        Run the bootstrap operation

Options:
  -h, --help    Shows this help information

EOF
}

function do_bootstrap {
  echo "Setting theme name as ${THEME_NAME}..."
  cd $THEME_SRC_DIR
  sed -i "/homepage/c\  \"homepage\": \"\/wp-content\/themes\/$THEME_NAME\"," ./package.json
  # Notice that this one doesn't add a comma at the end
  sed -i "/homepage/c\  \"homepage\": \"\/wp-content\/themes\/$THEME_NAME\"" ./user.prod.json 

  echo "Installing NPM packages using Yarn..."
  yarn
}

parse_args_basic $@
do_bootstrap
bootstrap_complete_message