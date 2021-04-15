#!/bin/bash

source .env
# Remove old build
rm -rf build

# handle build
cd theme/react-src 
yarn build

cd ../..

# move the build to the root/build dir
# ! note that theme/theme may cause some errors, it's not clear whether
# ! this name is dependent on css theme name
mkdir -p build/$THEME_NAME
mv theme/theme/* build/$THEME_NAME

# Remove build artifacts. The same piece of code is also used in theme_clean.sh
cd theme
ls --hide=react-src | xargs -d '\n' rm -rf

cat << EOF 

Build complete. You can find your theme in "build/$THEME_NAME".

The build operation removes some files that are necessary for development. 
To mitigate this, you can restart your devcontainer, then you can continue to
work normally.

EOF