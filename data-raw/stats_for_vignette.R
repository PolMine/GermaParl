# This is a script to prepare data.table objects with statis

library(polmineR)
use("GermaParl")

library(knitr)
library(data.table)


dts <- lapply(
  13:17,
  function(lp){
    print(lp)
    P <- partition("GERMAPARL", lp = lp)
    dates <- as.Date(s_attributes(P, "date"))
    dt <- count(P, p_attribute = "lemma")
    unknown <- round(sum(dt[grepl("#unknown#", dt[["lemma"]])][["count"]]) / size(P), digits = 3)
    
    data.table(
      lp = lp,
      protocols = length(unique(s_attributes(P, "session"))),
      first = min(dates, na.rm = TRUE),
      last = min(dates, na.rm = TRUE),
      size = size(P),
      unknown = unknown
    )
  }
)
germaparl_by_lp <- rbindlist(dts)

years <- as.integer(s_attributes("GERMAPARL", "year"))
dts <- lapply(
  min(years):max(years),
  function(year){
    P <- partition("GERMAPARL", year = as.character(year), verbose = FALSE)
    P.txt <- partition(P, src = "txt")
    P.pdf <- partition(P, src = "pdf")
    dt <- polmineR::count(P, p_attribute = "lemma")
    unknowns <- round(sum(dt[grepl("#unknown#", dt[["lemma"]])][["count"]]) / size(P), digits = 3)
    data.table(
      year = year,
      protocols = length(unique(s_attributes(P, "session"))),
      txt = length(s_attributes(P.txt, "session")),
      pdf = length(s_attributes(P.pdf, "session")),
      size = size(P),
      unknown = unknowns
    )
  }
)
dt1 <- rbindlist(dts)
dt2 <- rbind(dt1, t(data.table(colSums(dt1))), use.names = FALSE, fill = FALSE)
dt2[["year"]] <- as.character(dt2[["year"]])
dt2[nrow(dt2), 1] <- "TOTAL"
germaparl_by_year <- dt2

save(germaparl_by_lp, germaparl_by_year, file = "~/Lab/github/GermaParl/data/germaparl_stats.RData")
