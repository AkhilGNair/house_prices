# Normal R libraries
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(ggplot2))
library(magrittr)

# Helper functions
source("lib/lib.r")

# Data specification config
config = config::get(file = "conf/conf.yml")
load_datasets = import("lib/load_datasets")$load_datasets