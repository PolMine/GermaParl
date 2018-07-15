#' Use the GermaParl Corpus.
#' 
#' Utility function to ensure that registry directory points to registry in
#' GermaParl package.
#' @importFrom polmineR use
#' @return Invisibly, the registry directory in the GermaParl package is returned.
#' @export use_germaparl
use_germaparl <- function(){
  germaparl_regdir <- system.file(package = "GermaParl", "extdata", "cwb", "registry")
  if (Sys.getenv("CORPUS_REGISTRY") != germaparl_regdir){
    message("... environment variable CORPUS_REGISTRY is not yet path to ",
            "registry directory in GermaParl package - resetting")
    use("GermaParl")
  }
  invisible(germaparl_regdir)
}
