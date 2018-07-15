#' Query GermaParl
#' 
#'
#' @param cnt XXX
#' @param p_attribute XXX
#' @param min_size XXX
#' @import Matrix
#' @importFrom stats setNames
#' @importFrom slam row_sums
#' @importFrom polmineR as.sparseMatrix
#' @examples 
#' \dontrun{
#' P <- partition("GERMAPARL", cap = "^.*\\|8-01\\|.*$", regex = TRUE)
#' C <- count(P, p_attribute = c("word", "pos"))
#' CNT <- as(C, "count")
#' matches <- query(cnt = CNT, min_size = 250)
#' PB <- partitionBundle("GERMAPARL", sAttribute = "speech", values = names(matches)[1:20])
#' }
#' @export germaparl_search_speeches
germaparl_search_speeches <- function(cnt, p_attribute, min_size = 250){
  if (requireNamespace("qlcMatrix", quietly = TRUE)){
    dtm_file <- system.file(package = "GermaParl", "extdata", "dtm", sprintf("dtm_%s.rds", p_attribute))
    dtm <- readRDS(file = "~/Lab/tmp/dtm.rds") # ~ 3 secs
    
    
    dtm$i <- as.integer(c(dtm$i, rep(x = nrow(dtm) + 1, times = nrow(cnt))))
    dtm$v <- as.integer(c(dtm$v, cnt[["word"]]))
    dtm$j <- as.integer(c(dtm$j, cnt[["word_id"]]))
    dtm$nrow <- as.integer(as.integer(dtm$nrow + 1L))
    dtm$dimnames[[1]] <- c(dtm$dimnames[[1]], "search_vector")
    
    dtm_subset <- if (!is.null(min_size)) dtm[which(row_sums(dtm) >= 250),] else dtm
    dtm_weighed <- weigh(dtm_subset, method = "tfidf")
    M <- t(as.sparseMatrix(dtm_weighed))
    
    query <- setNames(as.vector(dtm_weighed["search_vector",]), colnames(dtm_weighed))
    query <- query[order(query, decreasing = TRUE)]
    
    simMatrix <- qlcMatrix::cosSparse(X = M[, 1L:(ncol(M) - 1L)], Y = Matrix(as.matrix(M[,ncol(M)])))
    simVector <- setNames(simMatrix[,1], rownames(simMatrix))
    simVectorOrdered <- simVector[order(simVector, decreasing = TRUE)]
    return(simVectorOrdered)
  } else {
    stop("package 'qlcMatrix' required but not available")
  }
}
