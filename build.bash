#!/usr/bin/env bash

set -euo pipefail

# install run script
install -Dm0755 run.bash "${FLATPAK_DEST}/bin/breitbandmessung"

# lsb-release so that Breitbandmessung thinks is running on a normal system
install -D lsb-release "${FLATPAK_DEST}/etc/lsb-release"

# unpack debian package
pushd "$FLATPAK_DEST"
bsdtar -Oxf "${FLATPAK_BUILDER_BUILDDIR}/Breitbandmessung-linux.deb" 'data.tar.*' |
    bsdtar -xf -

# /usr/share => /share
cp -R usr/* .
rm -rf usr

# .desktop file
mv share/applications/breitbandmessung.desktop "share/applications/$FLATPAK_ID.desktop"
desktop-file-edit --set-key=Exec --set-value=breitbandmessung "share/applications/$FLATPAK_ID.desktop"
desktop-file-edit --set-key=Icon --set-value="$FLATPAK_ID" "share/applications/$FLATPAK_ID.desktop"

# rename icons and remove large sizes
find share/icons -name 'breitbandmessung.*' -path '*1024*' -delete
find share/icons -name 'breitbandmessung.*' -exec rename -v breitbandmessung "$FLATPAK_ID" {} \;
