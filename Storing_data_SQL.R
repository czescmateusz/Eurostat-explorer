library(RSQLite)
library(DBI)
library(countrycode)
#Creating a local sqlite db
eurostatDB <- dbConnect(RSQLite::SQLite(), "./sqlite/eurostat.sqlite")

countries <- dbGetQuery(eurostatDB, "select * from countries")



## GG animate 

#dbDisconnect(eurostatDB)
#unlink("eurostat.sqlite")
#Eurostat Data
library(eurostat)
countries <-  eu_countries
countries$codename <- paste0(countries$name, " (", countries$code, ")")
#Yearly data
listOfTables <- list(A=countries, B=population_yr)
population_yr <- label_eurostat(get_eurostat("tps00001"), dic = "geo", countrycode = "country.name")

smth  = c(DE = "Germany")

## Not run:
lp <- get_eurostat("nama_10_lp_ulc")
lpl <- label_eurostat(lp)
str(lpl)
lpl_order <- label_eurostat(lp, eu_order = TRUE)
lpl_code <- label_eurostat(lp, code = "unit")
label_eurostat_vars(names(lp))
label_eurostat_tables("nama_10_lp_ulc")
label_eurostat(c("FI", "DE", "EU28"), dic = "geo")
label_eurostat(c("FI", "DE", "EU28"), dic = "geo", custom_dic = c(DE = "Germany"))
label_eurostat(c("FI", "DE", "EU28"), dic = "geo", countrycode = "country.name",
               custom_dic = c(EU28 = "EU"))
label_eurostat(c("FI", "DE", "EU28"), dic = "geo", countrycode = "country.name")
# In Finnish
label_eurostat(c("FI", "DE", "EU28"), dic = "geo", countrycode = "cldr.short.fi")

unemployment_yr <-label_eurostat(get_eurostat("tipsun20",  filters = list(age="TOTAL", sex="T")))
inflation_yr <- label_eurostat(get_eurostat("tec00118"))
debt_yr <- label_eurostat(get_eurostat("gov_10dd_edpt1", filters=list(unit="PC_GDP", sector="S13", na_item="GD")))
deficit_yr <- label_eurostat(get_eurostat("gov_10dd_edpt1", filters=list(unit="PC_GDP", sector="S13", na_item="B9")))
labour_costs_yr <- label_eurostat((get_eurostat("tps00173", filters = list(lcstruct="D1_D4_MD5"))))
immigration_yr <- label_eurostat(get_eurostat("tps00176", filters = list(agedef="COMPLET")))
#Quarterly data
gdp_qr <- label_eurostat(get_eurostat("namq_10_gdp", filters = list(na_item="B1GQ", unit="CP_MEUR",  s_adj="SCA")))

#Monthly data
##Business anc consumer surveys
sentiment_mnth <- label_eurostat(get_eurostat("teibs010"))
consumer_mnth  <- label_eurostat(get_eurostat("ei_bsco_m"))
industry_mnth  <- label_eurostat(get_eurostat("ei_bsin_m_r2"))
construction_mnth  <- label_eurostat(get_eurostat("ei_bsbu_m_r2"))
retail_mnth  <- label_eurostat(get_eurostat("ei_bsbu_m_r2"))
services_mnth  <- label_eurostat(get_eurostat("ei_bsse_m_r2"))
fin_services_mnth  <- label_eurostat(get_eurostat("ei_bsfs_m"))


#codes ei_bsco_m
#Poland data
#GUS - gminy i powiaty




#Inserting the tables into sqlite

writeToDB <- function(x) {
  dbWriteTable(eurostatDB, name=deparse(substitute(x)), value=x, row.names=F, overwrite=T)
}
setOldClass(c("tbl_df", "data.frame"))
lapply(names(listOfTables), function(x) writeToDB(listOfTables[[x]]))

