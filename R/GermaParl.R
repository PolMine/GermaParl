#' GermaParl R Data Package.
#' 
#' \emph{GermaParl} is  a corpus of parliamentary debates in the German
#' Bundestag. The package offers a convenient dissemination mechanism for the
#' \emph{GermaParl} corpus.  The corpus has been linguistically annotated and
#' indexed using the data format of the \emph{Corpus Workbench} (CWB). To make
#' full use if this data format, working with \emph{GermaParl} in combination
#' with the \emph{polmineR} package is recommended. After installation, only a
#' small sample corpus will be included in the package ("GERMAPARLMINI"). To
#' download the full corpus from the open science repository \emph{Zenodo}, use
#' the \code{germaparl_download_corpus} function. The package offers further
#' functionality to augment the corpus (see the the examples section below).
#' 
#' The \emph{GermaParl} R package and the \emph{GermaParl} corpus are two
#' different pieces of research data: The package offers a mechanism to ship,
#' easily install and augment the data. The indexed corpus is the actual data.
#' Package and corpus have different version numbers and should be quoted in
#' combination in publications. We recommend to follow the instructions you see
#' when calling \code{citation(package = "GermaParl")}. To ensure that the
#' recommended citation fits the corpus you use, the citation for the corpus is
#' available only when a version of \emph{GermaParl} has been downloaded and
#' installed.
#' 
#' @references Blaette, Andreas (2018): "Using Data Packages to Ship Annotated
#'   Corpora of Parliamentary Protocols: The GermaParl R Package". ISBN
#'   979-10-95546-02-3. Available online at
#'   \url{http://lrec-conf.org/workshops/lrec2018/W2/pdf/15_W2.pdf}.
#' @author Andreas Blaette \email{andreas.blaette@@uni-due.de}
#' @keywords package
#' @docType package
#' @aliases GermaParl GermaParl-package
#' @rdname GermaParl-package
#' @name GermaParl-package
#' @examples 
#' \donttest{
#' # This example assumes that the directories used by the CWB do not yet exist, so
#' # temporary directories are created.
#' cwb_dirs <- cwbtools::create_cwb_directories(prefix = tempdir(), ask = interactive())
#' registry_tmp <- cwb_dirs[["registry_dir"]]
#' 
#' # Download corpus from Zenodo
#' germaparl_download_corpus(registry_dir = registry_tmp)
#' 
#' # Check availability of the corpus
#' library(polmineR)
#' corpus() # should include GERMAPARLMINI as well as GERMAPARL
#' count("GERMAPARL", "Daten") # an arbitrary test
#' germaparl_is_installed() # TRUE now
#' germaparl_get_version() # get version of indexed corpus
#' germaparl_get_doi() # get 'document object identifier' (DOI) of GERMAPARL corpus
#' 
#' # Encode structural attribute 'speech'
#' germaparl_encode_speeches(
#'   registry_dir = cwb_dirs[["registry_dir"]],
#'   corpus_dir = cwb_dirs[["corpus_dir"]]
#' )
#' 
#' # Check whether the new attribute is available 
#' s_attributes("GERMAPARL")
#' values <- s_attributes("GERMAPARL", "speech")
#' sizes <- size("GERMAPARL", s_attribute = "speech")
#' dtm <- as.DocumentTermMatrix("GERMAPARL", p_attribute = "word", s_attribute = "speech")
#' 
#' # Download topic model (k = 250)
#' germaparl_download_lda(k = 250, data_dir = file.path(cwb_dirs[["corpus_dir"]]))
#' lda <- germaparl_load_topicmodel(k = 250)
#' lda_terms <- topicmodels::terms(lda, 50)
#' 
#' # Encode topic model classification of speeches
#' germaparl_encode_lda_topics(
#'   k = 250, n = 5,
#'   registry_dir = cwb_dirs[["registry_dir"]],
#'   data_dir = file.path(cwb_dirs[["corpus_dir"]], "germaparl")
#' )
#' 
#' # Check whether the newly encoded attribute 'topics' is available
#' s_attributes("GERMAPARL")
#' sc <- corpus("GERMAPARL") %>%
#'   subset(grep("\\|133\\|", topics))
#' b <- as.speeches(sc, s_attribute_name = "speaker")
#' length(b)
#' }
"_PACKAGE"


#' Get installation status of GERMAPARL
#' 
#' Auxiliary function to detect whether GERMAPARL is installed or not.
#' @param registry_dir Path to the registry directory.
#' @seealso See the examples section of the overview documentation of the
#'   \link{GermaParl} package for an example.
#' @return \code{TRUE} if the corpus has been installed, and \code{FALSE} if not.
#' @export germaparl_is_installed
#' @examples 
#' germaparl_is_installed() # to check whether GERMAPARL has been downloaded
germaparl_is_installed <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY")){
  "germaparl" %in% list.files(registry_dir)
}


#' Get DOI of corpus
#' 
#' Auxiliary function that extracts the DOI (Document Object Identifier) from
#' the registry file of the GERMAPARL corpus.
#' 
#' @param registry_dir Path to the registry directory.
#' @seealso See the examples section of the overview documentation of the
#'   \link{GermaParl} package for an example.
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
#' \code{germaparl_get_version} is an auxiliary function that extracts
#'   the version of the GERMAPARL corpus from the registry. 
#'   
#' @param registry_dir Path to the registry directory.
#' @seealso See the examples section of the overview documentation of the
#'   \link{GermaParl} package for an example.
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

#' Unload and relaod GERMAPARL corpus
#' 
#' After adding attributes to the corpus, new annotations will not be available
#' until the internal C representation of the corpus is deleted and reloaded.
#' The function is used internally by functions adding s-attributes to the
#' corpus. It is exported and documented as a matter of transparency.
#' 
#' The function ensures that a modified/updated registry file will be copied 
#' from the system registry directory (directory where registry files are
#' stored permanently) to the temporary registry directory used by polmineR.
#' 
#' @param session_registry_dir The temporary session registry directory created
#'   and used by the polmineR package.
#' @param system_registry_dir The non-temporary system registry directory.
germaparl_refresh <- function(session_registry_dir = polmineR::registry(), system_registry_dir = getOption("polmineR.corpus_registry")){
  file.copy(
    from = file.path(system_registry_dir, "germaparl"),
    to = file.path(session_registry_dir, "germaparl"),
    overwrite = TRUE
  )
  # RcppCWB_cl_delete_corpus will crash if the corpus has not been used before (missing C representation of
  # the corpus). A minimal corpus query - RcppCWB::cl_cpos2id() - is necessary to avoid the crash
  RcppCWB::cl_cpos2id(corpus = "GERMAPARL", p_attribute = "word", cpos = 0L, registry = session_registry_dir)
  RcppCWB::cl_delete_corpus("GERMAPARL", registry = session_registry_dir)
  polmineR::registry_reset()
}


#' LDA Tuning Results
#' 
#' The R package \href{https://CRAN.R-project.org/package=ldatuning}{ldatuning}
#' has been used to get guidance on the optimal number of topics when fitting an
#' LDA topic model on the GermaParl corpus. Using around 250 topics is a good
#' choice. The data object \code{germaparl_lda_tuning} reports the different metrics of the
#' ldatuning package.
#' 
#' @name germaparl_lda_tuning
#' @rdname germaparl_lda_tuning
#' @aliases germaparl_lda_tuning
"germaparl_lda_tuning"


#' Table with information on GermaParl by year
#' 
#' A dataset with information on the corpus on a year-by-year basis is included
#' in the package to be included in the data report of the package vignette.
#' 
#' The table is based on v1.0.5 of the corpus. The prepare the table, the script
#' available at
#' \href{https://github.com/PolMine/GermaParl/blob/master/data-raw/stats_for_vignette.R}{data-raw/stats_for_vignette.R}
#' has been used.
#' @name germaparl_by_year
#' @rdname germaparl_by_year
"germaparl_by_year"


#' Table with information on GermaParl by legislative period
#' 
#' A dataset with information on the corpus by legislative period is included
#' in the package to be included in the data report of the package vignette.
#' 
#' The table is based on v1.0.5 of the corpus. To prepare the table, the script
#' available at
#' \href{https://github.com/PolMine/GermaParl/blob/master/data-raw/stats_for_vignette.R}{data-raw/stats_for_vignette.R}
#' has been used.
#' @name germaparl_by_lp
#' @rdname germaparl_by_lp
"germaparl_by_lp"