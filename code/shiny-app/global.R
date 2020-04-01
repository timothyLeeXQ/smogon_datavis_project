library(dplyr)
library(tidyr)

#Dex import
df_dex <- readRDS(here("data", "dex.RDS"))

# Types data for splitting dex types from dex
types1 <- c("Grass", "Fire", "Water", "Electric", "Ground", "Rock", "Steel",
            "Flying", "Fighting", "Psychic", "Bug", "Poison", "Dragon",
            "Ghost", "Dark", "Normal", "Fairy", "Ice")
types2 <- c(types1, "")
types1_regex <- paste(types1, collapse = "|")
types2_regex <- paste(types2, collapse = "|")
types_regex_capture <- paste("(", types1_regex, ")", "(", types2_regex,")",
                             sep = "",
                             collapse = ""
                             )