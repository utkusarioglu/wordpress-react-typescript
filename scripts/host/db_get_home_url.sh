#!/bin/bash

source scripts/shared/exit_if_in_devcontainer.sh
source scripts/shared/check_env.sh
source .env
source scripts/shared/check_container_online.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

check_container_online "${THEME_NAME}__db__dev"

function title {
  title_template "Database Get Home Url Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt db get-home-url [options]

Commands:
  (none)        Return the current WordPress home url

Options:
  -h, --help    Shows this help information

EOF
}

function do_get_home_url {
  docker exec "${THEME_NAME}__db__dev" bash \
    -c "source /scripts/get_home_url.sh; get_home_url $DB_USER $DB_PASS $DB_NAME"
}

parse_args_basic $@
do_get_home_url