#!/usr/bin/env bash

set -euo pipefail

# install asar (later needed for application patching)
npm install "asar@3.2.0" --offline

# install run script
install -Dm0755 run.bash "${FLATPAK_DEST}/bin/breitbandmessung"

# unpack debian package
pushd "$FLATPAK_DEST"
bsdtar -Oxf "${FLATPAK_BUILDER_BUILDDIR}/Breitbandmessung-linux.deb" 'data.tar.*' |
    bsdtar -xf -

# path application to ignore that it is not running on debian
pushd opt/Breitbandmessung/resources
"${FLATPAK_BUILDER_BUILDDIR}/node_modules/asar/bin/asar.js" e app.asar unpacked/
sed -i 's/allowed:!1/allowed:!0/g' unpacked/build/static/js/*.js
sed -i 's/case"linux":/case"linux":break;/g' unpacked/build/static/js/*.js
"${FLATPAK_BUILDER_BUILDDIR}/node_modules/asar/bin/asar.js" p unpacked/ app.asar
rm -rf unpacked/

