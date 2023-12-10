# Purpose: Code for Shiny App for CovidWasteWatch
# Author: Vivian Wang
# Date: 2023-12-08
# Version: 0.2.0
# Bugs and Issues: None

# This script is adapted from
# Grolemund, G. (2015). Learn Shiny - Video Tutorials. URL:https://shiny.rstudio.com/tutorial/

library(shiny)
library(shinyalert)

# Define UI
ui <- fluidPage(

  # App title
  titlePanel("CovidWasteWatch: Analyze and Visualize COVID-19 Wastewater Viral
             Signal and Variant Frequency Data"),

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

      # input
      tags$p("Instructions: Below, upload a data file and select values required to perform the analysis.
             Then press 'Run' to explore the results to the right."),

      # br() element to introduce extra vertical spacing ----
      br(),

      # input
      shinyalert::useShinyalert(force = TRUE),  # Set up shinyalert
      uiOutput("tab1"),
      actionButton(inputId = "data1",
                   label = "Viral Signal Dataset Details"),
      uiOutput("tab2"),
      actionButton(inputId = "data2",
                   label = "Variant Frequency Dataset Details"),
      selectInput(inputId = "dataType", label = "Select data type.",
                  choices = c("Viral signal", "Variant frequency")),
      fileInput(inputId = "file1",
                label = "Select a viral dataset. File should be in .csv format.
                         Viral signal data should have columns 'date' and 'signal',
                         so each row corresponds to the viral signal at one timepoint.
                         Variant frequency data should have columns 'date', 'variant', and optionally 'parent',
                         so each row corresponds to the variant proportion (out of 1) for each variant per timepoint.",
                accept = c(".csv")),
      selectInput(inputId = "parentBool",
                  label = "If analyzing variant frequency data, select whether
                  a column 'parent' for parent variant names is present. Otherwise, disregard this.",
                  choices = c("Yes", "No"), selected = "Yes"),

      # br() element to introduce extra vertical spacing ----
      br(),

      # actionButton
      actionButton(inputId = "button1",
                   label = "Run")

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
    if (! is.null(input$file1)) {
      input$file1$datapath
    }
  })

  # Load and get data overview for the input data type
  results <- eventReactive(eventExpr = input$button1, {
    if (input$dataType == "Viral signal") {
      CovidWasteWatch::ViralSignal(fileSignal = input$file1$datapath)
    } else if (input$dataType == "Variant frequency") {
      if (input$parentBool == "No") {
        CovidWasteWatch::VarBreakdown(fileVariant = input$file1$datapath,
                                      parentVariants = FALSE)
      } else {
        CovidWasteWatch::VarBreakdown(fileVariant = input$file1$datapath)
      }
    }
  })

  # Output data overview and plot
  observeEvent(input$button1, {
    req(results())
      if(input$dataType == "Viral signal") {
        output$textOutOverview <- renderPrint({
          if (! is.null(results())) {
            cat("Number of timepoints:", results()$numTimepoints, "\n")
            cat("Average rate of change per day:", results()$avgRateOfChangePerDay, "\n")
          }
        })

        output$plot <- renderPlot({
          if (! is.null(results())) {
            results()$plotSignal
          }
        })
      }

      if (input$dataType == "Variant frequency") {
        output$textOutOverview <- renderPrint({
          if (! is.null(results())) {
            cat("Number of variants:", results()$numVariants, "\n")
          }
        })

        output$plot <- renderPlot({
          if (! is.null(results())) {
            results()$plotVariant
          }
        })
      }
  })

  # URLs for downloading data
  url1 <- a("Example Viral Signal Dataset",
            href="https://raw.githubusercontent.com/viv-wang/CovidWasteWatch/master/inst/extdata/viral_signal_input_data.csv"
            )
  output$tab1 <- renderUI({
    tagList("Download:", url1)
  })

  observeEvent(input$data1, {
    # Show a modal when the button is pressed
    shinyalert(title = "Example Viral Signal Dataset",
               text = "This dataset contains viral signal levels from wastewater
                      surveillance in Ontario, Canada. It was downloaded from
                      Public Health Ontario's website
                      (https://www.publichealthontario.ca/en/Data-and-Analysis/Infectious-Disease/COVID-19-Data-Surveillance/Wastewater)
                      which is updated weekly. The data was collected from
                      2022-10-26 to 2023-10-28.",
               type = "info")
  })

  url2 <- a("Example Variant Frequency Dataset",
            href="https://raw.githubusercontent.com/viv-wang/CovidWasteWatch/master/inst/extdata/variant_input_data.csv"
            )
  output$tab2 <- renderUI({
    tagList("Download:", url2)
  })

  observeEvent(input$data2, {
    # Show a modal when the button is pressed
    shinyalert(title = "Example Variant Frequency Dataset",
               text = "This dataset contains weekly variant proportion data in
                      Canada. This dataset was downloaded from Health Canada's website
                      (https://health-infobase.canada.ca/covid-19/testing-variants.html)
                      which is updated weekly. The dataset contains data
                      from 2023-08-27 to 2023-10-29.",
               type = "info")
  })

}

# Create Shiny app ----
shiny::shinyApp(ui, server)

# [END]
