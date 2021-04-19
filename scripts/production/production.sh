#! /bin/bash

source scripts/shared/vars.sh

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      push)
        shift
        "$PRODUCTION_SCRIPTS/production_push.sh" $@
        exit
        ;;

      pull)
        shift
        "$PRODUCTION_SCRIPTS/production_pull.sh" $@
        exit
        ;;

      init)
        shift
        "$PRODUCTION_SCRIPTS/production_init.sh" $@
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