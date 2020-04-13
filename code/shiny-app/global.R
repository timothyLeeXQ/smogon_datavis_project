library(magrittr)
library(dplyr)
library(tidyr)
library(stringr)
library(xml2)
library(rvest)
library(jsonlite)

# Dex
df_dex <- read_html("https://pokemondb.net/pokedex/all") %>%
  html_node(xpath = '//*[@id="pokedex"]') %>%
  html_table() %>%
  mutate(Name = str_replace_all(.data$Name, "é", "e")) %>%
  mutate(Name = str_replace_all(.data$Name, "♀", "F")) %>%
  mutate(Name = str_replace_all(.data$Name, "♂", "M")) %>%
  mutate(Name = str_replace_all(.data$Name, "Galarian.+", "-Galar")) %>%
  mutate(Name = str_replace_all(.data$Name, "Alolan.+", "-Alola")) %>%
  mutate(Name = str_replace_all(.data$Name, "Mega.+", "-Mega")) %>%
  mutate(Name = str_replace(.data$Name, "^-Mega", "Meganium")) %>%
  mutate(Name = str_remove_all(.data$Name, "Zen Mode|Standard Mode")) %>%
  mutate(Name = str_replace_all(.data$Name, "Eiscue.+", "Eiscue")) %>%
  mutate(Name = str_replace_all(.data$Name, " Rotom$", "")) %>%
  mutate(Name = str_replace_all(.data$Name, "Rotom", "Rotom-")) %>%
  mutate(Name = str_replace_all(.data$Name, "Rotom-$", "Rotom")) %>%
  mutate(Name = str_replace_all(.data$Name, "Morpeko.+", "Morpeko")) %>%
  mutate(Name = str_replace_all(.data$Name, "Basculin.+", "Basculin")) %>%
  mutate(Name = str_replace_all(.data$Name, "AegislashShield Forme", "Aegislash")) %>%
  mutate(Name = str_replace_all(.data$Name, "AegislashBlade Forme", "Aegislash-Blade")) %>%
  mutate(Name = str_replace_all(.data$Name, "Toxtricity.+", "Toxtricity")) %>%
  mutate(Name = str_replace_all(.data$Name, " Kyurem$", "")) %>%
  mutate(Name = str_replace_all(.data$Name, "Kyurem", "Kyurem-")) %>%
  mutate(Name = str_replace_all(.data$Name, "Kyurem-$", "Kyurem")) %>%
  mutate(Name = str_replace_all(.data$Name, "IndeedeeMale", "Indeedee")) %>%
  mutate(Name = str_replace_all(.data$Name, "IndeedeeFemale", "Indeedee-F")) %>%
  mutate(Name = str_replace_all(.data$Name, "Keldeo.+", "Keldeo")) %>%
  mutate(Name = str_replace_all(.data$Name, "Mr\\. ", "Mr.\\")) %>%
  mutate(Name = str_replace_all(.data$Name, "Mime ", "Mime")) %>%
  mutate(Name = str_replace_all(.data$Name, "Type: Null", "Type:Null")) %>%
  mutate(Name = str_replace_all(.data$Name, "Meowstic.+", "Meowstic")) %>%
  mutate(Name = str_replace_all(.data$Name, "Wishiwashi.+", "Wishiwashi")) %>%
  mutate(Name = str_replace_all(.data$Name, "Gourgeist", "Gourgeist-")) %>%
  mutate(Name = str_replace_all(.data$Name, "Pumpkaboo", "Pumpkaboo-")) %>%
  mutate(Name = str_remove_all(.data$Name, "(-Average)* Size$")) %>%
  mutate(Name = str_replace_all(.data$Name, "PikachuPartner Pickachu", "Pikachu-Starter")) %>%
  mutate(Name = str_replace_all(.data$Name, "Zacian", "Zacian-")) %>%
  mutate(Name = str_replace_all(.data$Name, "Zamazenta", "Zamazenta-")) %>%
  mutate(Name = str_remove_all(.data$Name, " Sword| Shield")) %>%
  mutate(Name = str_remove_all(.data$Name, "-*Hero of Many Battles")) %>%
  mutate(Name = str_replace_all(.data$Name, " Necrozma$", "")) %>%
  mutate(Name = str_replace_all(.data$Name, "Necrozma", "Necrozma-")) %>%
  mutate(Name = str_replace_all(.data$Name, "Necrozma-$", "Necrozma")) %>%
  mutate(Name = str_replace_all(.data$Name, "Dusk Mane", "Dusk-Mane")) %>%
  mutate(Name = str_replace_all(.data$Name, "Dawn Wings", "Dawn-Wings")) %>%
  mutate(Name = str_remove_all(.data$Name, "Incarnate Forme")) %>%
  mutate(Name = str_replace_all(.data$Name, "Therian Forme", "-Therian")) %>%
  mutate(Name = str_replace_all(.data$Name, "GreninjaAsh-Greninja", "Greninja-Ash")) %>%
  mutate(Name = str_replace_all(.data$Name, "^Tapu ", "Tapu")) %>%
  mutate(Name = str_replace_all(.data$Name, "Zygarde50% Forme", "Zygarde")) %>%
  mutate(Name = str_replace_all(.data$Name, "Zygarde10% Forme", "Zygarde-10")) %>%
  mutate(Name = str_replace_all(.data$Name, "ZygardeComplete Forme", "Zygarde-Complete")) %>%
  mutate(Name = str_remove_all(.data$Name, " Forme$")) %>%
  mutate(Name = str_replace_all(.data$Name, "Deoxys", "Deoxys-")) %>%
  mutate(Name = str_replace_all(.data$Name, "Deoxys-Normal", "Deoxys")) %>%
  mutate(Name = str_remove_all(.data$Name, " Meteor Form$|Core Form")) %>%
  mutate(Name = str_replace_all(.data$Name, "LycanrocMidday Form", "Lycanroc")) %>%
  mutate(Name = str_replace_all(.data$Name, "LycanrocMidnight Form", "Lycanroc-Midnight")) %>%
  mutate(Name = str_replace_all(.data$Name, "LycanrocDusk Form", "Lycanroc-Dusk")) %>%
  mutate(Name = str_replace_all(.data$Name, "MeloettaAria", "Meloetta")) %>%
  mutate(Name = str_replace_all(.data$Name, "MeloettaPirouette", "Meloetta-Pirouette")) %>%
  mutate(Name = str_replace_all(.data$Name, "ShayminLand", "Shaymin")) %>%
  mutate(Name = str_replace_all(.data$Name, "ShayminSky", "Shaymin-Sky")) %>%
  mutate(Name = str_replace_all(.data$Name, "WormadamPlant Cloak", "Wormadam")) %>%
  mutate(Name = str_replace_all(.data$Name, "WormadamSandy Cloak", "Wormadam-Sandy")) %>%
  mutate(Name = str_replace_all(.data$Name, "WormadamTrash Cloak", "Wormadam-Trash")) %>%
  mutate(Name = str_replace_all(.data$Name, "OricorioBaile Style", "Oricorio")) %>%
  mutate(Name = str_replace_all(.data$Name, "OricorioPom-Pom Style", "Oricorio-Pom-Pom")) %>%
  mutate(Name = str_replace_all(.data$Name, "OricorioSensu Style", "Oricorio-Sensu")) %>%
  mutate(Name = str_replace_all(.data$Name, "OricorioPa'u Style", "Oricorio-Pa'u")) %>%
  mutate(Name = str_replace_all(.data$Name, "HoopaHoopa Confined", "Hoopa")) %>%
  mutate(Name = str_replace_all(.data$Name, "HoopaHoopa Unbound", "Hoopa-Unbound")) %>%
  mutate(Name = str_replace_all(.data$Name, "Ho-oh", "Ho-Oh")) %>%
  mutate(Name = str_replace_all(.data$Name, "GroudonPrimal Groudon", "Groudon-Primal")) %>%
  mutate(Name = str_replace_all(.data$Name, "KyogrePrimal Kyogre", "Kyogre-Primal")) %>%
  mutate(Name = str_replace_all(.data$Name, "GiratinaAltered", "Giratina")) %>%
  mutate(Name = str_replace_all(.data$Name, "GiratinaOrigin", "Giratina-Origin")) %>%
  distinct()

df_dex$Name[8] <- "Charizard-Mega-X"
df_dex$Name[9] <- "Charizard-Mega-Y"
df_dex$Name[190] <- "Mewtwo-Mega-X"
df_dex$Name[191] <- "Mewtwo-Mega-Y"

add_to_dex <- function(number, name, type, total, hp,
                       atk, def, spatk, spdef, speed) {
  dex_entry <- data.frame(list(number, name, type, total, hp, atk,
                               def, spatk, spdef, speed),
                          stringsAsFactors = FALSE
  )

  colnames(dex_entry) <- colnames(df_dex)
  dex_entry
}


df_dex <- bind_rows(df_dex,
                    add_to_dex(773, "Silvally-Fairy", "Fairy", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Steel", "Steel", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Ground", "Ground", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Poison", "Poison", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Electric", "Electric", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Fire", "Fire", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Ghost", "Ghost", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Grass", "Grass", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Dark", "Dark", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Dragon", "Dragon", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Water", "Water", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Flying", "Flying", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Fighting", "Fighting", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Psychic", "Psychic", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Ice", "Ice", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Rock", "Rock", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Silvally-Bug", "Bug", 570, 95, 95, 95, 95, 95, 95),
                    add_to_dex(773, "Arceus-Fairy", "Fairy", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Steel", "Steel", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Ground", "Ground", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Poison", "Poison", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Electric", "Electric", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Fire", "Fire", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Ghost", "Ghost", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Grass", "Grass", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Dark", "Dark", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Dragon", "Dragon", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Water", "Water", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Flying", "Flying", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Fighting", "Fighting", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Psychic", "Psychic", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Ice", "Ice", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Rock", "Rock", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(773, "Arceus-Bug", "Bug", 720, 120, 120, 120, 120, 120, 120),
                    add_to_dex(25, "Pikachu-Alola", "Electric", 720, 35, 55, 40, 50, 50, 90),
                    add_to_dex(25, "Pikachu-Hoenn", "Electric", 720, 35, 55, 40, 50, 50, 90),
                    add_to_dex(25, "Pikachu-Kalos", "Electric", 720, 35, 55, 40, 50, 50, 90),
                    add_to_dex(25, "Pikachu-Original", "Electric", 720, 35, 55, 40, 50, 50, 90),
                    add_to_dex(25, "Pikachu-Partner", "Electric", 720, 35, 55, 40, 50, 50, 90),
                    add_to_dex(25, "Pikachu-Sinnoh", "Electric", 720, 35, 55, 40, 50, 50, 90),
                    add_to_dex(25, "Pikachu-Unova", "Electric", 720, 35, 55, 40, 50, 50, 90),
                    add_to_dex(79, "Slowpoke-Galar", "WaterPsychic", 315, 90, 65, 65, 40, 40, 15),
                    add_to_dex(105, "Marowak-Alola-Totem", "FireGhost", 425, 60, 80, 110, 50, 80, 45),
                    add_to_dex(784, "Kommo-o-Totem", "DragonFighting", 600, 75, 110, 125, 100, 105, 85),
                    add_to_dex(758, "Salazzle-Totem", "PoisonFire", 480, 68, 64, 60, 111, 60, 117),
                    add_to_dex(754, "Lurantis-Totem", "Grass", 480, 70, 105, 90, 80, 90, 45),
                    add_to_dex(738, "Vikavolt-Totem", "BugElectric", 500, 77, 70, 90, 145, 75, 43),
                    add_to_dex(778, "Mimikyu-Totem", "GhostFairy", 476, 55, 90, 80, 50, 105, 96),
                    add_to_dex(777, "Togedemaru-Totem", "ElectricSteel", 435, 65, 98, 63, 40, 73, 96),
                    add_to_dex(752, "Araquanid-Totem", "WaterBug", 454, 68, 70, 92, 50, 132, 42),
                    add_to_dex(20, "Raticate-Alola-Totem", "DarkNormal", 413, 75, 71, 70, 40, 80, 77),
                    add_to_dex(743, "Ribombee-Totem", "BugFairy", 464, 60, 55, 60, 95, 70, 124),
                    add_to_dex(735, "Gumshoos-Totem", "Normal", 418, 88, 110, 60, 55, 60, 45)
                    )

# Types data for splitting dex types from dex
types1 <- types1 <- c("Bug", "Dark", "Dragon", "Electric",
                      "Fairy", "Fighting", "Fire", "Flying",
                      "Ghost", "Grass", "Ground", "Ice",
                      "Normal", "Poison", "Psychic", "Rock",
                      "Steel", "Water")

types2 <- c(types1, "")
types1_regex <- paste(types1, collapse = "|")
types2_regex <- paste(types2, collapse = "|")
types_regex_capture <- paste("(", types1_regex, ")", "(", types2_regex,")",
                             sep = "",
                             collapse = ""
                             )

type_colours <- c("#A6B91A", "#705746", "#6F35FC", "#F7D02C",
                  "#D685AD", "#C22E28", "#EE8130", "#A98FF3",
                  "#735797", "#7AC74C", "#E2BF65", "#96D9D6",
                  "#A8A77A", "#A33EA1", "#F95587", "#B6A136",
                  "#B7B7CE", "#6390F0")
names(type_colours) <- types1

# Gens
gen_vec <- paste("Gen", c(8:1))

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

# Usage weightings
usage_weighting <- c("Usage", "Raw", "Real")

# Moveset functions
moveset_data_get <- function(x, pokemon, attribute) {
  weighted_count <- sum(unlist(x$data[[pokemon]][["Abilities"]]))
  moveset_data_raw <- unlist(x$data[[pokemon]][[attribute]]) %>% 
    sort(decreasing = TRUE)
  
  moveset_data_weighted <- moveset_data_raw/weighted_count
  percent_used <- round(moveset_data_weighted*100, 3)
  attribute_df <- data.frame(names(percent_used), percent_used)
  names(attribute_df) <- c(attribute, "Percent Used")
  row.names(attribute_df) <- NULL
  attribute_df
}

checks_n_counters_get <- function(chaos, txt, pokemon){
  checks_n_counters_chaos <- data.frame(chaos$data[[pokemon]]$`Checks and Counters`) %>%
    t() %>%
    as.data.frame()
  checks_n_counters_chaos <- cbind(names(chaos$data[[pokemon]]$`Checks and Counters`),
                                   checks_n_counters_chaos)
  checks_n_counters_chaos <- checks_n_counters_chaos %>%
    mutate(V4 = V2 - 4*V3,
           V2 = round(V2*100, 3),
           V3 = round(V3*100, 3),
           V4 = round(V4*100, 3)) %>%
    rename(Pokemon = 1,
           "KO/Switch Percentage Raw" = V2,
           "KO/Switch StDev (Percentage)" = V3,
           "KO/Switch Percentage Fixed" = V4)
  
  moveset_txt <- txt %>%
    str_remove_all("\t|\n") %>%
    str_split(fixed("+----------------------------------------+")) %>%
    unlist()
  
  pkmn_moveset <- moveset_txt[seq(2, length(moveset_txt), 9)] %>%
    str_remove_all(pattern = "[[:space:]\\|]")
  
  pkmn_moveset <- moveset_txt[seq(2, length(moveset_txt), 9)] %>%
    str_remove_all(pattern = "[[:space:]\\|]")
  
  into_1 <- c("x", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
  checks_n_counters_txt <- data.frame(moveset_txt[seq(9, length(moveset_txt), 9)],
                                      stringsAsFactors = FALSE) %>%
    separate(col = 1, into = into_1, sep = "\\|  \\|") %>%
    select(-1)
  
  into_2 <- c("check", NA, "3")
  into_3 <- c("KO", "Switch")
  checks_n_counters_txt <- cbind(pkmn_moveset, checks_n_counters_txt) %>%
    pivot_longer(-1, names_to = "number", values_to = "check") %>%
    separate(col = "check", into = into_2, sep = "\\(") %>%
    separate(col = "3", into = into_3, sep = "\\/") %>%
    mutate_at(.vars = c("KO", "Switch"),
              .funs = str_remove_all, pattern = "[^0-9.]") %>%
    mutate_at(.vars = "check",
              .funs = str_remove_all, pattern = "[^[:alpha:]-:]") %>%
    filter(pkmn_moveset == pokemon)
  
  checks_n_counters <- left_join(checks_n_counters_chaos,
                                 checks_n_counters_txt,
                                 by = c("Pokemon" = "check")) %>%
    rename("KO Percentage" = KO,
           "Switch Percentage" = Switch) %>%
    select(1, 5, 3, 4, 8, 9) %>% arrange(desc(`KO/Switch Percentage Fixed`))
  
  checks_n_counters[is.na(checks_n_counters)] <- " "
  
  checks_n_counters
}
