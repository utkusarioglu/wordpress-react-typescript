#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh
source scripts/shared/exit_if_in_devcontainer.sh

function title {
  title_template "Docker Prune Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt docker prune [options]

Commands:
  (none)        Take a sql backup and then run the docker prune operation 

Options:
  -n, --no-backup                         Skip taking the sql backup
  -b, --backup-filename [sql filename]    Set custom sql filename
  -h, --help                              Shows this help information

EOF
}

no_backup=FALSE
backup_file=""

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -n|--no-backup)
        no_backup=TRUE
        shift
        ;;

      -b|--backup-filename)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          backup_file=$2
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;

      *)
        parse_args_essential title commands_and_options $@
    esac
  done
  eval set -- "$PARAMS"
}

function do_docker_prune {
  echo "Running pruning for ${THEME_NAME}..."

  if [[ $no_backup == TRUE ]]; then
    echo "Skipping db backup creation upon user command"
  else
    if [ -z $backup_file ]; then
      bash "${HOST_SCRIPTS}/db_backup.sh"
    else 
      bash "${HOST_SCRIPTS}/db_backup.sh" -f $backup_file
    fi
  fi

  echo "Cleaning containers, volumes, and networks"

  for command in 'stop' 'rm';
  do
    docker container $command \
      "${WP_CONTAINER_NAME}" \
      "${DB_CONTAINER_NAME}" 1> /dev/null
  done;  

  repo_name="$(basename "$PWD")"
  docker volume rm "${repo_name}_db" 1> /dev/null
  docker network rm "${repo_name}_default" 1> /dev/null
}

parse_args $@
do_docker_prune