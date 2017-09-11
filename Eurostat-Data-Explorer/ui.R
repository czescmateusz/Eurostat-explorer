#


library(shiny)
library(rcdimple)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme="bootstrap.css",
  
  titlePanel("Eurostat Data Explorer"),
  
  
  navlistPanel(
    "Header",
    tabPanel("Introduction", dataTableOutput('countries'),
             helpText("Eurostat is a Directorate-General of the European Commission located in Luxembourg. Its main responsibilities are to provide statistical information to the institutions of the European Union (EU) and to promote the harmonisation of statistical methods across its member states and candidates for accession as well as EFTA countries. The organisations in the different countries that cooperate with Eurostat are summarised under the concept of the European Statistical System.")),
    tabPanel("Demography",  dimpleOutput('chart')), 
    tabPanel("General Economic Overview"), helpText("lorem ipsum"),
    tabPanel('Industry', helpText("lorem")),
    tabPanel('Unemployment', dataTableOutput('tabUnemployment')),
    tabPanel('Explore Eurostat database', textInput("query", "Search Eurostat Database", "Type in your query (ex. unemployment, GDP)"), 
             dataTableOutput('tabEuroStat'))
  )))


