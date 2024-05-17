#!/bin/bash

TOKEN="$bot_token"
CHAT_ID="$chat_id"

## Function to send Telegram message
send_telegram_message() {
    local message="$1"
    curl -s -X POST \
        https://api.telegram.org/bot$TOKEN/sendMessage \
        -d chat_id=$CHAT_ID \
        -d text="$message" \
        -d parse_mode="Markdown"
}

## Function to Upload files
upload_file() {
    echo "Uploading Build..."
    local file_path="$1"
    local server_info=$(curl -s -X GET 'https://api.gofile.io/servers')
    local server=$(echo "$server_info" | jq -r '.data.servers[0].name')
    local upload_result=$(curl -s -X POST "https://$server.gofile.io/contents/uploadfile" -F "file=@$file_path")
    local download_link=$(echo "$upload_result" | jq -r '.data.downloadPage')
    local file_Name=$(echo "$upload_result" | jq -r '.data.fileName')
    local md5=$(echo "$upload_result" | jq -r '.data.md5')
    local timestamp=$(date +"%b %d %H:%M:%S UTC %Y")

    # Send details on Telegram
    send_telegram_message "File Name: $file_Name  %0ATimestamp: $timestamp %0Amd5: $md5 %0ADownload link: $download_link"
}

## Notify
send_telegram_message "Evolution X build for M30s has been started"

## Clean up
.repo/local_manifests

build_m307f() {
    repo init -u https://github.com/Evolution-XYZ/manifest -b udc --git-lfs
    git clone https://github.com/sundrams-playground/local_manifests.git -b udc .repo/local_manifests
    repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
    . build/envsetup.sh
    export WITH_GMS=true
    lunch lineage_m307f-userdebug
    m installclean
    m evolution
}

#build_m307f
if [ $? -ne 0 ]; then
    send_telegram_message "Build Failed :("
    exit 1
fi

send_telegram_message "Evolution X Build for M307f Completed !"

# Upload
filepath=$(find out/target/product/m307f/ -name 'Evolution*.zip' -print -quit)
echo "File: $filepath"
upload_file "$filepath"

