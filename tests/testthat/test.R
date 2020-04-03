testthat::context("download")

test_that(
  "initial test",
  {
    expect_identical(germaparl_is_installed(), FALSE)
    skip_on_cran()
    
    germaparl_download_corpus()
    expect_identical(germaparl_is_installed(), TRUE)
    expect_identical(germaparl_get_doi(), "https://doi.org/10.5281/zenodo.3735141")
    expect_identical(germaparl_get_version(), "v1.0.5")
    
    germaparl_add_s_attribute_speech()
    library(polmineR)
    use("GermaParl")
    
    s_attrs <- s_attributes("GERMAPARL")
    expect_identical(TRUE, "speech" %in% s_attrs)
    
    s_attrs <- s_attributes("GERMAPARL", "speech")
    expect_identical(length(s_attrs), 162023L)
    
  }
)

test_that(
  "germaparl_add_s_attribute_speech",
  {
    expect_identical(germaparl_is_installed(), TRUE)
    skip_on_cran()
    
    germaparl_add_s_attribute_speech()
    library(polmineR)
    use("GermaParl")
    
    s_attrs <- s_attributes("GERMAPARL")
    expect_identical(TRUE, "speech" %in% s_attrs)
    
    s_attrs <- s_attributes("GERMAPARL", "speech")
    expect_identical(length(s_attrs), 162023L)
    
  }
)

