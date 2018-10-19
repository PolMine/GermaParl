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
germaparl_download_corpus <- function(tarball = "germaparl.tar.gz", dir = "http://polmine.sowi.uni-due.de/corpora/cwb/germaparl"){
  tarball <- file.path(dir, tarball)
  message("... downloading tarball: ", tarball)
  corpus_install(pkg = "GermaParl", tarball = tarball)
}
