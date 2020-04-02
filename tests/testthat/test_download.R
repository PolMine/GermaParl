context("download")

test_that(
  "initial test",
  {
    expect_identical(germaparl_is_installed(), FALSE)
    # skip_on_cran()
    
    germaparl_download_corpus()
    expect_identical(germaparl_is_installed(), TRUE)
  }
)