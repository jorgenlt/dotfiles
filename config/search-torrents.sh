#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <argument>"
  exit 1
fi

search=$1

websites=(
  "https://1337x.to/search/${search}/1/"
  "https://tprbay.xyz/search/${search}"
  "https://cloudtorrents.com/search?query=${search}"
  "https://www.torrentdownload.info/search?q=${search}"
)

for url in "${websites[@]}"; do
  xdg-open "$url" &
done
