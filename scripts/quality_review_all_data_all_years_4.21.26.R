# This code compiles all of the ROV survey data 
# Includes: raw quality review data for ROV surveys 2012-2023
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: April 21, 2026

# The goal here is is create one file with ALL of the RAW ROV quality review data for 
# yelloweye rockfish stock assessment survey. I want to include ALL transects, with 
# all species. Kelli or Phil compiled a lot of this data already, so I will
# start with the outputs they created and will recombine raw files if needed.

## ROV Surveys for DSR Stock Assessment
# CSEO_2012
# SSEO_2013
# 2014 CANCELED
# EYKT_2015
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

# set up ----
source('scripts/helper.r') 


##########################################################################################
### IMPORT DATA ###

# 2012 -----------------------------------------------------------------------
# Filepath: M:\ALL GROUNDFISH STAFF FOLDERS\Archived Previous Employees\Jenny Stahl\
# Rockfish_DSR\ROV survey\TransectLengths\2012 Line transects\2012VideoQualityReview
# tab called VQR

CSEO_2012_ALLdata <- read_csv("data/QUALITY_REVIEW_DATA/2012_CSEO/QC_CSEO_2012_summary.csv")

# 2013 -----------------------------------------------------------------------
# Filepath: M:\ALL GROUNDFISH STAFF FOLDERS\Archived Previous Employees\Jenny Stahl\
# Rockfish_DSR\ROV survey\TransectLengths\2013 Line transects\2013_video_quality_review


SSEO_2013_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2013_SSEO/QC_SSEO_2013_summary.csv") 


# 2015 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2015\2016_QC\QC review
# Saved the "QC_review" tab but there is also a "QC_review_JS_edited" tab
# Note from the QC file: Dive  11 had 2 video files due to camera issues. We decided to only include 11b, 
# so deleted 11a for QC and renamed 11b to 11.


EYKT_2015_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2015_EYKT/QC_EYKT_2015_summary.csv") 

# 2016 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2016\2016_QC - "AsiaQCReview" worksheet
# File path: M:\ROVSurvey\2016\2016_QC - "QC" worksheet

CSEO_2016_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2016_CSEO/QC_CSEO_2016_summary.csv")
NSEO_2016_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2016_NSEO/QC_NSEO_2016_summary.csv")

# 2017 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2017\EYKT\2017_QC\2017_EYKT_QC - worksheet"Original"
# The 2017 ROV Distance Analysis notes have been saved in the documents folder

EYKT_2017_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2017_EYKT/QC_EYKT_2017_summary.csv")

# 2018 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2018\CSEO\R Data Files\2018_cseo_qc
# File path: M:\ROVSurvey\2018\NSEO\QC_NSEO_2018
# File path: M:\ROVSurvey\2018\SSEO\Andrew R Code\2018_sseo_qc

CSEO_2018_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2018_CSEO/QC_CSEO_2018_summary.csv")
NSEO_2018_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2018_NSEO/QC_NSEO_2018_summary.csv") 
SSEO_2018_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2018_SSEO/QC_SSEO_2018_summary.csv") 


# 2019 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2019\EYKT\R Code\EYKT_2019\QC_EYKT_2019

EYKT_2019_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2019_EYKT/QC_EYKT_2019_summary.csv")

# 2020 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2020\R Code\Data\SSEO_2020_QC

SSEO_2020_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2020_SSEO/QC_SSEO_2020_summary.csv") 

# 2022 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2022\CSEO 2022\R Data Files\QC_CSEO_2022_summary

CSEO_2022_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2022_CSEO/QC_CSEO_2022_summary.csv") %>% 
  select(-Width,-Height)

# File path: M:\ROVSurvey\2022\NSEO 2022\R Data Files\QC_NSEO_2022_summary

NSEO_2022_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2022_NSEO/QC_NSEO_2022_summary.csv")

# 2023 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2023\EYKT\Final files for Analysis\QC_EYKT_2023_summary
EYKT_2023_ALLdata <- read.csv("data/QUALITY_REVIEW_DATA/2023_EYKT/QC_EYKT_2023_summary.csv") %>% 
  select(-Width,-Height) #these columns are empty 

# Combine Dataframes ---------------------------------------------------------
all_dfs <- list(
  CSEO_2012 = CSEO_2012_ALLdata,
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

# Now we need to combine the dataframes into one massive dataframe. This is going'
# to require a lot of data manipulation.

all_dfs <- lapply(all_dfs, clean_names)

# Here I am going to remove the columns that start with X or "user"- these are 
# empty columns and not needed
all_dfs <- lapply(all_dfs, function(df) {
  df[!grepl("^(x|user)", names(df), ignore.case = TRUE)]})

#Unpacks each cleaned dataframe back into your global environment
list2env(all_dfs, envir = .GlobalEnv)

lapply(all_dfs, names)

# R programmers everywhere are going to cry at what I am about to do. I am 
# finding a lot of variation in column names and also data types, and can't figure out
# how to make big changes to all of them at once, so I am going to change each 
# data frame one by one. Sowwy.

# CSEO 2012 --------------------------------------------------------------------

cols_cseo_2012 <- names(CSEO_2012)
cols_eykt_2023 <- names(EYKT_2023)

# Get max length between the two
max_len <- max(length(cols_cseo_2012), length(cols_eykt_2023))

# Make lists to the same length
cols_cseo_2012 <- c(cols_cseo_2012, rep(NA, max_len - length(cols_cseo_2012)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols1 <- data.frame(
  in_CSEO_2012 = cols_cseo_2012,
  in_EYKT_2023 = cols_eykt_2023);compare_cols1

unique(CSEO_2012$year)
unique(CSEO_2012$dive_no)
unique(CSEO_2012$transect_no) # transect_no = 1 2, or 3
unique(CSEO_2012$dive_trans) # dive number paired with transect number
unique(CSEO_2012$dive_trans_2) # identical to the one above
unique(CSEO_2012$hp_line) #i  wonder if this is the dive number
unique(CSEO_2012$event_id_7)# this is the dive number with the angle
unique(CSEO_2012$event_id_8) #this is the dive number witht he angle and transect
unique(CSEO_2012$date) # i want to add date to everything!
unique(CSEO_2012$utc_time)
unique(CSEO_2012$date_time) #date and utc time
unique(CSEO_2012$ast) # alaska standard time
unique(CSEO_2012$sec) # seconds
unique(CSEO_2012$quality_code)
unique(CSEO_2012$start_end)
unique(CSEO_2012$comments)
unique(CSEO_2012$segment) # not sure what this is


CSEO_2012 <- CSEO_2012 %>% 
  select(-event_id_7,
         -event_id_8,
         -segment,
         -date_time,
         -dive_trans,
         -dive_trans_2) %>% 
  rename(dive=dive_no, # n=24 but multiple transect were done per dive - so 46 actual "dives" were done
         # i think i should redo the dive numbers based on the order that they occurred
         transect_number=transect_no,
         time_utc=utc_time,
         time_akst=ast,# i think this is ak standard time
         seconds=sec,
         code=quality_code) %>% 
  mutate(filename=NA,
         frame=NA,
         time_hms=NA,
         period=NA,
         period_time_hms=NA,
         image_row=NA,
         image_col=NA,
         op_code=NA,
         tape_reader=NA,
         depth=NA,
         year="2012",
         family = case_when(code %in% c("GGF","GRB","GRBC")~"Good", TRUE ~ "Bad"),
         genus=case_when( 
           code=="GGF"~"Good Going Forward",
           code=="GRB"~"resting on bottom",
           code=="GRBC"~"resting on bottom with close-up image",
           code=="BDO"~"going over drop-off",
           code=="BBS"~"bottom stir-up",
           code=="BLB"~"lost bottom visual",
           code=="BGB"~"going backward",
           code=="BRB"~"resting on bottom",
           code=="BCF"~"bad camera focus",
           code=="BLA"~"loitering in same area",
           code=="BPV"~"poor visibiility",
           code=="BRP"~"repositioned", TRUE ~ "ERROR"),
         #there is a mystery code in this data set - GBG, not sure if they mean GRB or BGB. This would matter if we tried to redo the
         #line lengths one day
         species = code,
         number=NA,
         stage=NA,
         actvity=NA,
         mgmt_area = "CSEO", 
         time_akst = NA,
         time_ak = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         comment_1 = NA,
         event_time_hh_mm_ss = NA)


# SSEO 2013 --------------------------------------------------------------------

#the 2013 data is VERY different from later years - i was not able to find the raw files to recombine
cols_sseo_2013 <- names(SSEO_2013)
cols_eykt_2023 <- names(EYKT_2023) 

# Get max length between the two
max_len <- max(length(cols_sseo_2013), length(cols_eykt_2023))

# Make lists to the same length
cols_sseo_2013 <- c(cols_sseo_2013, rep(NA, max_len - length(cols_sseo_2013)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols2 <- data.frame(
  in_SSEO_2013 = cols_sseo_2013,
  in_EYKT_2023 = cols_eykt_2023);compare_cols2

unique(SSEO_2013$event_id)
#i think this is the transect and the angle

unique(SSEO_2013$dive_no)
#dive number 

unique(SSEO_2013$transect_no)
#this is left over from the way we used to do the sub surveys - now the transect number is assigned 
#before the survey and then the dive number is reflective of the order in which the dives were completed

unique(SSEO_2013$horita_code)
unique(SSEO_2013$drop_frame)
unique(SSEO_2013$quality_code)
unique(SSEO_2013$segment_no)
unique(SSEO_2013$start_end)
unique(SSEO_2013$comments)

SSEO_2013 <- SSEO_2013 %>% 
  select(-transect_no,#this = 1 for all dives
         -event_id,#i don't think event_id, dropframe, and segment_no are useful
         -drop_frame,
         -segment_no) %>% 
  rename(transect_number=dive_no,#this is more like the transect that is assigned before the survey
         code=quality_code,
         comment = comments) %>% 
  #i will create a column for dive number to match the order in which the transects were completed
  mutate(filename=NA,
         frame=NA,
         time_hms=NA,
         period=NA,
         period_time_hms=NA,
         image_row=NA,
         image_col=NA,
         op_code=NA,
         tape_reader=NA,
         depth=NA,
         year="2013",
         dive = NA, #need to figure out the order that the dives were performed to fix this - how does this look for the species review?
         dive_type="Line",
         family = case_when(code %in% c("GGF","GRB","GRBC")~"Good", TRUE ~ "Bad"),
         genus=case_when( 
           code=="GGF"~"Good Going Forward",
           code=="GRB"~"resting on bottom",
           code=="GRBC"~"resting on bottom with close-up image",
           code=="BDO"~"going over drop-off",
           code=="BBS"~"bottom stir-up",
           code=="BLB"~"lost bottom visual",
           code=="BGB"~"going backward",
           code=="BRB"~"resting on bottom",
           code=="BCF"~"bad camera focus",
           code=="BLA"~"loitering in same area",
           code=="BPV"~"poor visibiility",
           code=="BRP"~"repositioned", TRUE ~ "ERROR"),
         species = code,
         number=NA,
         stage=NA,
         actvity=NA,
         mgmt_area = "SSEO", 
         seconds = NA,
         time_utc = NA,
         time_akst = NA,
         time_ak = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         comment_1 = NA,
         event_time_hh_mm_ss = NA)




# EYKT 2015 --------------------------------------------------------------------

cols_eykt_2015 <- names(EYKT_2015)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

# Get max length between the two
max_len <- max(length(cols_eykt_2015), length(cols_eykt_2023))

# Make lists to the same length
cols_eykt_2015 <- c(cols_eykt_2015, rep(NA, max_len - length(cols_eykt_2015)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols3 <- data.frame(
  in_EYKT_2015 = cols_eykt_2015,
  in_EYKT_2023 = cols_eykt_2023);compare_cols3

EYKT_2015 <- EYKT_2015 %>% 
  rename(dive = dive_no,
         transect_number = transect_no) %>% 
  mutate(mgmt_area = "EYKT",
         dive_type="Line",
         time_utc = NA,
         time_akst = NA,
         horita_code=NA,
         time_ak = NA)

# CSEO 2016 --------------------------------------------------------------------

cols_cseo_2016 <- names(CSEO_2016)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

# Get max length between the two
max_len <- max(length(cols_cseo_2016), length(cols_eykt_2023))

# Make lists to the same length
cols_cseo_2016 <- c(cols_cseo_2016, rep(NA, max_len - length(cols_cseo_2016)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols4 <- data.frame(
  in_CSEO_2016 = cols_cseo_2016,
  in_EYKT_2023 = cols_eykt_2023);compare_cols4

CSEO_2016 <- CSEO_2016 %>% 
  rename(dive=dive_no,
         transect_number=transect_no,
         comment_1=comments) %>% 
  mutate(mgmt_area = "CSEO",
         dive_type = "Line",
         time_utc = NA,
         time_akst = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         horita_code=NA,
         actual_time_ak_std = NA,
         time_akst=NA)

# NSEO 2016 --------------------------------------------------------------------

cols_nseo_2016 <- names(NSEO_2016)
cols_eykt_2023 <- names(EYKT_2023) 

# Get max length between the two
max_len <- max(length(cols_nseo_2016), length(cols_eykt_2023))

# Make lists to the same length
cols_nseo_2016 <- c(cols_nseo_2016, rep(NA, max_len - length(cols_nseo_2016)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols5 <- data.frame(
  in_NSEO_2016 = cols_nseo_2016,
  in_EYKT_2023 = cols_eykt_2023);compare_cols5

NSEO_2016 <- NSEO_2016 %>% 
  rename(mgmt_area=management_area) %>% 
  select(-year_1) %>% #duplicate
  rename(dive = dive_no,
         transect_number = transect_no) %>% 
  mutate(time_hms = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         horita_code=NA,
         time_akst=NA,
         dive_type="Line",
         start_end = case_when(
           start_end == "End " ~ "End",
           TRUE ~ start_end))

# EYKT 2017 --------------------------------------------------------------------

cols_eykt_2017 <- names(EYKT_2017)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

# Get max length between the two
max_len <- max(length(cols_eykt_2017), length(cols_eykt_2023))

# Make lists to the same length
cols_eykt_2017 <- c(cols_eykt_2017, rep(NA, max_len - length(cols_eykt_2017)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols6 <- data.frame(
  in_EYKT_2017 = cols_eykt_2017,
  in_EYKT_2023 = cols_eykt_2023);compare_cols6

EYKT_2017 <- EYKT_2017 %>% 
  mutate(mgmt_area = "EYKT",
         dive_type = "Line",
         time_utc = NA,
         time_ak = NA,
         time_akst = NA,
         seconds = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         horita_code=NA,
         start_end = case_when(
           start_end == "START" ~ "Start",
           start_end == "END"   ~ "End",
           TRUE ~ start_end))

# NSEO 2018 --------------------------------------------------------------------

cols_nseo_2018 <- names(NSEO_2018)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

# Get max length between the two
max_len <- max(length(cols_nseo_2018), length(cols_eykt_2023))

# Make lists to the same length
cols_nseo_2018 <- c(cols_nseo_2018, rep(NA, max_len - length(cols_nseo_2018)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols7 <- data.frame(
  in_NSEO_2018 = cols_nseo_2018,
  in_EYKT_2023 = cols_eykt_2023);compare_cols7

NSEO_2018 <- NSEO_2018 %>% 
  rename(start_end=check_id) %>% 
    mutate(mgmt_area = "NSEO",
           time_utc = NA,
           time_akst = NA,
           time_ak = NA,
           time_hms_1 = NA,
           actual_time_hms = NA,
           actual_time_ak_std = NA,
           horita_code=NA,
         start_end = case_when(
           start_end == "START" ~ "Start",
           start_end == "END"   ~ "End",
           TRUE ~ start_end))

# CSEO 2018 --------------------------------------------------------------------

cols_cseo_2018 <- names(CSEO_2018)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

# Get max length between the two
max_len <- max(length(cols_cseo_2018), length(cols_eykt_2023))

# Make lists to the same length
cols_cseo_2018 <- c(cols_cseo_2018, rep(NA, max_len - length(cols_cseo_2018)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols8 <- data.frame(
  in_CSEO_2018 = cols_cseo_2018,
  in_EYKT_2023 = cols_eykt_2023);compare_cols8

CSEO_2018 <- CSEO_2018 %>% 
  mutate(mgmt_area = "CSEO",
         dive_type = "Line",
         time_utc = NA,
         time_ak = NA,
         time_akst = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         horita_code=NA,
         start_end = case_when(
           start_end == "START" ~ "Start",
           start_end == "END"   ~ "End",
           TRUE ~ start_end))

# SSEO 2018 --------------------------------------------------------------------

cols_sseo_2018 <- names(SSEO_2018)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

# Get max length between the two
max_len <- max(length(cols_sseo_2018), length(cols_eykt_2023))

# Make lists to the same length
cols_sseo_2018 <- c(cols_sseo_2018, rep(NA, max_len - length(cols_sseo_2018)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols9 <- data.frame(
  in_SSEO_2018 = cols_sseo_2018,
  in_EYKT_2023 = cols_eykt_2023);compare_cols9

SSEO_2018 <- SSEO_2018 %>% 
  mutate(mgmt_area = "SSEO",
         dive_type = "Line",
         time_utc = NA,
         time_ak = NA,
         time_akst = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         horita_code=NA,
         start_end = case_when(
           start_end == "START" ~ "Start",
           start_end == "END"   ~ "End",
           TRUE ~ start_end))

# EYKT 2019 --------------------------------------------------------------------

cols_eykt_2019 <- names(EYKT_2019)
cols_eykt_2023 <- names(EYKT_2023) 

# Get max length between the two
max_len <- max(length(cols_eykt_2019), length(cols_eykt_2023))

# Make lists to the same length
cols_eykt_2019 <- c(cols_eykt_2019, rep(NA, max_len - length(cols_eykt_2019)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols10 <- data.frame(
  in_EYKT_2019 = cols_eykt_2019,
  in_EYKT_2023 = cols_eykt_2023);compare_cols10

EYKT_2019 <- EYKT_2019 %>% 
  rename(start_end=check_id) %>% #rename check_id to start_end
  mutate(mgmt_area = "EYKT",
         time_utc = NA,
         time_ak = NA,
         time_akst = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         horita_code=NA,
         start_end = case_when( #fill start_end with the start end info that is recorded in the comments
           comment_1 == "START" ~ "Start",
           comment_1 == "END"   ~ "End",
           TRUE ~ start_end))


# SSEO 2020 --------------------------------------------------------------------

cols_sseo_2020 <- names(SSEO_2020)
cols_eykt_2023 <- names(EYKT_2023) 

# Get max length between the two
max_len <- max(length(cols_sseo_2020), length(cols_eykt_2023))

# Make lists to the same length
cols_sseo_2020 <- c(cols_sseo_2020, rep(NA, max_len - length(cols_sseo_2020)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols11 <- data.frame(
  in_SSEO_2020 = cols_sseo_2020,
  in_EYKT_2023 = cols_eykt_2023);compare_cols11

SSEO_2020 <- SSEO_2020 %>% 
  mutate(mgmt_area = "SSEO",
         dive_type = "Line",
         time_utc = NA,
         time_ak = NA,
         time_akst = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         horita_code=NA,
         event_time_hh_mm_ss = NA) %>% 
  rename(dive = dive_no,
         transect_number = transect_no)

# CSEO 2022 --------------------------------------------------------------------

cols_cseo_2022 <- names(CSEO_2022)
cols_eykt_2023 <- names(EYKT_2023) 

# Get max length between the two
max_len <- max(length(cols_cseo_2022), length(cols_eykt_2023))

# Make lists to the same length
cols_cseo_2022 <- c(cols_cseo_2022, rep(NA, max_len - length(cols_cseo_2022)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols11 <- data.frame(
  in_CSEO_2022 = cols_cseo_2022,
  in_EYKT_2023 = cols_eykt_2023);compare_cols11

CSEO_2022 <- CSEO_2022 %>% 
  mutate(mgmt_area = "CSEO",
         time_utc = NA,
         time_ak = NA,
         time_akst = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         horita_code=NA,
         actual_time_ak_std = NA,) %>% 
  rename(dive=dive_no,
         transect_number=transect_no)



# NSEO 2022 --------------------------------------------------------------------

cols_NSEO_2022 <- names(NSEO_2022)
cols_eykt_2023 <- names(EYKT_2023) 

# Get max length between the two
max_len <- max(length(cols_NSEO_2022), length(cols_eykt_2023))

# Make lists to the same length
cols_NSEO_2022 <- c(cols_NSEO_2022, rep(NA, max_len - length(cols_NSEO_2022)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols13 <- data.frame(
  in_NSEO_2022 = cols_NSEO_2022,
  in_EYKT_2023 = cols_eykt_2023);compare_cols13


NSEO_2022 <- NSEO_2022 %>% 
  rename(start_end=check_id) %>% #rename check_id to start_end
  mutate(mgmt_area = "NSEO",
         time_utc = NA,
         time_ak = NA,
         time_akst = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         horita_code=NA,
         seconds = NA,
         start_end = case_when( #fill start_end with the start end info that is recorded in the comments
           comment_1 == "START" ~ "Start",
           comment_1 == "END"   ~ "End",
           TRUE ~ start_end))


# EYKT 2023 --------------------------------------------------------------------

EYKT_2023 <- EYKT_2023 %>% 
  mutate(mgmt_area = "EYKT", 
         seconds = NA,
         time_utc = NA,
         time_akst = NA,
         time_ak = NA,
         time_hms_1 = NA,
         actual_time_hms = NA,
         actual_time_ak_std = NA,
         horita_code=NA) %>% 
  rename(start_end = check_id)

#recombine them in this list
all_dfs_edited <- list(
  CSEO_2012,
  SSEO_2013,
  EYKT_2015,
  CSEO_2016,
  NSEO_2016,
  EYKT_2017,
  NSEO_2018,
  CSEO_2018,
  SSEO_2018,
  EYKT_2019,
  SSEO_2020,
  CSEO_2022,
  NSEO_2022, 
  EYKT_2023) 

# Final standardizaiton --------------------------------------------------------

# Set EYKT_2023 as the template
template_cols <- names(EYKT_2023)

# Clean and align all data frames to match template
all_dfs_aligned <- lapply(all_dfs_edited, function(df) {
  
  # Add any missing columns
  missing_cols <- setdiff(template_cols, names(df))
  df[missing_cols] <- NA
  
  # Reorder columns to match template
  df <- df[, template_cols, drop = FALSE]
  
  # Convert all columns to character to prevent type conflicts
  df[] <- lapply(df, as.character)
  
  return(df)
})

# COMBINE THE DATA
ROV_quality_review_all_years <- bind_rows(all_dfs_aligned)

#Cleaning the data -------------------------------------------------------------

ROV_quality_review_all_years <- ROV_quality_review_all_years %>%
  select(-all_of(c("period","period_time_hms"))) %>% 
  mutate(year = as.character(year),
       dive = as.character(dive),
       transect_number = as.character(transect_number),
       species = as.character(species),
       code = as.character(code),
       op_code = "QC",
       family = case_when(code %in% c("GGF","GRB","GRBC")~"Good", TRUE ~ "Bad"))

write.csv(ROV_quality_review_all_years,"outputs/ROV_quality_review_all_years.csv")

# Data Exploration  ------------------------------------------------------------
names(ROV_quality_review_all_years)

unique(ROV_quality_review_all_years$op_code) #change to QC for everything!
unique(ROV_quality_review_all_years$tape_reader)
unique(ROV_quality_review_all_years$depth) #what depth is being recorded here?
unique(ROV_quality_review_all_years$year) #NA is being pulled for one of the years
unique(ROV_quality_review_all_years$dive_type) #which years has NA for dive type?
unique(ROV_quality_review_all_years$genus) #poor visibility spelled wrong, going backward spelled wrong
unique(ROV_quality_review_all_years$species)
#species should be the same as code - could honestly be removed
unique(ROV_quality_review_all_years$code) #this is a discrepancy between species and genus here.
#the species does not have resting on bottom but the code GRB is being used
#the code BCF is not being but the species "bad camera focus" is being used
unique(ROV_quality_review_all_years$number) #is this field always being used correctly? i think we just set it to 1
unique(ROV_quality_review_all_years$stage) #remove
unique(ROV_quality_review_all_years$activity) #remove
unique(ROV_quality_review_all_years$start_end) #needs some cleaning! 
unique(ROV_quality_review_all_years$comment_1)
unique(ROV_quality_review_all_years$event_time_hh_mm_ss)
unique(ROV_quality_review_all_years$mgmt_area)#NSEO with a space at the end needs to be fixed
unique(ROV_quality_review_all_years$seconds)
unique(ROV_quality_review_all_years$time_utc)
unique(ROV_quality_review_all_years$time_akst) #nothing here - could remove this column
unique(ROV_quality_review_all_years$time_ak)
unique(ROV_quality_review_all_years$time_hms_1)
unique(ROV_quality_review_all_years$actual_time_hms)
unique(ROV_quality_review_all_years$actual_time_ak_std) #nothing here - could remove this column
unique(ROV_quality_review_all_years$horita_code)



