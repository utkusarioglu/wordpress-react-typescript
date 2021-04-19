#! /bin/bash

source scripts/shared/vars.sh

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      bootstrap)
        shift
        bash "$HOST_SCRIPTS/bootstrap.sh" $@
        exit
        ;;

      db)
        shift
        bash "$HOST_SCRIPTS/db.sh" $@
        exit
        ;;

      theme)
        shift
        bash "$HOST_SCRIPTS/theme.sh" $@
        exit
        ;;

      docker)
        shift
        bash "$HOST_SCRIPTS/docker.sh" $@
        exit
        ;;

      docker)
        shift
        bash "$PRODUCTION_SCRIPTS/production.sh" $@
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