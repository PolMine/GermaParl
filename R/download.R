#' Download full GermaParl corpus.
#' 
#' The GermaParl R package includes only a small subset of the GermaParl corpus
#' (GERMAPARLMINI). The full corpus is deposited with
#' \href{https://zenodo.org/}{Zenodo}, an open science repository for research
#' data. The \code{germaparl_download_corpus} function downloads a tarball with
#' the indexed corpus from the zenodo repository and moves the corpus data to
#' the system corpus storage. If a corpus registry has not yet been created, an
#' interactive dialogue will help to do so. When calling the function, a stable
#' and fast internet connection will be useful as the size of the data amounts
#' to ~1 GB which needs to be downloaded.
#' 
#' @details After downloading and installing the tarball with the CWB indexed
#'   corpus, the registry file for the GERMAPARL corpus will be amended by the
#'   DOI and the corpus version, to make this information available for the
#'   citation information that is provided when calling the function
#'   \code{citation}.
#' 
#' @param doi The DOI (Digital Object Identifier) of the GermaParl tarball at
#'   zenodo, presented as a hyperlink. Defaults to the latest version of 
#'   GermaParl.
#' @param ask A \code{logical} value, whether to ask for user input before
#'   replacing an existing corpus.
#' @param registry_dir Path to the system registry directory. Defaults to value
#'   of \code{cwbtools::cwb_registry_dir()}.
#' @param corpus_dir Directory where data directories of corpora are located.
#' @param verbose Whether to show messages, defaults to \code{TRUE}.
#' @export germaparl_download_corpus
#' @return A logical value, \code{TRUE} if the corpus has been installed
#'   successfully.
#' @rdname download
#' @importFrom cwbtools corpus_install cwb_registry_dir cwb_corpus_dir
#' @examples
#' \dontrun{
#' if (!germaparl_is_installed()) germaparl_download_corpus()
#' use("GermaParl")
#' corpus() # should include GERMAPARLMINI and GERMAPARL
#' count("GERMAPARL", "Daten") # an arbitrary test
#' }
germaparl_download_corpus <- function(doi = "https://doi.org/10.5281/zenodo.3742113", registry_dir = cwb_registry_dir(), corpus_dir = cwb_corpus_dir(registry_dir), verbose = TRUE, ask = interactive()){
  corpus_install(doi = doi, registry_dir = registry_dir, corpus_dir = corpus_dir, ask = ask, verbose = verbose)
  return(TRUE)
}
