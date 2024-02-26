#!/bin/bash

# init and sync
repo init -u https://github.com/AOSPA/manifest -b uvite
repo sync --current-branch --no-tags -j$(nproc --all)
