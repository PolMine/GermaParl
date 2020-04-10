testthat::context("download")


if (Sys.getenv("NOT_CRAN") == "true"){
  Sys.setenv(CORPUS_REGISTRY = "")
  cwb_dirs <- create_cwb_directories(prefix = tempdir, ask = FALSE)
  germaparl_download_corpus(registry_dir = cwb_dirs[["registry_dir"]])
}


test_that(
  "availability of corpus after installation",
  {
    skip_on_cran()
    Sys.setenv(CORPUS_REGISTRY = file.path(tempdir(), "registry"))
    expect_identical(germaparl_is_installed(), TRUE)
    expect_true(grepl("https://doi.org/10.5281/zenodo.\\d+", germaparl_get_doi()))
    expect_true(grepl("v\\d+\\.\\d+\\.\\d+", germaparl_get_version()))
  }
)


test_that(
  "add s-attribute speech",
  {
    # skip_on_cran()
    # 
    # use("GermaParl")
    # 
    # germaparl_add_s_attribute_speech()
    # 
    # library("polmineR")
    # use("GermaParl")
    # 
    # s_attrs <- s_attributes("GERMAPARL")
    # expect_identical(TRUE, "speech" %in% s_attrs)
    # 
    # s_attrs <- s_attributes("GERMAPARL", "speech")
    # expect_identical(length(s_attrs), 162023L)
    # 
    # dtm <- as.DocumentTermMatrix("GERMAPARL", p_attribute = "word", s_attribute = "speech")
    # expect_equal(sum(dtm$v), size("GERMAPARL"))
    # expect_identical(dim(dtm)[1], length(s_attributes("GERMAPARL", "speech", unique = TRUE)))
    # 
    # germaparl_download_lda(k = 250L)
    # lda <- germaparl_load_topicmodel(k = 250)
    # germaparl_encode_lda_topics(k = 250)
    # 
    # t <- s_attributes("GERMAPARL", "topics")
    # x <- subset("GERMAPARL", grep("133", topics)) %>% 
    #   as.speeches(s_attribute_name = "speaker")
})
