library(tidyverse)
library(arrow)
library(lubridate)
library(dplyr)
library(caret)

house_static_data <- read_parquet("C:/Users/sohai/Documents/energy_consumption_ds/data/house_static_data.parquet")
all_county_weather_data <- read_csv("C:/Users/sohai/Documents/energy_consumption_ds/data/weather_data/weather_all_county_data.csv")
all_houses_energy_data <- read_parquet("C:/Users/sohai/Documents/energy_consumption_ds/data/complete_house_data.parquet")

# Extract the date and time from the 'date_time' column
all_county_weather_data$date <- as.Date(all_county_weather_data$date_time)
all_county_weather_data$time <- format(all_county_weather_data$date_time, "%H:%M:%S")
glimpse(all_county_weather_data)
colnames(house_static_data)
  
colSums(is.na(house_static_data))

cor(house_static_data %>% select(where(is.numeric)))
str(all_houses_energy_data)
sample_n(house_static_data, 10)

correlation_matrix <- cor(house_static_data %>% select(where(is.numeric)))
high_correlation <- findCorrelation(correlation_matrix, cutoff = 0.9)
high_correlation  # indices of highly correlated columns (correlation > 0.9)

colnames(house_static_data)[high_correlation]

categorical_columns <- house_static_data %>% select(where(is.factor))
sapply(categorical_columns, function(x) length(unique(x)))

house_static_data_cleaned <- house_static_data %>%
  select(-c(bldg_id, in.weather_file_latitude, in.weather_file_longitude))  # Example of columns to drop


ggplot(house_static_data_cleaned, aes(x = in.sqft)) +
  geom_bar() +
  labs(title = "Distribution of Square Footage", x = "Square Footage", y = "Frequency")

ggplot(house_static_data_cleaned, aes(x = in.income)) +
  geom_bar() +
  labs(title = "Distribution of Income", x = "Income", y = "Frequency")

# Ensure the time column is in datetime format
all_houses_energy_data$time <- as.POSIXct(all_houses_energy_data$time, format = "%Y-%m-%d %H:%M:%S")

# Filter data for the month of July
july_data <- all_houses_energy_data[format(all_houses_energy_data$time, "%m") == "07", ]

write.csv(july_data, "C:/Users/sohai/Documents/energy_consumption_ds/data/july_energy_model_data.csv", row.names = FALSE)
