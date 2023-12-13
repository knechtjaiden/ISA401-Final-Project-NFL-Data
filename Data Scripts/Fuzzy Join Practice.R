# Need to read in each CSV still

# Final Join ----------------------------------------------------------------------
matching_function <- function(x, y) {
  stringdist::stringdistmatrix(x, y, method = "jaccard") <= 0.2
}

# Perform fuzzy inner joins
final_table <- fuzzy_inner_join(
  x = qb_leaders,
  y = fantasy_rankings,
  by = c("Player" = "Name"),
  match_fun = matching_function
) |> 
  fuzzy_inner_join(
    y = unique_table,
    by = c("Player" = "Name"),
    match_fun = matching_function
  )
# Save to Excel ------------------------------------------------------------------
# write.xlsx(final_table, "ISA 401 Final Project Data.xlsx")