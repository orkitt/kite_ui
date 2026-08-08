#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="lib"
OUTPUT_DIR="files"
MANIFEST="manifest.json"

mkdir -p "$OUTPUT_DIR"
rm -f "$OUTPUT_DIR"/*.tml

echo "Generating templates..."

# Start manifest
cat > "$MANIFEST" <<'EOF'
{
  "schemaVersion": 2,
  "id": "project.vanilla",
  "version": "1.0.0",
  "description": "Lightweight Flutter vanilla project foundation.",
  "dependencies": [],
  "devDependencies": [],
  "files": [
EOF

first=true

find "$SOURCE_DIR" -type f | sort | while read -r file; do
  filename="$(basename "$file")"
  template_name="${filename}.tml"

  # Detect duplicate flattened filenames
  if [[ -f "$OUTPUT_DIR/$template_name" ]]; then
    echo "✗ Duplicate filename detected: $filename"
    echo "  Source: $file"
    exit 1
  fi

  # Copy source file -> files/file.dart.tml
  cp "$file" "$OUTPUT_DIR/$template_name"

  # lib/foo/bar.dart
  # ->
  # {{config.sourceDirectory}}/foo/bar.dart
  relative_path="${file#"$SOURCE_DIR"/}"
  target="{{config.sourceDirectory}}/$relative_path"

  if [[ "$first" == true ]]; then
    first=false
  else
    echo "," >> "$MANIFEST"
  fi

  cat >> "$MANIFEST" <<EOF
    {
      "template": "files/$template_name",
      "target": "$target",
      "upgradePolicy": "replace"
    }
EOF

  echo "✓ $file -> $OUTPUT_DIR/$template_name"
done

cat >> "$MANIFEST" <<'EOF'

  ],
  "requires": []
}
EOF

echo
echo "✓ Templates generated"
echo "✓ Manifest generated: $MANIFEST"


# #!/usr/bin/env bash

# set -e

# SOURCE_DIR="lib"
# TARGET_DIR="files"

# mkdir -p "$TARGET_DIR"
# rm -f "$TARGET_DIR"/*

# find "$SOURCE_DIR" -type f | while read -r file; do
#   filename="$(basename "$file")"

#   cp "$file" "$TARGET_DIR/${filename}.tml"

#   echo "✓ $file -> $TARGET_DIR/${filename}.tml"
# done

# echo
# echo "Done."
