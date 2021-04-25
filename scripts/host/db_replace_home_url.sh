#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Database Url Replacement Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt db replace-url [options]

Commands:
  (none)        Run the db backup operation

Options:
  -n, --new-url [url]       Url to which the current home url shall be 
                            corrected

EOF
}

NEW_URL=localhost

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -n|--new-url)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          NEW_URL=$2
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;

      *)
        parse_args_essential title commands_and_options $@
    esac
  done
  eval set -- "$PARAMS"
}

function do_replace_url {
  read -r -d '' COMMAND << EOM
  /scripts/replace_url.sh \
    --user root \
    --pass ${DB_ROOT_PASS} \
    --schema ${DB_NAME} \
    --new-url ${NEW_URL}
EOM

  docker exec "${THEME_NAME}__db__dev" bash -c "$COMMAND" \
    &> /dev/null
}

parse_args $@
do_replace_url