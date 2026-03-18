#!/bin/bash
# Adds review frontmatter + banner to song files that don't already have it.
# Safe to run multiple times — skips files that already have frontmatter.

SONGS_DIR="$(cd "$(dirname "$0")/../songs" && pwd)"
BANNER='> **Note:** This content was generated with AI assistance and has not yet been reviewed for theological accuracy. Please read with discernment and compare with Scripture.'

for file in "$SONGS_DIR"/*.md; do
  [ -f "$file" ] || continue

  # Skip if file already has frontmatter
  if head -1 "$file" | grep -q "^---$"; then
    echo "SKIP (already has frontmatter): $(basename "$file")"
    continue
  fi

  echo "ADDING: $(basename "$file")"

  # Build new content: frontmatter + banner + original
  {
    echo "---"
    echo "reviewed: false"
    echo "reviewed_by:"
    echo "reviewed_date:"
    echo "---"
    echo ""
    echo "$BANNER"
    echo ""
    cat "$file"
  } > "${file}.tmp" && mv "${file}.tmp" "$file"
done

echo ""
echo "Done. Review status can be updated by editing the frontmatter in each file."
