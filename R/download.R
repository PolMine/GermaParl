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
#' @details After downloading and installing the tarball with the CWB indexed
#'   corpus, the registry file for the GERMAPARL corpus will be amended by
#'   the DOI and the corpus version, to make this information for the citation
#'   information that is provided when calling the function \code{citation}.
#' 
#' @param doi The DOI (Digital Object Identifier) of the GermaParl tarball at
#'   zenodo, presented as a hyperlink. Defaults to the latest version of 
#'   GermaParl.
#' @param quiet Whether to suppress progress messages, defaults to \code{FALSE}.
#' @export germaparl_download_corpus
#' @return A logical value, \code{TRUE} if the corpus has been installed
#'   successfully.
#' @rdname download
#' @importFrom cwbtools corpus_install registry_file_parse registry_file_write
#' @importFrom RCurl url.exists getURL
#' @importFrom jsonlite fromJSON
#' @examples
#' \dontrun{
#' if (!germaparl_is_installed()) germaparl_download_corpus()
#' use("GermaParl")
#' corpus() # should include GERMAPARLMINI and GERMAPARL
#' count("GERMAPARL", "Daten") # an arbitrary test
#' }
germaparl_download_corpus <- function(doi = "https://doi.org/10.5281/zenodo.3742113", quiet = FALSE){
  if (isFALSE(is.logical(quiet))) stop("Argument 'quiet' needs to be a logical value.")
  zenodo_info <- .germaparl_zenodo_info(doi = doi)
  corpus_tarball <- grep(
    "^.*/germaparl_v\\d+\\.\\d+\\.\\d+\\.tar\\.gz$",
    zenodo_info[["files"]][["links"]][["self"]],
    value = TRUE
  )
  if (isFALSE(quiet)) message("... downloading tarball: ", corpus_tarball)
  corpus_install(pkg = "GermaParl", tarball = corpus_tarball, verbose = !quiet)
  regdata <- registry_file_parse(
    corpus = "GERMAPARL",
    registry_dir = system.file(package = "GermaParl", "extdata", "cwb", "registry")
  )
  regdata[["properties"]][["doi"]] <- doi
  regdata[["properties"]][["version"]] <- zenodo_info[["metadata"]][["version"]]
  regdata[["home"]] <- system.file(package = "GermaParl", "extdata", "cwb", "indexed_corpora", "germaparl")
  registry_file_write(
    data = regdata,
    corpus = "GERMAPARL", 
    registry_dir = system.file(package = "GermaParl", "extdata", "cwb", "registry")
  )
  return(TRUE)
}

.germaparl_zenodo_info <- function(doi){
  if (isFALSE(grepl("^.*?10\\.5281/zenodo\\.\\d+$", doi))){
    stop("Argument 'doi' is expected to offer a DOI (Digital Object Identifier) that refers to data",
         "hosted with zenodo, i.e. starting with 10.5281/zenodo.")
  }
  record_id <- gsub("^.*?10\\.5281/zenodo\\.(\\d+)$", "\\1", doi)
  zenodo_api_url <- sprintf("https://zenodo.org/api/records/%d", as.integer(record_id))
  fromJSON(getURL(zenodo_api_url))
}