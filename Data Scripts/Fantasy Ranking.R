# Loading proper libraries
library(rvest)
library(lubridate)
library(dplyr)
library(stringr)

# Creating the Dataframe
rvest::read_html('https://fantasy.nfl.com/research/rankings?leagueId=0&position=WR&statSeason=2023&statType=seasonStats&week=10') |> 
  rvest::html_elements(css='table') |> 
  rvest::html_table(header=1) |>  
  magrittr::extract2(1)-> wr_draft_rank

rvest::read_html('https://fantasy.nfl.com/research/rankings?leagueId=0&position=RB&statSeason=2023&statType=seasonStats&week=10') |> 
  rvest::html_elements(css='table') |> 
  rvest::html_table(header=1) |>  
  magrittr::extract2(1)-> rb_draft_rank

rvest::read_html('https://fantasy.nfl.com/research/rankings?leagueId=0&position=QB&statSeason=2023&statType=seasonStats&week=10') |> 
  rvest::html_elements(css='table') |> 
  rvest::html_table(header=1) |>  
  magrittr::extract2(1)-> qb_draft_rank

rvest::read_html('https://fantasy.nfl.com/research/rankings?leagueId=0&position=TE&statSeason=2023&statType=seasonStats&week=10') |> 
  rvest::html_elements(css='table') |> 
  rvest::html_table(header=1) |>  
  magrittr::extract2(1)-> te_draft_rank

rvest::read_html('https://fantasy.nfl.com/research/rankings?leagueId=0&position=K&statSeason=2023&statType=seasonStats&week=10') |> 
  rvest::html_elements(css='table') |> 
  rvest::html_table(header=1) |>  
  magrittr::extract2(1)-> k_draft_rank


# Combine all dataframes into one
combined_df <- rbind(wr_draft_rank, rb_draft_rank, qb_draft_rank, te_draft_rank, k_draft_rank)

# Clean Data
# Define the regular expression pattern
pattern <- "(.*) (WR|RB|QB|TE|K) - ([A-Z]+)(.*)?"

# Use str_match() to extract the components
matches <- str_match(combined_df$Player, pattern)

# Create new columns for Name, Position, Team, and IR
combined_df$Name <- matches[,2]
combined_df$Position <- matches[,3]
combined_df$Team <- matches[,4]

combined_df=combined_df |> select(-Rank,-Player,-"Salary ($)")
fantasy_rankings=combined_df
str(fantasy_rankings)

# Write into Excel
write.xlsx(fantasy_rankings, "Fantasy Rankings.xlsx")
