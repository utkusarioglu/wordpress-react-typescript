#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh
source scripts/shared/exit_if_in_devcontainer.sh

function title {
  title_template "Docker Stop Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt docker stop [options]

Commands:
  (none)        Stop devcontainers

Options:
  -h, --help    Shows this help information

EOF
}

function do_docker_stop {
  docker container stop "${THEME_NAME}__wp__dev" "${THEME_NAME}__db__dev"
}

parse_args_basic $@
do_docker_stop