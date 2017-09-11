library(eurostat)
library(knitr)


tabela <- as.table(paste0(eu_countries$name))

print(tabela)

#https://www.r-bloggers.com/pre-cran-waffle-update-isotype-pictograms/

#Plan

#1Introduction: KPI (liczba ludnosci, liczba bezrobotnych, GDP per capita) + lisa krajow z UE -> przejscie do KPI dla pojedynczych krajow
#2Demography: 

#
#Valuebox - works only with dashboad layout?
#change fluidpage to dashboard layout

library(shiny)
library(rcdimple)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme="bootstrap.css",
                  titlePanel("Eurostat Data Explorer"),
                  navlistPanel(
                    "Header",
                    tabPanel("Introduction", valueBoxOutput("populationbox"), valueBoxOutput("gdpbox")),
                    tabPanel("Demography",  dimpleOutput('chart')), 
                    tabPanel("General Economic Overview"),
                    tabPanel('Industry'),
                    tabPanel("General Economic Overview"),
                    tabPanel('Unemployment', dataTableOutput('tabUnemployment')),
                    tabPanel('Explore Eurostat database', textInput("query", "Search Eurostat Database", "Type in your query (ex. unemployment, GDP)"), 
                             dataTableOutput('tabEuroStat'))
                  )))

