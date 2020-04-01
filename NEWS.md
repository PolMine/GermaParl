# GermaParl v1.2.1.9002

- The GermaParl corpus is downloaded now from a storage location at zenodo. The 
  `germapar_download_corpus()` function has been reworked accordingly. It now
  takes the argument `doi`.
- The `GermaParl` R6 class has been dropped from the package. The main method of
  the function (`$summary()`) is superfluous as the `size()`-method of the polmineR
  package produces the same output (`data.table` with report of sizes of subcorpora
  on according to an `s_attribute`).
- The function `germaparl_add_p_attribute_stem()` has been removed from the package.
  The functionality (adding a new p-attribute with word stems) makes senes, but the
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

# GermaParl 1.2.1.9001

- Documentation for function to work with topicmodels have been integrated into one 
  documentation object.
- Bug removed from `germaparl_download_lda` examples.
- `germaparl_load_lda` will now return NULL object (instead of throwing an error) if
  lda model is not present.
- `germaparl_encode_lda_topics` will now issue a warning (instead of crashing) if the
  s-attribute 'speeches' has not yet been generated.
- The function `use_germaparl()` has been replaced by `germaparl_regdir`, it will return
  the registry directory with the R data package.
- The tarball is downloaded from the webserver of the PolMine Project.
- Upon loading the package, the registry file included in the package is copied to the 
  temporary registry by default, making the corpus available. 

# GermaParl 1.2.1

- configure.win script is removed so that installation works on Windows without Rtools installation

# GermaParl 1.2.0

- Package includes sample data, but not full corpus upon installation, use `germaparl_download_corpus()` for downloading full corpus.
- installation script setpaths.R in ./tools used for adapting paths

# GermaParl 1.1.0

- Stanford CoreNLP (updated ctk package as interface) used for tokenization and annotation
- vignette "The Making of GermaParl" included that documets annotation procedure
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

# GermaParl 0.9.0

- Vervollständigung des Korpus: Das Korpus enthält nun auch die letzten beiden Plenarprotokolle nach der Sommerpause. Die Aufbereitung der Protokolle der 17. Wahlperiode ist damit abgeschlossen.

- Vereinheitlichung der Bezeichnungen der Parteien: Die Unionsparteien waren im txt-basierten Teil des Korpus mit "CDU/CSU" bezeichnet, im pdf-basierten Teil mit "CDU CSU". Mit Version 0.9.0 erfolgt einheitliche Benennung ("CDUCSU").

- Vereinheitlichung von Datumsangaben: Im pdf-basierten Teil des Korpus erfolgte die Datumsangabe nach dem Muster TT-MM-JJJJ, im txt-basiertem Teil als JJJJMM-TT. Hier ist nun das einheitliche Format YYYY-MM-DD.

- Korrektur von Parteiangaben. Auch fur die Mitglieder des Bundestagspräsidiums war die Parteimitgliedschaft angegeben, so dass diese bei der Nutzung des Korpus nur auf umständliche Weise aus der Analyse ausgeschlossen werden konnten. Die Parteimitgliedschaften fur den Bundestagspräsidenten bzw. seine Stellvertreter wurden nun getilgt, so dass tats¨achlich nur die Redeanteile von Sprechern analysiert werden, die einer Fraktion/Partei zugerechnet werden können.

- Neu eingeführt wurde das Attribut text month. Dies ermöglicht es, Veränderungen von Häufigkeiten innerhalb eines Jahres zu untersuchen.

# GermaParl 0.8.0

- Das Korpus kombiniert fur den Zeitraum von Ende 2008 bis Anfang 2009 das txt-basierte Korpus mit dem pdf-basiertem Korpus, so dass ein luckenfreies Korpus fur den Zeitraum von 1996 bis 2013 zur Verfüugung steht.

# Version 0.7.0

- Neustrukturierung des Datenformats: Gegenuber früheren Versionen des Korpus (vom 01./02. August 2012) unterscheidet sich die Version des Korpus durch die Zerlegung des Ausgangsformats in solche Text fur den CWB/CQPweb-Import, die Passagen ununterbrochener Rede bzw. Zwischenrufe sind. Diese Zerlegung erfolgt seit der Version vom 6. April 2013 mit dem Ziel einer Optimierung der Daten fur die Nutzung von CQPweb.
