library(readxl)
library(dplyr)
library(ggplot2)

# Initialize an empty list to store data from each tab
data_list <- list()

# Define the file path to your Excel file
file_path <- "/Users/nguyec27/Downloads/Run00001-lipid-training.uni-2025-06-17T11-26-34.xlsx"

# Loop through each tab, read the data, skip the first three rows, and store in the list
for (tab in c("A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1", "I1", "J1", "K1", "L1", "M1", "N1", "O1", "P1")) {
  # Read the data from the tab skipping the first three rows, and setting the header name at row 4
  tab_data <- read_excel(file_path, sheet = tab, skip = 3)
  
  # Append the tab data to the list
  data_list[[tab]] <- tab_data
}

# Combine all data frames in the list into a single data frame
compiled_data <- bind_rows(data_list, .id = "Sample")

# Create a new column 'Lipid' based on the conditions for different sample groups
compiled_data <- compiled_data %>%
  mutate(Lipid = case_when(
    Sample %in% c('A1', 'B1', 'C1') ~ 'SEA Guardband Lipid (+10% Hexadecane, PDM20) L044',
    Sample %in% c('D1', 'E1', 'F1') ~ 'Bulk Q1 Lipid LM_2025_Q1_Jan_001',
    Sample %in% c('G1', 'H1', 'I1') ~ 'Bulk Q1 Lipid LM_2025_Q1_Jan_002',
    Sample %in% c('J1', 'K1', 'L1') ~ 'Bulk Q1 Lipid LM_2025_Q1_Jan_003',
    Sample %in% c('M1', 'N1', 'O1') ~ 'SR Kitted Q3 Lipid LM_2024_Q3_Jul_001_800 ml',
    Sample == 'P1' ~ 'Water',
    TRUE ~ NA_character_
  ))

# Optionally, write the compiled data to a new Excel file
write.csv(compiled_data, "compiled_data.csv", row.names = FALSE)

# Aggregate the data by 'Temperature' and 'Lipid', calculating the mean of 'BCM / nm'
aggregated_data <- compiled_data %>%
  group_by(Temperature, Lipid) %>%
  summarize(mean_BCM_nm = mean(`BCM / nm`, na.rm = TRUE))

# Print the aggregated data to verify
print(aggregated_data)

# Plot using ggplot2 with LOESS smoothing
ggplot(aggregated_data, aes(x = Temperature, y = mean_BCM_nm, color = Lipid, group = Lipid)) + 
  geom_point(alpha = 0.5) + 
  geom_smooth(method = "loess", se = FALSE) + 
  labs(title = "Mean BCM vs Temperature by Lipid Group (LOESS Smoothing)", x = "Temperature", y = "Mean BCM / nm") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Save the plot to a file
ggsave("Mean_BCM_vs_Temperature_by_Lipid_LOESS.png")

