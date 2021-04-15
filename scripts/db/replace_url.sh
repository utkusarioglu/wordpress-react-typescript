#!/bin/bash

# This script replaces the currently active wordpress home url 
# with the url that is given as one of the params
# if no change is required, the script quits without accessing mysql

source /scripts/clean_url.sh
source /scripts/get_current_url.sh

function invalid_flag_error {
cat >&2 << EOF

Operation failed. $1 is not a recognized flag. 
Available flags are listed below:

-u, --user [db username] : Username for mysql connection
-p, --pass [db pass] : Password for mysql user
-s, --schema [db schema] : Wordpress mysql schema
-a, --new-url [new wp url] : New url to be used by wordpress

EOF
}

DB_USER=""
DB_PASS=""
DB_NAME=""
NEW_URL=""

# Parses input params to the relevant variables listed above
function handle_input {
  while test $# -gt 0; do
    case "$1" in
      -u|--user)
        shift
        DB_USER=$1
        shift
        ;;&

      -p|--pass)
        shift
        DB_PASS=$1
        shift
        ;;&

      -s|--schema)
        shift
        DB_NAME=$1
        shift
        ;;&

      -a|--new-url)
        shift
        NEW_URL=$(clean_url $1)
        shift
        ;;&

      *)
        # TODO find a way to avoid this empty string check
        if [ ! -z "$1" ]; then
          invalid_flag_error $1
          # exit 1;
        fi
      ;;
    esac
  done 
}
handle_input $@

CURRENT_URL=$(get_current_url $DB_USER $DB_PASS $DB_NAME)

# Checks whether the urls are different
if [ $CURRENT_URL == $NEW_URL ]; then
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
mysql --user="$DB_USER" --password="$DB_PASS" --database="$DB_NAME" --execute="$REPLACE_QUERY"
