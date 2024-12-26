#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <argument1> <argument2> ... <argumentN>"
  exit 1
fi

s="$*"

websites=(
  "https://1337x.to/search/${s}/1/"
  "https://tprbay.xyz/search/${s}"
  "https://cloudtorrents.com/search?query=${s}"
  "https://www.torrentdownload.info/search?q=${s}"
  "https://torrentgalaxy.to/torrents.php?search=${s}"
  "https://www.limetorrents.lol/search/all/${s}"
)

for url in "${websites[@]}"; do
  vivaldi --incognito "$url" &
done
