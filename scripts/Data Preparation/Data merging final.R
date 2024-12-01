library(tidyverse)
library(arrow)
library(lubridate)
library(dplyr)
library(caret)

static_house_data <- 
wd <- read_csv("C:/Users/sohai/Documents/energy_consumption_ds/data/weather_data/weather_all_county_data.csv")
wd <- wd %>% select(-county_id)

str(wd)

wd <- wd %>%
  # Create new 'date' and 'time' columns
  mutate(
    date = as.Date(date_time),              # Extract the date part
    time = format(date_time, "%H:%M:%S")   # Extract the time part
  ) %>%
  # Filter for data from July 1 to July 31
  filter(
    date_time >= ymd_hms("2018-07-01 00:00:00") &  
      date_time <= ymd_hms("2018-07-31 23:59:59")   
  )

merged_data <- wd %>%
  inner_join(static_house_data, by = c("in.county" = "in.county")) %>%  
                                                

# View the merged data
head(merged_data)
