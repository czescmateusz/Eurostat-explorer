#
#Valuebox - works only with dashboad layout?
#change fluidpage to dashboard layout
#icons: http://fontawesome.io/icons/
#icons: https://getbootstrap.com/docs/3.3/components/

rm(list=ls())
library(shiny)
library(rcdimple)
library(shinydashboard)
library(eurostat)

#Tablica z kodami i krajami
countries <-  eu_countries
countries$codename <- paste0(countries$name, " (", countries$code, ")")

# Define UI for application that draws a histogram
shinyUI(dashboardPage(#theme="bootstrap.css",
  dashboardHeader(title = "Eurostat Indicators"),
  dashboardSidebar(id="sidebarmenu", sidebarMenu(menuItem("Introduction", tabName = "introduction", icon = icon("dashboard")), 
                   menuItem("Demography", tabName = "demography",  icon = icon("th")), menuItem("General Economic Overview", tabName = 'general economic overview'), 
                   menuItem("Industry", tabName = "industry"), menuItem("Unemployment"), 
                   menuItem("Explore"), menuItem("About me"), menuItem("Credits")
  )),
  dashboardBody(tabItems(
    tabItem(tabName = "introduction",
            valueBoxOutput("populationbox"), valueBoxOutput('gdpbox'),valueBoxOutput('unemploymentbox'),
            valueBoxOutput('inflationbox'), valueBoxOutput('govdebtbox'), valueBoxOutput('govdeficitbox'),
            valueBoxOutput('sentimentbox'), valueBoxOutput('labourcostbox'), valueBoxOutput('imigrationbox'),
            selectInput("country", "Choose a country:", countries$codename), 
            imageOutput("flag", width = "50%", height = "200px")))),
   tabItem(tabname = "demography", dimpleOutput('chart'), valueBoxOutput('gdpbox'))
    ))



