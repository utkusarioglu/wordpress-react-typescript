#! /bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Theme Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt theme [options] [COMMAND]

Commands:
  clean               Remove runtime files created by React WordPress 
                      theme scripts.
  build               Build the WordPress theme and place it inside 
                      <root>/build directory
  package             Create theme package at <root>/$THEME_NAME.zip
  get-active-plugins  Get plugins that are active in wp dev database 

Options:
  -h, --help    Shows this help information

EOF
}

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

      package)
        shift
        "$HOST_SCRIPTS/theme_package.sh" $@
        exit
        ;;

      get-active-plugins)
        shift
        "$HOST_SCRIPTS/theme_active_plugins.sh" $@
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