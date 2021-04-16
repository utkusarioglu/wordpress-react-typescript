#! /bin/bash

# adds .sql extension to the file if it's absent
function sanitize_sql_filename {
  if [ "${1:(-4)}" == '.sql' ]; then
    filename=$1
  else
    filename="$1.sql"
  fi
  echo $filename
}