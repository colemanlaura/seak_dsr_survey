# This code compiles all of the ROV survey data 
# Includes: raw species review data for ROV surveys 2012-2023
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: July 29, 2025

## ROV Surveys for DSR Stock Assessment
## two hashtags are used when the data has added to this repo
## CSEO_2012
## SSEO_2013
## 2014 CANCELED
## EYKT_2015
## CSEO_2016
## NSEO_2016
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

#The goal here is is create one file with ALL of the RAW ROV data. I want to include ALL
#transects, with all species. Kelli or Phil compiled a lot of this data already, so I will
#start with the outputs they created and will recombine raw files if needed.

# TO DO:
# Dive 11, EYKT 2015 has multiple version and I think I should read in all of those versions to have available to play with
# I added dive_type to several of these files - i need to figure out id there were any other experimental transects
# Check with Kelli - who added the data to oceanak, need to verify - justin didn't know


# set up ----
source('scripts/helper.r') 

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

CSEO_2012_ALLdata <- read_csv("data/SPECIES_REVIEW_DATA/2012_CSEO/species_CSEO_2012.csv")

# 2013 -----------------------------------------------------------------------
# I cannot find the original files from event measure, so that I can combine everything myself.
# Filepath: M:\ROVSurvey\2013\species_SSEO_2013
# This was created in 2021, so I am assuming it was created by Phil or Kelli
# The 2013 ROV Distance Analysis notes have been saved in the documents folder

SSEO_2013_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/species_SSEO_2013.csv")

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

CSEO_2018_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2018_CSEO/species_CSEO_2018.csv")

NSEO_2018_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2018_SSEO/species_SSEO_2018.csv")

SSEO_2018_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2018_NSEO/species_NSEO_2018.csv")

# 2019 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2019\EYKT\R Code\EYKT_2019\EYKT_2019_species
# There is not a document for the analysis beyond the SAFE report.

EYKT_2019_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2019_EYKT/species_EYKT_2019.csv")

# 2020 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2020\R Code\Data\SSEO_2020_Species
# The 2020 ROV Distance Analysis notes have been saved in the documents folder

SSEO_2020_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2020_SSEO/species_SSEO_2020.csv")

# 2022 -----------------------------------------------------------------------
# File path: M:\ROVSurvey\2022\CSEO 2022\R Data Files\SPECIES_CSEO_2022_summary
# File path: M:\ROVSurvey\2022\NSEO 2022\SPECIES REVIEW\SPECIES_NSEO_2022_summary

CSEO_2022_ALLdata <- read.csv("data/SPECIES_REVIEW_DATA/2022_CSEO/species_CSEO_2022.csv")

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

# Here I am going to remove the columns that start with X or "user"- these are empty columns and not needed
all_dfs <- lapply(all_dfs, function(df) {
  df[!grepl("^(x|user)", names(df), ignore.case = TRUE)]})

#Unpacks each cleaned dataframe back into your global environment
list2env(all_dfs, envir = .GlobalEnv)

lapply(all_dfs, names)

rbind(SSEO_2020,
      CSEO_2022,
      NSEO_2022,
      EYKT_2023)




