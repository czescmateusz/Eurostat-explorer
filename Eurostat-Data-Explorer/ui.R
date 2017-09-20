############################################################################################
# This application was built in RStudio by Mateusz Pawlowski at 
# mateusz.piotr.pawlowski@gmail.com
#
# The application allows users to analyse Eurostat Data
#
############################################################################################
#Quicknotes
#Valuebox - works only with dashboad layout?
#change fluidpage to dashboard layout
#icons: http://fontawesome.io/icons/
#icons: https://getbootstrap.com/docs/3.3/components/
#http://deanattali.com/blog/advanced-shiny-tips/
############################################################################################
# LOAD REQUIRED LIBRARIES
############################################################################################
rm(list=ls())
library(shiny)
library(shinyjs)
library(rcdimple)
library(shinydashboard)
library(eurostat)
#Eu countries and their codes in eurostat database
countries <-  eu_countries
countries$codename <- paste0(countries$name, " (", countries$code, ")")

#Dashboard header
dbHeader <- dashboardHeader(
  title="Eurostat Indicators")

############################################################################################
# DEFINE DASHBOARD SIDEBAR
############################################################################################
dbSidebar <- dashboardSidebar(
  # DEFINE SIDEBAR ITEMS
  sidebarMenu(
    menuItem("Introduction", tabName = "introduction", icon = icon("home")),
    menuItem("Demography", tabName = "demography", icon = icon("area-chart")),
    #menuItem("Data", tabName = "data", icon = icon("table")),
    #menuItem("RDF Tree", tabName = "tree", icon = icon("tree")),
    #menuItem("Reports", tabName = "reports", icon = icon("cogs")),
    menuItem("Source Code", icon = icon("code"), href = "https://github.com/czescmateusz/Eurostat-explorer")
  )
)

############################################################################################
# DEFINE DASHBOARD BODY HOME TAB
############################################################################################
introTab <- tabItem(
  tabName = "introduction",
  h1("Eurostat Data Explorer"),
  fluidRow(
    tags$em(
      "STATEMENT: 
      ...."
    ),
    br(),br(),
    box(
      h2("Instructions"),
      "1. ...",
      "Click on the ",
      icon("bars"),
      " icon on the top banner on mobile to show the selection menu.",
      br(),br(),
      "2. Once a model has been selected, another drop down box will be populated with the slot names ",
      "present in the selected model RDF file. You may click on the drop-down box to specify a slot ",
      "to select or you may type in partial names to filter the available slots in the list. ",
      "The drop-down box may take a few seconds to generate.",
      br(),br(),
      "3. Once a model and a slot has been selected, you may now view graphs and data in their respective ",
      "sections via the sidebar. Information about your selected RDF file and slot are shown by clicking ",
      "on the ",
      icon("envelope"),
      " icons at the top right of the window. You may change your selections at any time. ",
      br(),br()

    )
  )
)
############################################################################################
# DEFINE DASHBOARD BODY GRAPHS TAB
############################################################################################
demoTab <- tabItem(
  tabName = "demography",
  valueBoxOutput("populationbox"), valueBoxOutput('gdpbox'),valueBoxOutput('unemploymentbox'),
  valueBoxOutput('inflationbox'), valueBoxOutput('govdebtbox'), valueBoxOutput('govdeficitbox'),
  valueBoxOutput('sentimentbox'), valueBoxOutput('labourcostbox'), valueBoxOutput('imigrationbox'),
  selectInput("country", "Choose a country:", countries$codename), 
  imageOutput("flag", width = "50%", height = "200px"), dimpleOutput('chart'))

############################################################################################
# DEFINE INEQUALITY TAB
############################################################################################
#inequalityTab <- tabItem()


############################################################################################
# POPULATE DASHBOARD
############################################################################################
userInterface <- dashboardPage(
  skin = "blue",
  # DASHBOARD HEADER
  dbHeader,
  # DASHBOARD SIDEBAR
  dbSidebar,
  # DASHBOARD BODY
  dashboardBody(
    tabItems(
      introTab,
      demoTab
    )
  )
)

