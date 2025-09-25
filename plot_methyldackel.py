#!/usr/bin/env python

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Example data
df = pd.read_csv((input('Please enter csv name: ')))
positions = df[1]
methylation_percent = df[3]
conditions = df[0]

# Create a color dictionary for conditions
#color_dict = {'Condition A': 'blue', 'Condition B': 'green', 'Condition C': 'red'}
#colors = [color_dict[cond] for cond in conditions]

# Plotting
plt.figure(figsize=(10, 6))
bars = plt.bar(positions, methylation_percent, tick_label=positions)

# Adding labels on the bars
for bar, cond in zip(bars, conditions):
    plt.text(bar.get_x() + bar.get_width() / 2.0, bar.get_height(), f'{cond}\n{bar.get_height()}%', ha='center', va='bottom')

# Labeling axes
plt.xlabel('Position')
plt.ylabel('Percent Methylation')

# Adding title and subtitle
plt.suptitle('Methylation Analysis', fontsize=16)  # Main title
plt.title('Position vs. Percent Methylation by Condition', fontsize=10, color='gray')  # Subtitle

# Show the plot
plt.show()
