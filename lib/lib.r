#' Infix to format strings via named paramters
#'
#' @param fmt A string to format
#' @param list A list of named parameters
#'
#' @examples
#' parameters <- list(label = "months", april = 4, may = 5, june = 6)
#' "%(label)s: %(april)d %(may)d %(june)d" %format% parameters
#'
#' @export
`%format%` <- function(fmt, list) {
  pat <- "%\\(([^)]*)\\)"
  pat2 <- "(?<=%\\()([^)]*)(?=\\))"
  fmt2 <- gsub(pat, "%", fmt)
  list2 <- list[stringr::str_extract_all(fmt, pat2)[[1]]]
  do.call("sprintf", c(fmt2, list2))
}

#' Import library into environment
#'
#' Super simple import function inspired by klmr/modules
#' Simplicity makes it far more brittle + opinionated
#'
#' @param module_name The module filepath
#'
#' @examples
#' pkg = import("lib/pkg")
#'
#' @export
import = function(module_name) {
  
  # Set up a new environment
  env = structure(
    new.env(parent = globalenv()),
    class = c('namespace', 'environment')
  )
  
  # Try the two types of R file extension, r or R
  filepath = file_path_candidate(module_name, "r")
  if (file.exists(filepath))  eval(parse(filepath, encoding = 'UTF-8'), envir = env)
  
  filepath = file_path_candidate(module_name, "R")
  if (file.exists(filepath))  eval(parse(filepath, encoding = 'UTF-8'), envir = env)
  
  env
  
}

file_path_candidate = function(module_name, ext) file.path(module_name, ext, fsep = ".")