library(cwbtools)

corpus_as_tarball(
  corpus = "GERMAPARL",
  registry_dir = system.file(package = "GermaParl", "extdata", "cwb", "registry"),
  tarfile = "~/Lab/tmp/germaparl.tar.gz"
  )

