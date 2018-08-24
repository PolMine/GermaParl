#' Inspect Annotations Present in a Partition
#' 
#' @param x a partition object
#' @param annotation number of an annotation that will be looked up in values for s-attribute
#' @examples
#' \dontrun{
#' P <- partition(
#'   "GERMAPARL",
#'   lp = 17, session = 175, speaker = "Fritz Rudolf K\u00F6rper",
#'   xml = "nested"
#' )
#' annotations_inspect(P, annotation = "16")
#' }
#' @export annotations_inspect
#' @importFrom data.table rbindlist
annotations_inspect <- function(x, annotation = NULL){
  
  annos <- unique(unlist(strsplit(sAttributes(x, "cap"), split = "\\|")))
  annos <- annos[-which(annos %in% "")]
  if (!is.null(annotation)){
    if (!annotation %in% annos) stop("annotation is not present in partition")
    annos <- annotation
  }
  .show <- function(x, anno){
    xsub <- partition(x, cap = sprintf("^.*\\|%s\\|.*$", anno), xml = "nested", regex = TRUE)
    cpos <- unique(unlist(apply(xsub@cpos, 1, function(cpos) cpos[1]:cpos[2])))
    H <- html(x)
    H <- highlight(H, list(yellow = cpos)) 
    show(H)
  }
  if (length(annos) > 1){
    for (anno in annos){
      print(anno)
      .show(x, anno)
      if (readline(prompt = "print 'q' to exit") == "q") break
    }
  } else {
    .show(x, annos)
  }
  invisible(NULL)
}


#' Get Features of Annotations
#' 
#' @param x XXX
#' @param pAttribute XXX
#' @param annotation XXX
#' @export annotation_features
#' @importFrom methods as
annotation_features <- function(x, pAttribute = c("word", "pos"), annotation){
  P <- partition(x, cap = sprintf("^.*\\|%s\\|.*$", annotation), regex = TRUE)
  P2 <- enrich(P, pAttribute = pAttribute)
  annoCount <- as(P2, "count")
  
  gparl <- Corpus$new("GERMAPARL", pAttribute = pAttribute)$as.partition()
  gparlCount <- as(gparl, "count")
  
  F <- features(annoCount, gparlCount, included = TRUE)
  F <- subset(F, F[["chisquare"]] > 10.83)
  F <- subset(F, F[["pos"]] %in% c("NN", "ADJA"))
  F
}

#' Write CAP Annotations to GermaParl
#' 
#' @param dir directory with CAP annotations
#' @importFrom polmineR sAttributes
#' @importFrom pbapply pblapply
#' @importFrom data.table := rbindlist
#' @export germaparl_encode_cap_annotations
germaparl_encode_cap_annotations <- function(dir = "/Lab/gitlab/plprbttxt_annotations/2016_09_21"){
  
  if (!requireNamespace(package = "polmineR.anno", quietly = TRUE)){
    stop(
      "Package 'polmineR.anno' needs to be installed, but is not available.",
      "It can be installed from the drat repository of the PolMine Project."
      )
  }

  conll_files <- list.files(dir)
  Encoding(conll_files) <- "UTF-8"
  
  # Extract metadata information from filename and match it to corpus metadata
  speakerNames <- sAttributes("GERMAPARL", "speaker")
  
  .SD <- NULL # just for the sake of R CMD check
  
  dtList <- pbapply::pblapply(
    conll_files,
    function(filename){
      
      # get legislative period and session
      lp <- gsub("^(\\d+)_.*?$", "\\1", filename)
      sessionNo <- gsub("^\\d+_(\\d+)_.*?$", "\\1", filename)
      
      # get party from filename
      party <- gsub("^\\d+_\\d+_([0-9A-Z\u00dc_]+)_.*?$", "\\1", filename)
      if (grepl("^.*NDNIS_90_DIE_.*$", filename)) party <- "B90_DIE_GRUENEN"
      if (grepl("fraktionslos", filename)) party <- "fraktionslos"
      if (party == "F_D_P_") party <- "FDP"
      
      # get speaker from filename
      speakerName <- gsub("^(.*)_\\d+\\.tsv$", "\\1", filename)
      speakerName <- gsub("^\\d+_\\d+_[0-9A-Z\u00dc_]+_(.*?)?$", "\\1", speakerName)
      if (grepl("NEN_", speakerName)) speakerName <- gsub("^.*NEN_", "", speakerName)
      speakerName <- gsub("_", " ", speakerName)
      speakerName <- gsub("^Dr\\s", "", speakerName)
      speakerName <- gsub("\\s+[A-Z]\\s+", " ", speakerName)
      speakerName <- gsub("^-Ing\\s", "", speakerName)
      speakerName <- gsub("^\\s*(.*?)\\s*$", "\\1", speakerName)
      
      # match filename-speaker 
      if (speakerName %in% speakerNames){
        isPresent <- speakerName
      } else {
        matches <- agrep(speakerName, speakerNames)
        if (length(matches) > 0){
          isPresent <- speakerNames[matches[1]]
        } else {
          tmp <- iconv(strsplit(speakerName, split = "")[[1]], from = "UTF-8", to = "ISO-8859-1")
          tmp <- tmp[!is.na(tmp)]
          speakerNameNew <- iconv(paste(tmp, collapse = ""), from = "ISO-8859-1", to = "UTF-8")
          matches <- agrep(speakerNameNew, speakerNames)
          if (length(matches) > 0){
            isPresent <- speakerNames[matches[1]]
          } else {
            splitted <- strsplit(speakerName, " ")[[1]]
            lastName <- splitted[length(splitted)]
            lastTry <- grep(paste(lastName, "$", sep = ""), speakerNames, value = T)
            if (length(lastTry) > 0){
              isPresent <- lastTry[1]
            } else {
              isPresent <- "XXX"
            }
          }
        }
        
      }
      sAttributes <- data.table(
        filename = filename,
        lp = lp,
        session = sessionNo,
        parliamentary_group = party,
        speaker = isPresent
      )
    }
  )
  dt <- rbindlist(dtList)
  dt[["speaker"]] <- enc2utf8(dt[["speaker"]]) # encodings are mixed 
  
  # manual correction of known problems
  dt[dt[["speaker"]] == "Peter Glotz", "speaker" := "Peter G\u00F6tz"]
  dt[dt[["speaker"]] == "Heinrich L. Kolb", "speaker" := "Heinrich Leonhard Kolb"]
  dt[dt[["speaker"]] == "Kersten Naumann", "speaker" := "Kersten Steinke"]
  dt[dt[["speaker"]] == "Sevim Dagdelen", "speaker" := "Sevim Dadelen"]
  
  
  # Get corpus positions
  GPARL <- Corpus$new("GERMAPARL", sAttribute = c("session", "speaker", "lp"))
  CoNLL_objects <- pbapply::pblapply(
    setNames(1L:nrow(dt), dt[["filename"]]),
    function(i){
      P <- partition(
        GPARL,
        def = as.list(unlist(dt[i, c("session", "speaker", "lp")])),
        verbose = FALSE
      )
      if (is.null(P)) return( NULL )
      C <- polmineR.anno::CoNLL$new(filename = file.path(dir, conll_files[i]), partition = P)
      C$getCorpusPositions()
      C
    }
  )
  
  # not used - inspect failed matches
  if (FALSE) View(dt[which(sapply(CoNLL_objects, is.null) == TRUE)])
  
  regions <- rbindlist(lapply(CoNLL_objects, function(x) x[["cpos"]]))
  regions <- regions[is.na(regions[["cpos_left"]]) == FALSE] # check why this is necessary!!
  setnames(regions, old = "id", new = "cap")
  
  
  regions[, "quote" := NULL]
  .aggr <- function(.SD){
    data.table(
      cpos_left = .SD[["cpos_left"]]:.SD[["cpos_right"]],
      cpos_right = .SD[["cpos_left"]]:.SD[["cpos_right"]],
      cap = .SD[["cap"]]
    )
  }
  regionsToken <- regions[, .aggr(.SD), by = seq_len(nrow(regions))]
  regionsToken[, "seq_len" := NULL]
  
  # remove B- and I-
  regionsToken[, "cap2" := ifelse(
    nchar(gsub("^(B|I)-(\\d+)_(\\d+)$", "\\3", regionsToken[["cap"]])) >= 3,
    gsub("^(B|I)-(\\d+)_(\\d+)$", "\\3", regionsToken[["cap"]]),
    gsub("^(B|I)-(\\d+)_(\\d+)$", "\\2", regionsToken[["cap"]])
  )]
  
  regionsToken[, "cap3" := ifelse(
    nchar(regionsToken[["cap2"]]) >= 3,
    gsub("^(\\d+)(\\d{2})$", "\\1-\\2", regionsToken[["cap2"]]),
    regionsToken[["cap2"]]
  )]
  regionsToken[["cap"]] <- regionsToken[["cap3"]]
  regionsToken[, "cap2" := NULL][, "cap3" := NULL]

  .paste <- function(.SD) list(cap = paste(.SD[["cap"]], collapse = "|"))
  regionsToken2 <- regionsToken[, .paste(.SD), by = "cpos_left"]
  regionsToken2[, "cap" := paste("|", regionsToken2[["cap"]], "|", sep = "")]
  regionsToken2[, "cpos_right" := regionsToken2[["cpos_left"]] ]
  setcolorder(regionsToken2, neworder = c("cpos_left", "cpos_right", "cap"))

  germaparl_regdata <- registry_file_parse(corpus = "GERMAPARL", registry_dir = germaparl_regdir())
  germaparl_charset <- germaparl_regdata[["properties"]][["charset"]]
  germaparl_home <- germaparl_regdata[["home"]]
  
  cwbtools::s_attribute_encode(
    values = regionsToken2[["cap"]],
    data_dir = germaparl_home,
    s_attribute = "cap",
    corpus = "GERMAPARL",
    region_matrix = as.matrix(regionsToken2[, c("cpos_left", "cpos_right")]),
    method = "CWB",
    registry_dir = germaparl_regdir(),
    encoding = germaparl_charset
  )
  invisible( NULL )
}

