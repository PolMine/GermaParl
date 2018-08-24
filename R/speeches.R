#' Add Annotation of Speeches to GermaParl Corpus
#' 
#' The basic text unit in the GermaParl corpus are units of uninterrupted
#' speech. Speeches are interrupted by interjections, remarks of the presidency,
#' and questions from the Bundestag plenary. The heuristic of the
#' \code{as.speeches}-function from the \code{polmineR} package can be used to
#' generate partitions of speeches. This function will call \code{as.speeches}
#' and write back the finding as a structural attribute to the indexed GermaParl
#' corpus.
#' 
#' The \code{as.speeches}-function may consume several minutes. For writing the
#' structural attribute, the \code{s_attribute_encode} from the \code{cwbtools}
#' package is used.
#' 
#' @param mc An integer value, the number of cores to use, passed into the \code{as.speeches} function
#' @param progress Logical, whether to indicate progress by showing a progress bar.
#' @return A \code{NULL} value is returned invisibly.
#' @importFrom data.table data.table rbindlist setnames setorderv
#' @importFrom cwbtools s_attribute_encode registry_file_parse
#' @importFrom polmineR as.speeches use
#' @importFrom utils download.file
#' @export germaparl_add_s_attribute_speech
germaparl_add_s_attribute_speech <- function(mc = 1L, progress = TRUE){
  speeches <- as.speeches(
    "GERMAPARL", gap = 500, mc = mc, progress = progress,
    s_attribute_date = "date", s_attribute_name = "speaker"
  )
  regions_list <- lapply(
    speeches@objects,
    function(x){
      dt <- data.table(x@cpos)
      dt[["speech"]] <- x@name
      dt
    }
  )
  dt <- data.table::rbindlist(regions_list)
  setnames(dt, old = c("V1", "V2"), new = c("cpos_left", "cpos_right"))
  dt[, "cpos_left" := as.integer(dt[["cpos_left"]]) ]
  dt[, "cpos_right" := as.integer(dt[["cpos_right"]]) ]
  setorderv(dt, cols = "cpos_left", order = 1L)
  corpus_charset <- registry_file_parse(corpus = "GERMAPARL")[["properties"]][["charset"]]
  germaparl_data_dir <- registry_file_parse(corpus = "GERMAPARL")[["home"]]
  s_attribute_encode(
    values = dt[["speech"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = germaparl_data_dir,
    s_attribute = "speech",
    corpus = "GERMAPARL",
    region_matrix = as.matrix(dt[, c("cpos_left", "cpos_right")]),
    registry_dir = germaparl_regdir(),
    encoding = corpus_charset,
    method = "CWB",
    verbose = TRUE
    )
  
  invisible(dt)
}
