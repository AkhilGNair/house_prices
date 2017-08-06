# Run munge files
. = sapply(dir("munge", full.names = TRUE), source); rm(.)
