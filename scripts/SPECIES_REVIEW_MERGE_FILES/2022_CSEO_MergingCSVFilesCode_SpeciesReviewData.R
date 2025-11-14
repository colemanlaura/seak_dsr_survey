# This code compiles all of the ROV survey data from the 2022 CSEO ROV Survey
# Includes: raw species review data for the 2022 CSEO ROV Survey
# The times in the original excel files were never converted to HHMMSS, so when combined in
# R originally, the times were still incorrect. I was unable to convert the time in the combined file,
# so I converted the time in the original species review .csv files and will recombine them here
# Raw data can be found on the groundfish drive: M:\ROVSurvey\2015\Fish Review and Distance Results for Density\Text_and_Excel_Files
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: Nov 13, 2025

# set up ----
source('scripts/helper.r') 

##Map to folder you want to combine csv files from======================================
mydir = "~/R code - Working Files/seak_dsr_survey/data/SPECIES_REVIEW_DATA/2022_CSEO/2022_ROV_SPECIES_DATA"


#Create a list of files that you want to merge into one file============================
speciesfiles = list.files(path=mydir, pattern="*.csv", full.names=TRUE)
speciesfiles

#Combine files into one file============================================================
SPECIES_CSEO_2022 <-do.call(rbind, lapply(
  speciesfiles, read.csv, as.is=T, skip = 4, header=TRUE)
)

SPECIES_CSEO_2022

View(SPECIES_CSEO_2022)

#Export dataframe into a new csv file==================================================
write.csv(SPECIES_CSEO_2022,"outputs/SPECIES_CSEO_2022.csv", row.names = FALSE)
