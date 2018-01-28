#### -- Packrat Autoloader (version 0.4.8-21) -- ####
source("packrat/init.R")
#### -- End Packrat Autoloader -- ####

# Don't drop into debugger on error
options(error = NULL)

# Always print data.tables instead of data.frames
# Might be annoying in some cases, but avoids crashing R
print.data.frame = function(df) {
  data.table::setDT(df)
  print(df)
}
