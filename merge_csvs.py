#!/usr/bin/env python

import pandas as pd

# Load the two CSV files
csv1 = pd.read_csv('sample_sheet.csv')
csv2 = pd.read_csv('fastq_paths.csv')

# Merge the two dataframes on the common column (e.g., 'id')
merged_df = pd.merge(csv1, csv2, on='Sample_ID')

# Save the merged dataframe to a new CSV file
merged_df.to_csv('merged_file.csv', index=False)

print("The CSV files have been successfully merged and saved as 'merged_file.csv'.")
