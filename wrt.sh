#! /bin/bash

source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt [options] [COMMAND]

Commands:
  bootstrap     Set the theme name and download the dependencies
  db            Tools for managing the wordpress mysql database
  docker        Manage project's docker containers
  production    Communicate with the production environment, pull and push items
  theme         Build, clean, package the theme

Options:
  -h, --help    Shows this help information

EOF
}

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      bootstrap)
        shift
        "$HOST_SCRIPTS/bootstrap.sh" $@
        exit
        ;;

      db)
        shift
        "$HOST_SCRIPTS/db.sh" $@
        exit
        ;;

      theme)
        shift
        "$HOST_SCRIPTS/theme.sh" $@
        exit
        ;;

      docker)
        shift
        "$HOST_SCRIPTS/docker.sh" $@
        exit
        ;;

      production)
        shift
        "$PRODUCTION_SCRIPTS/production.sh" $@
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