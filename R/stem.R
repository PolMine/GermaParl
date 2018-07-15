#' Add Positional Attribute with Word Stems to GermaParl
#' @param verbose Logical, whether to output messages.
#' @return Invisibly \code{NULL} is returned.
#' @importFrom cwbtools p_attribute_encode
#' @export germaparl_add_p_attribute_stem
germaparl_add_p_attribute_stem <- function(verbose = TRUE){
  if (requireNamespace("SnowballC", quietly = TRUE)){
    if (verbose) message("... decoding token stream for p-attribute 'word'")
    words <- getTokenStream("GERMAPARL", pAttribute = "word")
    if (verbose) message("... adjusting encoding")
    words <- as.nativeEnc(words, from = getEncoding("GERMAPARL"))
    if (verbose) message("... stemming")
    stems <- SnowballC::wordStem(words, language = "german")
    rm(words); gc()
    germaparl_regdir = system.file(package = "GermaParl", "extdata", "cwb", "registry")
    germaparl_regdata <- registry_file_parse(corpus = "GERMAPARL", registry_dir = germaparl_regdir)
    germaparl_charset <- germaparl_regdata[["properties"]][["charset"]]
    germaparl_data_dir <- germaparl_regdata[["home"]]
    p_attribute_encode(
      token_stream = stems,
      p_attribute = "word",
      registry_dir = germaparl_regdir,
      corpus = "GERMAPARL",
      data_dir = germaparl_data_dir,
      method = "CWB",
      verbose = TRUE,
      encoding = germaparl_charset,
      compress = TRUE
    )
    return(invisible(NULL))
  } else { 
    stop("package 'SnowballC' required but not available")
  }
}
