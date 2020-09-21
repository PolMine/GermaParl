## General remarks

Brian Ripley alerted me that the previous GermaParl version failed to fully meet the CRAN Repository Policy. To improve, changes this package has seen are:

- Calling download.file() is now wrapped in tryCatch(). If downloading Internet resources fails, the calling function - germaparl_download_lda() - will fail gracefully issuing a warning.
- A test for md5 checksums is now performed for data that has been downloaded.
- An error seen in the OpenBLAS tests results from a difficulty of zen4R to parse Zenodo's if the API is temporarily unavailable. To make GermaParl more robust for this scenario, the invocation of ZenodoManager$new()$getRecordByDOI() is wrapped in tryCatch().


## Test environments

* local MacOS 10.15.3 install, R 4.0.2
* Ubuntu 14.04 (on Travis CI), R 4.0.0
* Windows/AppVeyor, R 4.0.2 Patched
* Windows release on R-hub


## R CMD check results

Occasionally, depending on the quality of the internet connection, I see a WARNING that checking the examples has taken more than 5 s (elapsed time > 5s).


## Downstream dependencies

Not yet relevant.
