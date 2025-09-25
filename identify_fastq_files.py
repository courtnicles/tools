#!/usr/bin/env python
import os
from os import getcwd
import csv

def find_fastq_files(directory, sample_ids, r1_pattern='_R1', r2_pattern='_R2'):
    sample_fastq_paths = []
    print(directory)

    for sample_id in sample_ids:
        fastq1_path = ''
        fastq2_path = ''

        for root, _, files in os.walk(directory):
            for file in files:
                if sample_id in file:
                    if r1_pattern in file and file.endswith('.fastq.gz'):
                        fastq1_path = os.path.join(root, file)
                    elif r2_pattern in file and file.endswith('.fastq.gz'):
                        fastq2_path = os.path.join(root, file)
        
        if fastq1_path and fastq2_path:
            sample_fastq_paths.append([sample_id, fastq1_path, fastq2_path])
        else:
            print(f"Warning: FASTQ files for Sample_ID {sample_id} not found or incomplete.")
    
    return sample_fastq_paths


def write_fastq_paths_to_csv(output_path, sample_fastq_paths):
    with open(output_path, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Sample_ID', 'Fastq1', 'Fastq2'])
        for row in sample_fastq_paths:
            writer.writerow(row)

def read_sample_ids(file_path):
    sample_ids = []
    with open(file_path, 'r') as file:
        for line in file:
            sample_ids.append(line.split(',')[0])
    return sample_ids

# Replace this line in Example usage
sample_ids = read_sample_ids('sample_sheet.csv')

# Example usage
#sample_ids = ['sample1', 'sample2', 'sample3']  # Replace this with reading sample IDs from a file or another source
startdir = getcwd()
directory = startdir + '/demux'  # Directory where demultiplexed FASTQ files are stored
output_csv_path = 'fastq_paths.csv'

sample_fastq_paths = find_fastq_files(directory, sample_ids)
write_fastq_paths_to_csv(output_csv_path, sample_fastq_paths)

print(f"FASTQ file paths written to {output_csv_path}")
