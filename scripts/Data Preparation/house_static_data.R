library(tidyverse)
library(arrow)
library(lubridate)
library(dplyr)
library(caret)

house_static_data <- read_parquet("C:/Users/sohai/Documents/energy_consumption_ds/data/house_static_data.parquet")
colnames(house_static_data)


house_static_reduced <- house_static_data %>% select(c(
  # General building information
  "bldg_id",
  "in.sqft",                                  # Building square footage
  "in.ahs_region",                            # AHJ region
  "in.building_america_climate_zone",         # Climate zone (Building America)
  "in.cec_climate_zone",                      # Climate zone (CEC)
  
  # Insulation and building structure
  "in.insulation_wall",
  "in.insulation_ceiling",
  "in.insulation_roof",
  "in.geometry_floor_area",                   # Floor area
  #"in.geometry_wall_area",                    # Wall area
  "in.geometry_foundation_type",              # Foundation type
  
  # HVAC system
  "in.hvac_cooling_type",                     # Cooling type
  "in.hvac_cooling_efficiency",               # Cooling efficiency
  "in.hvac_heating_type",                     # Heating type
  "in.hvac_heating_efficiency",               # Heating efficiency
  "in.heating_fuel",                          # Heating fuel
  "in.mechanical_ventilation",                # Mechanical ventilation
  
  # Appliances
  "in.clothes_dryer",                         # Clothes dryer
  "in.clothes_washer",                        # Clothes washer
  "in.dishwasher",                            # Dishwasher
  "in.refrigerator",                          # Refrigerator
  "in.range_spot_vent_hour",                  # Range vent hours
  "in.misc_hot_tub_spa" ,                               # Hot tub
  "in.misc_freezer",                          # Miscellaneous freezer
  
  # Plug loads and energy diversity
  "in.plug_load_diversity",                   # Plug load diversity
  "in.plug_loads",                            # Plug loads
  
  # Water heating
  "in.water_heater_efficiency",               # Water heater efficiency
  "in.water_heater_fuel",                     # Water heater fuel
  "in.hot_water_distribution",                # Hot water distribution
  
  # Renewable energy
  "in.has_pv",                                # PV (solar panels)
  "in.roof_material",                         # Roof material
  
  # Occupant characteristics
  "in.occupants",                             # Occupants
  "in.income"                                # Income
))
