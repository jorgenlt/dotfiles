#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./copy-with-date.sh -s "/path/to/portfolio-master.xlsm" -d "/path/to/destination/dir" [-b "portfolio"]

usage() {
  echo "Usage: $(basename "$0") -s SOURCE -d DEST_DIR [-b BASE]"
  echo
  echo "Options:"
  echo "  -s SOURCE     Path to the source file (e.g., portfolio-master.xlsm)"
  echo "  -d DEST_DIR   Destination directory where the new file will be placed"
  echo "  -b BASE       Optional base name to use before the date (default derived from source)"
  echo "  -h            Show this help message"
}

# Parse options
while getopts "s:d:b:h" opt; do
  case "$opt" in
    s) SOURCE="$OPTARG" ;;
    d) DEST_DIR="$OPTARG" ;;
    b) BASE_OVERRIDE="$OPTARG" ;;
    h) usage; exit 0 ;;
    *) echo "Invalid option"; usage; exit 1 ;;
  esac
done

# Validate required arguments
if [[ -z "${SOURCE:-}" || -z "${DEST_DIR:-}" ]]; then
  echo "Error: SOURCE and DEST_DIR are required."
  usage
  exit 1
fi

# Today’s date in the required format
TODAY=$(date +%Y-%m-%d-%s)

# Preserve the original extension
EXT="${SOURCE##*.}"

# Determine base name
if [[ -n "${BASE_OVERRIDE:-}" ]]; then
  BASE="$BASE_OVERRIDE"
else
  # Derive from source filename without extension
  BASENAME_WITHEXT="$(basename -- "$SOURCE")"
  BASE_NO_EXT="${BASENAME_WITHEXT%.*}"  # remove extension
  # If it ends with "-master", strip that suffix to match example
  if [[ "$BASE_NO_EXT" == *"-master" ]]; then
    BASE="${BASE_NO_EXT%-master}"
  else
    BASE="$BASE_NO_EXT"
  fi
fi

# Ensure destination directory exists
mkdir -p "$DEST_DIR"

# Destination file path
DEST_FILE="${DEST_DIR%/}/${BASE}-${TODAY}.${EXT}"

# Copy the file
cp -v "$SOURCE" "$DEST_FILE"

echo "Copied '$SOURCE' to '$DEST_FILE'."
