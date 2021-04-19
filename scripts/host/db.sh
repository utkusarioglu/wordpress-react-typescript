#! /bin/bash

source scripts/host/vars.sh

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      backup)
        shift
        "$HOST_SCRIPTS/db_backup.sh" $@
        exit
        ;;

      replace-url)
        shift
        "$HOST_SCRIPTS/db_replace_url.sh" $@
        exit
        ;;

      restore)
        shift
        "$HOST_SCRIPTS/db_restore.sh" $@
        exit
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