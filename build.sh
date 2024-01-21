#!/bin/bash

#sync
rm -rf .repo/local_manifests
repo init -u https://github.com/crdroidandroid/android.git -b 13.0 --git-lfs
git clone https://github.com/sundrams-playground/local_manifests.git -b tiramisu .repo/local_manifests
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

# fetch submodule
cd kernel/samsung/m30s
git submodule init && git submodule update
touch Android.mk
cd ../../..

# build
. build/envsetup.sh
lunch lineage_m307f-userdebug
mka bacon
