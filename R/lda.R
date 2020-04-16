#' @include download.R
NULL

#' Use topicmodels prepared for GermaParl.
#' 
#' A set of LDA topicmodels is part of the Zenodo release of GermaParl, for a number
#' of topics between 100 and 450.
#' 
#' @details The function \code{germaparl_download_lda} will download an
#'   rds-file that will be stored in the \code{extdata/topicmodels/}
#'   subdirectory of the installed GermaParl package.
#' @param k A numeric or integer vector, the number of topics of the topicmodel.
#'   If multiple values are provided, several topic models can be downloaded at
#'   once.
#' @param doi The DOI of GermaParl at Zenodo (preferrably given as an URL).
#' @param registry_dir The registry directory where the registry file for GERMAPARL
#'   is located.
#' @param data_dir The data directory with the binary files of the GERMAPARL corpus.
#' 
#' @importFrom jsonlite fromJSON
#' @importFrom RCurl getURL
#' @importFrom polmineR registry_reset count
#' @return The functions \code{germaparl_download_lda} and
#'   \code{germaparl_encode_lda_topics} are returned for their side effects
#'   (downloading topic model and encoding topic model). They return \code{TRUE}
#'   if this has been succesful. The \code{germaparl_download_lda} function will
#'   return a \code{LDA_Gibbs} class object as defined in the topicmodels
#'   package.
#' @export germaparl_download_lda
#' @aliases topics
#' @examples
#' \donttest{
#' library(polmineR)
#' if (!germaparl_is_installed()){
#'   germaparl_download_corpus()
#'   polmineR::registry_reset()
#' }
#'
#' germaparl_download_lda(k = 250)
#' lda <- germaparl_load_topicmodel(k = 250)
#' lda_terms <- topicmodels::terms(lda, 50)
#' 
#' if (!"speech" %in% s_attributes("GERMAPARL")) germaparl_add_s_attribute_speech()
#' germaparl_encode_lda_topics(k = 250, n = 5)
#' 
#' # make amended corpus available
#' count("GERMAPARL", "Integration")
#' RcppCWB::cl_delete_corpus()
#' polmineR::registry_reset()
#' 
#' s_attributes("GERMAPARL")
#' sc <- corpus("GERMAPARL") %>%
#'   subset(grep("\\|133\\|", topics))
#' b <- as.speeches(sc, s_attribute_name = "speaker")
#' length(b)
#' }
#' @rdname germaparl_topics
germaparl_download_lda <- function(
  k = c(100L, 150L, 175L, 200L, 225L, 250L, 275L, 300L, 350L, 400L, 450L),
  doi = "https://doi.org/10.5281/zenodo.3742113",
  data_dir = file.path(cwb_corpus_dir(), "germaparl")
  ){
  if (!is.numeric(k)) stop("Argument k is required to be a numeric vector.")
  if (length(k) > 1L){
    sapply(1L:length(k), function(i) germaparl_download_lda(k = k[i], doi = doi))
  } else {
    rds_file <- sprintf("germaparl_lda_speeches_%d.rds", k) 
    
    record_id <- gsub("^.*?10\\.5281/zenodo\\.(\\d+)$", "\\1", doi)
    zenodo_api_url <- sprintf("https://zenodo.org/api/records/%d", as.integer(record_id))
    zenodo_files <- fromJSON(getURL(zenodo_api_url))[["files"]][["links"]][["self"]]

    lda_tarball <- grep(sprintf("^.*/%s$", rds_file), zenodo_files, value = TRUE)
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



#' @details \code{germaparl_encode_lda_topics} will add a new s-attributes
#'   'topics' to GermaParl corpus with topicmodel for \code{k} topics. The
#'   \code{n} topics for speeches will be written to the corpus. A requirement
#'   for the function to work is that the s-attribute 'speech' has been
#'   generated beforehand using \code{germaparl_add_s_attribute_speech}.
#' 
#' @param n Number of topics to write to corpus
#' @importFrom polmineR decode partition s_attributes
#' @importFrom data.table setkeyv := setcolorder as.data.table
#' @importFrom topicmodels topics
#' @importFrom cwbtools s_attribute_encode
#' @export germaparl_encode_lda_topics
#' @importFrom polmineR size
#' @rdname germaparl_topics
germaparl_encode_lda_topics <- function(k = 200, n = 5, registry_dir = cwb_registry_dir(), data_dir = file.path(cwb_corpus_dir, "germaparl")){
  
  # data_dir <- system.file(package = "GermaParl", "extdata", "cwb", "indexed_corpora", "germaparl")
  corpus_charset <- registry_file_parse(corpus = "GERMAPARL")[["properties"]][["charset"]]
  
  model <- germaparl_load_topicmodel(k = k)
  
  message("... getting topic matrix")
  topic_matrix <- topicmodels::topics(model, k = n)
  topic_dt <- data.table(
    speech = colnames(topic_matrix),
    topics = apply(topic_matrix, 2, function(x) sprintf("|%s|", paste(x, collapse = "|"))),
    key = "speech"
  )
  
  message("... decoding s-attribute speech")
  if (!"speech" %in% s_attributes("GERMAPARL")){
    stop("The s-attributes 'speech' is not yet present.",
         "Use the function germaparl_add_s_attribute_speech() to generate it.")
  }
  cpos_df <- RcppCWB::s_attribute_decode(
    "GERMAPARL",
    data_dir = data_dir,
    registry = registry_dir,
    encoding = corpus_charset,
    s_attribute = "speech",
    method = "R"
  )
  cpos_dt <- as.data.table(cpos_df)
  setnames(cpos_dt, old = "value", new = "speech")

  ## Merge tables
  cpos_dt2 <- topic_dt[cpos_dt, on = "speech"]
  setorderv(cpos_dt2, cols = "cpos_left", order = 1L)
  cpos_dt2[, "speech" := NULL][, "topics" := ifelse(is.na(topics), "||", topics)]
  setcolorder(cpos_dt2, c("cpos_left", "cpos_right", "topics"))
  
  # some sanity tests
  message("... running some sanity checks")
  coverage <- sum(cpos_dt2[["cpos_right"]] - cpos_dt2[["cpos_left"]]) + nrow(cpos_dt2)
  if (coverage != size("GERMAPARL")) stop()
  P <- partition("GERMAPARL", speech = ".*", regex = TRUE)
  if (sum(cpos_dt2[["cpos_left"]] - P@cpos[,1]) != 0) stop()
  if (sum(cpos_dt2[["cpos_right"]] - P@cpos[,2]) != 0) stop()
  if (length(s_attributes("GERMAPARL", "speech", unique = FALSE)) != nrow(cpos_dt2)) stop()
  
  message("... encoding s-attribute 'topics'")
  retval <- s_attribute_encode(
    values = cpos_dt2[["topics"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = data_dir,
    s_attribute = "topics",
    corpus = "GERMAPARL",
    region_matrix = as.matrix(cpos_dt2[, c("cpos_left", "cpos_right")]),
    registry_dir = registry_dir,
    encoding = corpus_charset,
    method = "R",
    verbose = TRUE,
    delete = FALSE
  )
  count("GERMAPARL", "Daten")
  RcppCWB::cl_delete_corpus("GERMAPARL")
  registry_reset()

  invisible(TRUE)
}

#' @details \code{germaparl_load_topicmodel} will load a topicmodel into memory.
#'   The function will return a \code{LDA_Gibbs} topicmodel, if the topicmodel
#'   for \code{k} is present; \code{NULL} if the topicmodel has not yet been
#'   downloaded.
#' @param verbose logical
#' @export germaparl_load_topicmodel
#' @importFrom cwbtools registry_file_parse cwb_registry_dir
#' @rdname germaparl_topics
germaparl_load_topicmodel <- function(k, registry_dir = cwbtools::cwb_registry_dir(), verbose = TRUE){
  if (verbose) message(sprintf("... loading topicmodel for k = %d", k))
  topicmodel_dir <- registry_file_parse(corpus = "germaparl", registry_dir = registry_dir)
  lda_files <- Sys.glob(paths = sprintf("%s/germaparl_lda_speeches_*.rds", topicmodel_dir))
  ks <- as.integer(gsub("germaparl_lda_speeches_(\\d+)\\.rds", "\\1", basename(lda_files)))
  if (!k %in% ks){
    warning("no topicmodel available for k provided")
    return(NULL)
  }
  names(lda_files) <- ks
  readRDS(lda_files[[as.character(k)]])
}
