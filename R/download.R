#' Download GermaParl from zenodo.
#' 
#' \code{germaparl_download_corpus} will get a tarball with the indexed corpus
#' from a designated web space or a local directory and install the corpus into
#' the GermaParl package.
#' @param doi The DOI (Digital Object Identifier) of the GermaParl tarball at zenodo.
#' @param quiet Whether to output messages.
#' @export germaparl_download_corpus
#' @rdname installation
#' @importFrom cwbtools corpus_install
#' @importFrom RCurl url.exists getURL
#' @importFrom jsonlite fromJSON
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
  corpus_install(pkg = "GermaParl", tarball = tarball)
}