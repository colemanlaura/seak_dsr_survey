# This code will be used to combine the temperature data from the ROV with the output from the species review.
# Each survey will be processed individually.

# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: 5/5/25

# set up ----
source('r/helper.r') 

###  set plotting theme to use TNR  ###
#font_import() #remove # to run this but only do this one time - it takes a while
loadfonts(device="win")
windowsFonts(Times=windowsFont("TT Times New Roman"))
theme_set(theme_bw(base_size=18,base_family='Times New Roman')
          +theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()))


#Year - insert the year the survey took place
YEAR <- 2017

#Groundfish Management Area
MGMT_AREA <- "EYKT"

##########################################################################################
### IMPORT DATA ###
# The ROV data is saved on the groundfish drive by year and GF management area.
# For this data exploration we will just start with 2023
##########################################################################################

# Load in the temperature data - this only include temperature, date, and time
# Kristen Green and Jenny Stahl (maybe Kellii also) attached Hobo Tidbit loggers to Buttercup - according to Mike
# Data copied into the data folder from: M:\ROVSurvey\Temperature Data\2017 EYKT

# I had to rename the columns in excel - the other columns were empty, so i deleted those
# There are two files with temp data - one is Fahrenheit and the other is Celsius. We will use the Celsius to match 
# data collected from the other years
temp_data <- read_csv("data/2017_EYKT_Temperature_Data_ROV2.csv") %>% 
  separate(date_time, into = c("Date", "Time"), sep = " ") %>% 
  mutate(Time = ifelse(nchar(Time) == 5, paste0(Time, ":00"), Time)) %>%
  mutate(Time = parse_time(Time, "%H:%M:%S"))

# This is another file that is sent each year by Mike Byerly- this file has the dive_id, date, time,
# start and end, comments, and YE count.
# Data copied into data folder from: M:\ROVSurvey\2022\CSEO 2022\2022_CSEO_ROV_Data_Collection.csv
ROV_data <- read_csv("data/2017_EYKT_ROV_Data_Collection.csv") %>%
  rename("Time"="Time_AKDT") %>%
  filter(Start_End=="S"|Start_End=="E") %>%
  select("Dive_Id","Date") %>%
  fill(Dive_Id, .direction = "down") %>%
  fill(Date, .direction = "down") %>%
  mutate(dive_number = str_sub(Dive_Id, -2, -1),
           dive_number = str_replace_all(dive_number, "_", "0"))

#Here I am checking that there is a stop and an end for each dive
check <- ROV_data %>%
  group_by(dive_number) %>%
  summarise(count = n())

str(ROV_data)

# Load in the species review - this output is created by GF staff. Each transect has its own .csv file 
# from EventMEasure, which are combined for the assessment
# I needed to add the column time that had the milliseconds as :00 to facilitate combination
# with the temp data. Temp data is record every second but does not have milliseconds.
# Data copied from: M:\ROVSurvey\2022\CSEO 2022\SPECIES REVIEW
species_data <- read_csv("data/SPECIES_EYKT_2017_summary.csv") %>%
  select(Time, Dive.No, Transect.No, Length..mm., Precision..mm., Genus, Species, Code, Stage, Activity, Comment.1) %>%
  rename(dive_number = Dive.No) %>%
  mutate(dive_number = sprintf("%02d", as.integer(dive_number)))%>%
  filter(Genus != "unknown") 
  

 ##########################################################################################
#Merge the ROV data and the species data to get the date
merged_data <- species_data %>%
  left_join(ROV_data, by = "dive_number") %>% 
  distinct()


##########################################################################################
# Merge the newly merged temp data with the species data - the goal here is to apply the depth and temperature to each fish 
# One issue is that the time from the temperature data is not to the millisecond, so 
final_dat <- merged_data %>%
  left_join(temp_data, by = c("Date","Time")) %>% 
  select(-Comment.1,-number) %>% 
  mutate(Stage = factor(Stage, levels = c("JV", "SU", "AD"))) %>% 
  rename(Temperature=temp)

write.csv(final_dat,paste0("output/temp_summaries/temp_species_data",YEAR,MGMT_AREA,".csv"))

##########################################################################################
# Data Exploration

#Calculate the average temp for each dive
avg_temperature_per_dive <- final_dat %>%
  group_by(dive_number) %>%
  summarise(Average_Temperature = mean(Temperature, na.rm = TRUE))


# Plot the average temperature per dive
temp <- ggplot(avg_temperature_per_dive, aes(x = factor(dive_number), y = Average_Temperature)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Average Temperature (°C) per Dive - CSEO 2022", x = "", y = "Average Temperature (°C)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5)); temp


# Calculate the avg temp and depth per species
avg_per_species <- final_dat %>%
  group_by(Genus) %>%
  summarise(Average_Temperature = mean(Temperature, na.rm = TRUE))

temp_species <- ggplot(avg_per_species, aes(x = factor(Genus), y = Average_Temperature)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Average Temperature per Scecies - EYKT 2017", x = "", y = "Average Temperature (°C)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5));temp_species

#Let's look at all the data!
temp_species <- ggplot(final_dat, aes(x = factor(Genus), y = Temperature)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "Temperature per Species - EYKT 2017", x = "", y = "Temperature (°C)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5)); temp_species


#Let's look at all the yelloweye by stage
temp_YE_box <- final_dat %>% 
  filter(Genus == "yelloweye") %>% 
  ggplot(aes(x = factor(Stage), y = Temperature)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "Temperature per Yelloweye Rockfish Stage - EYKT 2017", x = "", y = "Temperature (°C)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5)); temp_YE_box





