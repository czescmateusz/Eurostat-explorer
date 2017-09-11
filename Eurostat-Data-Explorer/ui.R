#


library(shiny)
library(rcdimple)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme="./www/bootstrap.css",
  
  titlePanel("Eurostat Data Explorer"),
  
  
  navlistPanel(
    "Header",
    tabPanel("Introduction", dataTableOutput('countries')),
    tabPanel("Demography",  dimpleOutput('chart')), 
    tabPanel("General Economic Overview"), helpText("lorem ipsum"),
    tabPanel('Industry',  valueBoxOutput("vbox1")),
    tabPanel('Unemployment', dataTableOutput('tabUnemployment')),
    tabPanel('Explore Eurostat database', textInput("query", "Search Eurostat Database", "Type in your query (ex. unemployment, GDP)"), 
             dataTableOutput('tabEuroStat'))
  )))


