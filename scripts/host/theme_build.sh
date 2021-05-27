#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh
source scripts/shared/check_container_online.sh
source scripts/shared/exit_if_in_devcontainer.sh

check_container_online "${WP_CONTAINER_NAME}"

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
  docker exec -it \
    "${WP_CONTAINER_NAME}" \
    bash -c "cd /workspace/theme/react-src && yarn build"
  
  # adjust file permissions
  echo "Adjusting file permissions..."
  sudo chown "$(whoami):$(whoami)" -R build
  
  # Remove irrelevant files
  echo "Removing clutter..."
  cd build
  rm -f ./!READY_TO_DEPLOY!.txt
}

parse_args_basic $@
do_theme_build
theme_built_message