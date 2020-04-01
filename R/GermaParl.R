#' GermaParl R package.
#' 
#' @author Andreas Blaette (andreas.blaette@@uni-due.de)
#' @keywords package
#' @docType package
#' @aliases GermaParl GermaParl-package
#' @rdname GermaParl-package
#' @name GermaParl-package
#' @examples 
#' \dontrun{
#' library(polmineR)
#' use("GermaParl")
#' corpus() # will include GERMAPARLMINI, sample corpus included in pkg
#' germaparl_download_corpus() # takes time!
#' use("GermaParl")
#' corpus() # will include GERMAPARL, full corpus
#' }
NULL


#' LDA Tuning Results
#' 
#' @name lda_tuning
#' @rdname lda_tuning
#' @aliases lda_tuning
"lda_tuning"


#' Table with information on GermaParl by year
#' 
#' @name germaparl_by_year
#' @rdname germaparl_by_year
#' @examples 
#' \dontrun{
#' dts <- lapply(
#'  13:17,
#'  function(lp){
#'   print(lp)
#'   P <- partition("GERMAPARL", lp = lp)
#'   dates <- as.Date(s_attributes(P, "date"))
#'   dt <- count(P, p_attribute = "lemma")
#'   unknown <- round(sum(dt[grepl("#unknown#", dt[["lemma"]])][["count"]]) / size(P), digits = 3)
#'   
#'   data.table(
#'     lp = lp,
#'     protocols = length(unique(s_attributes(P, "session"))),
#'     first = min(dates, na.rm = TRUE),
#'     last = min(dates, na.rm = TRUE),
#'     size = size(P),
#'     unknown = unknown
#'   )
#' }
#' )
#' germaparl_by_lp <- rbindlist(dts)
#' }
"germaparl_by_year"


#' Table with information on GermaParl by legislative period
#' 
#' @name germaparl_by_lp
#' @rdname germaparl_by_lp
#' @examples 
#' \dontrun{
#' years <- as.integer(s_attributes("GERMAPARL", "year"))
#' dts <- lapply(
#'   min(years):max(years),
#'   function(year){
#'     P <- partition("GERMAPARL", year = as.character(year), verbose = FALSE)
#'     P.txt <- partition(P, src = "txt")
#'     P.pdf <- partition(P, src = "pdf")
#'     dt <- polmineR::count(P, p_attribute = "lemma")
#'     unknowns <- round(sum(dt[grepl("#unknown#", dt[["lemma"]])][["count"]]) / size(P), digits = 3)
#'     data.table(
#'       year = year,
#'       protocols = length(unique(s_attributes(P, "session"))),
#'       txt = length(s_attributes(P.txt, "session")),
#'       pdf = length(s_attributes(P.pdf, "session")),
#'       size = size(P),
#'       unknown = unknowns
#'     )
#'   }
#' )
#' dt1 <- rbindlist(dts)
#' dt2 <- rbind(dt1, t(data.table(colSums(dt1))), use.names = FALSE, fill = FALSE)
#' dt2[["year"]] <- as.character(dt2[["year"]])
#' dt2[nrow(dt2), 1] <- "TOTAL"
#' germaparl_by_year <- dt2
#' }
"germaparl_by_lp"