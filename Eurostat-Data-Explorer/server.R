#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#

library(shiny)
library(eurostat)
library(DT)
library(ggplot2)
library(dplyr)
library(mapproj)
library(tidyr)
library(rcdimple)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  #
  output$tabEuroStat <- renderDataTable({ query_table <- search_eurostat(input$query, type = "table") })
  #Table with information on unemployment
  output$tabUnemployment<-renderDataTable({unemployment <- spread(get_eurostat('tepsr_wc170', time_format = "num"), geo, values)})
  
<<<<<<< HEAD
  output$vbox1 <- renderValueBox({
    valueBox(
      subtitle="Box",
      1500,icon = icon("arrow-up"),
      color = "green"
    )
  })
  
=======
>>>>>>> db0112a080dd288a8c92752ddd609e709a578784
  output$countries <-renderDataTable({eu_countries})
    
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

