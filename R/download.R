#' Download full GermaParl corpus.
#' 
#' The GermaParl R package includes only a small subset of the GermaParl corpus
#' (GERMAPARLMINI). The full corpus is deposited with
#' \href{https://zenodo.org/}{zenodo}, a repository for research data. The
#' \code{germaparl_download_corpus} function downloads a tarball with the
#' indexed corpus from the zenodo repository and installs the corpus within the
#' GermaParl package. When calling the function, a stable and fast internet
#' connection will be useful as the size of the data amounts to ~1 GB which
#' needs to be downloaded.
#' 
#' @param doi The DOI (Digital Object Identifier) of the GermaParl tarball at zenodo.
#' @param quiet Whether to suppress progress messages, defaults to \code{FALSE}.
#' @export germaparl_download_corpus
#' @return A logical value, \code{TRUE} if the corpus has been installed
#'   successfully.
#' @rdname download
#' @importFrom cwbtools corpus_install
#' @importFrom RCurl url.exists getURL
#' @importFrom jsonlite fromJSON
#' @examples
#' \dontrun{
#' germaparl_download_corpus()
#' use("GermaParl")
#' corpus() # should include GERMAPARLMINI and GERMAPARL
#' count("GERMAPARL", "Daten") # an arbitrary test
#' }
germaparl_download_corpus <- function(doi = "https://doi.org/10.5281/zenodo.3735141", quiet = FALSE){
  if (isFALSE(is.logical(quiet))) stop("Argument 'quiet' needs to be a logical value.")
  if (isFALSE(grepl("^.*?10\\.5281/zenodo\\.\\d+$", doi))){
    stop("Argument 'doi' is expected to offer a DOI (Digital Object Identifier) that refers to data",
         "hosted with zenodo, i.e. starting with 10.5281/zenodo.")
  }
  record_id <- gsub("^.*?10\\.5281/zenodo\\.(\\d+)$", "\\1", doi)
  zenodo_api_url <- sprintf("https://zenodo.org/api/records/%d", as.integer(record_id))
  tarball <- fromJSON(getURL(zenodo_api_url))[["files"]][["links"]][["self"]]
  if (isFALSE(quiet)) message("... downloading tarball: ", tarball)
  corpus_install(pkg = "GermaParl", tarball = tarball, verbose = !quiet)
  return(TRUE)
}