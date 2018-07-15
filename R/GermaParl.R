#' GermaParl Corpus Class.
#' 
#' The class inherits from the \code{Corpus} class defined in the 
#' package 'polmineR'. So far, it only adds a method 'summary'.
#' 
#' @importFrom R6 R6Class
#' @importFrom data.table data.table setcolorder rbindlist
#' @importFrom polmineR enrich Corpus features html highlight getTokenStream as.nativeEnc getEncoding weigh as.sparseMatrix read 
#' 
#' @section Methods:
#' \describe{
#'   \item{\code{summary(sAttribute)}}{Get number of tokens in subcorpora
#'   that are prepared on the basis of the s-attribute provided.}
#' }
#' @examples
#' \dontrun{
#'   germaparl_download_corpus()
#'   germaparl_download_lda(k = 250L)
#'   germaparl_add_s_attribute_speech()
#'   germaparl_encode_lda_topics(k = 250L, n = 5L)
#'   germaparl_encode_cap_annotations()
#'   germaparl_build_dtm()
#' }
#' @export GermaParl
#' @rdname GermaParl
#' @name GermaParl
GermaParl <- R6Class(
  
  classname = "GermaParl",
  inherit = polmineR::Corpus,
  
  public = list(
    
    initialize = function(corpus = "GERMAPARL", pAttribute = NULL){
      super$initialize(corpus = corpus, pAttribute = pAttribute)
    },
    
    summary = function(sAttribute){
      values <- sAttributes("GERMAPARL", sAttribute)
      dts <- lapply(
        values,
        function(value){
          P <- partition("GERMAPARL", def = as.list(setNames(value, sAttribute)), verbose = FALSE)
          dt <- data.table(size = size(P))
          dt[[sAttribute]] <- value
          setcolorder(dt, neworder = c(sAttribute, "size"))
          dt
        }
      )
      dts
      rbindlist(dts)
    }
  )
)


#' LDA Tuning Resulty
#' @name lda_tuning
#' @rdname lda_tuning
#' @aliases lda_tuning
"lda_tuning"

