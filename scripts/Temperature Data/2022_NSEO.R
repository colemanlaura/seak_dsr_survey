# This code will be used to combine the temperature data from the ROV with the output from the species review.
# Each survey will be processed individually.

# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: 11/12/24

# set up ----
source('r/helper.r') 

###  set plotting theme to use TNR  ###
#font_import() #remove # to run this but only do this one time - it takes a while
loadfonts(device="win")
windowsFonts(Times=windowsFont("TT Times New Roman"))
theme_set(theme_bw(base_size=18,base_family='Times New Roman')
          +theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()))


#Year - insert the year the survey took place
YEAR <- 2022

#Groundfish Management Area
MGMT_AREA <- "NSEO"

##########################################################################################
### IMPORT DATA ###
# The ROV data is saved on the groundfish drive by year and GF management area.
# For this data exploration we will just start with 2023
##########################################################################################

# Load in the temperature data - this also includes pressure and depth data - this data is
# recorded by the ROV and the files are sent to GF staff by Mike Byerly
# Data copied into the data folder from: M:\ROVSurvey\Temperature Data\2022 NSEO\2022_NSEO_Temperature_Depth_Data.csv
temp_data <- read_csv("data/2022_NSEO_Temperature_Depth_Data.csv")

# This is another file that is sent each year by Mike Byerly- this file has the dive_id, date, time,
# start and end, comments, and YE count. 
# Data copied into data folder from: M:\ROVSurvey\2022\NSEO 2022\2022_NSEO_ROV_Data_Collection.csv
#There were two times that had a ; instead of : - fixed in excel
# Mike did not include the seconds in this file - so we shouldn't use it
ROV_data <- read_csv("data/2022_NSEO_ROV_Data_Collection.csv") %>%
  rename("Time"="TC (UTC)") %>%
  filter(Start_End=="Start"|Start_End=="End") %>%
  select("Dive_Id","Date") %>%
  fill(Dive_Id, .direction = "down") %>%
  fill(Date, .direction = "down") %>%
  mutate(dive_number = str_sub(Dive_Id, -2, -1))

str(ROV_data)

#Load in the quality review - this output is created by GF staff. Each transect has its own .csv file 
# from EventMEasure, which are combined for the assessment
# Data copied from: M:\ROVSurvey\2022\NSEO 2022\SPECIES REVIEW
QC_data <- read_csv("data/QC_NSEO_2022_summary.csv") %>% 
  select(Time..HMS.,Year,Dive,Transect.Number,Comment.1) %>% 
  rename(Time=Time..HMS., dive_number=Dive,Start_End=Comment.1) %>% 
  filter(Start_End=="START"|Start_End=="END") %>% 
  mutate(dive_number = sprintf("%02d", dive_number))

check <- QC_data %>%
  group_by(dive_number) %>%
  summarise(count = n()) 
#Dive 21 is missing the start because start was in all lowercase. Fixed this in excel.

str(QC_data)

# Load in the species review - this output is created by GF staff. Each transect has its own .csv file 
# from EventMEasure, which are combined for the assessment
# Data copied from: M:\ROVSurvey\2022\NSEO 2022\SPECIES REVIEW
species_data <- read_csv("data/SPECIES_NSEO_2022_summary.csv") %>% 
  select(Time..HMS., Dive, Transect.Number, Length..mm., Precision..mm., Dive.Type, Genus, 
         Species, Code, Stage, Activity, Comment.1) %>% 
  rename(Time=Time..HMS., dive_number=Dive) %>% 
  mutate(dive_number=as.character(dive_number)) %>% 
  mutate(Time=hms(Time)) %>% 
  filter(!Genus=="unknown")

##########################################################################################
#Merge the ROV data and the QC Data to add the date - the QC data does not have the date
merged_data <- QC_data %>%
  left_join(ROV_data, by = "dive_number") %>% 
  distinct()

#There should be 2 rows per dive - start and stop
check <- merged_data %>%
  group_by(dive_number) %>%
  summarise(count = n()) 

str(merged_data)

# Merge the temperature data and the QC data to add the dive number to the temp data. 
merged_data_final <- temp_data %>%
  left_join(merged_data, by = c("Date","Time")) 

# Next we want to label the rows between that the start and end as "Dive"so that we can easily EXCL all of 
# the rows when the ROV was not actively on transect.

# Initialize a flag to track whether we are in between "Start" and "End"
dive_flag <- FALSE

# Create a new column to store the dive status
merged_data_final$Dive_Status <- NA  # Initialize as NA

# Iterate over the rows to fill in the dive status
for (i in 1:nrow(merged_data_final)) {
  
  # Skip if Start_End is NA, we will handle NA rows later
  if (is.na(merged_data_final$Start_End[i])) {
    # If we are currently between a Start and End, fill with "Dive"
    if (dive_flag) {
      merged_data_final$Dive_Status[i] <- "DIVE"
    }
  } else {
    # Handle "Start" and "End" cases
    if (merged_data_final$Start_End[i] == "START") {
      dive_flag <- TRUE
      merged_data_final$Dive_Status[i] <- "START"
    }
    
    if (merged_data_final$Start_End[i] == "END") {
      dive_flag <- FALSE
      merged_data_final$Dive_Status[i] <- "END"
    }
  }
}

#Let's EXCL the non-transect rows - this is when the ROV is inbetween transects
merged_data_final <- merged_data_final %>%
  filter(Dive_Status %in% c("START", "END", "DIVE")) %>% 
  fill(dive_number, .direction = "down") %>% 
  select(-Dive_Id,-Start_End,-Year,-Transect.Number) %>% 
  mutate(Time=hms(Time))

##########################################################################################
# Merge the newly merged temp data with the species data - the goal here is to apply the depth and temperature to each fish 

final_dat <- merged_data_final %>%
  left_join(species_data, by = c("dive_number", "Time")) %>% 
  filter(!is.na(Species)) %>% 
  mutate(Stage = factor(Stage, levels = c("JV", "SU", "AD"))) %>% 
  filter(!dive_number==35) #exclude dive 35 - the depth is negative and temp is too high - suggests sensor was not in the water!

write.csv(final_dat,paste0("output/temp_species_data",YEAR,MGMT_AREA,".csv"))

##########################################################################################
# Data Exploration

#Calculate the average depth and temp for each dive
avg_temperature_per_dive <- final_dat %>%
  group_by(dive_number) %>%
  summarise(Average_Temperature = mean(Temperature, na.rm = TRUE),
            Average_Depth = mean(Depth, na.rm = TRUE))


# Plot the average temperature and depth per dive
temp <- ggplot(avg_temperature_per_dive, aes(x = factor(dive_number), y = Average_Temperature)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Average Temperature (°C) per Dive - NSEO 2022", x = "", y = "Average Temperature (°C)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5))

depth <- ggplot(avg_temperature_per_dive, aes(x = factor(dive_number), y = Average_Depth)) +
  geom_bar(stat = "identity", fill = "red", color = "black") +
  labs(title = "Average Depth (m) per Dive - NSEO 2022", x = "Transect Number", y = "Average Depth (m)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))

grid.arrange(temp, depth, ncol = 1)


# Calculate the avg temp and depth per species
avg_per_species <- final_dat %>%
  group_by(Genus) %>%
  summarise(Average_Temperature = mean(Temperature, na.rm = TRUE),
            Average_Depth = mean(Depth, na.rm = TRUE))

temp_species <- ggplot(avg_per_species, aes(x = factor(Genus), y = Average_Temperature)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Average Temperature per Scecies - NSEO 2022", x = "", y = "Average Temperature (°C)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5));temp_species

depth_species <- ggplot(avg_per_species, aes(x = factor(Genus), y = Average_Depth)) +
  geom_bar(stat = "identity", fill = "red", color = "black") +
  labs(title = "Average Depth per Species - NSEO 2022", x = "Species", y = "Average Depth (m)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5));depth_species

grid.arrange(temp_species, depth_species, ncol = 1)

#Let's look at all the data!
temp_species <- ggplot(final_dat, aes(x = factor(Genus), y = Temperature)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "Temperature per Species - NSEO 2022", x = "", y = "Temperature (°C)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))

depth_species <- ggplot(final_dat, aes(x = factor(Genus), y = Depth)) +
  geom_boxplot(fill = "red", color = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "Depth per Species - NSEO 2022", x = "Species", y = "Depth (m)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))

grid.arrange(temp_species, depth_species, ncol = 1)



#Let's look at all the yelloweye by stage
temp_YE_box <- final_dat %>% 
  filter(Genus == "yelloweye") %>% 
  ggplot(aes(x = factor(Stage), y = Temperature)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "Temperature per Yelloweye Rockfish Stage - NSEO 2022", x = "", y = "Temperature (°C)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))

depth_YE_box <- final_dat %>% 
  filter(Genus == "yelloweye") %>% 
  ggplot(aes(x = factor(Stage), y = Depth)) +
  geom_boxplot(fill = "red", color = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "Depth per Yelloweye Rockfish Stage - NSEO 2022", x = "Stage", y = "Depth (m)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))

grid.arrange(temp_YE_box, depth_YE_box, ncol = 1)





