#' Use topicmodels prepared for GermaParl.
#' 
#' A set of LDA topicmodels is deposited at a Amazon S3 webspace, for a number
#' of topics between 100 and 500.
#' 
#' @details The function \code{germaparl_download_lda} to download the
#'   *.rds-file. It will be stored in the \code{extdata/topicmodels/}
#'   subdirectory of the installed GermaParl package.
#' @param k The number of topics of the topicmodel.
#' @param webdir The web location.
#' @param rds_file filename of the RData file
#' @export germaparl_download_lda
#' @aliases topics
#' @examples
#' topicmodel_dir <- system.file(package = "GermaParl", "extdata", "topicmodels")
#' lda_files <- Sys.glob(paths = sprintf("%s/germaparl_lda_speeches_*.rds", topicmodel_dir))
#' if (length(lda_files) > 0  && requireNamespace("topicmodels")){
#'   lda <- readRDS(lda_files[1])
#'   lda_terms <- terms(lda, 50)
#' }
#' @rdname germaparl_topics
germaparl_download_lda <- function(k = c(100L, 150L, 175L, 200L, 225L, 250L, 275L, 300L, 350L, 400L, 450L, 500L), rds_file = sprintf("germaparl_lda_speeches_%d.rds", k), webdir = "https://s3.eu-central-1.amazonaws.com/polmine/corpora/cwb/germaparl"){
  tarball <- file.path(webdir, rds_file)
  if (!url.exists(tarball)){
    warning(sprintf("file '%s' is not available"), rds_file)
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



#' @details \code{germaparl_encode_lda_topics} will add a new s-attributes
#'   'topics' to GermaParl corpus with topicmodel for \code{k} topics. The
#'   \code{n} topics for speeches will be written to the corpus. A requirement
#'   for the function to work is that the s-attribute 'speech' has been
#'   generated beforehand using \code{germaparl_add_s_attribute_speech}.
#' 
#' @param n Number of topics to write to corpus
#' @importFrom polmineR decode partition s_attributes
#' @importFrom data.table setkeyv := setcolorder
#' @importFrom topicmodels topics
#' @importFrom cwbtools s_attribute_encode
#' @export germaparl_encode_lda_topics
#' @importFrom polmineR size
#' @examples 
#' \dontrun{
#' germaparl_encode_lda_topics(k = 250, n = 3)
#' }
#' @rdname germaparl_topics
germaparl_encode_lda_topics <- function(k = 200, n = 5){
  
  germaparl_data_dir <- registry_file_parse(
    corpus = "GERMAPARL",
    registry_dir = system.file(package = "GermaParl", "extdata", "cwb", "registry")
    )[["home"]]
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
         "Use the function germaparl_add_s_attribute_speech to generate it.")
  }
  cpos_dt <- decode("GERMAPARL", s_attribute = "speech")
  setkeyv(cpos_dt, "speech")
  
  
  ## Merge tables
  cpos_dt2 <- topic_dt[cpos_dt]
  setorderv(cpos_dt2, cols = "cpos_left", order = 1L)
  cpos_dt2[["speech"]] <- NULL
  cpos_dt2[["id"]] <- NULL
  cpos_dt2[, topics := ifelse(is.na(topics), "||", topics)]
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
  s_attribute_encode(
    values = cpos_dt2[["topics"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = germaparl_data_dir,
    s_attribute = "topics",
    corpus = "GERMAPARL",
    region_matrix = as.matrix(cpos_dt2[, c("cpos_left", "cpos_right")]),
    registry_dir = system.file(package = "GermaParl", "extdata", "cwb", "registry"),
    encoding = corpus_charset,
    method = "R",
    verbose = TRUE
  )
}

#' @details \code{germaparl_load_topicmodel} will load a topicmodel into memory.
#'   The function will return a \code{LDA_Gibbs} topicmodel, if the topicmodel
#'   for \code{k} is present; \code{NULL} if the topicmodel has not yet been
#'   downloaded.
#' @param verbose logical
#' @export germaparl_load_topicmodel
#' @rdname germaparl_topics
germaparl_load_topicmodel <- function(k, verbose = TRUE){
  if (verbose) message(sprintf("... loading topicmodel for k = %d", k))
  topicmodel_dir <- system.file(package = "GermaParl", "extdata", "topicmodels")
  lda_files <- Sys.glob(paths = sprintf("%s/germaparl_lda_speeches_*.rds", topicmodel_dir))
  ks <- as.integer(gsub("germaparl_lda_speeches_(\\d+)\\.rds", "\\1", basename(lda_files)))
  if (!k %in% ks){
    warning("no topicmodel available for k provided")
    return(NULL)
  }
  names(lda_files) <- ks
  readRDS(lda_files[[as.character(k)]])
}


#' @details @code{germaparl_get_speeches_for_topic} will get a bundle with
#'   Speeches for Topic.
#' @importFrom polmineR as.speeches
#' @export germaparl_get_speeches_for_topic
#' @examples
#' \dontrun{
#' k <- 250
#' model <- germaparl_load_topicmodel(k = k)
#' T <- topicmodels::terms(model, k)
#' topic <- 181 # topic nuclear energy
#' topic <- 133 # foreigners law
#' topic <- 65 # right-wing extremism
#' 
#' PB <- germaparl_get_speeches_for_topic(topic)
#' for (i in 1L:length(PB)) {
#'   fulltext <- read(PB[[i]])
#'   fulltext <- highlight(fulltext, list(yellow = T[1:100,topic]))
#'   print(fulltext)
#'   if (readline() == "q") stop()
#' }
#' }
#' @rdname germaparl_topics
germaparl_get_speeches_for_topic <- function(n){
  P <- partition("GERMAPARL", topics = sprintf("\\|%d\\|", n), regex = TRUE)
  as.speeches(P, s_attribute_date = "date", s_attribute_name = "speaker")
}
