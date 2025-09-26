# This code compiles all of the ROV survey data from the 2013 ROV Survey
# Includes: raw species review data for the 2013 ROV Survey but only include the 
# dives 9, 13, 14, 41, 45, 47, 49 and 56.
# In the 2013 folder there is file called species_SSEO_2013 that I assume was 
# made by Kellii or Phil but it is missing the above dives for some reason.
# Raw data can be found on the groundfish drive: MM:\ROVSurvey\2013\Fish Review\Text files
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: July 29, 2025

# set up ----
source('scripts/helper.r') 

##########################################################################################
### IMPORT DATA ###
# There was a lot of variet in the data, so I needed to add them in one file at a time to review.
dive56 <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/missing species review files 2013 sseo/SSEO_2013_dive_56.csv")

dive13 <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/missing species review files 2013 sseo/SSEO_2013_dive_13.csv") 

dive41 <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/missing species review files 2013 sseo/SSEO_2013_dive_41.csv")

dive47 <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/missing species review files 2013 sseo/SSEO_2013_dive_47.csv")

dive45 <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/missing species review files 2013 sseo/SSEO_2013_dive_45.csv")

dive14 <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/missing species review files 2013 sseo/SSEO_2013_dive_14.csv")

dive49 <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/missing species review files 2013 sseo/SSEO_2013_dive_49.csv")

dive9 <- read.csv("data/SPECIES_REVIEW_DATA/2013_SSEO/missing species review files 2013 sseo/SSEO_2013_dive_9.csv")

dive_list <- list(dive56, dive13, dive41, dive47, dive45, dive14, dive49, dive9)

#Remove the first 3 rows and make the fourth row a header ----------------------
dive_list <- lapply(dive_list, function(df) {
  # Get the 4th row and use it as column names
  new_header <- as.character(df[4, ])
  
  # Remove the first 4 rows
  df <- df[-(1:4), ]
  
  # Assign new column names
  names(df) <- new_header
  
  # Reset rownames (optional)
  rownames(df) <- NULL
  
  return(df)
})

#Appy these changes back to the OG dataframe -----------------------------------
dive56 <- dive_list[[1]]
dive13 <- dive_list[[2]]
dive41 <- dive_list[[3]]
dive47 <- dive_list[[4]]
dive45 <- dive_list[[5]]
dive14 <- dive_list[[6]]
dive49 <- dive_list[[7]]
dive9  <- dive_list[[8]]

#Combine the dataframes
combined_df <- bind_rows(dive_list)

##########################################################################################
#Export dataframe into a new csv file ------------------------------------------
write.csv(combined_df,"data/SPECIES_REVIEW_DATA/2013_SSEO/species_SSEO_2013_missing_dives.csv", row.names = FALSE)
