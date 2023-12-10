# Purpose: Code for Shiny App UI for CovidWasteWatch
# Author: Vivian Wang
# Date: 2023-12-08
# Version: 0.1.0
# Bugs and Issues: None

# This script is adapted from
# Grolemund, G. (2015). Learn Shiny - Video Tutorials. URL:https://shiny.rstudio.com/tutorial/

library(shiny)

# Define UI
ui <- fluidPage(

  # App title
  titlePanel("CovidWasteWatch: "),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      tags$p("CovidWasteWatch is an R package for analysis and visualization of
             COVID-19 wastewater viral signal and variant frequency data.
             This Shiny app provides the user interface for CovidWasteWatch.
             Using user-provided pre-processed data, this package
             provides users with various statistical backgrounds a simple and
             efficient way to observe trends in COVID-19 viral signal levels
             and variant frequencies over time."),

      # br() element to introduce extra vertical spacing ----
      br(),
      br(),

      # input
      tags$p("Instructions: Below, enter or select values required to perform the analysis. Default
             values are shown. Then press 'Run' to explore the results."),

      # br() element to introduce extra vertical spacing ----
      br(),

      # input
      uiOutput("tab1"),
      actionButton(inputId = "data1",
                   label = "Viral Signal Dataset Details"),
      uiOutput("tab2"),
      actionButton(inputId = "data2",
                   label = "Variant Frequency Dataset Details"),
      selectInput(inputId = "dataType", label = "Select data type.",
                  choices = c("Viral signal", "Variant frequency")),
      fileInput(inputId = "file1",
                label = "Select a viral dataset. File should be in .csv format
                         Viral signal data should have columns 'date' and 'signal'.
                         Variant frequency data should have columns 'date', 'variant', and optionally 'parent'.",
                accept = c(".csv")),
      selectInput(inputId = "parentBool",
                  label = "If analyzing viral signal data, select whether
                  a column 'parent' for parent variants is present.",
                  choices = c("Yes", "No"), selected = "Yes"),

      # br() element to introduce extra vertical spacing ----
      br(),

      # actionButton
      actionButton(inputId = "button1",
                   label = "Run"),

    ),

    # Main panel for displaying outputs ----
    mainPanel(
      h4("Data overview"),
      verbatimTextOutput("textOutOverview"),
      br(),
      plotOutput("plot")

    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # Save file path to input csv
  dataInputPath <- eventReactive(eventExpr = input$button1, {
    if (! is.null(input$file1))
      input$file1$datapath
  })

  # Load and get data overview
  results <- eventReactive(eventExpr = input$button1, {
    if (input$dataType == "Viral signal") {
      CovidWasteWatch::ViralSignal(fileSignal = input$file1)
    }
    if (input$dataType == "Variant frequency") {
      CovidWasteWatch::VarBreakdown(fileVariant = input$file1)
    }
  })

  if (input$dataType == "Viral signal") {
    output$textOutOverview <- renderPrint({
      if (! is.null(results))
        results()$numTimepoints
        results()$avgRateOfChangePerDay
    })

    output$plot <- renderPlot({
      results()$plotSignal
    })
  }

  if (input$dataType == "Variant frequency") {
    output$textOutOverview <- renderPrint({
      if (! is.null(results))
        results()$numTimepoints
      results()$avgRateOfChangePerDay
    })

    output$plot <- renderPlot({
      results()$plotVariant
    })
  }

}

# Create Shiny app ----
shiny::shinyApp(ui, server)


# [END]
