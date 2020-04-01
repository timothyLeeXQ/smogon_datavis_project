library(shiny)
library(shinydashboard)

shinyServer(function(input, output, session) {
    output$month_pv <- renderPrint({str(input$month_select)})
})
