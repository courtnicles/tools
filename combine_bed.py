#!/bin/bash

# Define the output TSV file
output_file="combined_output.tsv"

# Write the header to the TSV file
echo -e "filename\tchrom\tstart\tend\tpct_methylation\tnum_alignment_methylated\tnum_alignment_unmethylated" > "$output_file"

# Loop through each .bedGraph file in the current directory
for file in *.bedGraph; do
    # Strip the file extension to get the base filename
    base_filename=$(basename "$file" .bedGraph)
    
    # Use `awk` to skip the first line and add the base filename as a column
    awk -v filename="$base_filename" 'BEGIN { OFS="\t" } NR>1 { print filename, $0 }' "$file" >> "$output_file"
done

echo "All files have been processed and combined into $output_file"
