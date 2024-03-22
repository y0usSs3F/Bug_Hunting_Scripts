#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory> <word_to_search>"
    exit 1
fi

directory="$1"
word="$2"

for file in "$directory"/*.txt; do
    if [ -f "$file" ] && grep -q "$2" "$file"; then
        filename_only=$(basename "$file")
        echo "the word '$2' found in the file: $filename_only"
    fi
done
