source .env

NEW_URL=$1

read -r -d '' COMMAND << EOM
  /scripts/replace_url.sh \
    --user root \
    --pass ${DB_ROOT_PASS} \
    --schema ${DB_NAME} \
    --new-url ${NEW_URL}
EOM

docker exec "${THEME_NAME}__db" bash -c "$COMMAND" \
  &> /dev/null
