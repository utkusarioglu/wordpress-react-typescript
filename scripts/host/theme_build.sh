#!/bin/bash

source scripts/host/check_env.sh
source .env

# Remove old build
echo "Removing old build..."
rm -rf build

# handle build
echo "Building theme ${THEME_NAME}"
cd theme/react-src 
yarn build
cd ../..

# Remove irrelevant files
echo "Removing clutter..."
cd build
rm ./!READY_TO_DEPLOY!.txt

cat << EOF 

Build complete. You can find your theme in "build".

EOF