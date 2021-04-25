#! /bin/bash

source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Database Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt db [options] [COMMAND]

Commands:
  backup        Create a backup of the current wp database 
  replace-url   Replace the wp home url
  restore       Restore a sql backup to your wp instance

Options:
  -h, --help    Shows this help information

EOF
}

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      backup)
        shift
        "$HOST_SCRIPTS/db_backup.sh" $@
        exit
        ;;

      restore)
        shift
        "$HOST_SCRIPTS/db_restore.sh" $@
        exit
        ;;

      replace-home-url)
        shift
        "$HOST_SCRIPTS/db_replace_url.sh" $@
        exit
        ;;

      replace-home-url)
        shift
        "$HOST_SCRIPTS/db_replace_url.sh" $@
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