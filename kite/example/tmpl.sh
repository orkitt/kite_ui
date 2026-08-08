#!/usr/bin/env bash

set -e

SOURCE_DIR="lib"
TARGET_DIR="files"

mkdir -p "$TARGET_DIR"
rm -f "$TARGET_DIR"/*

find "$SOURCE_DIR" -type f | while read -r file; do
  filename="$(basename "$file")"

  cp "$file" "$TARGET_DIR/${filename}.tml"

  echo "✓ $file -> $TARGET_DIR/${filename}.tml"
done

echo
echo "Done."
