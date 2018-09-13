#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2018
# manually fix files that haven't been properly uploaded by chie.sh
# usage: ./chie.fix.sh [url copied from oneindex] [filename from oneindex] [modified time in unix timestamp format from oneindex]
# here we fockin' go
remote="" # your google drive remote on rclone, pls don't include ":"
baseurl="" # your oneindex website's root, pls don't include "/"

url="$1"
aria2c -x 128 -s 128 "$url"
relativepath=${url##$baseurl}
relativepath=${relativepath%/*}
touch -d @$3 "$2"
rclone move "$2" "$remote:$relativepath" --checksum -vv --low-level-retries=8 --drive-chunk-size=128M --fast-list
