#' GermaParl R Data Package.
#' 
#' The package offers a convenient dissemination mechanism for the GermaParl
#' corpus. It has been linguistically annotated and indexed (data format of the
#' Corpus Workbench / CWB). After installation, only a small sample corpus will
#' be included in the package. Use the \code{germaparl_download_corpus} function
#' to download the full corpus. The package offers further functionality to
#' amend the corpus.
#' 
#' The GermaParl R package and the GermaParl corpus are two different kinds of
#' research data: The package offers a mechanism to ship, easily install and
#' augment the data. The indexed corpus is the actual data. Package and corpus
#' have different version numbers and should be quoted in combination in
#' publications. We recommend to follow the instructions you see when calling
#' \code{citation(package = "GermaParl")}.
#' 
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
#' \donttest{
#' cwb_dirs <- cwbtools::create_cwb_directories(prefix = tempdir(), ask = interactive())
#' registry_tmp <- cwb_dirs[["registry_dir"]]
#' germaparl_download_corpus(registry_dir = registry_tmp)
#' 
#' library(polmineR)
#' corpus() # should include GERMAPARLMINI as well as GERMAPARL
#' count("GERMAPARL", "Daten") # an arbitrary test
#' 
#' germaparl_is_installed() # TRUE now
#' germaparl_get_version()
#' germaparl_get_doi() # get 'document object identifier' (DOI) of GERMAPARL corpus
#' 
#' # Removing the internal C representation and reloading corpora defined in the
#' # registry is necessary to make the amendments to the corpus available
#' germaparl_add_s_attribute_speech(registry_dir = registry_tmp)
#' file.copy(
#'   from = file.path(registry_tmp, "germaparl"),
#'   to = file.path(registry(), "germaparl"),
#'   overwrite = TRUE
#' )
#' RcppCWB::cl_delete_corpus("GERMAPARL", registry = registry())
#' polmineR::registry_reset()
#' 
#' s_attributes("GERMAPARL")
#' s_attributes("GERMAPARL", "speech")
#' sizes <- size("GERMAPARL", s_attribute = "speech")
#' dtm <- as.DocumentTermMatrix("GERMAPARL", p_attribute = "word", s_attribute = "speech")
#' 
#' germaparl_download_lda(k = 250)
#' lda <- germaparl_load_topicmodel(k = 250)
#' lda_terms <- topicmodels::terms(lda, 50)
#' 
#' germaparl_encode_lda_topics(
#'   k = 250, n = 5,
#'   registry_dir = cwb_dirs[["registry_dir"]],
#'   data_dir = file.path(cwb_dirs[["corpus_dir"]], "germaparl")
#' )
#' 
#' # make amended corpus available
#' file.copy(
#'   from = file.path(registry_tmp, "germaparl"),
#'   to = file.path(registry(), "germaparl"),
#'   overwrite = TRUE
#' )
#' count("GERMAPARL", "Integration")
#' RcppCWB::cl_delete_corpus("GERMAPARL")
#' polmineR::registry_reset()
#' 
#' s_attributes("GERMAPARL")
#' sc <- corpus("GERMAPARL") %>%
#'   subset(grep("\\|133\\|", topics))
#' b <- as.speeches(sc, s_attribute_name = "speaker")
#' length(b)
#' }
NULL


#' Get installation status of GERMAPARL
#' 
#' @param registry_dir Path to the registry directory.
#' Auxiliary function to detect whether GERMAPARL is installed or not.
#' @return \code{TRUE} if the corpus has been installed, and \code{FALSE} if not.
#' @export germaparl_is_installed
#' @examples 
#' germaparl_is_installed() # to check whether GERMAPARL has been downloaded
germaparl_is_installed <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY")){
  "germaparl" %in% list.files(registry_dir)
}


#' Get DOI of corpus
#' 
#' @param registry_dir Path to the registry directory.
#' @details Auxiliary function that extracts the DOI (Document Object
#'   Identifier) from the registry file of the GERMAPARL corpus.
#' @return If the DOI is declared in the registry file, a length-one
#'   \code{character} vector with it is returned. If the corpus has not yet been
#'   installed, \code{NULL} is returned and a warning will be issued.
#' @export germaparl_get_doi
germaparl_get_doi <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY")){
  if (isFALSE(germaparl_is_installed())){
    warning("Cannot get DOI for corpus GERMAPARL: Corpus has not yet been installed.")
    return(NULL)
  }
  regdata <- registry_file_parse(corpus = "GERMAPARL", registry_dir = registry_dir)
  regdata[["properties"]][["doi"]]
}


#' Get GERMAPARL version
#' 
#' 
#' @details \code{germaparl_get_version} is an auxiliary function that extracts
#'   the version of the GERMAPARL corpus from the registry. 
#'   
#' @param registry_dir Path to the registry directory.
#' @return The return value is the version of the corpus (class
#'   \code{numeric_version}). If the corpus has not yet been installed,
#'   \code{NULL} is returned, and a warning message is issued.
#' @export germaparl_get_version
germaparl_get_version <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY")){
  if (isFALSE(germaparl_is_installed())){
    warning("Cannot get GERMAPARL version: Corpus has not yet been installed.")
    return(NULL)
  }
  regdata <- registry_file_parse(corpus = "GERMAPARL", registry_dir = registry_dir)
  version <- regdata[["properties"]][["version"]]
  version <- gsub("^(v|)(\\d+\\.\\d+\\.\\d+)", "\\2", version)
  as.numeric_version(version)
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
#' Note that the table is based on v1.0.5 of the corpus. The script to reproduce
#' the table can be found in the file
#' \url{https://github.com/PolMine/GermaParl/blob/master/data-raw/stats_for_vignette.R}{data-raw/stats_for_vignette.R}.
#' @name germaparl_by_year
#' @rdname germaparl_by_year
"germaparl_by_year"


#' Table with information on GermaParl by legislative period
#' 
#' A dataset with information on the corpus on a year-by-year basis is included
#' in the package to be included in the data report of the package vignette. The 
#' code used to generate the data is reported in the examples section.
#' 
#' Note that the table is based on v1.0.5 of the corpus. The script to reproduce
#' the table can be found in the file
#' \url{https://github.com/PolMine/GermaParl/blob/master/data-raw/stats_for_vignette.R}{data-raw/stats_for_vignette.R}.
#' @name germaparl_by_lp
#' @rdname germaparl_by_lp
"germaparl_by_lp"