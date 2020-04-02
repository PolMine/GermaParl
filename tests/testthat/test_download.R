context("download")

test_that(
  "initial test",
  {
    expect_identical(germaparl_is_installed(), FALSE)
    skip_on_cran()
    
    germaparl_download_corpus()
    expect_identical(germaparl_is_installed(), TRUE)
    expect_identical(germaparl_get_doi(), "https://doi.org/10.5281/zenodo.3735141")
    expect_identical(germaparl_get_version(), "v1.0.5")
  }
)