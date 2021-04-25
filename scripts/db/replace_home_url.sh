#!/bin/bash

# This script replaces the currently active wordpress home url 
# with the url that is given as one of the params
# if no change is required, the script quits without accessing mysql

source /scripts/clean_url.sh
source /scripts/get_home_url.sh
source /scripts/messages.sh

function commands_and_options {
cat << EOF
Options:

  -u, --user [db username]    Username for mysql connection
  -p, --pass [db pass]        Password for mysql user
  -s, --schema [db schema]    Wordpress mysql schema
  -a, --new-url [new wp url]  New url to be used by wordpress

EOF
}

DB_USER=""
DB_PASS=""
DB_NAME=""
NEW_URL=""

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -u|--user)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          DB_USER=$2
          shift 2
        else
          missing_argument_error $1
          exit 1
        fi
        ;;

      -p|--pass)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          DB_PASS=$2
          shift 2
        else
          missing_argument_error $1
          exit 1
        fi
        ;;

      -s|--schema)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          DB_NAME=$2
          shift 2
        else
          missing_argument_error $1
          exit 1
        fi
        ;;

      -n|--new-url)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          NEW_URL=$(clean_url $2)
          shift 2
        else
          missing_argument_error $1
          exit 1
        fi
        ;;

      -*|--*=) # unsupported flags
        unsupported_flag_error $1
        commands_and_options
        exit 1
        ;;

      *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
    esac
  done
  eval set -- "$PARAMS"
}

function do_replace_home_url {
  CURRENT_URL=$(get_home_url $DB_USER $DB_PASS $DB_NAME)

  if [ -z "$CURRENT_URL" ]; then
    no_home_set_error
    exit 1
  fi

  # Checks whether the urls are different
  if [ "$CURRENT_URL" == "$NEW_URL" ]; then
      echo "Current url and replacement url are the same, quitting without change"
      exit 0
  else
      echo "Replacing $CURRENT_URL with $NEW_URL"
  fi

  # Does the replacement
  read -r -d '' REPLACE_QUERY << EOM
  START TRANSACTION;

  UPDATE wp_options 
  SET option_value = replace(option_value, '$CURRENT_URL', '$NEW_URL') 
  WHERE option_name = 'home' OR option_name = 'siteurl';

  UPDATE wp_posts 
  SET guid = replace(guid, '$CURRENT_URL','$NEW_URL');

  UPDATE wp_posts 
  SET post_content = replace(post_content, '$CURRENT_URL', '$NEW_URL');

  UPDATE wp_postmeta 
  SET meta_value = replace(meta_value,'$CURRENT_URL','$NEW_URL');

  COMMIT;
EOM

  mysql \
    --user="$DB_USER" \
    --password="$DB_PASS" \
    --database="$DB_NAME" \
    --execute="$REPLACE_QUERY" > /dev/null
}

parse_args $@
do_replace_home_url