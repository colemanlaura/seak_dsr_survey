# This code compiles all of the ROV survey data 
# Includes: raw species review data for ROV surveys 2012-2023
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: July 29, 2025

# The goal here is is create one file with ALL of the RAW ROV line transect data for 
# yelloweye rockfish stock assessment survey. I want to include ALL transects, with 
# all species. Kelli or Phil compiled a lot of this data already, so I will
# start with the outputs they created and will recombine raw files if needed.

# Note that this code should not be used to get the number of YE for the stock assessment survey
# I believe that yelloweye rockfish form the "bad" segments are not counted and are therefore
# removed. FLAG! This is something I still need to followup on.

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

###  set plotting theme to use TNR  ###
# #font_import() #remove # to run this but only do this one time - it takes a while
# loadfonts(device="win")
# windowsFonts(Times=windowsFont("TT Times New Roman"))
# theme_set(theme_bw(base_size=18,base_family='Times New Roman')
#           +theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()))


##########################################################################################
### IMPORT DATA ###

# 2012 -----------------------------------------------------------------------
# I cannot find the original files from eventmeasure, so that I can combine everything myself.
#Filepath: C:\Users\lscoleman\Documents\R code - Working Files\seak_dsr_survey\data\SPECIES_REVIEW_DATA\2012_CSEO\FishVideoReview_Feb2_2013ROV lengths_kg.csv

CSEO_2012_ALLdata <- read_csv("data/SPECIES_REVIEW_DATA/2012_CSEO/species_CSEO_2012.csv")

# 2013 -----------------------------------------------------------------------
# I cannot find the original files from event measure, so that I can combine everything myself.
# Filepath: M:\ROVSurvey\2013\species_SSEO_2013

# This was created in 2021, so I am assuming it was created by Phil or Kelli but there are 8 dives missing
# according to the dive log. 

#FLAG! I found event measure files for the missing dives but I did not find documentation 
# on why these dives were not included in the "species_SSEO_2013" file. I def want 
# to revisit this and make sure that those dives were included in the assessment in 2013.

# The 2013 ROV Distance Analysis notes have been saved in the documents folder

SSEO_2013_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/species_SSEO_2013.csv") %>% 
  mutate(Time..mins. = NA,
         Period.time..mins. = NA) #adding these columns to match the missing data

SSEO_2013_missing_data <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/species_SSEO_2013_missing_dives.csv") %>% 
  rename(Comment=Comment...20,
         Comment.1=Comment...37)

SSEO_2013_ALLdata <- rbind(SSEO_2013_ALLdata,SSEO_2013_missing_data)


# 2015 -----------------------------------------------------------------------
# I combined the raw files for this survey - see code: 2015_EYKT_MergingCSVFilesCode_SpeciesReviewData
# The 2015 ROV Distance Analysis notes have been saved in the documents folder

EYKT_2015_ALLdata <- read.csv("outputs/species_review/SPECIES_EYKT_2015.csv") 

# 2016 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2016
# The 2016 ROV Distance Analysis notes have been saved in the documents folder

CSEO_2016_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2016_CSEO/species_CSEO_2016.csv")

NSEO_2016_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2016_NSEO/species_NSEO_2016.csv")

# 2017 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2017
# The 2017 ROV Distance Analysis notes have been saved in the documents folder

EYKT_2017_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2017_EYKT/species_EYKT_2017.csv")

# 2018 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2018\CSEO\R Data Files\2018_cseo_species
# File path: M:\ROVSurvey\2018\NSEO\NSEO_2018_species
# File path: M:\ROVSurvey\2018\SSEO\Species Review Files\2018ROV Survey_FishVideoReview_SSEO

#It looks like dives 25 and 26 are missing but these dives were brf experimental dives
#There are .text files in the ROVSurvey/2018/CSEO/Stereo Files folder for those experimental dives
CSEO_2018_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2018_CSEO/species_CSEO_2018.csv")

#columns for NSEO 
cols <- c("Filename","Frame","Time..HMS.","Period","Period.time..HMS.","Length..mm.","Precision..mm.","RMS..mm.",
          "Range..mm.","Direction..deg.","Horz..Dir...deg.","Vert..Dir...deg.","Mid.X..mm.","Mid.Y..mm.","Mid.Z..mm.",
          "OpCode","TapeReader","Depth","Comment","Year","Dive","Transect.Number","Dive.Type","Family","Genus",
          "Species","Code","Number","Stage","Activity","Check.ID","Comment.1","Event.Time.HH.MM.SS")

NSEO_2018_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2018_NSEO/species_NSEO_2018.csv") %>% 
  mutate(Period = NA, 
         Period.time..HMS. = NA,
         Comment.1 = NA,
         Event.Time.HH.MM.SS = NA) %>% 
  select(any_of(cols))

#This spreadsheet is missing dive 26. I don't think it was included in the assessment because it is
#not in any of the combined species files in the 2018 NSEO
NSEO_2018_dive26 <- read.csv("data/SPECIES_REVIEW_DATA/2018_NSEO/NSEO_2018_Dive26.csv") %>% 
  select(! c(X,X.1,X.2,X.3)) %>% 
  select(any_of(cols))

NSEO_2018_ALLdata <- rbind(NSEO_2018_ALLdata,NSEO_2018_dive26)

unique(NSEO_2018_ALLdata$Dive)

SSEO_2018_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2018_SSEO/species_SSEO_2018.csv") %>% 
  # need to fix the dive and transect numbers for dive 16
  mutate(DIVE_NO = case_when(
    FILENAME == "SL_2018SSEO_Dive_16_19-03-14.000.avi" ~ 16, TRUE ~ DIVE_NO)) %>%  
  mutate(TRANSECT_NUMBER = case_when(
    FILENAME == "SL_2018SSEO_Dive_16_19-03-14.000.avi" ~ 64,TRUE ~ TRANSECT_NUMBER)) %>%
  # need to fix the dive and transect numbers for dive 21
  mutate(DIVE_NO = case_when(
    FILENAME == "SL_2018SSEO_Dive_21_10-59-57.000.avi" ~ 21,TRUE ~ DIVE_NO)) %>%  
  mutate(TRANSECT_NUMBER = case_when(
    FILENAME == "SL_2018SSEO_Dive_21_10-59-57.000.avi" ~ 69,TRUE ~ TRANSECT_NUMBER))

SSEO_2018_ALLdata %>% summarise(distinct_dives = n_distinct(DIVE_NO))

# the transect numbers recorded on the dive log from the field do not match what was recorded 
# in the species review files - i am going to assume that what is in the species review files
# is correct - may want to cross reference this with the GPS locations

# also note - dive 8 is missing because there was a note that the data was bad and to not use
# but there was no other explanation on why the data was bad (that I could find anyways!!)

# final note is that there are two other dives (34 and 35) that are on the dive log but are not
# in the species review. These dives were never analyzed in event measure and they do no belong
# to another area.

# with this in mind, 32 transects were used in the SEO DSR stock assessment but 35 were attempted

# FLAG! do we want to include dive 8 for completeness? i could not figure out why the data was bad
# so am worried about adding it and it accidentally being used for analysis


# 2019 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2019\EYKT\R Code\EYKT_2019\EYKT_2019_species
# There is not a document for the analysis beyond the SAFE report.

EYKT_2019_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2019_EYKT/species_EYKT_2019.csv") %>% 
  mutate(Dive = case_when(
  Filename == "SL_2019_EYKT_Dive_12_09-27-40.000.avi" ~ 12, TRUE ~ Dive))

# 2020 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2020\R Code\Data\SSEO_2020_Species
# I found that the transect number and dive number are flipped for transect 31.
# The 2020 ROV Distance Analysis notes have been saved in the documents folder

SSEO_2020_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2020_SSEO/species_SSEO_2020.csv") %>%
  #the transect number and dive number were flipped for dive 31
  mutate(Dive = case_when(
    Filename == "SL_2020_SSEO_Dive_31_09-34-49.000.avi" ~ 31, TRUE ~ Dive),
    Transect.Number = case_when(
      Filename == "SL_2020_SSEO_Dive_31_09-34-49.000.avi" ~ 18, TRUE ~ Transect.Number))

unique(SSEO_2020_ALLdata$Dive)
SSEO_2020_ALLdata %>% summarise(distinct_dives = n_distinct(Dive))

#This output was sent to Ivy for species distribution model
write.csv(SSEO_2020_ALLdata,"outputs/SPECIES_SSEO_2020_divenum_corrected.csv")

# 2022 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2022\CSEO 2022\R Data Files\SPECIES_CSEO_2022_summary
# The times in the original excel files were never converted to HHMMSS, so when combined in
# R originally, the times were still incorrect. I was unable to convert the time in the combined file,
# so I converted the time in the original species review .csv files and recombined them
# using the code 2022_CSEO_MergingCSVFilesCode_SpeciesReviewData

CSEO_2022_ALLdata <- read.csv("outputs/SPECIES_CSEO_2022.csv") %>% 
  # need to fix the dive and transect numbers for dive 17 - renamed from 17b to 17
  mutate(Dive = case_when(
    Filename == "SL_2022_CSEO_Dive_17b_07-57-18.000.avi" ~ 17,TRUE ~ as.numeric(Dive))) %>%  
  #dive number and transect number were both NA - changed to what is on the dive log
  mutate(Dive = case_when(
    Filename == "SL_2022_CSEO_Dive_18_14-14-08.000.avi" ~ 18,TRUE ~ as.numeric(Dive))) %>%  
  mutate(Transect.Number = case_when(
    Filename == "SL_2022_CSEO_Dive_18_14-14-08.000.avi" ~ 15,TRUE ~ as.numeric(Transect.Number))) %>% 
  mutate(Transect.Number = case_when(
    Filename == "SL_2022_CSEO_Dive_22_15-14-56.000.avi" ~ 23,TRUE ~ as.numeric(Transect.Number)))

unique(CSEO_2022_ALLdata$Dive)
CSEO_2022_ALLdata %>% summarise(distinct_dives = n_distinct(Dive))
CSEO_2022_ALLdata %>% summarise(distinct_trans = n_distinct(Transect.Number))

#This output was sent to Ivy for species distribution model
write.csv(CSEO_2022_ALLdata,"outputs/SPECIES_CSEO_2022_summary_time_corrected.csv")

# File path: M:\ROVSurvey\2022\NSEO 2022\SPECIES REVIEW\SPECIES_NSEO_2022_summary

NSEO_2022_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2022_NSEO/species_NSEO_2022.csv")

# 2023 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2023\EYKT\Final files for Analysis\SPECIES_EYKT_2023_summary
EYKT_2023_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2023_EYKT/species_EYKT_2023.csv")

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


CSEO_2012 <- CSEO_2012 %>% 
  mutate(mgmt_area = "CSEO",
         dive_type = "Line",
         time_hms = NA,
         period_time_hms = NA,
         event_time_hh_mm_ss = NA,
         time_akdt = NA) %>% #time_akdt is in 2015 EYKT so adding it here 
  rename(precision_mm = precision,
         rms_mm = rms_1_mm,
         op_code = opcode,
         depth = depth_not_used,
         comment = trip_comment,
         dive = dive_no,
         transect_number = transect_no,
         number = specimen_number,
         comment_1 = species_comment)

EYKT_2023 <- EYKT_2023 %>% 
  mutate(mgmt_area = "EYKT",
         time_mins = NA,
         period_time_mins = NA,
         rms_2_mm = NA,
         time_akdt = NA) #time_akdt is in 2015 EYKT so adding it here )

# SSEO 2013 --------------------------------------------------------------------

cols_sseo_2013 <- names(SSEO_2013)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

# Get max length between the two
max_len <- max(length(cols_sseo_2013), length(cols_eykt_2023))

# Make lists to the same length
cols_sseo_2013 <- c(cols_sseo_2013, rep(NA, max_len - length(cols_sseo_2013)))
cols_eykt_2023 <- c(cols_eykt_2023, rep(NA, max_len - length(cols_eykt_2023)))

# Combine into a data frame
compare_cols2 <- data.frame(
  in_SSEO_2013 = cols_sseo_2013,
  in_EYKT_2023 = cols_eykt_2023);compare_cols2

SSEO_2013 <- SSEO_2013 %>% 
  mutate(mgmt_area = "SSEO",
         dive_type = "Line",
         rms_2_mm = NA,
         time_akdt = NA) %>% #time_akdt is in 2015 EYKT so adding it here
  rename(rms_mm = rms_1_mm,
         dive = dive_no,
         transect_number = transect_no,
         event_time_hh_mm_ss = event_time)

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
  mutate(mgmt_area = "EYKT",
         dive_type = "Line",
         time_mins = NA,
         period_time_mins = NA,
         rms_2_mm = NA) %>%  
  rename(dive = dive_no,
         transect_number = transect_no) %>% 
  filter(!is.na(year))

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
  mutate(mgmt_area = "CSEO",
         dive_type = "Line",
         time_mins = NA,
         period_time_mins = NA,
         rms_2_mm = NA) %>%  
  rename(dive = dive_no,
         transect_number = transect_no)

# NSEO 2016 --------------------------------------------------------------------

cols_nseo_2016 <- names(NSEO_2016)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

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
  mutate(mgmt_area = "NSEO",
         dive_type = "Line",
         time_mins = NA,
         period_time_mins = NA,
         rms_2_mm = NA,
         event_time_hh_mm_ss = NA) %>%  
  rename(dive = dive_no,
         transect_number = transect_no) %>% 
  filter(!is.na(year)) #there is a rosethorn rf with no location data

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
         time_mins = NA,
         period_time_mins = NA,
         rms_2_mm = NA,
         event_time_hh_mm_ss = NA,
         time_akdt =  NA) %>%  
  rename(dive = dive_no,
         transect_number = transect_no) %>% 
  mutate(dive_type = case_when(
    filename == "SL_2017EYKT_Dive_16_11-05-02.000.avi" ~ "Exploratory", TRUE ~ as.character(dive_type)))

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
  mutate(mgmt_area = "NSEO",
         dive_type = "Line",
         time_mins = NA,
         period = NA,
         period_time_mins = NA,
         period_time_hms = NA,
         rms_2_mm = NA,
         time_akdt =  NA,
         event_time_hh_mm_ss = NA,
         comment_1 = NA)

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
  select(!dive) %>% #"dive" is "management area"_ "dive number", which is not helpful here
  mutate(mgmt_area = "CSEO",
         dive_type = "Line",
         time_mins = NA,
         period = NA,
         period_time_mins = NA,
         period_time_hms = NA,
         rms_2_mm = NA,
         time_akdt =  NA,
         event_time_hh_mm_ss = NA) %>%  
  rename(op_code = opcode,
         tape_reader = tapereader,
         dive = dive_no)

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
  select(!dive) %>% #"dive" is "management area"_ "dive number", which is not helpful here
  mutate(mgmt_area = "SSEO",
         dive_type = "Line",
         time_mins = NA,
         period_time_mins = NA,
         rms_2_mm = NA,
         time_akdt =  NA) %>%
  rename(op_code = opcode,
         tape_reader = tapereader,
         dive = dive_no)

# EYKT 2019 --------------------------------------------------------------------

cols_eykt_2019 <- names(EYKT_2019)
cols_eykt_2023 <- names(EYKT_2023) #should include the changes from the above step

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
  mutate(mgmt_area = "EYKT",
         time_mins = NA,
         period = NA,
         period_time_mins = NA,
         period_time_hms = NA,
         rms_2_mm = NA,
         time_akdt =  NA)

# SSEO 2020, CSEO and NSEO 2022 are the same as EYKT 2023, so don't need the other checks
# adding the columns that I needed to add to EYKT 2023

# SSEO 2020 --------------------------------------------------------------------
SSEO_2020 <- SSEO_2020 %>% 
  mutate(mgmt_area = "SSEO",
       time_mins = NA,
       period_time_mins = NA,
       rms_2_mm = NA,
       time_akdt = NA)

# CSEO 2022 --------------------------------------------------------------------
CSEO_2022 <- CSEO_2022 %>% 
  mutate(mgmt_area = "CSEO",
         time_mins = NA,
         period_time_mins = NA,
         rms_2_mm = NA,
         time_akdt = NA)

unique(CSEO_2022$dive)

# NSEO 2022 --------------------------------------------------------------------
NSEO_2022 <- NSEO_2022 %>% 
  mutate(mgmt_area = "NSEO",
         time_mins = NA,
         period_time_mins = NA,
         rms_2_mm = NA,
         time_akdt = NA)

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
ROV_species_review_all_years <- bind_rows(all_dfs_aligned)

#Cleaning the data -------------------------------------------------------------

ROV_species_review_all_years <- ROV_species_review_all_years %>% 
  mutate(year = as.character(year),
       dive_no = as.character(dive),
       transect_no = as.character(transect_number),
       species = as.character(species),
       code = as.character(code),
       length_mm = as.numeric(as.character(length_mm)),
       precision_mm = as.numeric(as.character(precision_mm)),
       rms_mm = as.numeric(as.character(rms_mm)),
       vert_dir_deg = as.character(vert_dir_deg),
       vert_dir_deg = na_if(vert_dir_deg, NA), 
       vert_dir_deg = as.numeric(as.character(vert_dir_deg))) %>% 
  mutate(tape_reader = case_when(
    tape_reader %in% c("Kristen", "Kristen Green ") ~ "Kristen Green",
    tape_reader %in% c("Jennifer Stahl", "Jenny") ~ "Jenny Stahl",
    tape_reader == "asia" ~ "Asia",
    tape_reader == "LauraColeman" ~ "Laura Coleman",
    TRUE ~ tape_reader),
    activity = case_when(
      activity == "fish seeking cover" ~ "Fish seeking cover",
      activity == "Fish milling" ~ "Fish milling/hovering",
      activity == "resting on bottom" ~ "Fish resting on bottom",
      activity == "Chase other" ~ "Fish chasing other fish",
      activity %in% c("fish moving slowly into frame", "moving slowly into frame") ~ "Fish moving slowly into frame",
      activity %in% c("fish moving quickly into frame", "moving quickly into frame") ~ "Fish moving quickly into frame",
      activity %in% c("actively swimming within frame", "Fish actively swimming within frame") ~ "Fish actively swimming in frame",
      activity %in% c("fish moving quickly out of frame", "Fish moving quickly out of frame.") ~ "Fish moving quickly out of frame",
      activity %in% c("milling", "milling/hovering") ~ "Fish milling/hovering",
      TRUE ~ activity),
    dive_type = case_when(
      dive_type == "Grouundtruth" ~ "Groundtruth",
      TRUE ~ dive_type)) %>% 
  filter(!dive_type %in% c("Groundtruth", "Exploratory")) %>% 
  mutate(dive_trans = paste(dive,transect_number, sep = "_"))

write.csv(ROV_species_review_all_years,"outputs/ROV_species_review_all_years.csv")

# Data Exploration  ------------------------------------------------------------
names(ROV_species_review_all_years)

unique(ROV_species_review_all_years$year)
unique(ROV_species_review_all_years$mgmt_area)
unique(ROV_species_review_all_years$tape_reader)
unique(ROV_species_review_all_years$family)
unique(ROV_species_review_all_years$genus)
unique(ROV_species_review_all_years$species)
unique(ROV_species_review_all_years$code)
unique(ROV_species_review_all_years$stage)
unique(ROV_species_review_all_years$activity)
unique(ROV_species_review_all_years$dive_type)

transects_per_area_per_year <- ROV_species_review_all_years %>%
  group_by(mgmt_area,year) %>%
  filter(!is.na(year)) %>% 
  summarise(num_dives = n_distinct(dive_trans)) %>%
  arrange(mgmt_area)

summary_table <- ROV_species_review_all_years %>%
  filter(species == 145 & stage %in% c("AD","SU")) %>% 
  group_by(mgmt_area, year) %>%  
  summarise(n_yelloweye = n())

# Data Exploration  ---------------------------------------------------------
#Since the adoption of the ROV in 2012, an average of 78% of all yelloweye 
#rockfish from the surveys moved minimally or slowly. Of those slow-moving 
#specimens, approximately 70% did not display directional movements (i.e., 
#they were milling or resting on the bottom). 


#The above text is from the draft of the ROP. I am assuming Kelli or Phil
#but I don't know where this analysis was completed. Below I replicated this
#analysis and updated the statement above in the ROP, which should be published
#in 2026


activity<- ROV_species_review_all_years %>%
  filter(genus=="yelloweye",
         !activity %in% c(""," "),
         !is.na(activity)) %>%  
  mutate(activity_new = case_when(
    activity %in% c("Fish milling/hovering",
                    "Fish resting on bottom",
                    "Fish moving slowly into frame",
                    "Fish moving slowly out of frame",
                    "Fish milling")~ "Not Moving or Minimal Movement",
    activity %in% c("Fish actively swimming in frame",
                    "Fish chasing other fish",
                    "Fish moving quickly into frame",
                    "Fish seeking cover",
                    "Fish being chased",
                    "Fish moving quickly out of frame",
                    "Fish actively swimming within frame",
                    "Feeding",
                    "Passing") ~ "Moving",
    activity == "Attracted" ~ "Attracted",
    TRUE ~ activity)) %>% 
  group_by(activity_new) %>% 
  summarize(count = n()) %>% 
  mutate(percentage = (count / sum(count)) * 100) %>%
  arrange(desc(percentage))

# Overall activity distribution
ggplot(activity, aes(x = reorder(activity_new, -percentage), y = percentage, fill = activity_new)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = paste0(round(percentage, 1), "%")), 
            vjust = -0.5, size = 4) +
  labs(title = "Yelloweye Rockfish Activity Distribution (All Years)",
    x = "Activity Category",
    y = "Percentage of Observations",
    fill = "Activity") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")


#Here I am asking the question - what is the percentage breakdown of the
# inactive fish? what activitiy are they doing?
inactive <- ROV_species_review_all_years %>%
  filter(genus == "yelloweye",
         !activity %in% c("", " "),
         !is.na(activity)) %>%
  mutate(
    activity_new = case_when(
      activity %in% c(
        "Fish milling/hovering",
        "Fish resting on bottom",
        "Fish moving slowly into frame",
        "Fish moving slowly out of frame",
        "Fish milling") ~ "Not Moving or Minimal Movement",
      activity %in% c(
        "Fish actively swimming in frame",
        "Fish chasing other fish",
        "Fish moving quickly into frame",
        "Fish seeking cover",
        "Fish being chased",
        "Fish moving quickly out of frame",
        "Fish actively swimming within frame",
        "Feeding",
        "Passing") ~ "Moving",
      activity == "Attracted" ~ "Attracted", TRUE ~ activity),
    inactive = case_when(activity %in% c(
        "Fish milling/hovering",
        "Fish resting on bottom",
        "Fish milling") ~ "No Movement",TRUE ~ "Moving")) %>%
  group_by(inactive) %>% 
  summarize(count = n()) %>% 
  mutate(percentage = (count / sum(count)) * 100) %>%
  arrange(desc(percentage))




# Breakdown of minimal movement behaviors
ggplot(inactive, aes(x = reorder(activity_new, -percentage), y = percentage, fill = activity_new)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = paste0(round(percentage, 1), "%")), 
            vjust = -0.5, size = 4) +
  labs(title = "Behavior Breakdown: Not Moving or Minimal Movement",
    x = "Specific Inactive Behaviors",
    y = "Percentage within Minimal Movement Group",
    fill = "Behavior") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none") +
  coord_flip()  # Flip for readability



