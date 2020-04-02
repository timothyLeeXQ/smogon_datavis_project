library(dplyr)
library(tidyr)
library(here)

# Dex import
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
# Gens
gen_vec <- paste("Gen", c(1:8))

# Formats
formats <- c("OU", "Ubers", "UU", "RU", "NU", "PU", "LC", "Anything Goes",
             "Monotype", "NFE", "1v1", "CAP", "Battle Stadium Singles",
             "Doubles OU", "Doubles Ubers", "Doubles UU", "Battle Stadium Doubles",
             "2v2 Doubles", "National Dex", "National Dex AG",
             "Inheritance", "Scalemons","Balanced Hackmons", "Mix and Mega",
             "Almost Any Ability", "STABmons", "Pet Mod Clean Slate Micro"
             )

# Skill rankings
skill_ranking <- c("0", "1500",
                   "1630 (all formats except current gen OU)", "1695 (for current gen OU)",
                   "1760 (all formats except current gen OU)", "1825 (for current gen OU)")