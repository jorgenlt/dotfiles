#!/bin/bash

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <argument1> <argument2> ... <argumentN>"
  exit 1
fi

# Concatenate all arguments into a single string
s="$*"

websites=(
  "https://www.imdb.com/find/?q=${s}"
  "https://www.limetorrents.lol/search/all/${s}"
  "https://torrentgalaxy.to/torrents.php?search=${s}"
  "https://cloudtorrents.com/search?query=${s}"
  "https://www.torrentdownload.info/search?q=${s}"
  "https://tprbay.xyz/search/${s}"
  "https://yts.mx/browse-movies/${s}"
  "https://1337x.to/search/${s}/1/"
)

# Open each URL in Vivaldi browser in incognito mode
for url in "${websites[@]}"; do
  vivaldi --incognito "$url"
done

# Wait for all background processes to finish
wait

# Kill the terminal
kill -9 $PPID
