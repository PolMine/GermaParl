#' Download full GermaParl corpus.
#' 
#' The GermaParl R package includes only a small subset of the GermaParl corpus
#' (GERMAPARLMINI). The full corpus is deposited with
#' \href{https://zenodo.org/}{zenodo}, a repository for research data. The
#' \code{germaparl_download_corpus} function downloads a tarball with the
#' indexed corpus from the zenodo repository and moves the corpus data to the
#' system corpus storage. If a corpus registry has not yet been created, an
#' interactive dialogie will help to do so. When calling the function, a stable
#' and fast internet connection will be useful as the size of the data amounts
#' to ~1 GB which needs to be downloaded.
#' 
#' @details After downloading and installing the tarball with the CWB indexed
#'   corpus, the registry file for the GERMAPARL corpus will be amended by
#'   the DOI and the corpus version, to make this information for the citation
#'   information that is provided when calling the function \code{citation}.
#' 
#' @param doi The DOI (Digital Object Identifier) of the GermaParl tarball at
#'   zenodo, presented as a hyperlink. Defaults to the latest version of 
#'   GermaParl.
#' @param registry_dir Path to the system registry directory. Defaults to value
#'   of \code{cwbtools::cwb_registry_dir()}.
#' @param quiet Whether to suppress progress messages, defaults to \code{FALSE}.
#' @export germaparl_download_corpus
#' @return A logical value, \code{TRUE} if the corpus has been installed
#'   successfully.
#' @rdname download
#' @importFrom cwbtools corpus_install registry_file_parse registry_file_write 
#' @importFrom cwbtools corpus_remove cwb_directories cwb_registry_dir create_cwb_directories
#' @importFrom RCurl url.exists getURL
#' @importFrom jsonlite fromJSON
#' @importFrom utils menu
#' @examples
#' \dontrun{
#' if (!germaparl_is_installed()) germaparl_download_corpus()
#' use("GermaParl")
#' corpus() # should include GERMAPARLMINI and GERMAPARL
#' count("GERMAPARL", "Daten") # an arbitrary test
#' }
germaparl_download_corpus <- function(doi = "https://doi.org/10.5281/zenodo.3742113", registry_dir = cwbtools::cwb_registry_dir(), quiet = FALSE){
  if (isFALSE(is.logical(quiet))) stop("Argument 'quiet' needs to be a logical value.")
  zenodo_info <- .germaparl_zenodo_info(doi = doi)
  
  if (!is.null(registry_dir)){
    if ("germaparl" %in% list.files(registry_dir)){
      regdata <- registry_file_parse(corpus = "GERMAPARL", registry_dir = registry_dir)
      if ("version" %in% names(regdata[["properties"]])){
        version_old <- regdata[["properties"]][["version"]]
      } else {
        version_old <- "unknown"
      }
      if (interactive()){
        if (version_old == zenodo_info[["metadata"]][["version"]]){
          userinput <- menu(
            choices = c("Yes / continue", "No / abort"), 
            title = sprintf(
              paste(
                "Local GERMAPARL version and the version of GERMAPARL to be retrieved from Zenodo are identical (%s).",
                "Are you sure you want to proceed and to replace the local corpus by a fresh download?"
              ),
              zenodo_info[["metadata"]][["version"]]
            )
          )
          if (userinput != 1L){
            stop("Aborting - existing version of GERMAPARL remains unchanged. ")
          }
        } else {
          userinput <- menu(
            choices = c("Yes / continue", "No / abort"), 
            title = sprintf(
              "Corpus GERMAPARL (version: %s) is already installed. Do you want to replace it by version %s?",
              version_old, zenodo_info[["metadata"]][["version"]]
            )
          )
          if (userinput != 1L){
            stop(
              "Aborting - existing version of GERMAPARL remains unchanged. ",
              "If you want to keep the existing GERMAPARL version, rename it using cwbtools::corpus_rename(), ",
              "and call GermaParl::corpus_install() again."
            ) 
          }
        }
      }
      corpus_remove(corpus = "GERMAPARL", registry_dir = registry_dir)
    }
  }
  
  cwb_dirs <- cwb_directories()
  if (is.null(cwb_dirs)) cwb_dirs <- create_cwb_directories() # will trigger interactive dialogue

  corpus_tarball <- grep(
    "^.*/germaparl_v\\d+\\.\\d+\\.\\d+\\.tar\\.gz$",
    zenodo_info[["files"]][["links"]][["self"]],
    value = TRUE
  )
  if (isFALSE(quiet)) message("... downloading tarball: ", corpus_tarball)

  corpus_install(
    pkg = NULL, 
    tarball = corpus_tarball,
    registry_dir = cwb_dirs[["registry_dir"]],
    corpus_dir = cwb_dirs[["corpus_dir"]], 
    verbose = !quiet
  )
  
  regdata <- registry_file_parse(corpus = "GERMAPARL", registry_dir = cwb_dirs[["registry_dir"]])
  regdata[["properties"]][["doi"]] <- doi
  regdata[["properties"]][["version"]] <- zenodo_info[["metadata"]][["version"]]
  regdata[["home"]] <- file.path(cwb_dirs[["corpus_dir"]], "germaparl")
  registry_file_write(data = regdata, corpus = "GERMAPARL",  registry_dir = cwb_dirs[["registry_dir"]])
  
  if (isNamespaceLoaded("polmineR")){
    file.copy(
      from = file.path(cwb_dirs[["registry_dir"]], "germaparl"),
      to = file.path(polmineR::registry(), "germaparl"),
      overwrite = TRUE
    )
    polmineR::registry_reset(registryDir = polmineR::registry())
  }
  return(TRUE)
}


.germaparl_zenodo_info <- function(doi){
  if (isFALSE(grepl("^.*?10\\.5281/zenodo\\.\\d+$", doi))){
    stop("Argument 'doi' is expected to offer a DOI (Digital Object Identifier) that refers to data",
         "hosted with zenodo, i.e. starting with 10.5281/zenodo.")
  }
  record_id <- gsub("^.*?10\\.5281/zenodo\\.(\\d+)$", "\\1", doi)
  zenodo_api_url <- sprintf("https://zenodo.org/api/records/%d", as.integer(record_id))
  fromJSON(getURL(zenodo_api_url))
}