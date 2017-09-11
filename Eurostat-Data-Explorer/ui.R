#
#Valuebox - works only with dashboad layout?
#change fluidpage to dashboard layout

library(shiny)
library(rcdimple)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(#theme="bootstrap.css",
  dashboardHeader(title = "Eurostat Indicators"),
  dashboardSidebar(sidebarMenuOutput("menu"), menuItem("Introduction", tabName = "introduction", icon = icon("dashboard")), menuItem("Demography"), 
                   menuItem("General Economic Overview"), menuItem("Industry"),
                   menuItem("General Economic Overview"), menuItem("Unemployment"),
                   menuItem("Explore"), menuItem("About me")
  ),
  dashboardBody(tabItems(
    tabItem(tabName = "introduction",
            valueBoxOutput("populationbox")
    )
  ))))

