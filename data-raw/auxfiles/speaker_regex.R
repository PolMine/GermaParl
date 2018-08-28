list(
  
  pres = list(
    regex = "^\\s*(?!\\()(P|Vizep|Altersp)räsident(|in)\\s+(?!des\\sSenats)([^!,]*?):\\s*(.*)$",
    fn = function(x){
      data.frame(
        who = x[,4],
        parliamentary_group = if (nrow(x) >= 1) "NA" else character(),
        role = if (nrow(x) >= 1) "presidency" else character(),
        position = if (nrow(x) >= 1) sprintf("%sräsident%s", x[,2], x[,3]) else character(),
        text = x[,5],
        stringsAsFactors = FALSE
      )
    }
  ),
  
  mp = list(
    regex = mp_regex,
    fn = function(x){
      data.frame(
        who = x[,3],
        parliamentary_group = x[,4],
        role = if (nrow(x) >= 1) "mp" else character(),
        position = if (nrow(x) >= 1) "NA" else character(),
        text = x[,6],
        stringsAsFactors = FALSE
      )
    }
  ),
  
  gov = c(
    regex = "^\\s*(?!\\()([^!]+?),\\s(Bundeskanzler|Bundesminister|Staatsminister\\s+(?!\\()|Staatsministerin\\s+(?!\\()|Staatssekretär|Parl\\.\\s+Staatssekretär|Beauftragter?\\sder\\sBundesregierung)([^!]*?)(|\\s*\\(vo[nm]\\s.*?mit Beifall be\\s?grüßt\\)):\\s*(.*?)$",
    fn = function(x) data.frame(
      who = x[,2],
      parliamentary_group = if (nrow(x) >= 1) "NA" else character(),
      role = if (nrow(x) >= 1) "government" else character(),
      position = sprintf("%s%s", x[,3], x[,4]),
      text = x[,6],
      stringsAsFactors = FALSE
    )
  ),
  
  state_a = c(
    regex="^\\s*(?!\\()(Präsident\\sdes\\Senats|Präsidentin\\sdes\\sSenats|Ministerpräsident|Ministerpräsidentin|Staatsminister|Staatsministerin)\\s+(.*?)\\s+(\\(.*?\\))(|\\s*\\(vo[nm]\\s.*?mit Beifall be\\s?grüßt\\)):(.*?)$",
    fn = function(x) data.frame(
      who = x[,3],
      parliamentary_group = if (nrow(x) >= 1) "NA" else character(),
      role = if (nrow(x) >= 1) "federal_council" else character(),
      position = x[,4],
      text = x[,6],
      stringsAsFactors = FALSE
    )
  ),
  
  state_b = c(
    regex = "^\\s*(?!\\()(.*?),\\s*(Minister|Ministerin|Staatsminister|Staatsministerin|Ministerpräsident|Ministerpräsidentin)\\s*(\\(.*?\\))\\s*(|\\s*\\(vo[nm]\\s.*?mit Beifall be\\s?grüßt\\)):(.*?)$",
    fn = function(x) data.frame(
      who = x[,2],
      parliamentary_group = if (nrow(x) >= 1) "NA" else character(),
      role = if (nrow(x) >= 1) "federal_council" else character(),
      position = x[,3],
      text = x[,6],
      stringsAsFactors = FALSE
    )
  ),
  
  comm = list(
    regex = "^\\s*(?!\\()(.*),\\s+Wehrbeauftragte(r|)\\sdes\\sDeutschen\\sBundestag(e|)s:(.*?)$",
    fn = function(x) data.frame(
      who = x[,2],  
      parliamentary_group = if (nrow(x) >= 1) "NA" else character(),
      role = if (nrow(x) >= 1) "parliamentary_commissioner" else character(),
      position = if (nrow(x) >= 1) "Wehrbeauftragter des Deutschen Bundestags" else character(),
      text = x[,4],
      stringsAsFactors = FALSE
    )
  )
  
)