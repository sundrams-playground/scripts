#!/bin/bash

# init and sync
repo init -u https://github.com/AOSPA/manifest -b uvite
git clone https://github.com/xyz-sundram/local_manifest.git -b uvite .repo/local_manifests
repo sync --current-branch --no-tags -j$(nproc --all) --force-sync

# build rom
source build/envsetup.sh
lunch aospa_tulip-eng
./rom-build.sh tulip -t eng
