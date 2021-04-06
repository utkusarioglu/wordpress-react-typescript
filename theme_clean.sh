#!/bin/bash

cd theme
ls --hide=react-src | xargs -d '\n' rm -rf

cd react-src
rm -rf node_modules
rm -rf build

cat << EOF
All non-essential files have been removed from the theme directory.
You can run bootstrap.sh to restore dependencies and other runtime files.
EOF