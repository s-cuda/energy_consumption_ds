library(tidyverse)
library(arrow)
library(lubridate)
library(dplyr)
library(caret)

house_static_data <- read_parquet("C:/Users/sohai/Documents/energy_consumption_ds/data/house_static_data.parquet")
july_house_energy_data <- read_csv("C:/Users/sohai/Documents/energy_consumption_ds/data/july_energy_model_data.csv")
glimpse(july_house_energy_data)

library(dplyr)
library(lubridate)
df <- df %>%
  mutate(across(everything(), ~ replace_na(., 0))) %>%
  mutate(across(everything(), ~ ifelse(. < 0, 0, .)))
# Create the dataframe from your input
df <- july_house_energy_data

# Add time-related features
df <- df %>%
  mutate(
    hour = hour(time),
    day_of_week = wday(time, label = TRUE),
    is_weekend = ifelse(day_of_week %in% c("Sat", "Sun"), 1, 0),
    is_daytime = ifelse(hour >= 6 & hour < 18, 1, 0)
  )

# Compute total energy consumption
df <- df %>%
  mutate(
    total_energy_consumption = 
      `out.electricity.ceiling_fan.energy_consumption` +
      `out.electricity.clothes_dryer.energy_consumption` +
      `out.electricity.clothes_washer.energy_consumption` +
      `out.electricity.cooling_fans_pumps.energy_consumption` +
      `out.electricity.cooling.energy_consumption` +
      `out.electricity.dishwasher.energy_consumption` +
      `out.electricity.freezer.energy_consumption` +
      `out.electricity.heating_fans_pumps.energy_consumption` +
      `out.electricity.heating_hp_bkup.energy_consumption` +
      `out.electricity.heating.energy_consumption` +
      `out.electricity.hot_tub_heater.energy_consumption` +
      `out.electricity.hot_tub_pump.energy_consumption` +
      `out.electricity.hot_water.energy_consumption` +
      `out.electricity.lighting_exterior.energy_consumption` +
      `out.electricity.lighting_garage.energy_consumption` +
      `out.electricity.lighting_interior.energy_consumption` +
      `out.electricity.mech_vent.energy_consumption` +
      `out.electricity.plug_loads.energy_consumption` +
      `out.electricity.pool_heater.energy_consumption` +
      `out.electricity.pool_pump.energy_consumption` +
      `out.electricity.pv.energy_consumption` +
      `out.electricity.range_oven.energy_consumption` +
      `out.electricity.refrigerator.energy_consumption` +
      `out.electricity.well_pump.energy_consumption` +
      `out.fuel_oil.heating_hp_bkup.energy_consumption` +
      `out.fuel_oil.heating.energy_consumption` +
      `out.fuel_oil.hot_water.energy_consumption` +
      `out.natural_gas.clothes_dryer.energy_consumption` +
      `out.natural_gas.fireplace.energy_consumption` +
      `out.natural_gas.grill.energy_consumption` +
      `out.natural_gas.heating_hp_bkup.energy_consumption` +
      `out.natural_gas.heating.energy_consumption` +
      `out.natural_gas.hot_tub_heater.energy_consumption` +
      `out.natural_gas.hot_water.energy_consumption` +
      `out.natural_gas.lighting.energy_consumption` +
      `out.natural_gas.pool_heater.energy_consumption` +
      `out.natural_gas.range_oven.energy_consumption` +
      `out.propane.clothes_dryer.energy_consumption` +
      `out.propane.heating_hp_bkup.energy_consumption` +
      `out.propane.heating.energy_consumption` +
      `out.propane.hot_water.energy_consumption` +
      `out.propane.range_oven.energy_consumption`
  )

# Energy buckets based on their usage categories
df <- df %>%
  mutate(
    ventilation_energy = `out.electricity.ceiling_fan.energy_consumption` + 
      `out.electricity.cooling_fans_pumps.energy_consumption` +
      `out.electricity.mech_vent.energy_consumption`,
    
    heating_energy = `out.electricity.heating_fans_pumps.energy_consumption` +
      `out.electricity.heating_hp_bkup.energy_consumption` +
      `out.electricity.heating.energy_consumption` +
      `out.fuel_oil.heating_hp_bkup.energy_consumption` +
      `out.fuel_oil.heating.energy_consumption` +
      `out.natural_gas.heating_hp_bkup.energy_consumption` +
      `out.natural_gas.heating.energy_consumption` +
      `out.propane.heating_hp_bkup.energy_consumption` +
      `out.propane.heating.energy_consumption`,
    
    cooling_energy = `out.electricity.cooling.energy_consumption` +
      `out.electricity.pool_heater.energy_consumption` +
      `out.electricity.pool_pump.energy_consumption` +
      `out.natural_gas.pool_heater.energy_consumption`,
    
    lighting_energy = `out.electricity.lighting_exterior.energy_consumption` +
      `out.electricity.lighting_garage.energy_consumption` +
      `out.electricity.lighting_interior.energy_consumption` +
      `out.natural_gas.lighting.energy_consumption`,
    
    plug_load_energy = `out.electricity.plug_loads.energy_consumption`,
    
    appliance_energy = `out.electricity.clothes_dryer.energy_consumption` +
      `out.electricity.clothes_washer.energy_consumption` +
      `out.electricity.dishwasher.energy_consumption` +
      `out.electricity.freezer.energy_consumption` +
      `out.electricity.hot_tub_heater.energy_consumption` +
      `out.electricity.hot_tub_pump.energy_consumption` +
      `out.electricity.range_oven.energy_consumption` +
      `out.electricity.refrigerator.energy_consumption` +
      `out.natural_gas.clothes_dryer.energy_consumption` +
      `out.natural_gas.grill.energy_consumption` +
      `out.natural_gas.range_oven.energy_consumption` +
      `out.propane.clothes_dryer.energy_consumption` +
      `out.propane.hot_water.energy_consumption` +
      `out.propane.range_oven.energy_consumption`,
    
    water_heating_energy = `out.electricity.hot_water.energy_consumption` +
      `out.fuel_oil.hot_water.energy_consumption` +
      `out.natural_gas.hot_water.energy_consumption` +
      `out.propane.hot_water.energy_consumption`,
    
    other_energy = `out.electricity.well_pump.energy_consumption` +
      `out.electricity.pv.energy_consumption` +
      `out.electricity.hot_water.energy_consumption` # Adjust as needed
  )

# Retain the built-in intensity variables already present in the dataset
# Assuming the intensity variables are present, we don't create new ones

# Check the final dataset
glimpse(df)

library(dplyr)

# Select the desired columns
df <- df %>%
  select(time, bldg_id, hour, day_of_week, is_weekend, is_daytime,
         total_energy_consumption, ventilation_energy, heating_energy, 
         cooling_energy, lighting_energy, plug_load_energy, appliance_energy, 
         water_heating_energy, other_energy)


library(ggplot2)
library(dplyr)

# Checking the first few rows of the data
head(df)

# Plotting total energy consumption over time
ggplot(df, aes(x = time, y = total_energy_consumption)) +
  geom_line() +
  labs(title = "Total Energy Consumption Over Time", x = "Time", y = "Energy Consumption")

# Summary statistics for each energy category
summary(df[, c("cooling_energy", "heating_energy", "lighting_energy", "plug_load_energy")])

# Correlation matrix between different energy consumption categories
cor(df[, c("cooling_energy", "heating_energy", "lighting_energy", "plug_load_energy")])

# Boxplot for energy consumption during day and night
ggplot(df, aes(x = is_daytime, y = total_energy_consumption)) +
  geom_boxplot() +
  labs(title = "Energy Consumption: Day vs Night", x = "Daytime", y = "Total Energy Consumption")

