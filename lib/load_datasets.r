source("lib/lib.r")  # To enable import
init_data = import("lib/init_data_helpers")  # Any specific loading described in helper

#' load_datasets
#'
#' Loads all the datasets specified into the global environment
#'
#' @param config The dataset configurations
#'
#' @return
#' @export
load_datasets = function(config) {
  
  datasets = names(config$data_specification)
  
  purrr::walk(datasets, load_dataset, config = config)
  
}


#' Load an individual dataset from config file 
#'
#' Control flow specifies whether to load from the cache, or initiailise
#' and cache the result for next time
#'
#' @param dataset The dataset to intialise
#' @param config The config file with the data initialisation specification
#'
#' @return
#' @export
load_dataset = function(dataset, config) {
  
  cache         = config$paths$cache
  download      = config$data_specification[[dataset]]$download
  assign_to     = config$data_specification[[dataset]]$assign
  init_function = config$data_specification[[dataset]]$init_function
  filepath      = config$data_specification[[dataset]]$save_as
  
  # To initialise, change download flag in "conf/conf.yml" to TRUE
  if (file.exists(filepath)) {
    
    # If the file exists in the cache load it globaally and return
    assign(assign_to, fst::read.fst(filepath, as.data.table = TRUE), envir = globalenv())
    
    cat(paste0("FOUND: ", dataset, " loaded as ", assign_to, "\n"))
    return()
    
  } else if (download) {
    
    assign(assign_to, init_data[[init_function]](config), envir = globalenv())
    
    # Write to cache for easy loading next time
    fst::write.fst(get(assign_to), path = filepath)
    
    cat(paste0("CACHED: ", dataset, " available as ", assign_to, "\n"))
    
  } else {
    
    cat(paste0("MISSED: Initialise ", dataset," in '", cache, "' by changing relevant download flag in 'conf/conf.yml' to TRUE\n"))
    
  }
  
}
