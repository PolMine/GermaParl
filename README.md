
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/GermaParl)](https://cran.r-project.org/package=GermaParl)
[![DOI](https://zenodo.org/badge/141028057.svg)](https://zenodo.org/badge/latestdoi/141028057)
[![R build
status](https://github.com/PolMine/GermaParl/workflows/R-CMD-check/badge.svg)](https://github.com/PolMine/GermaParl/actions)
[![codecov](https://codecov.io/gh/PolMine/GermaParl/branch/master/graph/badge.svg)](https://codecov.io/gh/PolMine/GermaParl/branch/master)

# The GermaParl R Data Package <img src="https://raw.githubusercontent.com/PolMine/GermaParl/master/inst/sticker/hexsticker.png" align="right" />

## About

GermaParl is a R data package that includes:

-   A small subset of the linguistically annotated and CWB-indexed
    GermaParl corpus of plenary protocols of the German Bundestag by
    default;
-   Functionality to load the the full CWB version of GermaParl from the
    Open Science repository [Zenodo](https://zenodo.org/), and
-   Additional functionality to work with topic models.

The companion GitHub repository
[GermaParlTEI](https://github.com/PolMine/GermaParlTEI) offers the
TEI-XML versions of the corpus. The GermaParl data package is designed
to provide easy access to a linguistically annotated and indexed version
of the data.

More specifically, GermaParl has been imported into the [Corpus
Workbench (CWB)](http://cwb.sourceforge.net/). Using the CWB keeps the
data size modest, ensures performance, exposes the syntax of the Corpus
Query Processor (CQP), and generates opportunites to combine
quantitative and qualitative approaches to analyzing text.

The GermaParl package is designed to be used with
[polmineR](https://cran.r-project.org/package=polmineR) as a toolset for
various standard qualitative and quantitative tasks in text analysis
(count, dispersion, ngrams, cooccurrences, viewing concordances as well
as going back to the original full-text). Using polmineR, you can easily
generate data structures (such as term-document matrices) that are
required as input for advanced statistical procedures.

## Installation

### CRAN Release

The GermaParl package can be installed from CRAN:

``` r
install.packages("GermaParl")
```

### Development Version

The development version of the GermaParl package may include
consolidated or new functionality, and improved documentation. To
install the development version of GermaParl package from GitHub,
proceed as follows.

``` r
if (!"devtools" %in% rownames(available.packages())) install.packages("devtools")
devtools::install_github("PolMine/GermaParl", ref = "dev")
```

Please note that on Windows systems, it may be necessary to install
[Rtools](https://cran.r-project.org/bin/windows/Rtools/) to be able to
use the full functionality of the devtools package.

### Download and install the GermaParl corpus

After the initial installation, the package only includes a small subset
of the GermaParl corpus (“GERMAPARLMINI”). The subset serves as sample
data and is used for running package tests. To download the full corpus,
use a function to download the full corpus from the Open Science
repository [Zenodo](https://about.zenodo.org/):

``` r
library(GermaParl)
germaparl_download_corpus()
```

Note that the corpus will be installed in the system corpus directory by
default. If the required directory structure is not available, a
dialogue will guide the user through creating the registry directory and
the corpus directory. If you want to download the corpus into the R
package, you might use the following code.

``` r
germaparl_download_corpus(
  registry_dir = system.file(package = "GermaParl", "extdata", "cwb", "registry"),
  corpus_dir = system.file(package = "GermaParl", "extdata", "cwb", "indexed_corpora")
)
```

To avoid bloating the data that needs to be downloaded - it is somewhat
large already -, further annotation can be generated on demand. See the
package documentation to learn about the functionality that is
available.

## Using GermaParl

The CWB indexed version of GermaParl can be used with any tool for
working with CWB indexed corpora (such as
[CQP](http://cwb.sourceforge.net/) or
[CQPweb](http://cwb.sourceforge.net/cqpweb.php)). The GermaParl R
package is optimized to work with the
[polmineR](https://github.com/PolMine/polmineR) R package. See the
documentation for instructions how to install polmineR.

To check whether the installation has been successful, run the following
commands. For further instructions, see the [documentation of
polmineR](https://polmine.github.io/polmineR/).

``` r
library(polmineR)
use("GermaParl") # only necessary if you have downloaded the corpus into GermaParl package
corpus() # to see whether the GERMAPARL corpus is listed
size("GERMAPARL") # to learn about the size of the corpus
```

## Digging Deeper - Open Educational Resources (OER)

### Using Corpora in Social Science Research (UCSSR)

The “UCSSR” ([Using Corpora in Social Science
Research](https://polmine.github.io/UCSSR)) series of online slides make
extensive use of GermaParl and introduce some analytical approaches to
parliamentary debates.

### Video Tutorials for GermaParl

[Christoph
Nguyen](https://www.polsoz.fu-berlin.de/polwiss/forschung/systeme/polsystem/Team/Christoph-Nguyen.html)
has crafted video tutorials on GermaParl available at YouTube for a
[class on Parliamentary Analysis in
R](https://github.com/cgnguyen/parlament_in_r). Four tutorials give a
hands-on introduction to analysing GermaParl in combination with the
polmineR package.

-   [Introduction](https://youtu.be/dJJXYrcObw8)
-   [Data Structure](https://youtu.be/BAts-nQ9Jak)
-   [Descriptives](https://youtu.be/yVwrkwy9UqY)
-   [“Advanced” Methods](https://youtu.be/ySiYup9D3Vc)

Click on the lessons to watch Christoph’s tutorials (in German)!

## License

The GermaParl R package uses the
[GPL-3](https://www.gnu.org/licenses/gpl-3.0.en.html) license as a
standard license for open source software. The license of the GermaParl
corpus is the [Creative Commons Attibution ShareAlike 4.0 License (CC
BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/). That
means:

**BY** - Attribution — You must give appropriate credit, provide a link
to the license, and indicate if changes were made. You may do so in any
reasonable manner, but not in any way that suggests the licensor
endorses you or your use.

**SA** - ShareAlike — If you remix, transform, or build upon the
material, you must distribute your contributions under the same license
as the original.

See the [CC Attribution-ShareAlike 4.0
License](https://creativecommons.org/licenses/by-sa/4.0/) for further
explanations.

## Quoting GermaParl

The ‘GermaParl’ R package and the ‘GermaParl’ corpus are two different
pieces of research data, with different version numbers, document object
identifiers (DOIs) and recommendations for quotation. If you use
GermaParl for your research, maximum transparency on the tools you used
is attained, when both the package and the corpus is quoted in your
publication. To ensure the reproducibility of your research, it is more
important to refer to and specify the corpus (including version, DOI)
you used.

Blaette, Andreas (2020): GermaParl. Download and Augment the Corpus of
Plenary Protocols of the German Bundestag. R package version 1.4.1.
<https://CRAN.R-project.org/package=GermaParl>

Blaette, Andreas (2020): GermaParl. Linguistically Annotated and Indexed
Corpus of Plenary Protocols of the German Bundestag. CWB corpus version
1.0.6. <https://doi.org/10.5281/zenodo.3735141>

NOTE: In an R session, you can get this recommendation how to quote
GermaParl by calling the usual `citation()` function:

``` r
citation("GermaParl")
```

## Feedback

We hope that GermaParl (and polmineR) will inspire your research and
make it more productive. We would be glad to learn what you do with the
data, and make your blog entries or publications visible here.

And please do not forget to bring issues that you come across to our
attention. We cordially invite you to use the [GitHub issues of this
package](https://github.com/PolMine/GermaParl/issues) to report bugs,
shortcomings and to suggest enhancements. Improving data quality is an
important concern of the PolMine Project, this is why the data is
versioned. The resource will benefit from its community of users and
your feedback!
