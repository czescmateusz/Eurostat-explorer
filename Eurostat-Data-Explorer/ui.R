#
#Valuebox - works only with dashboad layout?
#change fluidpage to dashboard layout
#icons: http://fontawesome.io/icons/
#icons: https://getbootstrap.com/docs/3.3/components/

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
  dashboardSidebar(sidebarMenuOutput("menu"), menuItem("Introduction", tabName = "introduction", icon = icon("dashboard")), 
                   menuItem("Demography", tabName = 'Demography'), menuItem("General Economic Overview"), 
                   menuItem("Industry", tabName = "industry"), menuItem("Unemployment"), 
                   menuItem("Explore"), menuItem("About me"), menuItem("Credits")
  ),
  dashboardBody(tabItems(
    tabItem(tabName = "introduction",
            valueBoxOutput("populationbox"), valueBoxOutput('gdpbox'),valueBoxOutput('unemploymentbox'),
            valueBoxOutput('inflationbox'), valueBoxOutput('govdebtbox'), valueBoxOutput('govdeficitbox'),
            valueBoxOutput('induprodbox'), valueBoxOutput('minwagebox'), valueBoxOutput('imigrationbox'),
            selectInput("country", "Choose a country:", countries$codename), imageOutput("flag")))),
   tabItem(tabName = "Demography", dimpleOutput('chart'))
    ))



