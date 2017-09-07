#


library(shiny)
library(rcdimple)

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  title = 'Eurostat Data Explorer',
  tabPanel('Introduction'), helpText("This app lets the user explore Eurostats vast database"), imageOutput("logo"),
  tabPanel('Demography'),  dimpleOutput('chart'), 
  tabPanel('General Economic Overview'),
  tabPanel('Industry'),
  tabPanel('Unemployment'), tableOutput('tabUnemployment'),
  tabPanel('Explore Eurostat database', textInput("query", "Search Eurostat Database", "Type in your query (ex. unemployment, GDP)"), 
           dataTableOutput('tabEuroStat'))
))

