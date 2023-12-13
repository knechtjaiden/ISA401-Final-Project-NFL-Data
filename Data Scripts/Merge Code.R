#Read in Data --------------------------------------------------------------------
fantasy_rankings <- read.csv("G:\\My Drive\\Fall 2023\\ISA 401\\401 R Notebook\\Project\\Fantasy Rankings.xlsx - Sheet 1.csv")
QB_Leaders <- read.csv("G:\\My Drive\\Fall 2023\\ISA 401\\401 R Notebook\\Project\\QB Leaders.xlsx - Sheet 1.csv")
wonderlic <- read.csv("G:\\My Drive\\Fall 2023\\ISA 401\\401 R Notebook\\Project\\wonderlic.xlsx - Sheet 1.csv")

#Separate first and last names ---------------------------------------------------
Salary_df <- Salary_df %>% 
  separate(Player,
           c("First_Name", "Last_Name"),
           sep = " ")

wonderlic <- wonderlic %>% 
  separate(Player, 
           c("First_Name","Last_Name"), 
           sep = " ")

QB_Leaders <- QB_Leaders %>% 
  separate(Player,
           c("First_Name", "Last_Name"), 
           sep = " ")

fantasy_rankings <- fantasy_rankings %>% 
  separate(Name, 
           c("First_Name", 
             "Last_Name"), sep = " ")

#Join Tables----------------------------------------------------------------------------
library(dplyr)
salary_wonderlic <- inner_join(Salary_df, wonderlic, by = c('First_Name', 'Last_Name'))

qblead_wonderlic <- inner_join(QB_Leaders, wonderlic, by = c('First_Name', 'Last_Name'))

fantasy_wonderlic <- inner_join(fantasy_rankings, wonderlic, by = c('First_Name', 'Last_Name'))

salary_qblead <- inner_join(Salary_df, QB_Leaders, by = c('First_Name', 'Last_Name'))

salary_fantasy <- inner_join(Salary_df, fantasy_rankings, by = c('First_Name', 'Last_Name'))

merged <- inner_join(State_merged, wonderlic, by = c('First_Name', 'Last_Name'))
location <- read.csv("G:\\My Drive\\Fall 2023\\ISA 401\\401 R Notebook\\Project\\Locationcity.csv")

State_merged <- merge(Salary_df, location, by = "Team", all = TRUE)

Salary_df$Team = stringr::str_remove(Salary_df$Team, " ")

State_merged <- State_merged[-(1:229), ]
write.csv(State_merged, "Team Location Salary.csv", row.names = FALSE)

merged <- merge(State_merged, wonderlic, by = c('First_Name', 'Last_Name'), all = TRUE)
write.csv(merged, "Wonderlic Locatoin.csv", row.names = FALSE)

write.csv(salary_wonderlic, "Salary vs Wonderlic.csv", row.names = FALSE)
write.csv(qblead_wonderlic, "QB Leaders vs Wonderlic.csv", row.names = FALSE)
write.csv(fantasy_wonderlic, "Fantasy Rankings vs Wonderlic.csv", row.names = FALSE)
write.csv(salary_fantasy, "Fantasy Rankings vs Salary.csv", row.names = FALSE)

# Data Explorer-----------------------------------------------------------------------
DataExplorer::create_report(salary_wonderlic)
DataExplorer::create_report(qblead_wonderlic)
DataExplorer::create_report(fantasy_wonderlic)
