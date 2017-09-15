library(eurostat)
library(knitr)


tabela <- as.table(paste0(eu_countries$name))

population <- label_eurostat(get_eurostat("tps00001",  filters = list(geo = str_sub(input$country,-3,-2))))


print(tabela)

#https://www.r-bloggers.com/pre-cran-waffle-update-isotype-pictograms/

#Plan

#1Introduction: KPI (liczba ludnosci, liczba bezrobotnych, GDP per capita) + lisa krajow z UE -> przejscie do KPI dla pojedynczych krajow
#2Demography: 

#
#Valuebox - works only with dashboad layout?
#change fluidpage to dashboard layout

gdp <- get_eurostat("nama_aux_gph", filters = list(geo = "UK"))
indic_na=RGDPH

unemployment <- label_eurostat(get_eurostat("tipsun20",  filters = list(geo = "UK", age="TOTAL", sex="T")))

population <- label_eurostat(get_eurostat("tps00001",  filters = list(geo = "EU28")))

population <- label_eurostat(get_eurostat("tps00001",  filters = list(geo = "EU28")))
population[population[, "time"]==as.character(max(population$time)), ]

countries <-  eu_countries
countries$codename <- paste0(countries$name, " (", countries$code, ")")

newdata <- mydata[ which(mydata$gender=='F' 
                         & mydata$age > 65), ]

#GDP forecasting

gdp <- get_eurostat("namq_10_gdp", filters = list(geo="UK", na_item="B1GQ", unit="CP_MEUR", s_adj="NSA"))

library(forecast)

gdptimeseries <- ts(gdp$values, frequency=4, start=c(1975,4))

gdpforecasts <- HoltWinters(gdptimeseries, beta=FALSE, gamma=FALSE)
plot(gdpforecasts)
gdpforecasts2 <- forecast.HoltWinters(rainseriesforecasts, h=8)
plot.forecast(gdpforecasts2)
