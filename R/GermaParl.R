#' GermaParl R Data Package.
#' 
#' \emph{GermaParl} is  a corpus of parliamentary debates in the German
#' Bundestag. The package offers a convenient dissemination mechanism for the
#' \emph{GermaParl} corpus. The corpus has been linguistically annotated and
#' indexed using the data format of the \emph{Corpus Workbench} (CWB). To make
#' full use if this data format, working with \emph{GermaParl} in combination
#' with the \emph{polmineR} package is recommended. 
#' 
#' The GermaParl package initially only includes  a subset of the GermaParl
#' corpus which serves as a sample corpus ("GERMAPARLMINI"). To download the
#' full corpus from the open science repository \emph{Zenodo}, use the
#' \code{germaparl_download_corpus} function.
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
#' # This example uses the GERMAPARLSAMPLE corpus rather than the full GERMAPARL
#' # corpus in order to reduce the time required for testing the code. To apply
#' # everything on GERMAPARL rather than GERMAPARLSAMPLE, set variable 'samplemode' 
#' # to FALSE, or simply omit argument 'sample'.
#' 
#' samplemode <- TRUE
#' corpus_id <- "GERMAPARLSAMPLE" # to get full corpus: corpus_id <- "GERMAPARL"
#' 
#' # This example assumes that the directories used by the CWB do not yet exist, so
#' # temporary directories are created.
#' cwb_dirs <- cwbtools::create_cwb_directories(prefix = tempdir(), ask = interactive())
#' registry_tmp <- cwb_dirs[["registry_dir"]]
#' 
#' # Download corpus from Zenodo
#' germaparl_download_corpus(
#'   registry_dir = registry_tmp,
#'   corpus_dir = cwb_dirs[["corpus_dir"]],
#'   verbose = FALSE,
#'   sample = samplemode
#' )
#' 
#' # Check availability of the corpus
#' germaparl_is_installed(sample = samplemode) # TRUE now
#' germaparl_get_version(sample = samplemode) # get version of indexed corpus
#' germaparl_get_doi(sample = samplemode) # get 'document object identifier' (DOI) of GERMAPARL corpus
"_PACKAGE"


#' Get installation status of GERMAPARL
#' 
#' Auxiliary function to detect whether GERMAPARL is installed or not.
#' @param registry_dir Path to the registry directory.
#' @param sample A \code{logical} value. If \code{FALSE} (default), the
#'   GERMAPARL corpus will be used, if \code{TRUE}, the GERMAPARLSAMPLE corpus
#'   will be used.
#' @seealso See the examples section of the overview documentation of the
#'   \link{GermaParl} package for an example.
#' @return \code{TRUE} if the corpus has been installed, and \code{FALSE} if not.
#' @export germaparl_is_installed
germaparl_is_installed <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY"), sample = FALSE){
  corpus_id <- if (isFALSE(sample)) "GERMAPARL" else "GERMAPARLSAMPLE"
  tolower(corpus_id) %in% list.files(registry_dir)
}


#' Get DOI of corpus
#' 
#' Auxiliary function that extracts the DOI (Document Object Identifier) from
#' the registry file of the GERMAPARL corpus.
#' 
#' @param registry_dir Path to the registry directory.
#' @param sample A \code{logical} value, if \code{FALSE} (default), use
#'   GERMAPARL, if \code{TRUE}, use GERMAPARLSAMPLE.
#' @seealso See the examples section of the overview documentation of the
#'   \link{GermaParl} package for an example.
#' @return If the DOI is declared in the registry file, a length-one
#'   \code{character} vector with it is returned. If the corpus has not yet been
#'   installed, \code{NULL} is returned and a warning will be issued.
#' @export germaparl_get_doi
germaparl_get_doi <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY"), sample = FALSE){
  corpus_id <- if (isFALSE(sample)) "GERMAPARL" else "GERMAPARLSAMPLE"
  if (isFALSE(germaparl_is_installed(sample = sample))){
    warning("Cannot get DOI for corpus GERMAPARL: Corpus has not yet been installed.")
    return(NULL)
  }
  regdata <- registry_file_parse(corpus = corpus_id, registry_dir = registry_dir)
  regdata[["properties"]][["doi"]]
}


#' Get GERMAPARL version
#' 
#' 
#' \code{germaparl_get_version} is an auxiliary function that extracts
#'   the version of the GERMAPARL corpus from the registry. 
#'   
#' @param registry_dir Path to the registry directory.
#' @param sample If \code{TRUE}, work with GERMAPARLSAMPLE corpus, if
#'   \code{FALSE} (default), use GERMAPARL corpus.
#' @seealso See the examples section of the overview documentation of the
#'   \link{GermaParl} package for an example.
#' @return The return value is the version of the corpus (class
#'   \code{numeric_version}). If the corpus has not yet been installed,
#'   \code{NULL} is returned, and a warning message is issued.
#' @export germaparl_get_version
germaparl_get_version <- function(registry_dir = Sys.getenv("CORPUS_REGISTRY"), sample = FALSE){
  corpus_id <- if (isFALSE(sample)) "GERMAPARL" else "GERMAPARLSAMPLE"
  if (isFALSE(germaparl_is_installed(sample = sample))){
    warning("Cannot get GERMAPARL version: Corpus has not yet been installed.")
    return(NULL)
  }
  regdata <- registry_file_parse(corpus = corpus_id, registry_dir = registry_dir)
  version <- regdata[["properties"]][["version"]]
  version <- gsub("^(v|)(\\d+\\.\\d+\\.\\d+)", "\\2", version)
  as.numeric_version(version)
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
#' The table is based on v1.0.6 of the corpus. The prepare the table, the script
#' available at
#' \href{https://github.com/PolMine/GermaParl/blob/master/data-raw/stats_for_vignette.R}{data-raw/stats_for_vignette.R}
#' has been used.
#' @format A \code{data.frame} with 22 rows and 6 variables with summary
#'   statistics on the GermaParl corpus on a year-by-year basis.
#' \describe{
#'   \item{year}{year reported on in the row (\code{integer} value)}
#'   \item{protocols}{total number of protocols included in the corpus for the
#'   respective year (\code{integer} value)}
#'   \item{txt}{number of protocols prepared based on plain text versions of the
#'   protocols (\code{integer} value)}
#'   \item{pdf}{number of protocols prepared based on pdf versions of the
#'   protocols (\code{integer} value)}
#'   \item{size}{number of tokens in subcorpus for the respective year
#'   (\code{integer} value)}
#'   \item{unknown}{share of words that cannot be lemmatized, resulting in
#'   #unknown# tag (\code{numeric} value)}
#' }
#' @return A \code{data.frame}.
#' @name germaparl_by_year
#' @rdname germaparl_by_year
"germaparl_by_year"


#' Table with information on GermaParl by legislative period
#' 
#' A dataset with information on the corpus by legislative period is included
#' in the package to be included in the data report of the package vignette.
#' @format A \code{data.frame} with 5 rows and 6 variables with summary
#'   statistics on the GermaParl corpus on a year-by-year basis.
#' \describe{
#'   \item{lp}{legislative period (\code{integer} value)}
#'   \item{protocols}{total number of protocols included in the corpus for the
#'   respective legislative period (\code{integer} value)}
#'   \item{first}{date of the first plenary protocol in the legislative period
#'   (\code{Date} class)}
#'   \item{last}{date of the last plenary protocol in the legislative period
#'   (\code{Date} class)}
#'   \item{size}{number of tokens in subcorpus for the respective legislative
#'   period (\code{integer} value)}
#'   \item{unknown_total}{total number of words that cannot be lemmatized, resulting in
#'   #unknown# tag (\code{numeric} value)}
#'   \item{unknown_share}{share of words that cannot be lemmatized, resulting in
#'   #unknown# tag (\code{numeric} value)}
#' }
#' The table is based on v1.0.6 of the corpus. To prepare the table, the script
#' available at
#' \href{https://github.com/PolMine/GermaParl/blob/master/data-raw/stats_for_vignette.R}{data-raw/stats_for_vignette.R}
#' has been used.
#' @return A \code{data.frame}.
#' @name germaparl_by_lp
#' @rdname germaparl_by_lp
"germaparl_by_lp"