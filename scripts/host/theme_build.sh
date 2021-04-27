#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh
source scripts/shared/check_container_online.sh

check_container_online "${THEME_NAME}__wp__dev"

function title {
  title_template "Theme Build Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt theme build [options]

Commands:
  (none)        Run the build operation

Options:
  -h, --help    Shows this help information

EOF
}

function do_theme_build {
  # Remove old build
  echo "Removing old build..."
  rm -rf build

  # handle build
  echo "Building theme ${THEME_NAME}"
  cd theme/react-src 
  yarn build
  cd ../..

  # Remove irrelevant files
  echo "Removing clutter..."
  cd build
  rm ./!READY_TO_DEPLOY!.txt
}

parse_args_basic $@
do_theme_build
theme_built_message