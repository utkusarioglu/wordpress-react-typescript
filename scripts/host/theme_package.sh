#! /bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh
source scripts/shared/check_container_online.sh
source scripts/shared/exit_if_in_devcontainer.sh

check_container_online "${WP_CONTAINER_NAME}"

function title {
  title_template "Theme Package Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt theme package [options]

Commands:
  (none)        Run the packaging operation

Options:
  -h, --help    Shows this help information

EOF
}

function do_theme_package {
  "$HOST_SCRIPTS/theme_build.sh"

  echo 'Removing previous package...'
  rm -f "$THEME_NAME.zip"

  echo "Creating $THEME_NAME.zip"
  cd build
  zip -r "../$THEME_NAME.zip" *
  cd ..

  echo 'Removing intermediaries'
  rm -rf build

  theme_packaged_message $THEME_NAME
}

parse_args_basic $@
do_theme_package