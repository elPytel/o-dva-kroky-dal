#!/bin/bash

# Default values
WORDS_PER_PAGE=250
SHOW_PAGES=false
REPO_DIR="."

# help function
function show_help {
    echo "Usage: $0 [options] [directory]"
    echo "Options:"
    echo "  -p, --pages [words_per_page]   Show approximate page count (default: 250 words/page)"
    echo "  -h, --help                     Show this help message"
    echo "Arguments:"
    echo "  directory                       Directory to scan (default: current directory)"
}

# clean md front matter from word count
function clean_front_matter {
    # If argument exists, use it as file, otherwise read from stdin
    local input="${1:-/dev/stdin}"
    awk '
        BEGIN{in_fm=0}
        NR==1 && $0 ~ /^---[[:space:]]*$/ {in_fm=1; next}
        in_fm==1 && $0 ~ /^---[[:space:]]*$/ {in_fm=0; next}
        { if(!in_fm) print }
    ' "$input"
}

# remove markdown code blocks from word count
function clean_code_blocks {
    # If argument exists, use it as file, otherwise read from stdin
    local input="${1:-/dev/stdin}"
    awk '
        BEGIN { in_code=0 }
        /^```/ { in_code = !in_code; next }
        { if(!in_code) print }
    ' "$input"
}

# list of included path functions
function included_paths {
    # Listing files that match the criteria
    find "$REPO_DIR" -type f -name "*.md" \
        -not -path '*/.*' \
        -not -path '*/_site/*' \
        -not -path '*/node_modules/*' \
        -not -path '*/dist/*' \
        -not -path '*/build/*' \
        -not -path '*/kategorie/*' \
        -not -path '*/vendor/*'
}

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
        -h|--help)
            show_help
            exit 0
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
    included_paths
    echo "--- END OF DEBUG LIST ---"

    echo "DEBUG: Showing cleaned content (front matter removed) for each file:"
    included_paths | while IFS= read -r file; do
        echo "---- $file ----"
        clean_front_matter "$file"
    done
fi

# Word count calculation (use included_paths + clean_front_matter)
# - `included_paths` lists files to include
# - `clean_front_matter` removes YAML front matter per-file
# - then count words across cleaned content
TOTAL_WORDS=$(included_paths | while IFS= read -r file; do
    # ensure file is non-empty and exists before processing
    if [ -n "$file" ] && [ -f "$file" ]; then
        clean_front_matter "$file" | clean_code_blocks
    fi
done | wc -w)

# -exec cat {} + | wc -w

echo "Total word count in .md files: $TOTAL_WORDS"

# Page conversion if requested
if [ "$SHOW_PAGES" = true ]; then
    # Integer arithmetic for ceiling division
    PAGES=$(( (TOTAL_WORDS + WORDS_PER_PAGE - 1) / WORDS_PER_PAGE ))
    echo "Approximate pages ($WORDS_PER_PAGE words/page): $PAGES"
fi