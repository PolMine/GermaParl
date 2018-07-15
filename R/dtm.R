#' Generate Document-Term-Matrix
#' 
#' Generate a document-term-matrix from the GermaParl corpus. Speeches will
#' be treated as documents. The function requires the annotation of speeches
#' to be present, see \code{germaparl_add_s_attribute_speech}.
#' @param pAttribute The p-attribute for wich to generate the matrix.
#' @param store Logical, if \code{TRUE} (default), the dtm will be stored in the package.
#' @importFrom polmineR as.DocumentTermMatrix
#' @export germaparl_build_dtm
germaparl_build_dtm <- function(pAttribute = "word", store = TRUE){
  
  stopifnot(length(pAttribute) == 1)
  
  dtm <- as.DocumentTermMatrix("GERMAPARL", pAttribute = pAttribute, sAttribute = "speech")
  
  if (store){
    dtm_dir <- system.file(package = "GermaParl", "extdata", "dtm")
    if (dtm_dir == ""){
      dtm_dir <- file.path(system.file(package = "GermaParl", "extdata"), "dtm")
      dir.create(dtm_dir)
    }
    saveRDS(dtm, file = file.path(dtm_dir, sprintf("dtm_%s.rds", pAttribute)))
  }
  invisible(dtm)
}



