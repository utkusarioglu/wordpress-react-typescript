#!/bin/bash

source scripts/host/check_env.sh
source .env

function invalid_flag_error {
cat >&2 << EOF

Operation failed. $1 is not a recognized flag. 
Available flags are listed below:

-n, --new-url [new url]: Url to which the current home url shall be corrected

EOF
}

# Vars
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

      -*|--*=) # unsupported flags
        invalid_flag_error $1
        exit 1
        ;;

      *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
    esac
  done
  eval set -- "$PARAMS"
}
parse_args $@

read -r -d '' COMMAND << EOM
  /scripts/replace_url.sh \
    --user root \
    --pass ${DB_ROOT_PASS} \
    --schema ${DB_NAME} \
    --new-url ${NEW_URL}
EOM

docker exec "${THEME_NAME}__db" bash -c "$COMMAND" \
  &> /dev/null
