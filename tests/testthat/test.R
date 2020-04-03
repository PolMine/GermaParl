testthat::context("download")

test_that(
  "tests",
  {
    expect_identical(germaparl_is_installed(), FALSE)
    skip_on_cran()
    
    germaparl_download_corpus()
    expect_identical(germaparl_is_installed(), TRUE)
    expect_identical(germaparl_get_doi(), "https://doi.org/10.5281/zenodo.3735141")
    expect_identical(germaparl_get_version(), "v1.0.5")
    
    library(polmineR)
    use("GermaParl")
    germaparl_add_s_attribute_speech()
    use("GermaParl")
    
    s_attrs <- s_attributes("GERMAPARL")
    expect_identical(TRUE, "speech" %in% s_attrs)
    
    s_attrs <- s_attributes("GERMAPARL", "speech")
    expect_identical(length(s_attrs), 162023L)
    
  }
)

