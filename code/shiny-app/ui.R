#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
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
                box(width = 4,
                    title = "Select Month:",
                    airMonthpickerInput(
                        inputId = "month_select",
                        minDate = "2014-11-01",
                        minView = "months"
                        )
                    ),
                box(width = 4,
                    title = "Select Format",
                    verbatimTextOutput("month_pv", placeholder = TRUE),
                    ),
                box(width = 4,
                    title = "Select Rating",
                    verbatimTextOutput("month_pv", placeholder = TRUE),
                )
                
            ),
            fluidRow(
                valueBox("Most common type", value = "placeholder_val", color = "red"),
                valueBox("Number of Battles", value = "placeholder_val"),
                valueBox("Most used", value = "placeholder_val", color = "orange")
                )
            ),
        tabItem(
            tabName = "item",
            fluidRow(
                valueBox("Hardest Question", icon("question"), value = "placeholder"),
                valueBox("Hardest Category", icon("laptop-code"), value = "placeholder")
                ),
            fluidRow(
                box(width = 2,
                    title = "Choose a Category",
                    selectInput(label = "Choose a Category",
                                inputId = "cat_choose",
                                choices = c("All"))
                    )
                ),
            fluidRow(
                box(width = 12,
                    title = "Class Performance for Questions in Each Category")
                ),
            fluidRow(
                box(width = 12,
                    title = "Student Performance for Each Category",
                    DT::dataTableOutput("cat_dt"),
                    style = "height:600px;
                             width:auto;
                             overflow-y:scroll;
                             overflow-x: scroll;")
                )
        )
    )
)
        
        
        
        
        
        
        



ui <- dashboardPage(header, sidebar, body)
# Define UI for application that draws a histogram
