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
#' @param mc An \code{integer} value, the number of cores to use, passed into the
#'   \code{as.speeches} function
#' @param progress A \code{logical} value, whether to show a progress bar.
#' @return A \code{data.table} with the regions of speeches and speech ids is
#'   returned invisibly.
#' @importFrom data.table data.table setnames setorderv :=
#' @importFrom cwbtools s_attribute_encode registry_file_parse
#' @importFrom polmineR as.speeches use
#' @importFrom utils download.file
#' @importFrom methods slot
#' @export germaparl_add_s_attribute_speech
#' @examples 
#' \dontrun{
#' if (isFALSE(germaparl_is_installed())) germaparl_download_corpus()
#' use("GermaParl")
#' germaparl_add_s_attribute_speech()
#' 
#' library(polmineR)
#' RcppCWB::cl_delete_corpus("GERMAPARL", registry = registry())
#' use("GermaParl")
#' s_attributes("GERMAPARL")
#' s_attributes("GERMAPARL", "speech")
#' sizes <- size("GERMAPARL", s_attribute = "speech")
#' dtm <- as.DocumentTermMatrix("GERMAPARL", p_attribute = "word", s_attribute = "speech")
#' } 
germaparl_add_s_attribute_speech <- function(mc = 1L, progress = TRUE){
  speeches <- as.speeches(
    "GERMAPARL", gap = 500, mc = mc, progress = progress,
    s_attribute_date = "date", s_attribute_name = "speaker"
  )
  dt <- data.table(do.call(rbind, lapply(speeches@objects, slot, "cpos")))
  setnames(dt, old = c("V1", "V2"), new = c("cpos_left", "cpos_right"))
  dt[, "speech" := do.call(c, Map(rep, names(speeches), sapply(speeches@objects, function(x) nrow(x@cpos))))]
  setorderv(dt, cols = "cpos_left", order = 1L)
  regdir <- system.file(package = "GermaParl", "extdata", "cwb", "registry")
  s_attribute_encode(
    values = dt[["speech"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = system.file(package = "GermaParl", "extdata", "cwb", "indexed_corpora", "germaparl"),
    s_attribute = "speech",
    corpus = "GERMAPARL",
    region_matrix = as.matrix(dt[, c("cpos_left", "cpos_right")]),
    registry_dir = system.file(package = "GermaParl", "extdata", "cwb", "registry"),
    encoding = registry_file_parse(corpus = "GERMAPARL", registry_dir = regdir)[["properties"]][["charset"]],
    method = "R",
    verbose = TRUE,
    delete = FALSE
  )
  invisible(dt)
}
