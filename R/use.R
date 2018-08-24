#' Get the registry directory in the GermaParl package.
#' 
#' Utility function that returns the registry directory within the GermaParl package.
#' @return The registry directory within the GermaParl package.
#' @export germaparl_regdir
germaparl_regdir <- function(){
  system.file(package = "GermaParl", "extdata", "cwb", "registry")
}
