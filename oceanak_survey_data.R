# This code explores the submersible and ROV data in OceanAK
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: October 28, 2025

##########################################################################################
### SET UP ###
source('scripts/helper.r') 

###  set plotting theme to use TNR  ###
# #font_import() #remove # to run this but only do this one time - it takes a while
# loadfonts(device="win")
# windowsFonts(Times=windowsFont("TT Times New Roman"))
# theme_set(theme_bw(base_size=18,base_family='Times New Roman')
#           +theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()))

##########################################################################################
### BACKGROUND ###

# I spoke to Jenny Stahl in summer 2025 she told me they were entering data into the 
# access databaser and moved it all to OceanAK. She was entering ROV data straight into
# OceanAK until she left in 2017. I am not sure why we stopped entering data into
# OceanAK

# There are two subject areas for th visual surveys:
# Region 1 – Groundfish – Surveys – Sub – Species
# Region 1 – Groundfish – Surveys – Sub – Length

# -----------------------
# Below is info from Justin Daily about the Region 1 – Groundfish – Surveys – Sub – Species 
# subject area. I was asking if ther was any location data associated with the subject area:
# Scott Johnson and Kari Reyes were working together on this one, Scott doing the database 
# design and Kari working on an application, but it never came to anything and was dropped. 

# The subject area Region 1 – Groundfish – Surveys – Sub – Species contains data from four database tables:
  
# G_SUR_TRIP_SUB (“trip” level, appears to be the top level) 
# G_SUR_SUB_DIVE (“dive” level, each trip having one or more dives)
# G_SUR_SUB_TRANSECT (“transect” level, each dive having one or more transects)
# G_SUR_SUB_SPECIES (I’m guessing this is actually a table of “observations” by transect, 
# but possibly summed up at the species level? Like, a total count of one particular 
# species in a given transect, not sure why it’s called “G_SUR_SUB_SPECIES” rather than 
# “G_SUR_SUB_OBSERVATION” or similar)

# Looking through the existing tables that link to the subject area, it does seem that 
# management area and possibly area description are the only location-based columns in 
# the data set. However, there are dozens of other tables that aren’t *technically* linked 
# to the subject area but might be relevant to the data set. For example, there are tables 
# called “G_SUR_SUB_FIX” and “G_SUR_SUB_ACCESS_FIX” which both seem to contain lat/long data. 
# Based on other columns in those tables, it seems like these tables *might* be children of 
# the transect level, but I don’t know if that makes them a sibling of the observation or a parent. 
# There are no column names in the “observation” level that reference a “fix”, which could 
# mean that fix is a sibling of observation rather than a parent-child relationship.

# There’s also a table called “G_SUR_SUB_STAT_AREA” which has both start and end lat/long info. 
# This also seems like possibly a child of the “transect” level, as it has columns for year and 
# trip number (trip level), dive number (dive level), and transect number (transect level). It also 
# has columns called “first fix” and “last fix”, so I’m not sure what those mean in relation to the above “fix” tables.

# Then there’s “G_SUR_SUB_ACCESS_NAV” which has lat/long columns, as well as a dive no and fix no, 
# so that may be a child of the “fix” level?

# -----------------------

# Fixes are periodical location fixes along the transect. They were using TRAK-POINT navigation with loran
# or GPS. The length of the transect is the sum of the distances between locational fixes.
# The fix data exists in OceanAK but is not in these subject areas.......
# When we used the ROV we moved to using Hypack software tp track the ROV. The Hypack is taking location data
# every 2-3 seconds.

# -----------------------

# My goal with this code is to see if the  ROV data from OceanAK matcyhes the raw files from the groundfish drive
# that I compiled in the code: species_review_all_data_all_years_9.16.25
  

##########################################################################################
### IMPORT DATA ###

# output from the R code species_review_all_data_all_years_9.16.25
# as of 10.28.25 - this output is not final - my goal with this output was to inlcude all
# dives - even if they were excluded from the assessment.
rov_data_compiled <- read_csv("outputs/ROV_species_review_all_years.csv")

#https://oceanak.adfg.alaska.gov/analytics/saw.dll?Answers&path=%2Fshared%2FCommercial%20Fisheries%2FRegion%20I%2FGroundFish%2FUser%20Reports%2FLaura%20Coleman%2FYELLOWEYE%2FVISUAL%20SURVEY%20DATA
visual_survey_species_data <- read_csv("data/OCEANAK VISUAL SURVEY DATA/visual_survey_species_data_oceanak.csv") %>% 
  clean_names()

#There are only lengths available for the fish observed from the ROV - i wonder why?
#https://oceanak.adfg.alaska.gov/analytics/saw.dll?Answers&SubjectArea=%22Region%20I%20-%20Groundfish%20-%20Surveys%20-%20Sub%20-%20Length%22#resultsTab19a2c2e1246
#visual_survey_length_data <- read_csv("data/OCEANAK VISUAL SURVEY DATA/visual_survey_length_data_oceanak.csv")

##########################################################################################
### DATA EXPLORATION ###

names(visual_survey_species_data)

unique(visual_survey_species_data$vessel_name)
#"R/V Medeia"   "R/V Pandalus" "R/V Solstice"
unique(visual_survey_species_data$target_species_code)
#NA 145
unique(visual_survey_species_data$trip_comments)
unique(visual_survey_species_data$trip_fix_method)
#"DGPS, 5 minute fixes"
#"DGPS, 5 minute fixes; Winfrog, 2 second fixes"
#"Hypack"
unique(visual_survey_species_data$management_area)
#"NSEI" "CSEO" "EYKT" "NSEO" "SSEO" "SSEI" NA     "IBS"  "pws"
unique(visual_survey_species_data$transect_type)
#"Bounce"
#"Line Transect"
#"Reconnaissance"     
#"Aborted"            
#"Experimental"       
#"Pinnacles"         
#"Lingcod Nesting"
#"Geology"            
#"Random Observation" 
#"Interface"          
#"Shakedown"         
#"Groundtruth"        
#"Calibration"
unique(visual_survey_species_data$transect_fix_method)
#"5  minute" "5 minute"  "winfrog"   "Hypack"    "hypack"  
unique(visual_survey_species_data$camera)
unique(visual_survey_species_data$observation_source)
unique(visual_survey_species_data$observation_type)

# right now, we are only interested in the line transect data

visual_survey_species_data <- read_csv("data/OCEANAK VISUAL SURVEY DATA/visual_survey_species_data_oceanak.csv") %>% 
  clean_names() %>% 
  mutate(dive_trans = paste(dive_number,transect_number, sep = "_"))

transects_per_area_per_year <- visual_survey_species_data %>%
  filter(transect_type=="Line Transect",
         management_area %in% c("EYKT","NSEO","CSEO","SSEO")) %>% 
  group_by(management_area,year,submersible_type) %>%
  summarise(num_dives = n_distinct(dive_trans)) %>%
  arrange(management_area)

#compared this to the numbers in the SAFE report and there were very few discrepancies
#EYKT 1999 20 vs 18 transects
#NSEO - 2001 8 transects were done and this is not in the SAFE report - i believe this 
#is because not enough data was collected for a density estimate
#CSEO 1994 - there is not data in the SAFE report
#CSEO 1995 24VS 36
#CSEO 2012 - this actually matches between the SAFE report and this output but there is a big mismatch
#between this output and the output from "species_review_all_data_all_year_9.16.25"
#SSEO 1994 13 vs 16 transects

YE_per_area_per_year <- visual_survey_species_data %>%
  filter(
    transect_type == "Line Transect",
    management_area %in% c("EYKT", "NSEO", "CSEO", "SSEO"),
    species_code == 145,  # yelloweye only
    stage %in% c("adult", "subadult")) %>%
  group_by(management_area, year, submersible_type) %>%
  summarise(YE = sum(number_of_fish, na.rm = TRUE),
    total_length_m = sum(unique(line_length_meters), na.rm = TRUE)) %>%
  mutate(encounter_rate = YE / total_length_m) %>%
  arrange(management_area, year)

# The 1994 stock assessment only used survey data from the CSEO, NSEO and SSEO sections. 
# The 1994 survey covered more area than past surveys and employed improved navigational techniques.
# They used an automated system for regularly recording the GPS location along the transect lines each minute.
# In 1990 and 1991, they were manually recording thel ocation every 10 mins.
#The new data resulted in a significantly lower estimate of DSR biomass than previous estimates.
  
