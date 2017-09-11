library(eurostat)
library(knitr)


tabela <- as.table(paste0(eu_countries$name))

print(tabela)

#https://www.r-bloggers.com/pre-cran-waffle-update-isotype-pictograms/

#Plan

#1Introduction: KPI (liczba ludnosci, liczba bezrobotnych, GDP per capita) + lisa krajow z UE -> przejscie do KPI dla pojedynczych krajow
#2Demography: 