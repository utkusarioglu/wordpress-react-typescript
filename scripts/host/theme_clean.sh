#!/bin/bash

source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Theme Clean Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt theme clean [options]

Commands:
  <none>        Run the clean operation

Options:
  -h, --help    Shows this help information

EOF
}

function do_theme_clean {
  cd theme
  ls --hide=react-src | xargs -d '\n' rm -rf

  cd react-src
  rm -rf node_modules
  rm -rf build

  theme_cleaned_message
}

parse_args_basic $@
do_theme_clean