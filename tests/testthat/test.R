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
    expect_true(grepl("https://doi.org/10.5281/zenodo.\\d+", germaparl_get_doi()))
    expect_true(grepl("\\d+\\.\\d+\\.\\d+", as.character(germaparl_get_version())))
    
    germaparl_encode_speeches(
      registry_dir = cwb_dirs[["registry_dir"]],
      corpus_dir = cwb_dirs[["corpus_dir"]]
    )

    library("polmineR")
    if (!RcppCWB::cqp_is_initialized()) RcppCWB::cqp_initialize()
    count("GERMAPARL", query = '"erfolgreiche" "Integration"')
    RcppCWB::cl_delete_corpus("GERMAPARL")
    registry_reset()
    count("GERMAPARL", query = '"erfolgreiche" "Integration"')

    s_attrs <- s_attributes("GERMAPARL")
    expect_identical(TRUE, "speech" %in% s_attrs)

    s_attrs <- s_attributes("GERMAPARL", "speech")
    expect_identical(length(s_attrs), 162023L)

    dtm <- as.DocumentTermMatrix("GERMAPARL", p_attribute = "word", s_attribute = "speech")
    expect_equal(sum(dtm$v), size("GERMAPARL"))
    expect_identical(dim(dtm)[1], length(s_attributes("GERMAPARL", "speech", unique = TRUE)))

    germaparl_download_lda(k = 250L, data_dir = file.path(cwb_dirs[["corpus_dir"]], "germaparl"))
    lda <- germaparl_load_topicmodel(k = 250, registry = cwb_dirs[["registry_dir"]])
    germaparl_encode_lda_topics(
      k = 250,
      registry_dir = cwb_dirs[["registry_dir"]],
      data_dir = file.path(cwb_dirs[["corpus_dir"]], "germaparl")
    )
    
    file.copy(
      from = file.path(cwb_dirs[["registry_dir"]], "germaparl"),
      to = file.path(registry(), "germaparl"),
      overwrite = TRUE
    )
    
    library("polmineR")
    if (!RcppCWB::cqp_is_initialized()) RcppCWB::cqp_initialize()
    count("GERMAPARL", query = '"erfolgreiche" "Integration"')
    RcppCWB::cl_delete_corpus("GERMAPARL")
    registry_reset()
    count("GERMAPARL", query = '"erfolgreiche" "Integration"')
    
    expect_true("topics" %in% s_attributes("GERMAPARL"))
    # x <- subset("GERMAPARL", grep("133", topics)) %>% 
    #   as.speeches(s_attribute_name = "speaker")
})
