testthat::context("download")


test_that(
  "availability of corpus after installation",
  {
    skip_on_cran()
    
    Sys.setenv(CORPUS_REGISTRY = "")
    cwb_dirs <- cwbtools::create_cwb_directories(prefix = tempdir(), ask = FALSE)
    Sys.setenv(CORPUS_REGISTRY = cwb_dirs[["registry_dir"]])
    
    germaparl_download_corpus(
      registry_dir = cwb_dirs[["registry_dir"]],
      corpus_dir = cwb_dirs[["corpus_dir"]],
      ask = FALSE
    )

    expect_identical(germaparl_is_installed(), TRUE)
    expect_true(grepl("10.5281/zenodo.\\d+", germaparl_get_doi()))
    expect_true(grepl("\\d+\\.\\d+\\.\\d+", as.character(germaparl_get_version())))
})
