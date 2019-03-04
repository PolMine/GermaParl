.onAttach <- function (libname, pkgname){
  
  pkg_registry_dir <- file.path(normalizePath(libname, winslash = "/"), pkgname, "extdata", "cwb", "registry", fsep = "/")
  pkg_indexed_corpora_dir <- file.path(normalizePath(libname, winslash = "/"), pkgname, "extdata", "cwb", "indexed_corpora", fsep = "/")

  polmineR_registry_dir <- polmineR::registry()
  if (!dir.exists(polmineR_registry_dir)) dir.create(polmineR_registry_dir)

  for (corpus in list.files(pkg_registry_dir)){
    polmineR:::registry_move(
      corpus = corpus,
      registry = pkg_registry_dir,
      registry_new = polmineR_registry_dir,
      home_dir_new = file.path(pkg_indexed_corpora_dir, tolower(corpus))
    )
  }
  
  Sys.setenv("CORPUS_REGISTRY" = polmineR_registry_dir)
}
