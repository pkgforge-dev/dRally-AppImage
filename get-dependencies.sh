#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor \
    sdl2_net

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of dRally..."
echo "---------------------------------------------------------------"
REPO="https://github.com/urxp/dRally"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./dRally
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./dRally
FLAGS="-std=gnu17" make -j$(nproc)
mv -v drally_linux ../AppDir/bin
