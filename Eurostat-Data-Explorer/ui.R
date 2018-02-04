############################################################################################
# This application was built in RStudio by Mateusz Pawlowski at 
# mateusz.piotr.pawlowski@gmail.com
############################################################################################
#Quicknotes
#Valuebox - works only with dashboad layout?
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
library(dygraphs)

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
    menuItem("KPI", tabName = "KPI", icon = icon("area-chart")),
    menuItem("Time series models", tabName = "timeseriesTab", icon = icon("cogs")),
    menuItem("Source Code", icon = icon("code"), href = "https://github.com/czescmateusz/Eurostat-explorer")
  )
)

############################################################################################
# DEFINE DASHBOARD BODY HOME TAB
############################################################################################
introTab <- tabItem(
  tabName = "introduction",
  h1("Economic overview of Europe"),
  fluidRow(
    tags$em(
      "STATEMENT: this app was prepared as an excercise in using R-shiny and time-series models."
    ),
    br(),br(),
    box(
      h2("Instructions"),
      "1.",
      "Click on the ",
      icon("bars"),
      " icon on the top banner on mobile to show the selection menu.",
      br(),br(),
      icon("area-chart"), "2. The user is presented a set of KPI indcators that summarize the economic situation of a given country",
      br(),br(),
      icon("cogs"), "3. On this page the user can compare a set of time-series models using both charts and tables with performance metrics",
      br(),br(),
      "4. Business value: hard to estimate, but the government might consider firing the analysts who prepare such forecasts and substitute them with a shiny app"
    )
  )
)
############################################################################################
# DEFINE KPI'S and DEFINITIONS
############################################################################################
kpiTab <- tabItem(
  tabName = "KPI",
  selectInput("country", "Choose a country:", countries$codename),
  htmlOutput("flag", align="middle"),
  tags$div(title="The number of persons having their usual residence in a country on 1 January of the respective year. When usually resident population is not available, countries may report legal or registered residents.", valueBoxOutput("populationbox")), 
  tags$div(title="Seasonally adjusted GDP in market prices (millions euro)", valueBoxOutput('gdpbox')),
  tags$div(title="The unemployment rate is the number of unemployed persons as a percentage of the labour force based on International Labour Office (ILO) definition. The labour force is the total number of people employed and unemployed. Unemployed persons comprise persons aged 15 to 74 who: - are without work during the reference week; - are available to start work within the next two weeks; - and have been actively seeking work in the past four weeks or had already found a job to start within the next three months.", valueBoxOutput('unemploymentbox')),
  tags$div(title="HICP - inflation rate. Annual average rate of change (%). Harmonised Indices of Consumer Prices (HICPs) are designed for international comparisons of consumer price inflation. HICP is used for example by the European Central Bank for monitoring of inflation in the Economic and Monetary Union and for the assessment of inflation convergence as required under Article 121 of the Treaty of Amsterdam.", valueBoxOutput('inflationbox')), 
  tags$div(title="Government debt as percentage of GDP", valueBoxOutput('govdebtbox')), 
  tags$div(title="Government deficit as percentage of GDP", valueBoxOutput('govdeficitbox')),
  tags$div(title="The Economic Sentiment Indicator (ESI) is a composite indicator made up of five sectoral confidence indicators with different weights: Industrial confidence indicator, Services confidence indicator, Consumer confidence indicator, Construction confidence indicator Retail trade confidence indicator. Confidence indicators are arithmetic means of seasonally adjusted balances of answers to a selection of questions closely related to the reference variable they are supposed to track (e.g. industrial production for the industrial confidence indicator).", valueBoxOutput('sentimentbox')), 
  tags$div(title="Labour costs are defined as total labour costs divided by the corresponding number of hours worked by the yearly average number of employees, expressed in full-time units", valueBoxOutput('labourcostbox')), 
  tags$div(title="Total number of long-term immigrants arriving into the reporting country during the reference year", valueBoxOutput('imigrationbox'))
)


############################################################################################
# DEFINE Time series Tab
############################################################################################
timeseriesTab <- tabItem(
  tabName="timeseriesTab",
  h1("Time Series models  - hover over a chart or a table to get a description"),
  selectInput("country2", "Choose a country:", countries$codename),
  numericInput("periods", "Number of periods in the test set:", 8, min = 2, max = 20),
  tags$div(title="Forecast produced with an autoarima function. Returns best ARIMA model according to either AIC, AICc or BIC value.", dygraphOutput("dygraph")), 
  tags$div(title="ME: Mean Error
RMSE: Root Mean Squared Error
           MAE: Mean Absolute Error
           MPE: Mean Percentage Error
           MAPE: Mean Absolute Percentage Error
           MASE: Mean Absolute Scaled Error
           ACF1: Autocorrelation of errors at lag 1.
           ", tableOutput("table1")), 
  tags$div(title="Exponential Smoothing State Space Model", dygraphOutput("dygraph2")), 
  tags$div(title="ME: Mean Error
RMSE: Root Mean Squared Error
           MAE: Mean Absolute Error
           MPE: Mean Percentage Error
           MAPE: Mean Absolute Percentage Error
           MASE: Mean Absolute Scaled Error
           ACF1: Autocorrelation of errors at lag 1.
           ", tableOutput("table2")), 
  tags$div(title="A naive forecasting method. Forecasts and prediction intervals from an ARIMA(0,0,0)(0,1,0)m model where m is the seasonal period.", dygraphOutput("dygraph3")), 
  tags$div(title="ME: Mean Error
RMSE: Root Mean Squared Error
           MAE: Mean Absolute Error
           MPE: Mean Percentage Error
           MAPE: Mean Absolute Percentage Error
           MASE: Mean Absolute Scaled Error
           ACF1: Autocorrelation of errors at lag 1.
           ",tableOutput("table3")), 
  tags$div(title="Feed-forward neural networks with a single hidden layer and lagged inputs for forecasting univariate time series.", dygraphOutput("dygraph4")), 
  tags$div(title="ME: Mean Error
RMSE: Root Mean Squared Error
           MAE: Mean Absolute Error
           MPE: Mean Percentage Error
           MAPE: Mean Absolute Percentage Error
           MASE: Mean Absolute Scaled Error
           ACF1: Autocorrelation of errors at lag 1.
           ",tableOutput("table4")))


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
      kpiTab,
      timeseriesTab
    )
  )
)

