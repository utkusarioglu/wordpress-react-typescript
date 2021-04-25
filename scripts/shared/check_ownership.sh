#! /bin/bash

source scripts/shared/messages.sh

# Checks ownership of the path given in $1
# exits with 1 if it's not equal to current user
function check_ownership {
  OWNER=$(ls -l | awk -v path="$1" '$0~path {print($3)}')
  if [ "$OWNER" != "$USER" ]; then
    permission_error $1 $OWNER
    exit 1
  fi
}