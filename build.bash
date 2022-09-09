#!/usr/bin/env bash

set -euo pipefail

# install run script
install -Dm0755 run.bash "${FLATPAK_DEST}/bin/breitbandmessung"

# install apply_extra script
install -Dm0755 apply_extra.bash "${FLATPAK_DEST}/bin/apply_extra"
sed -i "s/__FLATPAK_ID__/$FLATPAK_ID/g" "${FLATPAK_DEST}/bin/apply_extra"

# lsb-release so that Breitbandmessung thinks is running on a normal system
install -D lsb-release "${FLATPAK_DEST}/etc/lsb-release"
