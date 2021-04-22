#! /bin/bash

source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Production Push Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt production push [options] [COMMAND]

Commands:
  sql-backup    Push a sql backup to be used in production
  uploads       Push wp uploads folder content to production
  plugins       Push wp plugins folder content to production
  theme         Push wp theme that you are developing to production

Options:
  -h, --help    Shows this help information

EOF
}

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

      plugins)
        shift
        "${PRODUCTION_PUSH_PREFIX}plugins.sh" $@
        exit
        ;;

      theme)
        shift
        "${PRODUCTION_PUSH_PREFIX}theme.sh" $@
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