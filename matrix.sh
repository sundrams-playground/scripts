#!/bin/bash

#sync
rm -rf .repo/local_manifests
repo init -u https://github.com/xyz-sundram/android.git -b 14.0 --git-lfs
git clone https://github.com/xyz-sundram/treble_manifest.git .repo/local_manifests  -b 14
sed -i '/external\/mockito-kotlin/d' .repo/manifest/default.xml
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune

#apply patches
bash patches/apply-patches.sh .

#Generating Rom Makefile
cd device/phh/treble
bash generate.sh crDroid

#compile
. build/envsetup.sh
lunch treble_arm64_bgN-userdebug 
make systemimage -j$(nproc --all)

#compress img
cd out/target/product/tdgsi_arm64_ab
xz -z -k system.img 
