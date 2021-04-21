#! /bin/bash

source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Docker Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt docker [options] [COMMAND]

Commands:
  prune         Remove containers, volumes and networks associated
                with your wrt dev environment

Options:
  -h, --help    Shows this help information

EOF
}

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      prune)
        shift
        "$HOST_SCRIPTS/docker_prune.sh" $@
        exit
        ;;

      *)
        parse_args_essential title commands_and_options $@
    esac
  done
  eval set -- "$PARAMS"
}
parse_args $@

title
commands_and_options