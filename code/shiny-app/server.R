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

    observeEvent(
      moveset_chaos_input(), {
        chaos <- moveset_chaos_input()
        choices <- sort(names(chaos$data))
        updateSelectInput(session, "pokemon_moveset", choices = choices)

    })

    output$abil_table <- DT::renderDataTable({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      dt_abil_table <- tryCatch({
        abil_table <- moveset_data_get(chaos, pokemon_chosen, "Abilities")

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

    output$item_table <- DT::renderDataTable({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      dt_item_table <- tryCatch({
        item_table <- moveset_data_get(chaos, pokemon_chosen, "Items")

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

    output$move_table <- DT::renderDataTable({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      dt_move_table <- tryCatch({
        move_table <- moveset_data_get(chaos, pokemon_chosen, "Moves")

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

    output$spread_table <- DT::renderDataTable({
      chaos <- moveset_chaos_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      dt_spread_table <- tryCatch({
        spread_table <- moveset_data_get(chaos, pokemon_chosen, "Spreads") %>%
          separate(col = "Spreads", into = c("Nature", "HP", "Attack",
                                             "Defense", "SpAtk", "SpDef",
                                             "Speed"),
           sep = "[:/]")

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

    output$checks_n_counters <- DT::renderDataTable({
      chaos <- moveset_chaos_input()
      txt <- moveset_txt_input()
      pokemon_chosen <- paste(input$pokemon_moveset)

      dt_check_n_counter <- tryCatch({
        check_n_counters <- checks_n_counters_get(chaos, txt, pokemon_chosen)

        DT::datatable(check_n_counters,
                      options = list(pageLength = nrow(check_n_counters),
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
