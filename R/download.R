#' Download full GermaParl corpus.
#' 
#' The GermaParl R package includes only a small subset of the GermaParl corpus
#' (GERMAPARLMINI). The full corpus is deposited with
#' \href{https://zenodo.org/}{Zenodo}, an open science repository for research
#' data. The \code{germaparl_download_corpus} function downloads a tarball with
#' the indexed corpus from the Zenodo repository and moves the corpus data to
#' the system corpus storage. If a corpus registry has not yet been created, an
#' interactive dialogue will assist doing so. When calling the function, a
#' stable internet connection is recommended. The size of the data to be
#' downloaded is about 1 GB.
#' 
#' @details After downloading and installing the tarball with the CWB indexed
#'   corpus, the registry file for the GERMAPARL corpus will be amended by the
#'   DOI and the corpus version. Afterwards, this information is available for a
#'   citation information fitting the corpus used that is provided when calling
#'   \code{citation(package = "GermaParl")}.
#' 
#' @param doi The DOI (Digital Object Identifier) of the GermaParl tarball at
#'   zenodo, presented as a hyperlink. Defaults to the latest version of 
#'   GermaParl.
#' @param ask A \code{logical} value, whether to ask for user input before
#'   replacing an existing corpus.
#' @param registry_dir Path to the system registry directory. Defaults to value
#'   of \code{cwbtools::cwb_registry_dir()} to guess the registry directory. 
#'   We recommend to state the registry directory explicitly.
#' @param corpus_dir Directory where data directories of corpora are located. By
#'   default, the directory is guessed using \code{cwbtools::cwb_registry_dir}.
#'   We recommend to state the directory explicitly.
#' @param verbose Whether to show messages, defaults to \code{TRUE}.
#' @param sample A \code{logical} value, whether to download sample data
#'   (GERMAPARLSAMPLE) rather than full corpus (GERMAPARL) for testing purposes.
#' @export germaparl_download_corpus
#' @seealso An example for using the \code{germaparl_download_corpus} function
#'   is part of the examples section of the overview documentation of the
#'   \link{GermaParl} package.
#' @return Logical value. \code{TRUE} if the corpus has been installed
#'   successfully.
#' @rdname download
#' @importFrom cwbtools corpus_install cwb_registry_dir cwb_corpus_dir
germaparl_download_corpus <- function(doi = "https://doi.org/10.5281/zenodo.3742113", registry_dir = cwb_registry_dir(), corpus_dir = cwb_corpus_dir(registry_dir), verbose = interactive(), ask = interactive(), sample = FALSE){
  if (isTRUE(sample)) doi <- "https://doi.org/10.5281/zenodo.3823245"
  corpus_install(doi = doi, registry_dir = registry_dir, corpus_dir = corpus_dir, ask = ask, verbose = verbose)
  return(TRUE)
}
