#! /bin/bash

source scripts/shared/vars.sh

"$HOST_SCRIPTS/theme_build.sh"

echo 'Removing previous dist...'
rm -f dist.zip

echo 'Creating dist.zip'
cd build
zip -r ../dist.zip *
cd ..

echo 'Removing intermediaries'
rm -rf build

echo 'done'