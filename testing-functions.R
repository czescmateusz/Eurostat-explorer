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

population <- get_eurostat("tps00001")

population <- label_eurostat(get_eurostat("tps00001",  filters = list(geo = "EU28")))
population[population[, "time"]==as.character(max(population$time)), ]

countries <-  eu_countries
countries$codename <- paste0(countries$name, " (", countries$code, ")")

newdata <- mydata[ which(mydata$gender=='F' 
                         & mydata$age > 65), ]




library(stringr)

str_sub(countries$codename,-3,-2)

input$country