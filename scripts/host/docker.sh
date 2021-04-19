#! /bin/bash

source scripts/shared/vars.sh

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      prune)
        shift
        "$HOST_SCRIPTS/docker_prune.sh" $@
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