#! /bin/bash

source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Production Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt production [options] [COMMAND]

Commands:
  push          Upload items to your production environment
  pull          Download items from your production environment
  init          Initialize your production environment

Options:
  -h, --help    Shows this help information

EOF
}

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

      *)
        parse_args_common title commands_and_options $@
    esac
  done
  eval set -- "$PARAMS"
}

parse_args $@
title
commands_and_options