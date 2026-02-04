#!/bin/bash

# Default values
WORDS_PER_PAGE=250
SHOW_PAGES=false
REPO_DIR="."

# Argument parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--pages)
            SHOW_PAGES=true
            if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
                WORDS_PER_PAGE=$2
                shift
            fi
            shift
        ;;
        *)
            REPO_DIR="$1"
            shift
        ;;
    esac
done

# Check if directory exists
if [ ! -d "$REPO_DIR" ]; then
    echo "Error: Directory '$REPO_DIR' does not exist."
    exit 1
fi

# Debug section: list files if DEBUG environment variable is set
if [ "$DEBUG" = "1" ]; then
  echo "--- DEBUG: List of found .md files ---"
  # Listing files that match the criteria
  find "$REPO_DIR" -type f -name "*.md" \
    -not -path '*/.*' \
    -not -path '*/node_modules/*' \
    -not -path '*/dist/*' \
    -not -path '*/vendor/*' \
    -not -path '*/build/*'
  echo "--- END OF DEBUG LIST ---"
fi

# Word count calculation
# - find: locate all .md files
# - exec cat: stream content
# - wc -w: count words
TOTAL_WORDS=$(find "$REPO_DIR" -type f -name "*.md" \
  -not -path '*/.*' \
  -not -path '*/_site/*' \
  -not -path '*/node_modules/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  -not -path '*/kategorie/*' \
  -not -path '*/vendor/*' \
  -exec sed '1{/^---$/{:a;n;/^---$/!ba;d}}' {} + | wc -w)

# -exec cat {} + | wc -w

echo "Total word count in .md files: $TOTAL_WORDS"

# Page conversion if requested
if [ "$SHOW_PAGES" = true ]; then
    # Integer arithmetic for ceiling division
    PAGES=$(( (TOTAL_WORDS + WORDS_PER_PAGE - 1) / WORDS_PER_PAGE ))
    echo "Approximate pages ($WORDS_PER_PAGE words/page): $PAGES"
fi