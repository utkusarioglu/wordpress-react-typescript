#! /bin/bash

source scripts/shared/vars.sh

PRODUCTION_PUSH_PREFIX="$PRODUCTION_SCRIPTS/production_push_"

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      sql-backup)
        shift
        "${PRODUCTION_PUSH_PREFIX}sql_backup.sh" $@
        exit
        ;;

      uploads)
        shift
        "${PRODUCTION_PUSH_PREFIX}uploads.sh" $@
        exit
        ;;

      theme)
        shift
        "${PRODUCTION_PUSH_PREFIX}theme.sh" $@
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