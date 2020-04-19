library(shiny)
library(shinydashboard)
library(tidyr)
library(stringr)
library(dplyr)
library(readr)
library(highcharter)

shinyServer(function(input, output, session) {
  # Usage
    usage_input <- reactive({
        month_chosen <- paste(format(input$month_select, "%Y-%m"))
        gen_chosen <- paste(input$gen_select)
        format_chosen <- paste(input$format_select)
        weighting_chosen <- paste(input$skill_weighting_select) %>%
          str_replace_all(pattern = fixed("(all formats except current gen OU)"),
               replacement = "") %>%
          str_replace_all(pattern = fixed("(for current gen OU)"),
               replacement = "")

        usage_endpoint <- paste("https://www.smogon.com/stats/",
                                month_chosen, "/",
                                gen_chosen, format_chosen, "-",
                                weighting_chosen, ".txt") %>%
          str_replace_all(pattern = "[[:space:]]", replacement = "") %>%
          str_to_lower()

      usage <- tryCatch({
        read_lines(usage_endpoint)
        }, error = function(error) {
        return(NULL)
        })

      usage
    })

    df_usage <- reactive({
      usage <- usage_input()
      df_usage <- usage_data_get(usage)

      df_usage_type <- left_join(df_usage, df_dex, by = c("Pokemon" = "Name"))

      df_usage_types_sep <- tidyr::extract(df_usage_type,
                                           col = Type,
                                           into = c("Type 1", "Type 2"),
                                           types_regex_capture)
      df_usage_types_sep
    })

    df_usage_plot <- reactive({
      df_usage <- df_usage()
      df_usage_type_plot <- pivot_longer(df_usage,
                                         cols = c("Type 1", "Type 2"),
                                         names_to = "type_num",
                                         values_to = "Type") %>%
        filter(Type != "") %>%
        group_by(Type) %>%
        summarise_at(vars(`Usage %`:`Real %`), sum)

      if (paste(input$gen_select) == "Gen 1") {
        df_usage_type_plot <- bind_rows(df_usage_type_plot,
                                        data.frame("Dark", 0, 0, 0, 0, 0))
      }

      df_usage_type_plot <- df_usage_type_plot %>% arrange(Type)

      df_usage_type_plot
    })

    output$usage_plot <- renderHighchart({
      df_usage_plot <- df_usage_plot()
      usage_weighting_chosen <- paste(input$usage_weighting_select, "%")

      usage_plot <- tryCatch({
        hchart(df_usage_plot,
               type = "bar",
               name = usage_weighting_chosen,
               hcaes(x = .data$Type,
                     y = .data[[usage_weighting_chosen]], color = type_colours)) %>%
        hc_add_theme(hc_theme_elementary()) %>%
        hc_xAxis(title = list(text = "Type")) %>%
        hc_yAxis(title = list(text = usage_weighting_chosen))
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })


      usage_plot
    })

    output$usage_plot_note <- renderText({"Note: Percentages can be above 100%
      as pokemon with two types are counted once for each type, and percentages
      refers to proportions of teams with using a particuar Pokemon."
    })

    output$total_battles <- renderValueBox({
      usage <- usage_input()
      if (is.null(usage)) {
        total_battles <- 0
      } else {
        total_battles <- str_extract(usage[1], pattern = "[0-9]+")
      }
      valueBox("Number of Battles", total_battles)
    })

    output$common_type <- renderValueBox({
      usage <- usage_input()
      df_usage_plot <- df_usage_plot()
      usage_weighting_chosen <- paste(input$usage_weighting_select, "%")
      if (is.null(usage)) {
        most_common_type <- "Blank"
      } else {
        df_usage_sort_type <- arrange(df_usage_plot,
                                      desc(.data[[usage_weighting_chosen]]))
        most_common_type <- df_usage_sort_type[["Type"]][[1]]
      }
      valueBox("Most Common Type", most_common_type)
    })

    output$most_used_mon <- renderValueBox({
      usage <- usage_input()
      df_usage <- df_usage()
      usage_weighting_chosen <- paste(input$usage_weighting_select, "%")
      if (is.null(usage)) {
        most_common_type <- "Blank"
      } else {
        df_usage_sort_mon <- arrange(df_usage,
                                     desc(.data[[usage_weighting_chosen]]))
        most_common_type <- df_usage_sort_mon[["Pokemon"]][[1]]
      }
      valueBox("Most Common Pokemon", most_common_type)
    })

    output$usage_table <- DT::renderDataTable({
      df_usage <- df_usage() %>%
        select(1, 8, 2, 9, 10, everything()) %>%
        rename(`Stat Total` = .data$Total)

      dt_usage_table <- DT::datatable(df_usage,
                                      options = list(pageLength = nrow(df_usage),
                                                     scrollX = TRUE,
                                                     scrollY = 400,
                                                     fixedHeader=TRUE)
                                                   ) %>%
        DT::formatStyle(c("Type 1", "Type 2"),
                        backgroundColor = DT::styleEqual(names(type_colours), type_colours))
      dt_usage_table
    })

    # Moveset data
    moveset_chaos_input <- reactive({
      month_chosen <- paste(format(input$month_moveset, "%Y-%m"))
      gen_chosen <- paste(input$gen_moveset)
      format_chosen <- paste(input$format_moveset)
      weighting_chosen <- paste(input$skill_weighting_moveset) %>%
        str_replace_all(pattern = fixed("(all formats except current gen OU)"),
             replacement = "") %>%
        str_replace_all(pattern = fixed("(for current gen OU)"),
             replacement = "")

      chaos_endpoint <- paste("https://www.smogon.com/stats/",
                              month_chosen, "/chaos/",
                              gen_chosen, format_chosen, "-",
                              weighting_chosen, ".json") %>%
        str_replace_all(pattern = "[[:space:]]", replacement = "") %>%
        str_to_lower()

      chaos <- tryCatch({
        fromJSON(chaos_endpoint)
        }, error = function(error) {
        return(NULL)
        })

      chaos
    })

    moveset_txt_input <- reactive({
      month_chosen <- paste(format(input$month_moveset, "%Y-%m"))
      gen_chosen <- paste(input$gen_moveset)
      format_chosen <- paste(input$format_moveset)
      weighting_chosen <- paste(input$skill_weighting_moveset) %>%
        str_replace_all(pattern = fixed("(all formats except current gen OU)"),
             replacement = "") %>%
        str_replace_all(pattern = fixed("(for current gen OU)"),
             replacement = "")

      moveset_txt_endpoint <- paste("https://www.smogon.com/stats/",
                              month_chosen, "/moveset/",
                              gen_chosen, format_chosen, "-",
                              weighting_chosen, ".txt") %>%
        str_replace_all(pattern = "[[:space:]]", replacement = "") %>%
        str_to_lower()

      moveset_txt <- tryCatch({
        read_file(moveset_txt_endpoint)
        }, error = function(error) {
        return(NULL)
        })
    })


    # Dynamic selector for which pokemon's stats to show
    observeEvent(
      moveset_chaos_input(), {
        chaos <- moveset_chaos_input()
        choices <- sort(names(chaos$data))
        updateSelectInput(session, "pokemon_moveset", choices = choices)

    })

    # Abilities
    abil_table <- reactive({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      abil_table <- tryCatch({
        moveset_data_get(chaos, pokemon_chosen, "Abilities")
      }, error = function(error) {
        message("An error occurred. Did you pick a game format that exists?")
      })

      abil_table
    })

    output$hc_abil_plot <- renderHighchart({
      abil_table <- abil_table()

      hc_abil_plot <- tryCatch({
        hchart(abil_table,
               type = "bar",
               name = "Percent Used",
               hcaes(x = .data[["Abilities"]],
                     y = .data[["Percent Used"]])) %>%
        hc_add_theme(hc_theme_elementary()) %>%
        hc_xAxis(title = list(text = "Ability")) %>%
        hc_yAxis(title = list(text = "Percent Used"),
                 min = 0,
                 max = 100,
                 tickInterval = 10)
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      hc_abil_plot
    })

    output$dt_abil_table <- DT::renderDataTable({
      abil_table <- abil_table()
      dt_abil_table <- tryCatch({
        DT::datatable(abil_table,
                      options = list(pageLength = nrow(abil_table),
                                     scrollX = TRUE,
                                     scrollY = 300,
                                     fixedHeader=TRUE)
                       )
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
      })
      dt_abil_table
    })

    # Items
    item_table <- reactive({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      item_table <- tryCatch({
        moveset_data_get(chaos, pokemon_chosen, "Items")
      }, error = function(error) {
        message("An error occurred. Did you pick a game format that exists?")
      })

      item_table
    })

    output$hc_item_plot <- renderHighchart({
      item_table <- item_table()
      item_table <- item_table[1:10,]

      hc_item_plot <- tryCatch({
        hchart(item_table,
               type = "bar",
               name = "Percent Used",
               hcaes(x = .data[["Items"]],
                     y = .data[["Percent Used"]])) %>%
        hc_add_theme(hc_theme_elementary()) %>%
        hc_xAxis(title = list(text = "Item")) %>%
        hc_yAxis(title = list(text = "Percent Used"),
                 min = 0,
                 max = 100,
                 tickInterval = 10)
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      hc_item_plot
    })

    output$dt_item_table <- DT::renderDataTable({
      item_table <- item_table()
      dt_item_table <- tryCatch({
        DT::datatable(item_table,
                      options = list(pageLength = nrow(item_table),
                                     scrollX = TRUE,
                                     scrollY = 300,
                                     fixedHeader=TRUE)
                      )
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      dt_item_table
    })

    # Moves
    move_table <- reactive({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      move_table <- tryCatch({
        moveset_data_get(chaos, pokemon_chosen, "Moves")
      }, error = function(error) {
        message("An error occurred. Did you pick a game format that exists?")
      })

      move_table
    })

    output$hc_move_plot <- renderHighchart({
      move_table <- move_table()
      move_table <- move_table[1:10,]

      hc_move_plot <- tryCatch({
        hchart(move_table,
               type = "bar",
               name = "Percent Used",
               hcaes(x = .data[["Moves"]],
                     y = .data[["Percent Used"]])) %>%
        hc_add_theme(hc_theme_elementary()) %>%
        hc_xAxis(title = list(text = "Move")) %>%
        hc_yAxis(title = list(text = "Percent Used"),
                 min = 0,
                 max = 100,
                 tickInterval = 10)
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      hc_move_plot
    })

    output$dt_move_table <- DT::renderDataTable({
      move_table <- move_table()
      dt_move_table <- tryCatch({
        DT::datatable(move_table,
                      options = list(pageLength = nrow(move_table),
                                     scrollX = TRUE,
                                     scrollY = 300,
                                     fixedHeader=TRUE)
                      )
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      dt_move_table
    })

    # Spreads
    spread_table <- reactive({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      spread_table <- tryCatch({
        moveset_data_get(chaos, pokemon_chosen, "Spreads")
      }, error = function(error) {
        message("An error occurred. Did you pick a game format that exists?")
      })

      spread_table
    })

    output$hc_spreads_plot <- renderHighchart({
      spread_table <- spread_table()
      spread_table <- spread_table[1:10,]

      hc_spreads_plot <- tryCatch({
        hchart(spread_table,
               type = "bar",
               name = "Percent Used",
               hcaes(x = .data[["Spreads"]],
                     y = .data[["Percent Used"]])) %>%
        hc_add_theme(hc_theme_elementary()) %>%
        hc_xAxis(title = list(text = "Nature, IV/EV Spread")) %>%
        hc_yAxis(title = list(text = "Percent Used"),
                 min = 0,
                 max = 100,
                 tickInterval = 10)
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      hc_spreads_plot
    })

    output$dt_spread_table <- DT::renderDataTable({
      spread_table <- spread_table()
      spread_table <- spread_table %>%
        separate(col = "Spreads", into = c("Nature", "HP", "Attack",
                                           "Defense", "SpAtk", "SpDef",
                                           "Speed"),
         sep = "[:/]")

      dt_spread_table <- tryCatch({
        DT::datatable(spread_table,
                      options = list(pageLength = nrow(spread_table),
                                     scrollX = TRUE,
                                     scrollY = 300,
                                     fixedHeader=TRUE)
                      )
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      dt_spread_table
    })

    output$spreads_plot_note <- renderText({"Format -
    Nature: HP/Attack/Defense/SpAtk/SpDef/Speed"
    })

    # Teammates
    teammate_table <- reactive({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      teammate_table <- tryCatch({
        moveset_data_get(chaos, pokemon_chosen, "Teammates")
      }, error = function(error) {
        message("An error occurred. Did you pick a game format that exists?")
      })

      teammate_table
    })

    output$hc_teammate_plot <- renderHighchart({
      teammate_table <- teammate_table()
      teammate_table <- rbind(head(teammate_table, 10), tail(teammate_table, 5))

      hc_teammate_plot <- tryCatch({
        hchart(teammate_table,
               type = "bar",
               name = "Percent Used",
               hcaes(x = .data[["Teammates"]],
                     y = .data[["Percent Used"]])) %>%
        hc_add_theme(hc_theme_elementary()) %>%
        hc_xAxis(title = list(text = "Pokemon")) %>%
        hc_yAxis(title = list(text = "Percent Used Over Baseline"),
                 max = 100,
                 tickInterval = 10)
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      hc_teammate_plot
    })

    output$dt_teammate_table <- DT::renderDataTable({
      teammate_table <- teammate_table()
      dt_teammate_table <- tryCatch({
        DT::datatable(teammate_table,
                      options = list(pageLength = nrow(teammate_table),
                                     scrollX = TRUE,
                                     scrollY = 300,
                                     fixedHeader=TRUE)
                      )
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      dt_teammate_table
    })

    # Checks and Counters

    checks_n_counters_table <- reactive({
      chaos <- moveset_chaos_input()
      txt <- moveset_txt_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      checks_n_counters_table <- tryCatch({
        checks_n_counters_get(chaos, txt, pokemon_chosen)
      }, error = function(error) {
        message("An error occurred.xxx Did you pick a game format that exists?")
      })

      checks_n_counters_table
    })

    output$hc_checks_plot <- renderHighchart({
      checks_n_counters_table <- checks_n_counters_table()
      checks_n_counters_table <- rbind(head(checks_n_counters_table, 10),
                                       tail(checks_n_counters_table, 5))

      hc_checks_plot <- tryCatch({
        hchart(checks_n_counters_table,
               type = "bar",
               name = "Percent Used",
               hcaes(x = .data[["Pokemon"]],
                     y = .data[["KO/Switch Percentage Fixed"]])) %>%
        hc_add_theme(hc_theme_elementary()) %>%
        hc_xAxis(title = list(text = "Move")) %>%
        hc_yAxis(title = list(text = "Percent Used"),
                 max = 100,
                 tickInterval = 10)
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      hc_checks_plot
    })

    output$dt_checks_n_counters <- DT::renderDataTable({
      checks_n_counters_table <- checks_n_counters_table()
      dt_check_n_counter <- tryCatch({
        DT::datatable(checks_n_counters_table,
                      options = list(pageLength = nrow(checks_n_counters_table),
                                     scrollX = TRUE,
                                     scrollY = 300,
                                     fixedHeader=TRUE)
                      )
        }, error = function(error) {
          message("An error occurred. Did you pick a game format that exists?")
        })

      dt_check_n_counter
    })

})
