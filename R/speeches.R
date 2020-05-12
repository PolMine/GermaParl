#' @include GermaParl.R
NULL

#' Add Annotation of Speeches to GermaParl Corpus
#' 
#' The basic text unit in the \emph{GermaParl} corpus are units of uninterrupted
#' speech. Speeches are interrupted by interjections, remarks of the presidency,
#' and questions from the Bundestag plenary. The heuristic of the
#' \code{as.speeches}-function from the \code{polmineR} package can be used to
#' generate subcorpora with speeches. This function will call \code{as.speeches}
#' and write back the finding as a structural attribute to the indexed
#' \emph{GermaParl} corpus.
#' 
#' For encoding the structural attribute, the \code{s_attribute_encode} from the
#' \code{cwbtools} package is used.
#' 
#' @param mc An \code{integer} value, the number of cores to use, passed into the
#'   \code{as.speeches} function.
#' @param progress A \code{logical} value, whether to show a progress bar.
#' @param registry_dir The registry directory where the registry file for the
#'   GERMAPARL corpus resides. By default, the function
#'   \code{cwbtools::cwb_registry_dir} is used to guess the registry directory.
#'   We recommend to state the registry directory explicitly.
#' @param corpus_dir The directory where CWB data_directories reside.
#' @param sample A \code{logical} value, if \code{FALSE}, enrich "GERMAPARL",
#'   enrich "GERMAPARLSAMPLE" if \code{TRUE}.
#' @seealso The workflow to add an annotation of speeches is part of the
#'   examples section of the overview documentation of the \link{GermaParl}
#'   package.
#' @return A \code{data.table} with the regions of speeches and speech ids is
#'   returned invisibly. The function is usually called for its side
#'   effects, i.e. adding the structural annotation of speeches to the corpus.
#' @importFrom data.table data.table setnames setorderv :=
#' @importFrom cwbtools s_attribute_encode registry_file_parse cwb_corpus_dir
#'   cwb_directories
#' @importFrom polmineR as.speeches use registry
#' @importFrom utils download.file
#' @importFrom methods slot
#' @importFrom RcppCWB cqp_is_initialized cqp_get_registry
#' @export germaparl_encode_speeches
germaparl_encode_speeches <- function(mc = 1L, progress = TRUE, registry_dir = cwbtools::cwb_registry_dir(), corpus_dir = NULL, sample = FALSE){
  corpus_id <- if (isTRUE(sample)) "GERMAPARLSAMPLE" else "GERMAPARL"
  speeches <- as.speeches(
    corpus_id, gap = 500, mc = mc, progress = progress,
    s_attribute_date = "date", s_attribute_name = "speaker"
  )
  dt <- data.table(do.call(rbind, lapply(speeches@objects, slot, "cpos")))
  setnames(dt, old = c("V1", "V2"), new = c("cpos_left", "cpos_right"))
  dt[, "speech" := do.call(c, Map(rep, names(speeches), sapply(speeches@objects, function(x) nrow(x@cpos))))]
  setorderv(dt, cols = "cpos_left", order = 1L)
  
  cwb_dirs <- cwb_directories(registry_dir = registry_dir, corpus_dir = corpus_dir)
  
  s_attribute_encode(
    values = dt[["speech"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = file.path(cwb_dirs[["corpus_dir"]], tolower(corpus_id)),
    s_attribute = "speech",
    corpus = corpus_id,
    region_matrix = as.matrix(dt[, c("cpos_left", "cpos_right")]),
    registry_dir = cwb_dirs[["registry_dir"]],
    encoding = registry_file_parse(corpus = corpus_id, registry_dir = cwb_dirs[["registry_dir"]])[["properties"]][["charset"]],
    method = "R",
    verbose = TRUE,
    delete = FALSE
  )
  
  if (isNamespaceLoaded("polmineR")){
    germaparl_refresh(
      system_registry_dir = cwb_dirs[["registry_dir"]],
      session_registry_dir = registry(),
      sample = sample
    )
  }

  invisible(dt)
}
