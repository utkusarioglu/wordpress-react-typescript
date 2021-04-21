#! /bin/bash

source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

function title {
  title_template "Theme Package Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt theme package [options]

Commands:
  <none>        Run the packaging operation

Options:
  -h, --help    Shows this help information

EOF
}

function do_theme_package {
  "$HOST_SCRIPTS/theme_build.sh"

  echo 'Removing previous package...'
  rm -f dist.zip

  echo 'Creating dist.zip'
  cd build
  zip -r ../dist.zip *
  cd ..

  echo 'Removing intermediaries'
  rm -rf build

  theme_packaged_message
}

parse_args_basic $@
do_theme_package