#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

for file in "$directory"/*.txt; do
    if [ -f "$file" ] && grep -q "200" "$file"; then
        filename_only=$(basename "$file")
        echo "File with '200' found: $filename_only"
    fi
done
