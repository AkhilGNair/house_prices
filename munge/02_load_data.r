source("lib/lib.r")
library(data.table)
library(magrittr)
# devtools::install_github("fstpackage/fst")

config = config::get(file = "conf/conf.yml")
url_data = readLines("data/house_price.url")

# To initialise, change download flag in "conf/conf.yml" to TRUE
flag_download = config$download
years = config$years
colnames = config$data_specification$dt_house_prices$colnames
# Build all s3 links
urls = lapply(years, function(year) url_data %format% list(year = year))

if (flag_download) {
  # Read all s3 files and bind into one dataset
  dt = lapply(urls, fread, header = FALSE) %>% rbindlist()
  # Rename columns
  data.table::setnames(dt, names(colnames), unlist(colnames, use.names = FALSE))
  # Write to cache for easy loading next time
  fst::write.fst(dt, "cache/house_prices.fst")
  message("Data written to 'cache/'")
} else if (file.exists("cache/house_prices.fst")) {
  dt = fst::read.fst("cache/house_prices.fst", as.data.table = TRUE)
  message("Data read from 'cache/'")
} else {
  message("Initialise data in 'cache/' by changing download flag in 'conf/conf.yml' to TRUE")
}
