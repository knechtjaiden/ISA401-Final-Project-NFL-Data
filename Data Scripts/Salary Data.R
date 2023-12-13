#Wide Reciever Salaries 
contract_WR = rvest::read_html('https://spotrac.com/nfl/rankings/contract-value/wide-receiver/')

contract_WR |> 
  rvest::html_element("table") |> 
  rvest::html_table() -> contract_WR

dplyr::glimpse(contract_WR)

contract_WR$Player = stringr::str_remove(contract_WR$Player, "\n\t\t\t\n            \t\n            \t\t\n\t                \t                        \t     \n               \n            \n        \t\n\t\t\t\t\n\t\t\t\t\t") |> 
  stringr::str_remove("\n\t\t\t\t\t")

library(tidyverse)

split_names <- strsplit(contract_WR$Player, "(?<=[a-z])(?=[A-Z])", perl=TRUE)

contract_WR$first_name <- sapply(split_names, `[`, 2)
contract_WR$last_name <- sapply(split_names, `[`, 1)

contract_WR |> dplyr::pull(first_name) |> stringr::str_split_fixed(pattern = ' ', n = 3) -> WR_Names

WR_df = data.frame(WR_Names)
colnames(WR_df) = c('First', 'Last', 'Team')

WR_df$Salary <- contract_WR$`contract value`

WR_df$Position <- contract_WR$POS

player_team_df$new_column <-NULL

WR_df$Salary <- gsub("\\$", "", WR_df$Salary)  # remove dollar sign
WR_df$Salary <- gsub(",", "", WR_df$Salary)  # remove commas
WR_df$Salary <- as.numeric(WR_df$Salary)  # convert to numeric

write.csv(WR_df, "WR Salary.csv", row.names = FALSE)

#Running Back Salaries
contract_RB = rvest::read_html('https://www.spotrac.com/nfl/rankings/contract-value/running-back/')

contract_RB |> 
  rvest::html_element("table") |> 
  rvest::html_table() -> contract_RB

dplyr::glimpse(contract_WR)

contract_RB$Player = stringr::str_remove(contract_RB$Player, "\n\t\t\t\n            \t\n            \t\t\n\t                \t                        \t     \n               \n            \n        \t\n\t\t\t\t\n\t\t\t\t\t") |> 
  stringr::str_remove("\n\t\t\t\t\t")

library(tidyverse)

split_names <- strsplit(contract_RB$Player, "(?<=[a-z])(?=[A-Z])", perl=TRUE)



contract_RB$first_name <- sapply(split_names, `[`, 2)
contract_RB$last_name <- sapply(split_names, `[`, 1)

contract_RB |> dplyr::pull(first_name) |> stringr::str_split_fixed(pattern = ' ', n = 3) -> RB_Names

RB_df = data.frame(RB_Names)
colnames(RB_df) = c('First', 'Last', 'Team')

RB_df$Salary <- contract_RB$`contract value`

RB_df$Position <- contract_RB$POS


RB_df$Salary <- gsub("\\$", "", RB_df$Salary)  # remove dollar sign
RB_df$Salary <- gsub(",", "", RB_df$Salary)  # remove commas
RB_df$Salary <- as.numeric(RB_df$Salary)  # convert to numeric

write.csv(RB_df, "WR Salary.csv", row.names = FALSE)


