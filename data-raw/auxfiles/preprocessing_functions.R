list(
  
  "BT_13_022" = function(txt){
    gsub("Norbert\\s+Rängen", "Norbert Röttgen", txt)
  },
  
  "BT_13_030" = function(txt){
    lineToReplace <- grep("Einzelplan\\s11", txt)[1] - 2
    txt[lineToReplace] <- "Vizepräsidentin Hans-Ulrich Klose:"
    txt
  },
  
  "BT_13_038" = function(txt){
    gsub("Vizepräsidentin\\sFrau\\sDr\\.\\sAntje\\sVollmer:", "Vizepräsidentin Dr. Antje Vollmer:", txt)
  },
  
  "BT_13_066" = function(txt){
    lineToReplace <- grep("Einzelplan\\s10", txt)[1] - 2
    txt[lineToReplace] <- "Vizepräsidentin Dr. Antje Vollmer:"
    gsub("Präsidentin\\s+Dr\\.\\.\\s+Rita\\s+Süssmuth:", "Präsidentin Dr. Rita Süssmuth:", txt)
  },
  
  "BT_16_183" = function(txt){
    gsub("Dr\\.\\sh\\.\\sc\\sSusanne\\sKastner", "Dr. h. c. Susanne Kastner", txt)
  },
  
  "BT_13_158" = function(txt){
    gsub("Dr. Uwe-Jens Rössel Kolleginnen und Kollegen!", "Dr. Uwe-Jens Rössel (PDS): Kolleginnen und Kollegen!", txt)
  },
  "BT_13_221"=function(txt){
    gsub("Aber bitte schön, Herr Staatssekretär.", "Aber bitte schön, Herr Staatssekretär.\n", txt) 
    strsplit(paste(txt, collapse="\n"), "\\n")[[1]]
  },
  "BT_13_238"=function(txt){
    gsub("Bundesminister Dr\\. Edzard Schmidt-Jortzig \\(F\\.D\\.P\\.\\):", "Dr. Edzard Schmidt-Jortzig, Bundesminister für Justiz", txt)
  },
  "BT_14_045"=function(txt){
    txt <- gsub("Jochen Dieckmann, Minister \\(Nordrhein-West-", "Jochen Dieckmann, Minister (Nordrhein-Westfalen):", txt)
    gsub("^falen\\):", "", txt)
  },
  "BT_14_090"=function(txt){
    txt <- gsub("Berlin,\\sDonnerstag,\\sden\\s24.\\sFebruar\\s2000", "Berlin, Donnerstag, den 24. Februar 2000\nI n h a l t :", txt)
    strsplit(paste(txt, collapse="\n"), "\\n")[[1]]
  },
  "BT_14_105"=function(txt){
    txt <- gsub("Berlin,\\sDonnerstag,\\sden\\s18.\\sMai\\s2000", "Berlin, Donnerstag, den 18. Mai 2000\nI n h a l t :", txt)
    strsplit(paste(txt, collapse="\n"), "\\n")[[1]]
  },
  "BT_17_173"=function(txt){
    gsub("0Plenarprotokoll\\s17/173", "Plenarprotokoll 17/173", txt)
  },
  "BT_15_031"=function(txt){
    gsub("Berlin,\\sDonnerstag,\\sden\\s13.\\sMä\\srz\\s2003", "Berlin, Donnerstag, den 13. März 2003", txt)
  },
  "BT_15_032"=function(txt){
    gsub("Berlin,\\sFreitag,\\sden\\s14.\\sMä\\srz\\s2003", "Berlin, Freitag, den 14. März 2003", txt)
  },
  "BT_18_053"=function(txt){
    gsub("Berlin,\\sMittwoch,\\sden\\s24.\\sMittwoch\\s2014", "Berlin, Mittwoch, den 24. September 2014", txt)
  },
  "BT_18_119"=function(txt){
    gsub("undePlenarprotokoll\\s18/119", "", txt)
  }
)
