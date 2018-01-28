# Littler doesn't respect .Rprofile
source(".Rprofile")

# Run munge files
. = sapply(dir("munge", full.names = TRUE), source); rm(.)
