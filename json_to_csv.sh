#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Install it using your package manager (e.g., apt, yum, brew)."
    exit 1
fi

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.json output.csv"
    exit 1
fi

INPUT_JSON="$1"
OUTPUT_CSV="$2"

# Check if the input file exists
if [ ! -f "$INPUT_JSON" ]; then
    echo "Error: File '$INPUT_JSON' not found."
    exit 1
fi

# Extract all keys (Run Names) and use them to build the header
HEADER=$(jq -r 'to_entries | .[0].value | keys_unsorted | ["Run Name"] + . | @csv' "$INPUT_JSON")

# Extract all rows
ROWS=$(jq -r 'to_entries | .[] | ["\(.key)"] + (.value | to_entries | map(.value)) | @csv' "$INPUT_JSON")

# Write to CSV file
{
    echo "$HEADER"
    echo "$ROWS"
} > "$OUTPUT_CSV"

echo "Conversion complete. Output saved to '$OUTPUT_CSV'."
