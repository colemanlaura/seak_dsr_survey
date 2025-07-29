# This code compiles all of the ROV survey data from the 2015 ROV Survey
# Includes: raw species review data for the 2015 ROV Survey
# Raw data can be found on the groundfish drive: M:\ROVSurvey\2015\Fish Review and Distance Results for Density\Text_and_Excel_Files
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: July 29, 2025

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
# There was a lot of variet in the data, so I needed to add them in one file at a time to review.
dive1 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive1.csv") %>% 
  clean_names() %>% 
  rename(dive_no=dive,
         transect_no=transect,
         event_time_hh_mm_ss=event_time_h_mm_ss)
dive2 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive2.csv") %>% 
  clean_names()%>% 
  rename(event_time_hh_mm_ss=event_time_h_mm_ss)
dive3 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive3.csv")%>% 
  clean_names()%>% 
  rename(event_time_hh_mm_ss=event_time_h_mm_ss)
dive4 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive4.csv")%>% 
  clean_names()
dive5 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive5.csv")%>% 
  clean_names()
dive6 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive6.csv")%>% 
  clean_names()
dive7 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive7.csv")%>% 
  clean_names()
#dive 8 was aborted
dive9 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive9.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive10 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive10.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive11 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive11.csv")%>% 
  clean_names()
#dive11 was a weird one where some fish were excluded - here i read in the
#"FOR GOLDEN" version
dive12 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive12.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive13 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive13.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive14 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive14.csv") %>% 
  rename(Time_AKDT=Time_UTC) %>% 
  clean_names()
dive15 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive15.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive16 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive16.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive17 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive17.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive18 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive18.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive19 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive19.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive20 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive20.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive21 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive21.csv")%>% 
  clean_names()
dive22 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive22.csv")%>% 
  clean_names()
dive23 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive23.csv")%>% 
  clean_names()
dive24 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive24.csv")%>% 
  clean_names()
dive25 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive25.csv")%>% 
  clean_names()
dive26 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive26.csv")%>% 
  clean_names()
dive27 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive27.csv")%>% 
  clean_names()
dive28 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive28.csv")%>% 
  clean_names()
dive29 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive29.csv")%>% 
  clean_names()
dive30 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive30.csv")%>% 
  clean_names()
dive31 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive31.csv")%>% 
  clean_names()
dive32 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive32.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive33 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive33.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()
dive34 <- read.csv("data/2015_ROV_SPECIES_DATA/2015_Dive34.csv")%>% 
  rename(Time_AKDT = AKDT)%>% 
  clean_names()

#now lets check that all of the dataframes match================================
# Make a list of expected dive object names
dive_names <- setdiff(paste0("dive", 1:34), "dive8")

# Filter only those that actually exist
existing_dive_names <- dive_names[dive_names %in% ls()]

# Load them into a list
df_list <- mget(existing_dive_names)

ref_names <- names(dive1)

for (i in seq_along(df_list)) {
  df <- df_list[[i]]
  if (!identical(names(df), ref_names)) {
    cat("\n❌ Column mismatch in", existing_dive_names[i], "\n")
    cat("  These are the names found:\n")
    print(names(df))
    cat("  Difference:\n")
    print(setdiff(union(names(df), ref_names), intersect(names(df), ref_names)))}}

#Combine files into one file====================================================
# List all dive object names, excluding dive8
dive_names <- paste0("dive", c(1:7, 9:34))

# Create a list of the actual dataframes
df_list <- mget(dive_names)

# Combine all into one dataframe
SPECIES_EYKT_2015 <- bind_rows(df_list)

View(SPECIES_EYKT_2015)

unique(SPECIES_EYKT_2015$year)
unique(SPECIES_EYKT_2015$dive_no)

#Export dataframe into a new csv file==================================================
write.csv(SPECIES_EYKT_2023,"Output/SPECIES_EYKT_2015.csv", row.names = FALSE)
