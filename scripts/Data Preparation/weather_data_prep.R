install.packages(c("tidyverse", "data.table", "caret", "randomForest", 
                   "xgboost", "shiny", "shinydashboard", "lubridate", 
                   "arrow", "e1071","ggplot","dplyr"))

library(tidyverse)
library(arrow)
library(dplyr)
library(readr)
library(stringr)

static_house_data <- read_parquet("https://intro-datascience.s3.us-east-2.amazonaws.com/SC-data/static_house_info.parquet")
write_parquet(static_house_data, "C:/Users/sohai/Documents/energy_consumption_ds/data/house_static_data.parquet")

weather_files <- list.files("data/weather", pattern = "*.csv", full.names = TRUE)
weather_data <- lapply(weather_files, read_csv) %>% bind_rows()




# Function to download and save weather data for each county
download_and_save_weather_data <- function(static_house_data) {
base_url <- "https://intro-datascience.s3.us-east-2.amazonaws.com/SC-data/weather/2023-weather-data/"
# Create the directory if it doesn't exist
dir.create("data/weather_data", recursive = TRUE, showWarnings = FALSE)

weather_data_list <- list()
# Iterate over each unique county id in the static_house_data dataframe
  for (county_id in unique(static_house_data$in.county)) {
    
    file_url <- paste0(base_url, county_id, ".csv")
    
    
    tryCatch({
      
      weather_data <- read_csv(file_url)
      weather_data <- weather_data %>% mutate(in.county = county_id)
      weather_data_list[[county_id]] <- weather_data
      write_csv(weather_data, paste0("C:/Users/sohai/Documents/energy_consumption_ds/data/weather_data/", county_id, ".csv"))
      cat("Successfully downloaded and saved weather data for county:", county_id, "\n")
    }, error = function(e) {
      cat("Error downloading data for county:", county_id, "\n")
    })
  }
  
combined_weather_data <- bind_rows(weather_data_list, .id = "county_id") 

 
  write_csv(combined_weather_data, "C:/Users/sohai/Documents/energy_consumption_ds/data/weather_data/weather_all_county_data.csv")
  cat("Combined weather data saved as weather_all_county_data.csv\n")
  return(weather_data_list)
}
weather_data <- download_and_save_weather_data(static_house_data)

wd <- read_csv("C:/Users/sohai/Documents/energy_consumption_ds/data/weather_data/weather_all_county_data.csv")
str(wd)
