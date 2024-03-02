#!/bin/bash

# init and sync
repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs
git clone https://github.com/xyz-sundram/local_manifest.git -b rising .repo/local_manifests
repo sync --current-branch --no-tags -j$(nproc --all) --force-sync

# build rom
source build/envsetup.sh
lunch rising_tulip-userdebug
m bacon
