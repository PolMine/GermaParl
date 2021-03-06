% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GermaParl.R
\name{germaparl_get_version}
\alias{germaparl_get_version}
\title{Get GERMAPARL version}
\usage{
germaparl_get_version(
  registry_dir = Sys.getenv("CORPUS_REGISTRY"),
  sample = FALSE
)
}
\arguments{
\item{registry_dir}{Path to the registry directory.}

\item{sample}{If \code{TRUE}, work with GERMAPARLSAMPLE corpus, if
\code{FALSE} (default), use GERMAPARL corpus.}
}
\value{
The return value is the version of the corpus (class
  \code{numeric_version}). If the corpus has not yet been installed,
  \code{NULL} is returned, and a warning message is issued.
}
\description{
\code{germaparl_get_version} is an auxiliary function that extracts
  the version of the GERMAPARL corpus from the registry.
}
\seealso{
See the examples section of the overview documentation of the
  \link{GermaParl} package for an example.
}
