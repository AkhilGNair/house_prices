#' Initialise House Prices dataset
#' 
#' Pull down as many years data as specified in the data config file
#' and write to the cache for easy laoding next time 
#'
#' @param config Data set specification file
#'
#' @return
#' @export
init_house_prices = function(config) {
  
  url_data = config$data_specification$dt_house_prices$extra$url
  
  # Build all s3 links
  years = config$data_specification$dt_house_prices$extra$years
  colnames = config$data_specification$dt_house_prices$colnames
  filepath = config$data_specification$dt_house_prices$save_as
  urls = lapply(years, function(year) url_data %format% list(year = year))
  
  # Read all s3 files and bind into one dataset
  dt = lapply(urls, fread, header = FALSE) %>% rbindlist()
  
  # Rename columns
  data.table::setnames(dt, names(colnames), unlist(colnames, use.names = FALSE))
  
  dt
  
}


#' Initialise Postcodes dataset
#' 
#' Download dataset o tmp folder, unzip, load and cache 
#'
#' @param config Data set specification file
#'
#' @return
#' @export
init_postcodes = function(config) {
  
  url_data = config$data_specification$dt_postcodes$extra$url
  filepath = config$data_specification$dt_postcodes$save_as
  colnames = names(config$data_specification$dt_postcodes$colnames)
  
  # Download an open source postcode geocoding
  temp_dir = tempdir()
  temp_zip = file.path(temp_dir, "postcodes.zip")
  download.file(url_data, temp_zip)
  
  # Unzipping will only work on a linux system with zip installed
  system(paste("unzip", temp_zip, "-d", temp_dir)) 
  
  # Read in from tmp folder
  dt = fread(file.path(temp_dir, "ukpostcodes.csv"))
  
  # Return only columns we care about
  dt[, colnames, with = FALSE][]
  
}
