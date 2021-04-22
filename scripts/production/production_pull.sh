#! /bin/bash

source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Production Pull Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt production pull [options] [COMMAND]

Commands:
  sql-backup    Pull sql backup from production
  uploads       Pull wp uploads folder content from production
  plugins       Pull wp plugins folder content from production

Options:
  -h, --help    Shows this help information

EOF
}

PRODUCTION_PULL_PREFIX="$PRODUCTION_SCRIPTS/production_pull_"

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      sql-backup)
        shift
        "${PRODUCTION_PULL_PREFIX}sql_backup.sh" $@
        exit
        ;;

      uploads)
        shift
        "${PRODUCTION_PULL_PREFIX}uploads.sh" $@
        exit
        ;;

      plugins)
        shift
        "${PRODUCTION_PULL_PREFIX}plugins.sh" $@
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