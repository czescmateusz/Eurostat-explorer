#
#Valuebox - works only with dashboad layout?
#change fluidpage to dashboard layout
#icons: http://fontawesome.io/icons/
#icons: https://getbootstrap.com/docs/3.3/components/

library(shiny)
library(rcdimple)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(#theme="bootstrap.css",
  dashboardHeader(title = "Eurostat Indicators"),
  dashboardSidebar(sidebarMenuOutput("menu"), menuItem("Introduction", tabName = "introduction", icon = icon("dashboard")), menuItem("Demography"), 
                   menuItem("General Economic Overview"), menuItem("Industry", tabName = "industry"), menuItem("Unemployment"),
                   menuItem("Explore"), menuItem("About me"), menuItem("Credits")
  ),
  dashboardBody(tabItems(
    tabItem(tabName = "introduction",
            valueBoxOutput("populationbox"), valueBoxOutput('gdpbox'),valueBoxOutput('unemploymentbox'),selectInput("country", "Choose a country:", countries$codename
                                                           ))))
    ))

#inflation: credit-card
#government debt: euro
#government deficit: warning
#industrial production: bar-chart
#minimum wage compass
#imigration: line-chart
#time: clock-o

