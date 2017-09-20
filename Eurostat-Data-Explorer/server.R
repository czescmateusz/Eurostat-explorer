#
# This is the server logic of a Shiny web application. You can run the 


library(shiny)
library(stringr)
library(eurostat)
library(DT)
library(ggplot2)
library(dplyr)
library(mapproj)
library(tidyr)
library(rcdimple)
library(shinydashboard)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$tabEuroStat <- renderDataTable({ query_table <- search_eurostat(input$query, type = "table") })
  #Table with information on unemployment
  output$tabUnemployment<-renderDataTable({unemployment <- spread(get_eurostat('tepsr_wc170', time_format = "num"), geo, values)})
  
  #KPI - economic indicators on the Introduction page
  #Population value box
  output$populationbox <- renderValueBox({
    population <- label_eurostat(get_eurostat("tps00001",  filters = list(geo = str_sub(input$country,-3,-2))))
    popyear <- as.character(max(population$time))
    population <- paste0((population[population[, "time"]==popyear, ]$values/1000000), "mln")
    valueBox(
      population, paste0("Population in :", popyear), icon = icon("group"),
      color = "purple"
    )
  })
  
  
  #GDP value box
  output$gdpbox <- renderValueBox({
    gdp <- label_eurostat(get_eurostat("nama_aux_gph",  filters = list(geo = str_sub(input$country,-3,-2), unit="EUR_HAB", indic_na="RGDPH")))
    gdpyear <- as.character(max(gdp$time))
    gdp <-gdp[gdp[, "time"]==as.character(max(gdp$time)), ]$values
    valueBox(
      gdp, paste0("GDP in :", gdpyear), icon = icon("money"),
      color = "purple"
    )
  })
  
  #Unemployment
  output$unemploymentbox <- renderValueBox({
    unemployment <- label_eurostat(get_eurostat("tipsun20",  filters = list(geo = str_sub(input$country,-3,-2), age="TOTAL", sex="T")))
    unemployment <- unemployment[unemployment[, "time"]==as.character(max(unemployment$time)), ]$values
    valueBox(
      unemployment, "Unemployment rate", icon = icon("cogs"),
      color = "purple"
    )
  })
  
  #Inflation
  output$inflationbox <- renderValueBox({
    inflation <- label_eurostat(get_eurostat("tec00118",  filters = list(geo = str_sub(input$country,-3,-2))))
    inflation <-inflation[inflation[, "time"]==as.character(max(inflation$time)), ]$values
    valueBox(
      inflation, "Inflation rate", icon = icon("euro"),
      color = "purple"
    )
  })
  
  
  #Government debt
  output$govdebtbox <- renderValueBox({
    
    debt <- get_eurostat("gov_10dd_edpt1", filters=list(geo= str_sub(input$country,-3,-2),unit="PC_GDP", sector="S13", na_item="GD"))
    debt <- debt[debt[, "time"]==as.character(max(debt$time)), ]$values
    
    valueBox(
      debt, "Government debt", icon = icon("euro"),
      color = "purple"
    )
  })
  
  
  #Government deficit
  output$govdeficitbox <- renderValueBox({
    
    deficit <- get_eurostat("gov_10dd_edpt1", filters=list(geo= str_sub(input$country,-3,-2),unit="PC_GDP", sector="S13", na_item="B9"))
    deficit <- deficit[deficit[, "time"]==as.character(max(deficit$time)), ]$values
    
    valueBox(
      deficit, "Government deficit", icon = icon("warning"),
      color = "purple"
    )
  })
  
  #Sentiment
  output$sentimentbox <- renderValueBox({
    sentiment <- get_eurostat("teibs010", filters=list(geo= str_sub(input$country,-3,-2)))
    sentiment <- sentiment[sentiment[, "time"]==as.character(max(sentiment$time)), ]$values
    valueBox(
      sentiment, "Economic sentiment indicator", icon = icon("bar-chart"),
      color = "purple"
    )
  })
  
  #Labour costs
  output$labourcostbox <- renderValueBox({
    
    labour_costs <- get_eurostat("tps00173", filters = list(geo=str_sub(input$country,-3,-2), lcstruct="D"))
    labour_costs <- labour_costs[labour_costs[, "time"]==as.character(max(labour_costs$time)), ]$values
    
    valueBox(
      labour_costs, "Labour costs" , icon = icon("compass"),
      color = "purple"
    )
  })
  
  #Imigration
  output$imigrationbox <- renderValueBox({
    
    immigration <- get_eurostat("tps00176", filters = list(geo=str_sub(input$country,-3,-2), agedef="COMPLET"))
    immigration <- immigration[immigration[, "time"]==as.character(max(immigration$time)), ]$values
    
    valueBox(
      immigration, "Imigration" , icon = icon("line-chart"),
      color = "purple"
    )
  })
  
  
  #Flagi
  
  output$flag <- renderImage({
    return(list(src = "flags/Bosnia.svg.png",
      contentType = "image/png", deleteFile = FALSE
    ))
  })

  
  #Fancy animated chart
  #Wykres dynamiczny z piramidą populacji  
  output$chart <- renderDimple({demography <- get_eurostat('demo_pjangroup', time_format = "num")
  
  germany <- demography[ which(demography$geo=='DE' 
                               & demography$sex!='T' & demography$age!='TOTAL' & demography$age!='UNK'
                               & demography$age!='Y_GE75' & demography$age!='Y_GE80' 
                               & demography$age!='Y_GE85' & demography$age!='Y_LT5'), ]
  
  germany$ageCode <- as.character(gsub("Y", "", as.character(germany$age)))
  
  germany$agestring <- as.numeric(gsub("-", "", as.character(germany$ageCode)))
  germany <- germany[order(germany$time, germany$agestring),]
  
  germany <- select(germany, -unit)
  germany <- select(germany, -geo)
  germany <- select(germany, -age)
  germany <- germany %>% mutate(values = ifelse(sex == 'M', values*(-1), values*1))
  
  # Format the table with dplyr and tidyr
  
  max_x <- plyr::round_any(max(germany$values), 10000, f = ceiling)
  min_x <- plyr::round_any(min(germany$values), 10000, f = floor)
  
  html <- paste0("<h3 style='font-family:Helvetica; text-align: center;'>", 'Population Dynamics', min(germany$time), "
                 -", max(germany$time, "</h3>"))
  
# Build the chart with rcdimple

chart <-germany %>%
  dimple(x = "values", y = "ageCode", group = "sex", type = 'bar', storyboard = "time") %>%
  yAxis(type = "addCategoryAxis", orderRule = "agestring") %>%
  xAxis(type = "addMeasureAxis", overrideMax = max_x, overrideMin = min_x) %>%
  default_colors(c("green", "orange")) %>%
  add_legend() %>%
  add_title(html = html) %>%
  
  # Here, I'll pass in some JS code to make all the values on the X-axis and in the tooltip absolute values
  tack(., options = list(
    chart = htmlwidgets::JS("
                            function(){
                            var self = this;
                            // x axis should be first or [0] but filter to make sure
                            self.axes.filter(function(ax){
                            return ax.position == 'x'
                            })[0] // now we have our x axis set _getFormat as before
                            ._getFormat = function () {
                            return function(d) {
                            return d3.format(',.0f')(Math.abs(d) / 1000000) + 'm';
                            };
                            };
                            // return self to return our chart
                            return self;
                            }
                            "))
    )
})
})

