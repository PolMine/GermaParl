list(
  
  any = "rufe\\s+(den\\s+|die\\s+|)Tagesordnungspunkt(e|)\\s+\\d+",
  any = "(.{0,90})(kommen?|steigen|rufe|fahre|gehen|gehe)(\\s{0,2}|\\s.{0,20}|\\,.{0,60}) (lfd\\.?\\s?Nrn?\\.?|Zusatzpunkt|Zusatztagesordnungs?|Tagesordnung?|[Pp]unkt[ens]*|Tagesordnungspunkte|Tagesordnungspunkten|Nummer+)(.{0,60})(\\s(auf|fort|ein))?",
  any = "(.{0,20})(rufe. ohne Tagesordnungspunkt)(.{0,10})(abzuschließen. Tagesordnungspunkt)(.{0,10})(auf)",
  any = "(Ich den Tagesordnungspunkt .* auf:)",
  any = "((ZP|lfd\\.?\\s?Nrn?\\.?|Punkte?|Zusatz|Tagesordnungs)punkt[ens]*\\s+)\\d+",
  question_time = "(rufe\\snun\\sdie\\sFragestunde\\sauf|kommen\\szur\\sFragestunde)",
  budget = "kommen.*?zum\\s+Geschäftsbereich.*?Einzelplan\\s+\\d+",
  budget = "^\\s*Einzelplan\\s+\\d+\\s*$",
  budget = "kommen.{0,20}zum\\sGeschäftsbereich\\sdes\\sBundesministeriums.*?[dD]as\\Wort"
  
)
