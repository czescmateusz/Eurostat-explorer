# This is the server logic of a Shiny web application.


library(shiny)
library(stringr)
library(eurostat)
library(DT)
library(ggplot2)
library(dplyr)
library(mapproj)
library(tidyr)
library(shinydashboard)
library(dygraphs)
library(xts)
library(forecast)
library(knitr)
library(tmap)
library(geojsonio)
library(Matrix)
#Todo's
#Map - unemployment, gdp, whateva
# How do we catch up to the west?
# 


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  #output$tabEuroStat <- renderDataTable({ query_table <- search_eurostat(input$query, type = "table") })
  #Table with information on unemployment

  #KPI - economic indicators on the Introduction page
  #Population value box
  output$populationbox <- renderValueBox({
    Sys.sleep(0.5)
    population <-  tryCatch(label_eurostat(get_eurostat("tps00001",  filters = list(geo = str_sub(input$country,-3,-2)))), error=function(e) print("Sorry, there is no data for the selection made"))
    popyear <- as.character(max(population[ which(!is.na(population$values)),]$time))
    population <- paste0(round((population[population[, "time"]==popyear, ]$values/1000000),2), "mln")
    valueBox(
      population, paste0("Population in: ", popyear), icon = icon("group"),
      color = "purple"
    )
  })
  
  
population <- label_eurostat(get_eurostat("tps00001"))
  
  #GDP value box
  output$gdpbox <- renderValueBox({
    #nama_aux_gph
    Sys.sleep(0.5)
    gdp <- tryCatch(get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country,-3,-2), na_item="B1GQ", unit="CP_MEUR",  s_adj="SCA")), error=function(e) print("Sorry, there is no data for the selection made"))
    gdpyear <- tryCatch(as.character(max(gdp[ which(!is.na(gdp$values)),]$time)), error=function(e) print("Sorry, there is no data for the selection made"))
    gdp <- tryCatch(round(gdp[gdp[, "time"]==as.character(max(gdp$time)), ]$values,2),  error=function(e) print("No data"))
    valueBox(
      gdp, paste0("GDP in :", gdpyear), icon = icon("money"),
      color = "purple"
    )
  })
  
  #Unemployment
  output$unemploymentbox <- renderValueBox({
    Sys.sleep(0.5)
    unemployment <- label_eurostat(get_eurostat("tipsun20",  filters = list(geo = str_sub(input$country,-3,-2), age="TOTAL", sex="T")))
    unempyear <- as.character(max(unemployment[ which(!is.na(unemployment$values)),]$time))
    unemployment <- paste0(unemployment[unemployment[, "time"]==as.character(max(unemployment$time)), ]$values, "%")
    valueBox(
      unemployment, paste0("Unemployment rate in: ", unempyear), icon = icon("cogs"),
      color = "purple"
    )
  })
  
  #Inflation
  output$inflationbox <- renderValueBox({
    Sys.sleep(0.5)
    inflation <- label_eurostat(get_eurostat("tec00118",  filters = list(geo = str_sub(input$country,-3,-2))))
    inflatyear <- as.character(max(inflation[ which(!is.na(inflation$values)),]$time))
    inflation <- paste0(inflation[inflation[, "time"]==as.character(max(inflation$time)), ]$values, "%")
    valueBox(
      inflation, paste0("Inflation rate in: ", inflatyear), icon = icon("calculator"),
      color = "purple"
    )
  })
  
  
  #Government debt
  output$govdebtbox <- renderValueBox({
    Sys.sleep(0.5)
    debt <- get_eurostat("gov_10dd_edpt1", filters=list(geo= str_sub(input$country,-3,-2),unit="PC_GDP", sector="S13", na_item="GD"))
    debtyear <- as.character(max(debt[ which(!is.na(debt$values)),]$time))
    debt <- paste0(debt[debt[, "time"]==as.character(max(debt$time)), ]$values, "%")
  
    valueBox(
      debt, paste0("Government debt in: ", debtyear), icon = icon("euro"),
      color = "purple"
    )
  })
  
  
  #Government deficit
  output$govdeficitbox <- renderValueBox({
    Sys.sleep(0.5)
    deficit <- get_eurostat("gov_10dd_edpt1", filters=list(geo= str_sub(input$country,-3,-2),unit="PC_GDP", sector="S13", na_item="B9"))
    deficityear <- as.character(max(deficit[ which(!is.na(deficit$values)),]$time))
    deficit <- paste0(deficit[deficit[, "time"]==as.character(max(deficit$time)), ]$values, "%")
    
    valueBox(
      deficit, paste0("Government deficit in: ", deficityear), icon = icon("warning"),
      color = "purple"
    )
  })
  
  #Economic Sentiment
  output$sentimentbox <- renderValueBox({
    Sys.sleep(0.5)
    sentiment <- get_eurostat("teibs010", filters=list(geo= str_sub(input$country,-3,-2)))
    sentiyear <- as.character(max(sentiment[ which(!is.na(sentiment$values)),]$time))
    sentiment <- sentiment[sentiment[, "time"]==as.character(max(sentiment$time)), ]$values
    valueBox(
      sentiment, paste0("Economic sentiment indicator in: ", sentiyear), icon = icon("bar-chart"),
      color = "purple"
    )
  })
  
  #Labour costs
  output$labourcostbox <- renderValueBox({
    Sys.sleep(0.8)
    labour_costs <- na.omit(get_eurostat("tps00173", filters = list(geo=str_sub(input$country,-3,-2), lcstruct="D1_D4_MD5")))
    labour_year <-  as.character(max(labour_costs[ which(!is.na(labour_costs$values)),]$time))
    labour_costs <- labour_costs[labour_costs[, "time"]==as.character(max(labour_costs$time)), ]$values
    
    valueBox(
      labour_costs, paste0("Labour costs in: ", labour_year),  icon = icon("compass"),
      color = "purple"
    )
  })
  
  #Immigration
  output$imigrationbox <- renderValueBox({
    Sys.sleep(0.5)
    immigration <- get_eurostat("tps00176", filters = list(geo=str_sub(input$country,-3,-2), agedef="COMPLET"))
    immigrationyr <- as.character(max(immigration[ which(!is.na(immigration$values)),]$time))
    immigration <- immigration[immigration[, "time"]==as.character(max(immigration$time)), ]$values
    
    valueBox(
      immigration, paste0("Immigration in: ", immigrationyr),  icon = icon("line-chart"),
      color = "purple"
    )
  })
  
  #Map
  output$map <- renderLeaflet({
  # Can be retrieved from the eurostat service with:
  tgs00026 <- get_eurostat("tgs00026", time_format = "raw")
  # Data from Eurostat
  sp_data <- tgs00026 %>%
    # subset to have only a single row per geo
    dplyr::filter(time == 2010, nchar(as.character(geo)) == 4) %>%
    # categorise
    dplyr::mutate(income = cut_to_classes(values, n = 5)) %>%
    # merge with geodata
    merge_eurostat_geodata(data = ., geocolumn = "geo",resolution = "60",
                           output_class = "spdf", all_regions = TRUE)
  
  data(Europe)
  
  map1 <- tmap::tm_shape(Europe) +
    tmap::tm_fill("lightgrey") +
    tmap::tm_shape(sp_data) +
    tmap::tm_grid() +
    tmap::tm_polygons("income", title = "Disposable household\nincomes in 2010",
                      palette = "Oranges") +
    tmap::tm_format_Europe()
  
  tmap_leaflet(map1)

  })
  
  
  #Flagi

  
  output$flag <- renderText({
    paste0('<table>
             <tbody>
             <tr>
             <td>
             <p>This page presents a set of economic indicators that summarize the economic situation in European countries.&nbsp;</p>
             <p>&nbsp;</p>
             <p>Please hover over the indicator to get a definition.&nbsp;</p>
             </td>
             <td><img src="http://ec.europa.eu/eurostat/guip/web/countries/', 
           tolower(str_sub(input$country,-3,-2)), '.gif" height="50%" /></td>
    </tr>
           </tbody>
           </table>')
  })
  
  #Dygraphy
  
  output$dygraph <- renderDygraph({
    
    gdp <- get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country2,-3,-2), na_item="B1GQ", unit="CP_MEUR", s_adj="SCA"))
    
    gdpTSeries <- xts(gdp$values, as.Date(gdp$time, format='%Y/%m/%d'))
    colnames(gdpTSeries) <- "GDP"
    gdptimeseries <- na.trim(gdpTSeries)
    
    #Splitting time series
    gdp.learn <-  first(gdptimeseries, length(gdptimeseries)-input$periods)
    colnames(gdp.learn) <- "GDP-learn"
    gdp.test  <-  last(gdptimeseries, input$periods)
    colnames(gdp.test) <- "GDP-test"
    #Autoarima
    autoarima.model <- auto.arima(gdp.learn)
    autoARfore <- forecast(autoarima.model, h= input$periods )
    autoardf <- summary(autoARfore)
    dates <- rownames(as.data.frame(gdp.test))
    autoardf <- cbind(autoardf, dates)
    #convert into a Time-Series class
    autoardfTsPoint <- xts(autoardf$`Point Forecast`, as.Date(autoardf$dates))
    colnames(autoardfTsPoint) <- "Point Forecast"
    autoardfTsLo80 <- xts(autoardf$`Lo 80`, as.Date(autoardf$dates))
    colnames(autoardfTsLo80) <- "Lo 80"
    autoardfTsHi95 <- xts(autoardf$`Hi 95`, as.Date(autoardf$dates))
    colnames(autoardfTsHi95) <- "Hi 95"
    
    forplot <- cbind (gdp.learn, gdp.test, autoardfTsPoint, autoardfTsLo80, autoardfTsHi95)
    
 
    #plots
    dygraph(forplot, main="Auto Arima Forecast") %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE)
    
  })
  

  output$table1 <- renderTable({
    
    gdp <- get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country2,-3,-2), na_item="B1GQ", unit="CP_MEUR", s_adj="SCA"))
    
    gdpTSeries <- xts(gdp$values, as.Date(gdp$time, format='%Y/%m/%d'))
    colnames(gdpTSeries) <- "GDP"
    gdptimeseries <- na.trim(gdpTSeries)
    
    #Splitting time series
    gdp.learn <-  first(gdptimeseries, length(gdptimeseries)-input$periods)
    colnames(gdp.learn) <- "GDP-learn"
    gdp.test  <-  last(gdptimeseries, input$periods)
    colnames(gdp.test) <- "GDP-test"
    #Autoarima
    autoarima.model <- auto.arima(gdp.learn)
    autoARfore <- forecast(autoarima.model, h=input$periods)
    table1 <- data.frame(Item=c('In Sample Error', 'Out Sample Error'),accuracy(autoARfore, gdp.test))

  })
  

  output$dygraph2 <- renderDygraph({
    gdp <- get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country2,-3,-2), na_item="B1GQ", unit="CP_MEUR", s_adj="SCA"))
    
    gdpTSeries <- xts(gdp$values, as.Date(gdp$time, format='%Y/%m/%d'))
    colnames(gdpTSeries) <- "GDP"
    gdptimeseries <- na.trim(gdpTSeries)
    
    #Splitting time series
    gdp.learn <-  first(gdptimeseries, length(gdptimeseries)-input$periods)
    colnames(gdp.learn) <- "GDP-learn"
    gdp.test  <-  last(gdptimeseries, input$periods)
    colnames(gdp.test) <- "GDP-test"
    
  #Ets
  ets.model <- ets(gdp.learn)
  etsfore <- forecast(ets.model, input$periods)
  etsdf <- summary(etsfore)
  dates <- rownames(as.data.frame(gdp.test))
  etsdf <- cbind(etsdf, dates)
  #convert into a Time-Series class
  etsdfTsPoint <- xts(etsdf$`Point Forecast`, as.Date(etsdf$dates))
  colnames(etsdfTsPoint) <- "Point Forecast"
  etsdfTsLo80 <- xts(etsdf$`Lo 80`, as.Date(etsdf$dates))
  colnames(etsdfTsLo80) <- "Lo 80"
  etsdfTsHi95 <- xts(etsdf$`Hi 95`, as.Date(etsdf$dates))
  colnames(etsdfTsHi95) <- "Hi 95"
  
  forplotEts <- cbind(gdp.learn, gdp.test, etsdfTsPoint, etsdfTsLo80, etsdfTsHi95)
  
  dygraph(forplotEts,  main="ETS model") %>%
    dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE)
  })
  
  output$table2 <- renderTable({
    
    gdp <- get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country2,-3,-2), na_item="B1GQ", unit="CP_MEUR", s_adj="SCA"))
    
    gdpTSeries <- xts(gdp$values, as.Date(gdp$time, format='%Y/%m/%d'))
    colnames(gdpTSeries) <- "GDP"
    gdptimeseries <- na.trim(gdpTSeries)
    
    #Splitting time series
    gdp.learn <-  first(gdptimeseries, length(gdptimeseries)-input$periods)
    colnames(gdp.learn) <- "GDP-learn"
    gdp.test  <-  last(gdptimeseries, input$periods)
    colnames(gdp.test) <- "GDP-test"
    #Ets
    ets.model <- ets(gdp.learn)
    etsfore <- forecast(ets.model, input$periods)
    table2 <- data.frame(Item=c('In Sample Error', 'Out Sample Error'),accuracy(etsfore, gdp.test))
    
  })
  
  output$dygraph3 <- renderDygraph({
    gdp <- get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country2,-3,-2), na_item="B1GQ", unit="CP_MEUR", s_adj="SCA"))
    
    gdpTSeries <- xts(gdp$values, as.Date(gdp$time, format='%Y/%m/%d'))
    colnames(gdpTSeries) <- "GDP"
    gdptimeseries <- na.trim(gdpTSeries)
    
    #Splitting time series
    gdp.learn <-  first(gdptimeseries, length(gdptimeseries)-input$periods)
    colnames(gdp.learn) <- "GDP-learn"
    gdp.test  <-  last(gdptimeseries, input$periods)
    colnames(gdp.test) <- "GDP-test"
    
    #Snaive model
    snaive.forecast <- snaive(gdp.learn, input$periods)
    snainvedf <- summary(snaive.forecast)
    dates <- rownames(as.data.frame(gdp.test))
    snainvedf  <- cbind(snainvedf , dates)
    #convert into a Time-Series class
    snainveTsPoint <- xts(snainvedf$`Point Forecast`, as.Date(snainvedf$dates))
    colnames(snainveTsPoint) <- "Point Forecast"
    snainvedfTsLo80 <- xts(snainvedf$`Lo 80`, as.Date(snainvedf$dates))
    colnames(snainvedfTsLo80) <- "Lo 80"
    snainvedfTsHi95 <- xts(snainvedf$`Hi 95`, as.Date(snainvedf$dates))
    colnames(snainvedfTsHi95) <- "Hi 95"
    
    forplotSnaive <- cbind(gdp.learn, gdp.test, snainveTsPoint, snainvedfTsLo80, snainvedfTsHi95)
    
    dygraph(forplotSnaive,  main="forplotSnaive") %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE)
  })

  output$table3 <- renderTable({
    gdp <- get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country2,-3,-2), na_item="B1GQ", unit="CP_MEUR", s_adj="SCA"))
    gdpTSeries <- xts(gdp$values, as.Date(gdp$time, format='%Y/%m/%d'))
    colnames(gdpTSeries) <- "GDP"
    gdptimeseries <- na.trim(gdpTSeries)
    
    #Splitting time series
    gdp.learn <-  first(gdptimeseries, length(gdptimeseries)-input$periods)
    colnames(gdp.learn) <- "GDP-learn"
    gdp.test  <-  last(gdptimeseries, input$periods)
    colnames(gdp.test) <- "GDP-test"
    #Snaive
    snaive.forecast <- snaive(gdp.learn, input$periods)
    table3 <- data.frame(Item=c('In Sample Error', 'Out Sample Error'),accuracy(snaive.forecast, gdp.test))
    
  })  
  
  output$dygraph4 <- renderDygraph({
    gdp <- get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country2,-3,-2), na_item="B1GQ", unit="CP_MEUR", s_adj="SCA"))
    
    gdpTSeries <- xts(gdp$values, as.Date(gdp$time, format='%Y/%m/%d'))
    colnames(gdpTSeries) <- "GDP"
    gdptimeseries <- na.trim(gdpTSeries)
    
    #Splitting time series
    gdp.learn <-  first(gdptimeseries, length(gdptimeseries)-input$periods)
    colnames(gdp.learn) <- "GDP-learn"
    gdp.test  <-  last(gdptimeseries, input$periods)
    colnames(gdp.test) <- "GDP-test"
    
    #nnetar model
    nnetarmodel <- nnetar(gdp.learn, repeats = 300, lambda=0.8, scale.inputs = T)
    forNnetar <- forecast(nnetarmodel, h=input$periods)
    forNnetardf <- summary(forNnetar)
    dates <- rownames(as.data.frame(gdp.test))
    forNnetardf  <- cbind(forNnetardf, dates)
    #convert into a Time-Series class
    forNnetarTsPoint <- xts(forNnetardf$`Point Forecast`, as.Date(forNnetardf$dates))
    colnames(forNnetarTsPoint) <- "Point Forecast"
    
    forplotNnetar <- cbind(gdp.learn, gdp.test, forNnetarTsPoint)
    
    dygraph(forplotNnetar,  main="NNetar forecast") %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE)
  })  

  output$table4 <- renderTable({
    
    gdp <- get_eurostat("namq_10_gdp", filters = list(geo=str_sub(input$country2,-3,-2), na_item="B1GQ", unit="CP_MEUR", s_adj="SCA"))
    
    gdpTSeries <- xts(gdp$values, as.Date(gdp$time, format='%Y/%m/%d'))
    colnames(gdpTSeries) <- "GDP"
    gdptimeseries <- na.trim(gdpTSeries)
    
    #Splitting time series
    gdp.learn <-  first(gdptimeseries, length(gdptimeseries)-input$periods)
    colnames(gdp.learn) <- "GDP-learn"
    gdp.test  <-  last(gdptimeseries, input$periods)
    colnames(gdp.test) <- "GDP-test"
    #Snaive
    nnetarmodel <- nnetar(gdp.learn, repeats = 300, lambda=0.8, scale.inputs = T)
    forNnetar <- forecast(nnetarmodel, h=input$periods)
    table4 <- data.frame(Item=c('In Sample Error', 'Out Sample Error'),accuracy(forNnetar, gdp.test))
    
  })  
  
})

