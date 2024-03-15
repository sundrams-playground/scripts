#!/bin/bash

# init and sync
rm -rf .repo/local_manifests
repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs
git clone https://github.com/xyz-sundram/local_manifest.git -b rising .repo/local_manifests
repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j$(nproc --all)

#apply patch for custom hal
cd vendor/lineage
curl https://github.com/xyz-sundram/android_vendor_lineage/commit/b6971d2c1293ad8c8eb3eba74d40eec8a6b084b2.patch | git am
cd ../..

# build rom
source build/envsetup.sh
lunch rising_tulip-userdebug
m bacon

# crave build command
# crave run --no-patch "rm -rf rising.sh && wget https://raw.githubusercontent.com/sundrams-playground/scripts/main/rising.sh && chmod +x rising.sh && bash rising.sh"
