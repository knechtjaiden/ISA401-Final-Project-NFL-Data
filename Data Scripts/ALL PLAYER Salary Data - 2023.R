
#Scrape Data From Spotrac.com-------------------------------------------------------
"https://www.spotrac.com/nfl/rankings/contract-value/" |> 
  rvest::read_html() |>
  rvest::html_node("table") |>
  rvest::html_table() -> all_players

all_teams = "https://www.profootballnetwork.com/nfl-teams-in-alphabetical-order/" |> 
  rvest::read_html() |>
  rvest::html_nodes("div > ul:nth-child(7) > li") |> 
  rvest::html_text2() |> 
  tolower() |>
  stringr::str_replace_all(' ', '-')

all_urls = paste0("https://www.spotrac.com/nfl/rankings/contract-value/", all_teams, '/')

scrape_fun = function(url){
  url |> 
    rvest::read_html() |>
    rvest::html_node("table") |>
    rvest::html_table() -> all_players
  return(all_players)
}

all_players = purrr::map_df(.x = all_urls, .f = scrape_fun)
players_df = all_players |> dplyr::select(Player, POS, `contract value`)

players_df = players_df[-seq(16, by = 16, to =2109),]

#Clean Player Data -----------------------------------------------------------------
dplyr::glimpse(players_df)

players_df$Player = stringr::str_remove(players_df$Player, "\n\t\t\t\n            \t\n            \t\t\n\t                \t                        \t     \n               \n            \n        \t\n\t\t\t\t\n\t\t\t\t\t") |> 
  stringr::str_remove("\n\t\t\t\t\t")

library(tidyverse)

split_names <- strsplit(players_df$Player, "(?<=[a-z])(?=[A-Z])", perl=TRUE)

players_df$first_name <- sapply(split_names, `[`, 2)
players_df$last_name <- sapply(split_names, `[`, 1)

players_df |> dplyr::pull(first_name) |> stringr::str_split_fixed(pattern = ' ', n = 3) -> Player_Names

Salary_df = data.frame(Player_Names)
colnames(Salary_df) = c('First', 'Last', 'Team')

Salary_df$Salary <- players_df$`contract value`

Salary_df$Position <- players_df$POS

Salary_df$Player <- paste(Salary_df$First, Salary_df$Last)
Salary_df$First <-NULL
Salary_df$Last <-NULL

Salary_df$Salary <- gsub("\\$", "", Salary_df$Salary)  # remove dollar sign
Salary_df$Salary <- gsub(",", "", Salary_df$Salary)  # remove commas
Salary_df$Salary <- as.numeric(Salary_df$Salary)  # convert to numeric

write.csv(Salary_df, "All Player Salary.csv", row.names = FALSE)



