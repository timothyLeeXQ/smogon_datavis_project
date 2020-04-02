
library(shiny)
library(shinydashboard)
library(shinyWidgets)



header <- dashboardHeader(title = "Smogon Stats UI")


sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Usage Stats", tabName = "usage", icon = icon("chess")),
        menuItem("Item use", tabName = "item", icon = icon("shopping-bag"))
    )
)


body <- dashboardBody(
    tabItems(
        tabItem(
            tabName = "usage",
            fluidRow(
                box(width = 2,
                    title = "Select Month:",
                    airMonthpickerInput(
                        inputId = "month_select",
                        value = format(Sys.Date()-31, "%Y-%m-%d"),
                        label = " ",
                        minDate = "2014-11-01",
                        minView = "months"
                        )
                    ),
                box(width = 2,
                    title = "Select Gen:",
                    selectInput("gen_select", label = " ", choices = gen_vec),
                    ),
                box(width = 2,
                    title = "Select Format:",
                    selectInput("format_select", label = " ", choices = formats),
                    ),
                box(width = 3,
                    title = "Select Skill Weighting:",
                    selectInput("skill_weighting_select",
                                label = "See the FAQ if you don't know what this is",
                                choices = skill_ranking)
                    ),
                box(width = 3,
                    title = "Select Usage Weighting:",
                    selectInput("usage_weighting_select",
                                label = "See the FAQ if you don't know what this is",
                                choices = usage_weighting)
                    )
            ),
            fluidRow(
                valueBox("Most Used", value = "lorem ipsum", color = "orange"),
                valueBox("Most common type", value = "placeholder_val", color = "red"),
                valueBoxOutput("total_battles")
                ),
            fluidRow(
                box(
                      width = 12,
                      title = "Usage by Type",
                      highchartOutput("usage_plot"),
                      textOutput("usage_plot_note")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "Usage Table",
                    DT::dataTableOutput("usage_table"),
                    style = "height:600px;
                             width:auto;
                             overflow-y:scroll;
                             overflow-x:scroll;")
                )
          ),
        tabItem(
            tabName = "item",
            fluidRow(
                valueBox("Hardest Question", icon("question"), value = "placeholder"),
                valueBox("Hardest Category", icon("laptop-code"), value = "placeholder")
                ),
            fluidRow(
                box(
                      width = 12,
                      title = "Number of Clicks Each Student Used to Answer a Question",
                      textOutput("str_pv")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "Class Performance for Questions in Each Category")
                )
        )
    )
)










ui <- dashboardPage(header, sidebar, body)
# Define UI for application that draws a histogram
