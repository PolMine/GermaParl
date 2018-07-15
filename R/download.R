#' Download GermaParl from Web Directory.
#' 
#' \code{germaparl_download_corpus} will get a tarball with the indexed corpus
#' from a designated web space or a local directory and install the corpus into
#' the GermaParl package.
#' @param tarball Name of the tarball.
#' @param dir directory where the tarball resides, either the URL of a webspace,
#'   or a local directory
#' @export germaparl_download_corpus
#' @rdname installation
#' @importFrom cwbtools corpus_install
#' @importFrom RCurl url.exists
germaparl_download_corpus <- function(tarball = "germaparl.tar.gz", dir = "https://s3.eu-central-1.amazonaws.com/polmine/corpora/cwb/germaparl"){
  tarball <- file.path(dir, tarball)
  message("... downloading tarball: ", tarball)
  corpus_install(pkg = "GermaParl", tarball = tarball)
}

#' Download Topicmodels for GermaParl.
#' 
#' A set of LDA topicmodels is deposited at a Amazon S3 webspace, for a number of topics between
#' 100 and 500. The function
#' \code{germaparl_download_lda} to download the *.rds-file. It will be stored in the
#' \code{extdata/topicmodels/} subdirectory of the installed GermaParl package.
#' 
#' @param k The number of topics of the topicmodel.
#' @param webdir The web location.
#' @param rds_file filename of the RData file
#' @export germaparl_download_lda
#' @examples
#' topicmodel_dir <- system.file(package = "GermaParl", "extdata", "topicmodels")
#' lda_files <- Sys.glob(paths = sprintf("%s/lda_germaparl_speeches_*.rds", topicmodel_dir))
#' if (length(lda_files) > 0  && requireNamespace("topicmodels")){
#'   lda <- readRDS(lda_files[1])
#'   lda_terms <- terms(lda, 50)
#' }
germaparl_download_lda <- function(k = c(100L, 150L, 175L, 200L, 225L, 250L, 275L, 300L, 350L, 400L, 450L, 500L), rds_file = sprintf("germaparl_lda_speeches_%d.rds", k), webdir = "https://s3.eu-central-1.amazonaws.com/polmine/corpora/cwb/germaparl"){
  tarball <- file.path(webdir, rds_file)
  if (!url.exists(tarball)){
    stop(sprintf("file '%s' is not available"), rds_file)
    return(FALSE)
  } else {
    message("... downloading: ", tarball)
    download.file(
      url = tarball,
      destfile = file.path(system.file(package = "GermaParl", "extdata", "topicmodels"), rds_file)
    )
    return(invisible(TRUE))
  } 
}
