#!/bin/bash

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <search query>"
  exit 1
fi

# Concatenate all arguments into a single string
s="$*"

websites=(
  "https://www.duckduckgo.com/?q=!+site:imdb.com+${s}"
  "https://eztvx.to/search/${s}"
  "https://www.torlock.com/?qq=1&q=${s}"
  "https://www.limetorrents.lol/search/all/${s}"
  "https://torrentgalaxy.to/torrents.php?search=${s}"
  "https://cloudtorrents.com/search?query=${s}"
  "https://www.torrentdownload.info/search?q=${s}"
  "https://tpb.party/search/${s}"
  "https://www.yts-official.cc/browse-movies?keyword=${s}"
  "https://x1337x.cc/search/${s}/1/"
)

echo "Opening ${#websites[@]} URLs in Vivaldi..."
echo ""

for url in "${websites[@]}"; do
  echo -e "🌐 \e[32m$url\e[0m"
done

# Open all URLs in ONE browser process
vivaldi \
  --incognito \
  --new-window \
  "${websites[@]}" \
  >/dev/null 2>&1 &

disown

echo ""
echo "Done."

# Wait for all background processes to finish
wait

# Kill the terminal
echo ""
echo "Closing terminal..."
sleep 2
kill -9 $PPID
