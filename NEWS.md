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
