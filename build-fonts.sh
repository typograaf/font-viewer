#!/bin/bash
# Scans the fonts/ directory and generates fonts.json
# Usage: ./build-fonts.sh

FONTS_DIR="$(dirname "$0")/fonts"
OUTPUT="$(dirname "$0")/fonts.json"

echo "[" > "$OUTPUT"
first=true

for f in "$FONTS_DIR"/*.{ttf,otf,woff,woff2,TTF,OTF,WOFF,WOFF2}; do
  [ -f "$f" ] || continue
  filename=$(basename "$f")
  # Use filename without extension as the font name, replace hyphens/underscores with spaces
  name="${filename%.*}"
  name=$(echo "$name" | sed 's/[-_]/ /g')

  if [ "$first" = true ]; then
    first=false
  else
    echo "," >> "$OUTPUT"
  fi

  printf '  { "name": "%s", "file": "%s" }' "$name" "$filename" >> "$OUTPUT"
done

echo "" >> "$OUTPUT"
echo "]" >> "$OUTPUT"

count=$(grep -c '"file"' "$OUTPUT" || echo 0)
echo "Generated fonts.json with $count font(s)."
