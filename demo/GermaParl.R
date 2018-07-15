## Getting started / not part of the demo

library(GermaParl)
setwd("~/Lab/tmp")
options("demo.ask" = FALSE)

misses_watson_explaining <- function(x, linewidth = 60, clear = TRUE, wait = TRUE) {
  txt <- paste0(.misses_watson_output[[x]][["text"]], collapse = " ")
  txt_screen <- gsub("polmIneR", "polmineR", txt)
  
  # send text to IBM Watson and play it
  credentials <- rjson::fromJSON(file = "~/Lab/tmp/watson.json")
  audio_output <- RCurl::CFILE(filename = "media/audio_file.wav", mode = "wb")
  RCurl::curlPerform(
    url = paste(
      "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize",
      "?text=", URLencode(txt),
      "&voice=", "en-US_LisaVoice", sep = ""),
    userpwd = paste(
      credentials$username, 
      credentials$password, sep = ":"
    ),
    httpheader = c(accept = "audio/wav"),
    writedata = audio_output@ref
  )
  RCurl::close(audio_output)
  system(paste("open", filename, "-a vlc"))
  system(paste("open", filename))
  closeAllConnections()
  
  j <- 0
  for (i in 1L:nchar(txt_screen)){
    char <- substr(txt_screen, start = i, stop = i)
    if (char == " " && j > linewidth){
      j <- 0
      cat("\n")
    } else {
      cat(crayon::bold(crayon::green(char)))
      j <- j + 1
    }
    
    Sys.sleep(0.055)
  }
  if (wait){
    cat(crayon::blue(crayon::italic(" [...]")))
    readline()
  }
  if (clear) cat("\014")
  invisible(NULL)
}

.misses_watson_output <- list(
  
  "The GermaParl corpus" = list(
    text = c(
      "GermaParl is a corpus of the German federal parliament prepared in the PolMine Project,",
      "and enhanced in a CLARIN-funded cooperation project with the University of Stuttgart."
    )
  ),
  
  "The CWB as indexing and query engine" = list(
    text = c(
      "The corpus is available as XML in a format compliant with the standards of the Text Encoding Initiative,",
      "and as an indexed, and linguistically annotated version offered as an R package. The indexing and query engine used is the",
      "Corpus Workbench, a classic open source tool widely used for corpus analysis."
    )
  ),
  
  "The polmineR package" = list(
    text = c(
      "The polmIneR package offers specialized functionality to work efficiently with GermaParl.",
      "We start this short demo by loading the package."
    )
  ),
  
  "Activating GermaParl" = list(
    text = c(
      "Now we activate GermaParl simply by calling 'use GermaParl'."
    )
  ),
  
  "Basic functionality: count" = list(
    text = c(
      "The polmIneR can do basic things quite efficiently, such as counting.",
      "But the crucial point is, that whenver we formulate queries,",
      "the powerful syntax of the Corpus Query Processor (CQP) can be",
      "used."
    )
  ),
  
  "Basic functionality: dispersion" = list(
    text = c(
      "We can also count the dispersion of matches for a query across metadata, or 'structural attributes'",
      "as it is called in the jargon of the Corpus Workbench."
    )
  ),
  
  "From statistics to plots" = list(
    text = c(
      "R is known to be great for visualizations.",
      "At any time, we can turn statistics into plots seamlessly."
    )
  ),
  
  "Basic functionality: kwic" = list(
    text = c(
      "A 'keyword-in-context'-view (or KWIC in short) can be displayed,",
      "using the kwic-method."
    )
  ),
  
  "Basic functionality: kwic (metadata)" = list(
    text = c(
      "GermaParl includes all kinds of metadata, which can be used throughout.",
      "Of course, metainformation can be displayed when using the kwic-method."
    )
  ),
  
  "Reading the fulltext" = list(
    text = c(
      "Being able to return to the fulltext of a subcorpus is fundamentally important to implement a",
      "research workflow that warrants validity.",
      "The formula 'code is theory' inspires the development of polmIneR. The package is very flexible to create subcorpora, or partitions, and",
      "to display the fulltext of a partition."
    )
  ),
  
  "Topic modeling and unsupervised classification" = list(
    text = c(
      "For many research scenarios, reasonably designed subsets of the GermaParl corpus will be required.",
      "We offer optimized LDA topic models for",
      "the corpus. Models can be downloaded from a designated webspace. You can use the topic model", 
      "to get a subset of speeches that meet your research interest. The terms with the highest loadings",
      "on a topic can be highlighted. Thus you will know how unsupervised learning has worked out."
    )
  ),
  
  "Annotations and supervised classification" = list(
    text = c(
      "Unsupervised learning is just a first step towards classification. In our CLARIN curation",
      "project, we created a set of manual annotations following the classification scheme",
      "of the Policy Agendas Project. These annotations have been generated in a specialized",
      "web-based annotation environment, and they have been written back to GermaParl.",
      "These annotations can be inspected, and used."
    )
  ),
  
  "Upcoming developments" = list(
    text = c(
      "Next steps for GermaParl are: We will expand the period covered by GermaParl,",
      "we will improve data quality, and we will make further use of the annotations we have",
      "so that subcorpora can be created based on classifications derived from machine learning.",
      "Please stay tuned!"
    )
  )
)

hitkey <- function(flush = FALSE){
  # cat(crayon::italic("Hit key to continue ..."))
  readline()
  if (flush) cat("\014")
  invisible(NULL)
}

#####################################

hitkey(flush = TRUE)

misses_watson_explaining("The GermaParl corpus", clear = FALSE)

misses_watson_explaining("The CWB as indexing and query engine")

misses_watson_explaining("The polmineR package", clear = FALSE)
library(polmineR)

misses_watson_explaining("Activating GermaParl", clear = FALSE)
use("GermaParl")

hitkey(flush = TRUE)

misses_watson_explaining("Basic functionality: count", clear = FALSE)
count("GERMAPARL", query = '"[eE]urop.*"', cqp = TRUE)

misses_watson_explaining("Basic functionality: dispersion", clear = FALSE, wait = FALSE)
europe <- dispersion("GERMAPARL", query = '"[eE]urop.*"', sAttribute = "year", progress = FALSE)
show(europe)

misses_watson_explaining("From statistics to plots", clear = FALSE, wait = FALSE)
barplot(
  europe[["count"]],
  names.arg = europe[["year"]],
  main = "Europe in the German Bundestag",
  las = 2
  )
hitkey(flush = TRUE)


misses_watson_explaining("Basic functionality: kwic", clear = FALSE)
kwic("GERMAPARL", query = '"[eE]urop.*"')
hitkey(flush = FALSE)

misses_watson_explaining("Basic functionality: kwic (metadata)", clear = FALSE)
kwic("GERMAPARL", query = '"[eE]urop.*"', meta = c("speaker", "date"))

hitkey(flush = TRUE)

misses_watson_explaining("Reading the fulltext", clear = FALSE)
scholz <- partition("GERMAPARL", speech = "Olaf Scholz_2009-11-11_3")
read(scholz)

misses_watson_explaining("Topic modeling and unsupervised classification", clear = FALSE)

model <- germaparl_load_topicmodel(k = 250L)
topic_vocabulary <- topicmodels::terms(model, k = 250L)
topic_no <- 181L # topic nuclear energy
PB <- germaparl_get_speeches_for_topic(topic_no)

fulltext <- read(PB[[20]])
fulltext <- highlight(fulltext, list(yellow = topic_vocabulary[1:100, topic_no]))
show(fulltext)

hitkey(flush = TRUE)

misses_watson_explaining("Annotations and supervised classification", clear = FALSE)
P <- partition(
  "GERMAPARL",
  lp = 17, session = 175, speaker = "Fritz Rudolf K\u00F6rper",
  xml = "nested"
)
annotations_inspect(P)

misses_watson_explaining("Upcoming developments", clear = FALSE)



