#' GermaParl R Data Package.
#' 
#' The package offers a convenient dissemination mechanism for the 
#' GermaParl corpus that has been linguistically annotated and indexed (data format
#' of the Corpus Workbench / CWB). After installation, only a small sample corpus
#' will be included in the package. Use the \code{germaparl_download_corpus} function
#' to download the full corpus. The package offers further functionality to amend 
#' the corpus.
#' 
#' Note that the R package and the corpus are two different kinds of research
#' data: The package offers a mechanism to ship, easily install and augment the data.
#' The indexed corpus is the actual data. Package and corpus have different version
#' numbers and should be quoted in combination in publications. We recommend to follow 
#' the instructions you see when calling \code{citation(package = "GermaParl")}.
#' 
#' @param registry_dir Path to the system registry directory.
#' @references Blaette, Andreas (2018): "Using Data Packages to Ship Annotated
#'   Corpora of Parliamentary Protocols: The GermaParl R Package". ISBN
#'   979-10-95546-02-3.
#' @author Andreas Blaette \email{andreas.blaette@@uni-due.de}
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
#' if (!germaparl_is_installed()) germaparl_download_corpus() # ~1 GB, takes time ...
#' use("GermaParl")
#' corpus() # will include GERMAPARL, full corpus
#' }
NULL


#' @details \code{germaparl_is_installed} is an auxiliary function that returns \code{TRUE}
#'   if the corpus has been installed, and \code{FALSE} if not.
#' @rdname GermaParl-package
#' @export germaparl_is_installed
#' @examples 
#' germaparl_is_installed() # to check whether GERMAPARL has been downloaded
germaparl_is_installed <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY")){
  "germaparl" %in% list.files(registry_dir)
}


#' @details \code{germaparl_get_doi} is an auxiliary function that extracts the DOI
#'   (Document Object Identifier) from the registry file of the GERMAPARL corpus. If
#'   the corpus has not yet been installed, \code{NULL} is returned and a warning 
#'   will be issued.
#' @rdname GermaParl-package
#' @export germaparl_get_doi
#' @examples
#' germaparl_get_doi() # get 'document object identifier' (DOI) of GERMAPARL corpus
germaparl_get_doi <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY")){
  if (isFALSE(germaparl_is_installed())){
    warning("Cannot get DOI for corpus GERMAPARL: Corpus has not yet been installed.")
    return(NULL)
  }
  regdata <- registry_file_parse(corpus = "GERMAPARL", registry_dir = registry_dir)
  regdata[["properties"]][["doi"]]
}


#' @details \code{germaparl_get_version} is an auxiliary function that extracts the 
#'   version of the GERMAPARL corpus from the registry file. If the corpus has not
#'   yet been installed, \code{NULL} is returned, and a warning message is issued.
#' @rdname GermaParl-package
#' @export germaparl_get_version
#' @examples
#' germaparl_get_version
germaparl_get_version <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY")){
  if (isFALSE(germaparl_is_installed())){
    warning("Cannot get GERMAPARL version: Corpus has not yet been installed.")
    return(NULL)
  }
  regdata <- registry_file_parse(corpus = "GERMAPARL", registry_dir = registry_dir)
  regdata[["properties"]][["version"]]
}


#' LDA Tuning Results
#' 
#' The R package \href{https://CRAN.R-project.org/package=ldatuning}{ldatuning}
#' has been used to get guidance on the optimal number of topics when fitting an
#' LDA topic model on the GermaParl corpus. Using around 250 topics is a good
#' choice. The data object \code{lda_tuning} reports the different metrics of the
#' ldatuning package.
#' 
#' @name lda_tuning
#' @rdname lda_tuning
#' @aliases lda_tuning
"lda_tuning"


#' Table with information on GermaParl by year
#' 
#' A dataset with information on the corpus on a year-by-year basis is included
#' in the package to be included in the data report of the package vignette. The 
#' code used to generate the data is reported in the examples section.
#' 
#' Note that the table is based on v1.0.5 of the corpus.
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
#' A dataset with information on the corpus on a year-by-year basis is included
#' in the package to be included in the data report of the package vignette. The 
#' code used to generate the data is reported in the examples section.
#' 
#' Note that the table is based on v1.0.5 of the corpus.
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