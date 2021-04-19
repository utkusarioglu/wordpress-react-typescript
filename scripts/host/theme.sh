#! /bin/bash

source scripts/host/vars.sh

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      clean)
        shift
        "$HOST_SCRIPTS/theme_clean.sh" $@
        exit
        ;;

      build)
        shift
        "$HOST_SCRIPTS/theme_build.sh" $@
        exit
        ;;

      dist)
        shift
        "$HOST_SCRIPTS/theme_dist.sh" $@
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