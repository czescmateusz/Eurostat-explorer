#


library(shiny)
library(rcdimple)
library(shinydashboard)

# Define UI for application that draws a histogram
<<<<<<< HEAD
shinyUI(fluidPage(theme="./www/bootstrap.css",
=======
shinyUI(fluidPage(theme="bootstrap.css",
>>>>>>> db0112a080dd288a8c92752ddd609e709a578784
  
  titlePanel("Eurostat Data Explorer"),
  
  
  navlistPanel(
    "Header",
<<<<<<< HEAD
    tabPanel("Introduction", dataTableOutput('countries')),
    tabPanel("Demography",  dimpleOutput('chart')), 
    tabPanel("General Economic Overview"), helpText("lorem ipsum"),
    tabPanel('Industry',  valueBoxOutput("vbox1")),
=======
    tabPanel("Introduction", dataTableOutput('countries'),
             helpText("Eurostat is a Directorate-General of the European Commission located in Luxembourg. Its main responsibilities are to provide statistical information to the institutions of the European Union (EU) and to promote the harmonisation of statistical methods across its member states and candidates for accession as well as EFTA countries. The organisations in the different countries that cooperate with Eurostat are summarised under the concept of the European Statistical System.")),
    tabPanel("Demography",  dimpleOutput('chart')), 
    tabPanel("General Economic Overview"), helpText("lorem ipsum"),
    tabPanel('Industry', helpText("lorem")),
>>>>>>> db0112a080dd288a8c92752ddd609e709a578784
    tabPanel('Unemployment', dataTableOutput('tabUnemployment')),
    tabPanel('Explore Eurostat database', textInput("query", "Search Eurostat Database", "Type in your query (ex. unemployment, GDP)"), 
             dataTableOutput('tabEuroStat'))
  )))


