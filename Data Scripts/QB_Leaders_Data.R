# Install packages
install.packages('rvest','lubridate','dplyr','stringr')

# Loading proper libraries
library(rvest)
library(lubridate)
library(dplyr)
library(stringr)

# Creating the Dataframe
rvest::read_html('https://www.pro-football-reference.com/leaders/pass_yds_career.htm') %>% 
  rvest::html_elements(css='#pass_yds_leaders') %>% 
  rvest::html_table(header=1) %>% 
  magrittr::extract2(1)-> qb_leaders 
glimpse(qb_leaders)

# Changing the Yds column to a Double
qb_leaders$Yds <- gsub(",", "", qb_leaders$Yds) # This will remove the commas
qb_leaders$Yds <- as.numeric(qb_leaders$Yds) # This will convert the character strings to double

# Splitting Years and Changing to Date
qb_leaders$Year_Start <- sapply(strsplit(qb_leaders$Years, "-"), "[", 1)
qb_leaders$Year_End <- sapply(strsplit(qb_leaders$Years, "-"), "[", 2)
qb_leaders$Year_Start <- as.Date(paste0(qb_leaders$Year_Start, "-01-01"), "%Y-%m-%d")
qb_leaders$Year_End <- as.Date(paste0(qb_leaders$Year_End, "-12-31"), "%Y-%m-%d")
qb_leaders$Year_Start <- year(qb_leaders$Year_Start)
qb_leaders$Year_End <- year(qb_leaders$Year_End)
# Get rid of Years
qb_leaders <- select(qb_leaders, -Years)

# Split off Player into Hall of Famer
qb_leaders$`Hall of Famer` <- str_detect(qb_leaders$Player, fixed("+"))
qb_leaders$Player <- str_replace_all(qb_leaders$Player, fixed("+"), "")

# Write into Excel
write.xlsx(qb_leaders, "QB Leaders.xlsx")
