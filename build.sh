#!/bin/bash

#sync
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs
git clone https://github.com/sundrams-playground/local_manifests.git -b udc .repo/local_manifests
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

# build
. build/envsetup.sh
lunch lineage_m307f-eng
mka bacon
