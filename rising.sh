#!/bin/bash

# init and sync
rm -rf .repo/local_manifests
repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs
git clone https://github.com/xyz-sundram/local_manifest.git -b rising .repo/local_manifests
repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j$(nproc --all)

rm -rf hardware/qcom-caf/common/
git clone https://github.com/xyz-sundram/android_hardware_qcom-caf_common.git hardware/qcom-caf/common/

# build rom
source build/envsetup.sh
lunch rising_tulip-userdebug
mka bacon

# crave build command
# crave run --no-patch "rm -rf rising.sh && wget https://raw.githubusercontent.com/sundrams-playground/scripts/main/rising.sh && chmod +x rising.sh && bash rising.sh"
