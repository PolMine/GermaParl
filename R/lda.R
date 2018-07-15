#' Write s-attribute with top topicmodels to corpus
#' 
#' Add a new s-attributes 'topics' to GermaParl corpus with topicmodel 
#' for \code{k} topics. The \code{n} topics for speeches will be written to 
#' the corpus.
#' 
#' @param k number of topics of the topicmodel to load
#' @param n number of topics to write to corpus
#' @importFrom polmineR decode partition
#' @importFrom data.table setkeyv
#' @importFrom topicmodels topics
#' @importFrom cwbtools s_attribute_encode
#' @export germaparl_encode_lda_topics
#' @importFrom polmineR size
#' @examples 
#' \dontrun{
#' germaparl_encode_lda_topics(k = 250, n = 3)
#' }
germaparl_encode_lda_topics <- function(k = 200, n = 5){
  
  germaparl_regdir <- use_germaparl()
  germaparl_data_dir <- registry_file_parse(corpus = "GERMAPARL")[["home"]]
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
  cpos_dt <- decode("GERMAPARL", sAttribute = "speech")
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
  if (length(sAttributes("GERMAPARL", "speech", unique = FALSE)) != nrow(cpos_dt2)) stop()
  
  message("... encoding s-attribute 'topics'")
  s_attribute_encode(
    values = cpos_dt2[["topics"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = germaparl_data_dir,
    s_attribute = "topics",
    corpus = "GERMAPARL",
    region_matrix = as.matrix(cpos_dt2[, c("cpos_left", "cpos_right")]),
    registry_dir = germaparl_regdir,
    encoding = corpus_charset,
    method = "R",
    verbose = TRUE
  )
}

#' Load Topicmodel
#' 
#' @param k number of topics
#' @param verbose logical
#' @export germaparl_load_topicmodel
germaparl_load_topicmodel <- function(k, verbose = TRUE){
  if (verbose) message(sprintf("... loading topicmodel for k = %d", k))
  topicmodel_dir <- system.file(package = "GermaParl", "extdata", "topicmodels")
  lda_files <- Sys.glob(paths = sprintf("%s/germaparl_lda_speeches_*.rds", topicmodel_dir))
  ks <- as.integer(gsub("germaparl_lda_speeches_(\\d+)\\.rds", "\\1", basename(lda_files)))
  if (!k %in% ks) stop("no topicmodel available for k provided")
  names(lda_files) <- ks
  readRDS(lda_files[[as.character(k)]])
}


#' Get Bundle with Speeches for Topic.
#' 
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
#' @param n topic number
germaparl_get_speeches_for_topic <- function(n){
  P <- partition("GERMAPARL", topics = sprintf("\\|%d\\|", n), regex = TRUE)
  as.speeches(P, s_attribute_date = "date", s_attribute_name = "speaker")
}
