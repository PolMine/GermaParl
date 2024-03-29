# GermaParl 1.5.2

- The `germaparl_download_lda()` will check md5 sums now when downloading data.
- If downloading an LDA model using `germaparl_download_lda()` fails, you will now see an informative message and the return value will be `FALSE`.
- An XSL to transform GermaParl TEI-XML files to an XML format better suited for the CWB is included in the directory inst/extdata/xsl. Previously, this file was included in the (unpublished) ctk.plpr package.

# GermaParl 1.5.1

- Functions included in older versions of the package that used functions from the RcppCWB package had been dropped. An unnecessary declaration of RcppCWB in the 'Imports:' section of the DESCRIPTION file has been removed. 
- The data objects `germaparl_by_lp` and `germaparl_by_year` were included as `data.table` objects, making the presence of the `data.table` package necessary. To reduce the number of packages imported from and to avoid an error that emerged on Windows, these tables are included as `data.frame` objects.
- The documentation of the data objects `germaparl_by_lp` and `germaparl_by_year` now includes an explanation of what is reported in rows and columns.
- The `germaparl_by_year` table now includes a column `unknown_total` and `unknown_share` with the total number of tokens that cannot be lemmatized, and their share, respectively. On this basis, an error in the calculation of the aggregate unknown share for all years can be corrected.


# GermaParl 1.5.0

- The package will not depend on the polmineR package any more. Higher-level functions of the polmineR package have been replaced by lower-level functions.
- The functions `germaparl_encode_speeches()` and `germaparl_encode_lda_topics()` have been moved to the (GitHub-only) [polmineR.misc package](https://github.com/PolMine/polmineR.misc). These are higher-level functions that rely on polmineR classes and methods. Keeping them in the GermaParl package would require to make polmineR a dependency of GermaParl. But as GermaParl is designed to become a dependency of polmineR, we prevent a circular dependecy by removing the functions. What is more, both functions have been designed to augmment GermaParl, but their essence is morge generic. In the long run, a cwbtools.misc package (to be created) might be the most logical place for generic functionality to augment corpora.



# GermaParl 1.4.2

- Most functions now include an argument `sample` that defaults to `FALSE`. If set as
  `TRUE`, functionality to retrieve information from the corpus or to modify the corpus
  will be applied to the smaller GERMAPARLSAMPLE corpus rather than the GERMAPARL corpus.
- The sample workflow of the overall package documentation object will now rely on the
  GERMAPARLSAMPLE corpus rather than the full GERMAPARL corpus.
- A Rmarkdown document in the data-raw folder explains how the topic model for the sample
  corpus has been prepared.
  

# GermaParl 1.4.1

- The 'topicmodels' package has been turned into a suggested package and has been
  moved from the 'Depends' section to the 'Suggests' section in the DESCRIPTION 
  file.
- Rework of the documentation, including examples.

# GermaParl 1.4.0

- To meet CRAN requirements, the corpus is not stored within the package as in 
  previous version, but in a system corpus directory. The same is applies to
  supplementary data such as LDA topic models fitted on GERMAPARL.
- The core of the functionality of `germaparl_download_corpus()` to download the 
  corpus has been moved to cwbtools (v0.2.0). The `germaparl_download_corpus()` 
  function is now a convenience wrapper for `cwbtools::corpus_install()` that 
  ensures that the correct DOI (argument `doi`) is passed to `corpus_install()`.


# GermaParl 1.3.0

- The GermaParl corpus is downloaded now from a storage location at zenodo. The 
  `germapar_download_corpus()` function has been reworked accordingly. It now
  takes the argument `doi`.
- The `GermaParl` R6 class has been dropped from the package. The main method of
  the function (`$summary()`) is superfluous as the `size()`-method of the polmineR
  package produces the same output (`data.table` with report of sizes of subcorpora
  on according to an `s_attribute`).
- The function `germaparl_add_p_attribute_stem()` has been removed from the package.
  The functionality (adding a new p-attribute with word stems) makes sense, but the
  implementation should be generic and included in the cwbtools package.
- The file 'zzz.R' has been removed from the package. It moved the registry files 
  from the GermaParl package to a central registry. This is not necessary any more
  as polmineR works with a temporary registry directory.
- The file 'configure' in the main directory of the package has been removed, as the 
  polmineR approach to work with a temporary registry does not require the paths 
  in the registry files to be set. The file 'tools/setpaths.R' has been removed
  for the same reason.
- The `germaparl_regdir()` function has been removed. Not necessary any more.
- The `germaparl_search_speeches()` function has been removed from the package. The
  functionality is nice, but there should either be a generic implementation in the
  polmineR package, or it might be offered as a recipe.
- Documentation for function to work with topicmodels have been integrated into one 
  documentation object.
- Bug removed from `germaparl_download_lda` examples.
- `germaparl_load_lda` will now return NULL object (instead of throwing an error) if
  lda model is not present.
- `germaparl_encode_lda_topics` will now issue a warning (instead of crashing) if the
  s-attribute 'speeches' has not yet been generated.
- The tarball is downloaded from Zenodo.

# GermaParl 1.2.1

- configure.win script is removed so that installation works on Windows without Rtools installation

# GermaParl 1.2.0

- Package includes sample data, but not full corpus upon installation, use `germaparl_download_corpus()` for downloading full corpus.
- installation script setpaths.R in ./tools used for adapting paths

# GermaParl 1.1.0

- Stanford CoreNLP (updated ctk package as interface) used for tokenization and annotation
- vignette "The Making of GermaParl" included that documents annotation procedure
- simplification of names of s-attributes (e.g. date instead of text_date)
- data in the GermaParl package synced with data available at github.com/PolMine/GermaParlTEI
- data includes 18th legislative period (until December 2016)


# GermaParl 1.0.5

- extended README added
- English version of the package vignette prepared
- documentation generated with pkgdown


# GermaParl 1.0.4

- template.json added to make use of new template mechanism (as offered by polmineR 0.7.4)


# GermaParl 1.0.3

- package/corpus renamed to GermaParl
- no substantial changes


# GermaParl 1.0.2

- adding a (German) vignette to the package

