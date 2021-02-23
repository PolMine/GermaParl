## General remarks

This is a maintenance release: Resulting from functionality of the 'cwbtools' package that ceased to work robustely, tests for 'GermaParl' v1.5.2 resulted in ERRORS on Windows machines.

A new cwbtools version (v0.3.3) just released at CRAN fixes the issue. GermaParl v1.5.3 requires cwbtools v0.3.3 to ensure that download mechanisms works as intended for all users. 

## Test environments

* local MacOS 10.15.3 install, R 4.0.2
* GitHub Actions (Ubuntu 20.04 release and devel, macOS, Windows), R 4.0.4
* R-Winbuilder R 4.0.4 and R-devel


## R CMD check results

Occasionally, depending on the quality of the internet connection, I see a WARNING that checking the examples has taken more than 5 s (elapsed time > 5s).

## Downstream dependencies

Not yet relevant.
