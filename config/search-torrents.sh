#!/bin/bash

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <argument1> <argument2> ... <argumentN>"
  exit 1
fi

# Concatenate all arguments into a single string
s="$*"

websites=(
  "https://www.duckduckgo.com/?q=!+site:imdb.com+${s}"
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
  echo -e "🚀 Opening \e[32m$url\e[0m"
  vivaldi --incognito "$url"
  echo ""
  sleep 0.2
done

# Wait for all background processes to finish
wait

# Kill the terminal
echo "Closing terminal..."
sleep 1
kill -9 $PPID
