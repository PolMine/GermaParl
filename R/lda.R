#' @include download.R GermaParl.R
NULL

#' Use topicmodels prepared for GermaParl.
#' 
#' A set of LDA topicmodels is part of the Zenodo release of GermaParl (k
#' between 100 and 450). These topic models can be downloaded using
#' \code{germaparl_download_lda} and loaded using \code{germaparl_load_lda}.
#' 
#' @details The function \code{germaparl_download_lda} will download an
#'   \code{rds}-file that will be stored in the data directory of the GermaParl
#'   corpus.
#' @param k A \code{numeric} or \code{integer} vector, the number of topics of
#'   the topicmodel. Multiple values can be provided to download several topic
#'   models at once.
#' @param doi The DOI of GermaParl at Zenodo.
#' @param registry_dir The registry directory where the registry file for GERMAPARL
#'   is located.
#' @param data_dir The data directory with the binary files of the GERMAPARL
#'   corpus. If missing, the directory will be guessed using the function
#'   \code{cwb::cwb_corpus_dir}
#' @param sample A \code{logical} value, if \code{TRUE}, use GERMAPARLSAMPLE
#'   corpus rather than GERMAPARL.
#' @return The functions \code{germaparl_download_lda} and
#'   \code{germaparl_encode_lda_topics} are returned for their side effects
#'   (downloading topic model and encoding topic model). They return \code{TRUE}
#'   if the operation has been succesful. The \code{germaparl_download_lda}
#'   function will return a \code{LDA_Gibbs} class object as defined in the
#'   topicmodels package.
#' @export germaparl_download_lda
#' @importFrom zen4R ZenodoManager
#' @aliases topics
#' @rdname germaparl_topics
#' @importFrom utils download.file
#' @examples
#' # This example assumes that the directories used by the CWB do not yet exist, so
#' # temporary directories are created.
#' cwb_dirs <- cwbtools::create_cwb_directories(prefix = tempdir(), ask = FALSE)
#' 
#' samplemode <- TRUE
#' corpus_id <- "GERMAPARLSAMPLE" # for full corpus: corpus_id <- "GERMAPARL"
#' 
#' dir.create(file.path(cwb_dirs[["corpus_dir"]], tolower(corpus_id)))
#' 
#' # Download topic model
#' germaparl_download_lda(
#'   k = 30, # k = 250 recommended for full GERMAPARL corpus
#'   data_dir = file.path(cwb_dirs[["corpus_dir"]], tolower(corpus_id)),
#'   sample = samplemode
#' )
#' lda <- germaparl_load_lda(
#'   k = 30L, registry_dir = cwb_dirs[["registry_dir"]],
#'   sample = samplemode
#' )
#' lda_terms <- topicmodels::terms(lda, 10)
germaparl_download_lda <- function(
  k = c(100L, 150L, 175L, 200L, 225L, 250L, 275L, 300L, 350L, 400L, 450L),
  doi = "10.5281/zenodo.3742113",
  data_dir,
  sample = FALSE
  ){
  
  if (isTRUE(sample)) doi <- "10.5281/zenodo.3823245"
  corpus_id <- if (isFALSE(sample)) "GERMAPARL" else "GERMAPARLSAMPLE"
  if (missing(data_dir)) data_dir <- file.path(cwb_corpus_dir(), tolower(corpus_id))
  if (!is.numeric(k)) stop("Argument k is required to be a numeric vector.")
  if (length(k) > 1L){
    sapply(1L:length(k), function(i) germaparl_download_lda(k = k[i], doi = doi))
  } else {
    zenodo_record <- ZenodoManager$new()$getRecordByDOI(doi = doi)
    zenodo_files <- sapply(zenodo_record[["files"]], function(x) x[["links"]][["download"]])
    tarball <- grep("^.*?_(v|)\\d+\\.\\d+\\.\\d+\\.tar\\.gz$", zenodo_files, value = TRUE)
    lda_tarball <- grep(sprintf("^.*/%s_lda_.*?%d\\.rds$", tolower(corpus_id), k), zenodo_files, value = TRUE)
    rds_file <- basename(lda_tarball)
    if (!nchar(lda_tarball)){
      warning(sprintf("File '%s' is not available at Zenodo repository for the DOI given.", rds_file))
      return(FALSE)
    } else {
      message("... downloading: ", lda_tarball)
      download.file(
        url = lda_tarball,
        destfile = file.path(data_dir, rds_file)
      )
      return(invisible(TRUE))
    } 
  }
  invisible(TRUE)
}


#' @details \code{germaparl_load_lda} will load a topicmodel into memory.
#'   The function will return a \code{LDA_Gibbs} topicmodel, if the topicmodel
#'   for \code{k} is present; \code{NULL} if the topicmodel has not yet been
#'   downloaded.
#' @param verbose logical
#' @export germaparl_load_lda
#' @importFrom cwbtools registry_file_parse cwb_registry_dir
#' @rdname germaparl_topics
germaparl_load_lda <- function(k, registry_dir = cwbtools::cwb_registry_dir(), verbose = TRUE, sample = FALSE){
  corpus_id <- if (isFALSE(sample)) "GERMAPARL" else "GERMAPARLSAMPLE" 
  if (verbose) message(sprintf("... loading topicmodel for k = %d", k))
  if (file.exists(file.path(registry_dir, tolower(corpus_id)))){
    topicmodel_dir <- registry_file_parse(corpus = tolower(corpus_id), registry_dir = registry_dir)[["home"]]
  } else {
    topicmodel_dir <- file.path(dirname(registry_dir), "indexed_corpora", tolower(corpus_id))
    if (!dir.exists(topicmodel_dir)){
      stop("Cannot guess directory for topicmodels.")
    }
  }
  lda_files <- Sys.glob(paths = sprintf("%s/%s_lda_*.rds", topicmodel_dir, tolower(corpus_id)))
  ks <- as.integer(gsub(sprintf("%s_lda_.*?(\\d+)\\.rds$", tolower(corpus_id)), "\\1", basename(lda_files)))
  if (!k %in% ks){
    warning("no topicmodel available for k provided")
    return(NULL)
  }
  names(lda_files) <- ks
  readRDS(lda_files[[as.character(k)]])
}
