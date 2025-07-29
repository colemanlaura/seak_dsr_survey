# This code compiles all of the ROV survey data 
# Includes: raw species review data for ROV surveys 2012-2023
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: July 29, 2025

## ROV Surveys for DSR Stock Assessment
## two hashtags are used when the data has added to this repo
## CSEO_2012
# SSEO_2013
# 2014 CANCELED
## EYKT_2015
# CSEO_2016
# NSEO_2016
# EYKT_2017
# NSEO_2018
# CSEO_2018
# SSEO_2018
# EYKT_2019
# SSEO_2020
# 2021 CANCELLED
# CSEO_2022
# NSEO_2022
# EYKT_2023
# The ROV program was suspended after 2023 due to the retirement of ROV pilot Mike Byerly

# TO DO:
# Dive 11, EYKT 2015 has multiple version and I think I should read in all of those versions to have available to play with
# I added dive_type to several of these files - i need to figure out id there were any other experimental transects
# Check with Kelli - who added the data to oceanak, need to verify - justin didn't know


# set up ----
source('code/helper.r') 

###  set plotting theme to use TNR  ###
#font_import() #remove # to run this but only do this one time - it takes a while
loadfonts(device="win")
windowsFonts(Times=windowsFont("TT Times New Roman"))
theme_set(theme_bw(base_size=18,base_family='Times New Roman')
          +theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()))


##########################################################################################
### IMPORT DATA ###

# 2012 -----------------------------------------------------------------------
# I cannot find the original files from eventmeasure, so that I can combine everything myself.
#Filepath: C:\Users\lscoleman\Documents\R code - Working Files\seak_dsr_survey\data\SPECIES_REVIEW_DATA\2012_CSEO\FishVideoReview_Feb2_2013ROV lengths_kg.csv

CSEO_2012_ALLdata <- read_csv("data/SPECIES_REVIEW_DATA/2012_CSEO/FishVideoReview_Feb2_2013ROV lengths_kg.csv")%>% 
  clean_names()%>% 
  mutate(mgmt_area = "SSEO",
         dive_type = "Line") %>% #are all transects considered line for this survey?
  select(year,mgmt_area,time_mins,length_mm,precision,rms_1_mm,vert_dir_deg,
         tape_reader,dive_no, transect_no, family,genus,species,code,specimen_number,stage,
         activity,check_id,trip_comment,species_comment) %>% 
  rename(rms_mm = rms_1_mm,
         comment = trip_comment,
         comment_1 = species_comment,
         time_hms = time_mins,
         precision_mm = precision,
         number = specimen_number) 


# 2013 -----------------------------------------------------------------------
# I cannot find the original files from event measure, so that I can combine everything myself.
# Filepath: M:\ROVSurvey\2013\species_SSEO_2013
# The 2013 ROV Distance Analysis notes have been saved in the documents folder

SSEO_2013_ALLdata <- data_list$"2013_SSEO_ALLdata" %>% 
  clean_names() %>% 
  mutate(mgmt_area = "SSEO",
         dive_type = "Line") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_1_mm,vert_dir_deg,
         tape_reader,dive_no, transect_no, family,genus,species,code,number,stage,
         activity,check_id,comment_20,comment_37) %>% 
  rename(rms_mm = rms_1_mm,
         comment = comment_20,
         comment_1 = comment_37) 

SSEO_2013_ALLdata$time_hms <- hms::as_hms(SSEO_2013_ALLdata$time_hms * 86400)
SSEO_2013_ALLdata$time_hms <- format(SSEO_2013_ALLdata$time_hms, "%H:%M:%S")

head(SSEO_2013_ALLdata)
str(SSEO_2013_ALLdata)


# 2015 -----------------------------------------------------------------------

EYKT_2015_ALLdata <- read.csv("outputs/species_review/SPECIES_EYKT_2015.csv") %>% 
  mutate(mgmt_area = "EYKT",
         dive_type = "Line") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive_no, transect_no, family,genus,species,code,number,stage,
         activity,check_id,comment,comment_1)%>% 
  mutate(length_mm = as.numeric(as.character(length_mm))) %>% 
  filter(!is.na(year))

# 2016 -----------------------------------------------------------------------

CSEO_2016_ALLdata <- data_list$"2016_CSEO_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "CSEO",
         dive_type = "Line") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive_no, transect_no, family,genus,species,code,number,stage,
         activity,check_id,comment,comment_1) 

CSEO_2016_ALLdata$time_hms <- format(CSEO_2016_ALLdata$time_hms, "%H:%M:%S")

head(EYKT_2015_ALLdata)
str(EYKT_2015_ALLdata)

NSEO_2016_ALLdata <- data_list$"2016_NSEO_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "NSEO",
         dive_type = "Line",
         length_mm = as.numeric(as.character(length_mm))) %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive_no, transect_no, family,genus,species,code,number,stage,
         activity,check_id,comment,comment_1) %>% 
  filter(!is.na(year)) #this gets rid of two rows with data but none that are YE

NSEO_2016_ALLdata$time_hms <- format(NSEO_2016_ALLdata$time_hms, "%H:%M:%S")

head(NSEO_2016_ALLdata)
str(NSEO_2016_ALLdata)

unique(NSEO_2016_ALLdata$year)

# 2017 -----------------------------------------------------------------------

EYKT_2017_ALLdata <- data_list$"2017_EYKT_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "EYKT",
         dive_type = "Line") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive_no, transect_no, family,genus,species,code,number,stage,
         activity,check_id,comment,comment_1) %>% 
  mutate(length_mm = as.numeric(as.character(length_mm)))

EYKT_2017_ALLdata$time_hms <- format(EYKT_2017_ALLdata$time_hms, "%H:%M:%S")

head(EYKT_2017_ALLdata)
str(EYKT_2017_ALLdata)

# 2018 -----------------------------------------------------------------------

NSEO_2018_ALLdata <- data_list$"2018_NSEO_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "NSEO",
         dive_type = "Line") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive, transect_number, family,genus,species,code,number,stage,
         activity,check_id,comment_19,comment_36,) %>% 
  rename(dive_no = dive,
         transect_no = transect_number,
         comment = comment_19,
         comment_1 = comment_36) %>% 
  filter(!year=="cobbled surface - not YE habitat") #there are 11 rows where it looks the cells were shifted over by one and i need to fix this

NSEO_2018_ALLdata$time_hms <- format(NSEO_2018_ALLdata$time_hms, "%H:%M:%S")

head(NSEO_2018_ALLdata)
str(NSEO_2018_ALLdata)

CSEO_2018_ALLdata <- data_list$"2018_CSEO_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "CSEO",
         dive_type = "Line") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tapereader,dive_no, transect_number, family,genus,species,code,number,stage,
         activity,check_id,comment_17,comment_30) %>% 
  rename(tape_reader = tapereader,
         transect_no = transect_number,
         comment = comment_17,
         comment_1 = comment_30)

CSEO_2018_ALLdata$time_hms <- format(CSEO_2018_ALLdata$time_hms, "%H:%M:%S")

head(CSEO_2018_ALLdata)
str(CSEO_2018_ALLdata)

SSEO_2018_ALLdata <- data_list$"2018_SSEO_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "SSEO",
         dive_type = "Line") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tapereader,dive, transect_number, family,genus,species,code,number,stage,
         activity,check_id,comment_19,comment_36) %>% 
  rename(dive_no = dive,
         tape_reader = tapereader,
         transect_no = transect_number,
         comment = comment_19,
         comment_1 = comment_36)

SSEO_2018_ALLdata$time_hms <- format(SSEO_2018_ALLdata$time_hms, "%H:%M:%S")

head(SSEO_2018_ALLdata)
str(SSEO_2018_ALLdata)

# 2019 -----------------------------------------------------------------------

EYKT_2019_ALLdata <- data_list$"2019_EYKT_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "EYKT") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive, transect_number, family,genus,species,code,number,stage,
         activity,check_id,comment_19,comment_36,dive_type) %>% 
  rename(dive_no = dive,
         transect_no = transect_number,
         comment = comment_19,
         comment_1 = comment_36)

EYKT_2019_ALLdata$time_hms <- format(EYKT_2019_ALLdata$time_hms, "%H:%M:%S")

head(EYKT_2019_ALLdata)
str(EYKT_2019_ALLdata)

# 2020 -----------------------------------------------------------------------

SSEO_2020_ALLdata <- data_list$"2020_SSEO_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "SSEO") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive, transect_number, family,genus,species,code,number,stage,
         activity,check_id,comment,comment_1,dive_type) %>% 
  rename(dive_no = dive,
         transect_no = transect_number) %>% 
  mutate(length_mm = as.numeric(as.character(length_mm)))

SSEO_2020_ALLdata$time_hms <- format(SSEO_2020_ALLdata$time_hms, "%H:%M:%S")

head(SSEO_2020_ALLdata)
str(SSEO_2020_ALLdata)

# 2022 -----------------------------------------------------------------------

CSEO_2022_ALLdata <- data_list$"2022_CSEO_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "CSEO") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive, transect_number, family,genus,species,code,number,stage,
         activity,check_id,comment,comment_1,dive_type) %>% 
  rename(dive_no = dive,
         transect_no = transect_number) %>% 
  mutate(length_mm = as.numeric(as.character(length_mm)))

CSEO_2022_ALLdata$time_hms <- hms::as_hms(CSEO_2022_ALLdata$time_hms * 86400)
CSEO_2022_ALLdata$time_hms <- format(CSEO_2022_ALLdata$time_hms, "%H:%M:%S")


head(CSEO_2022_ALLdata)
str(CSEO_2022_ALLdata)

NSEO_2022_ALLdata <- data_list$"2022_NSEO_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "NSEO") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive, transect_number, family,genus,species,code,number,stage,
         activity,check_id,dive_type) %>% 
  rename(dive_no = dive,
         transect_no = transect_number) %>% 
  mutate(length_mm = as.numeric(as.character(length_mm)),
         comment = "",
         comment_1 = "")

NSEO_2022_ALLdata$time_hms <- hms::as_hms(NSEO_2022_ALLdata$time_hms * 86400)
NSEO_2022_ALLdata$time_hms <- format(NSEO_2022_ALLdata$time_hms, "%H:%M:%S")

head(NSEO_2022_ALLdata)
str(NSEO_2022_ALLdata)

# 2023 -----------------------------------------------------------------------

EYKT_2023_ALLdata <- data_list$"2023_EYKT_ALLdata" %>% 
clean_names() %>% 
  mutate(mgmt_area = "EYKT") %>% 
  select(year,mgmt_area,time_hms,length_mm,precision_mm,rms_mm,vert_dir_deg,
         tape_reader,dive, transect_number, family,genus,species,code,number,stage,
         activity,check_id,comment,comment_1,dive_type) %>% 
  rename(dive_no = dive,
         transect_no = transect_number) %>% 
  mutate(length_mm = as.numeric(as.character(length_mm)))

EYKT_2023_ALLdata$time_hms <- format(EYKT_2023_ALLdata$time_hms, "%H:%M:%S")

head(EYKT_2023_ALLdata)
str(EYKT_2023_ALLdata)

# Combine Dataframes ---------------------------------------------------------
all_dfs <- list(
  SSEO_2013 = SSEO_2013_ALLdata,
  EYKT_2015 = EYKT_2015_ALLdata,
  CSEO_2016 = CSEO_2016_ALLdata,
  NSEO_2016 = NSEO_2016_ALLdata,
  EYKT_2017 = EYKT_2017_ALLdata,
  NSEO_2018 = NSEO_2018_ALLdata,
  CSEO_2018 = CSEO_2018_ALLdata,
  SSEO_2018 = SSEO_2018_ALLdata,
  EYKT_2019 = EYKT_2019_ALLdata,
  SSEO_2020 = SSEO_2020_ALLdata,
  CSEO_2022 = CSEO_2022_ALLdata,
  NSEO_2022 = NSEO_2022_ALLdata,
  EYKT_2023 = EYKT_2023_ALLdata)

all_dfs <- lapply(all_dfs, function(df) {
  df %>%
    mutate(year = as.character(year),
      dive_no = as.character(dive_no),
      transect_no = as.character(transect_no),
      species = as.character(species),
      code = as.character(code),
      length_mm = as.numeric(as.character(length_mm)),
      precision_mm = as.numeric(as.character(precision_mm)),
      rms_mm = as.numeric(as.character(rms_mm)),
      vert_dir_deg = as.character(vert_dir_deg),
      vert_dir_deg = na_if(vert_dir_deg, "NA"), 
      vert_dir_deg = as.numeric(as.character(vert_dir_deg)))})


species_review_summary_2013_2023 <- bind_rows(all_dfs) %>%
  mutate(tape_reader = case_when(
      tape_reader == "Kristen Green " ~ "Kristen Green",
      tape_reader %in% c("Jennifer Stahl", "Jenny") ~ "Jenny Stahl",
      tape_reader == "asia" ~ "Asia",
      tape_reader == "LauraColeman" ~ "Laura Coleman",
      TRUE ~ tape_reader),
    activity = case_when(
      activity == "fish seeking cover" ~ "Fish seeking cover",
      activity == "resting on bottom" ~ "Fish resting on bottom",
      activity == "Chase other" ~ "Fish chasing other fish",
      activity %in% c("fish moving slowly into frame", "moving slowly into frame") ~ "Fish moving slowly into frame",
      activity %in% c("fish moving quickly into frame", "moving quickly into frame") ~ "Fish moving quickly into frame",
      activity == "actively swimming within frame" ~ "Fish actively swimming in frame",
      activity %in% c("fish moving quickly out of frame", "Fish moving quickly out of frame.") ~ "Fish moving quickly out of frame",
      activity %in% c("milling", "milling/hovering") ~ "Fish milling/hovering",
      TRUE ~ activity),
    dive_type = case_when(
      dive_type == "Grouundtruth" ~ "Groundtruth",
      TRUE ~ dive_type)) %>% 
  filter(!is.na(family))


write.csv(species_review_summary_2013_2023,"output/species_review_summary_2013_2023.csv")

# Data Exploration  ---------------------------------------------------------
names(species_review_summary_2013_2023)

unique(species_review_summary_2013_2023$year)
unique(species_review_summary_2013_2023$mgmt_area)
unique(species_review_summary_2013_2023$tape_reader)
unique(species_review_summary_2013_2023$family)
unique(species_review_summary_2013_2023$genus)
unique(species_review_summary_2013_2023$species)
unique(species_review_summary_2013_2023$code)
unique(species_review_summary_2013_2023$stage)
unique(species_review_summary_2013_2023$activity)
unique(species_review_summary_2013_2023$dive_type)

transects_per_area_per_year <- species_review_summary_2013_2023 %>%
  group_by(mgmt_area,year) %>%
  summarise(num_dives = n_distinct(dive_no)) %>%
  arrange(mgmt_area)
#Data check
#2018 CSEO- 35 transects in SAFE report but 33 here
#2022 CSEO- 32 transects in SAFE report but 31 here
#2017 EYKT- 35 transects in SAFE report but 36 here
#2019 EYKT- 33 transects in SAFE report but 32 here
#2023 EYKT- 22 transects in SAFE report but 24 here
#2018 NSEO- 30 transects in SAFE report but 29 here

# Data Exploration  ---------------------------------------------------------
#Since the adoption of the ROV in 2012, an average of 78% of all yelloweye 
#rockfish from the surveys moved minimally or slowly. Of those slow-moving 
#specimens, approximately 70% did not display directional movements (i.e., 
#they were milling or resting on the bottom). 
#
#The above text is from the draft of the ROP. I am assuming Kelli or Phil
#but I don't know where this analysis was completed. 

activity_missing <- species_review_summary_2013_2023 %>%
  filter(genus=="yelloweye"&is.na(activity)) %>% 
  group_by(year,mgmt_area) %>% 
  summarize(n())
# year  mgmt_area `n()`
# 2016  CSEO        118
# 2016  NSEO        143
# 2017  EYKT         98
# 2018  CSEO          1
# 2018  NSEO          1
# 2018  SSEO          2
# 2022  CSEO          2
#why is this data missing?

activity<- species_review_summary_2013_2023 %>%
  filter(genus=="yelloweye",
         !activity %in% c(""," "),
         !is.na(activity)) %>%  
  mutate(activity_new = case_when(
    activity %in% c("fish seeking cover", 
                    "Feeding",
                    "Fish actively swimming in frame",
                    "Fish moving quickly out of frame",
                    "Fish moving quickly into frame",
                    "Passing",
                    "Fish being chased",
                    "Fish chasing other fish")~ "Moving",
    activity %in% c("Fish resting on bottom",
                    "Fish moving slowly into frame",
                    "Fish milling/hovering",
                    "Fish seeking cover",
                    "Fish moving slowly out of frame") ~ "Not Moving or Minimal Movement",
                    activity == "Attracted" ~ "Attracted",
                    TRUE ~ activity)) %>% 
  group_by(activity_new) %>% 
  summarize(count = n()) %>% 
  mutate(percentage = (count / sum(count)) * 100) %>%
  arrange(desc(percentage))

inactive <- species_review_summary_2013_2023 %>%
  filter(genus=="yelloweye",
         !activity %in% c(""," "),
         !is.na(activity)) %>%  
  mutate(activity_new = case_when(
    activity %in% c("fish seeking cover", 
                    "Feeding",
                    "Fish actively swimming in frame",
                    "Fish moving quickly out of frame",
                    "Fish moving quickly into frame",
                    "Passing",
                    "Fish being chased",
                    "Fish chasing other fish")~ "Moving",
    activity %in% c("Fish resting on bottom",
                    "Fish moving slowly into frame",
                    "Fish milling/hovering",
                    "Fish seeking cover",
                    "Fish moving slowly out of frame") ~ "Not Moving or Minimal Movement",
    activity == "Attracted" ~ "Attracted",
    TRUE ~ activity)) %>% 
  filter(activity_new == "Not Moving or Minimal Movement") %>% 
  group_by(activity) %>% 
  summarize(count = n()) %>% 
  mutate(percentage = (count / sum(count)) * 100) %>%
  arrange(desc(percentage))

  