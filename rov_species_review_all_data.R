# This code compiles all of the ROV survey data 
# Includes: raw species review data for ROV surveys 2012-2023
# Authors: Laura Coleman (laura.coleman@alaska.gov)
# Last modified: July 29, 2025

#ROV Surveys for DSR Stock Assessment
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
source('code/helper.r') 

###  set plotting theme to use TNR  ###
#font_import() #remove # to run this but only do this one time - it takes a while
loadfonts(device="win")
windowsFonts(Times=windowsFont("TT Times New Roman"))
theme_set(theme_bw(base_size=18,base_family='Times New Roman')
          +theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()))


##########################################################################################
### IMPORT DATA ###