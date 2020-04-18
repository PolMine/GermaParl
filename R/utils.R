.germaparl_refresh <- function(session_registry_dir = polmineR::registry(), system_registry_dir = getOption("polmineR.corpus_registry")){
  file.copy(
    from = file.path(system_registry_dir, "germaparl"),
    to = file.path(session_registry_dir, "germaparl"),
    overwrite = TRUE
  )
  # RcppCWB_cl_delete_corpus will crash if the corpus has not been used before (missing C representation of
  # the corpus). A minimal corpus query - RcppCWB::cl_cpos2id() - is necessary to avoid the crash
  RcppCWB::cl_cpos2id(corpus = "GERMAPARL", p_attribute = "word", cpos = 0L, registry = session_registry_dir)
  RcppCWB::cl_delete_corpus("GERMAPARL", registry = session_registry_dir)
  polmineR::registry_reset()
}

library(polmineR)
library(RcppCWB)


RcppCWB::cl_cpos2id(corpus = "GERMAPARL", cpos = 0L, p_attribute = "word", registry = registry())
RcppCWB::cl_delete_corpus("GERMAPARL")
