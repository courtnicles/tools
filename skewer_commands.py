#!/usr/bin/env python
import csv

# Function to parse the sample sheet and generate skewer commands
def generate_skewer_commands(sample_sheet_path):
    commands = []

    with open(sample_sheet_path, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            # Adjust these column names based on your sample sheet
            sample_name = row['Sample_ID']
           # index = row['index']
           # index2 = row['index2']
            fastq1 = row['Fastq1']   # Forward reads
            fastq2 = row['Fastq2']   # Reverse reads
            
            # Construct the skewer command
            skewer_cmd = f"skewer -x AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -y AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -m pe {fastq1} {fastq2}"
            
            # Append the command to the list
            commands.append(skewer_cmd)

    return commands


# Function to write commands to a file
def write_commands_to_file(commands, output_path):
    with open(output_path, 'w') as outfile:
        for cmd in commands:
            outfile.write(cmd + '\n')

# Example usage
sample_sheet_path = 'merged_file.csv'
output_commands_path = 'skewer_commands.sh'

commands = generate_skewer_commands(sample_sheet_path)
write_commands_to_file(commands, output_commands_path)

print(f"Skewer commands written to {output_commands_path}")
