## General remarks

The 'GermaParl' package has been present at CRAN already and has been archived when the RcppCWB failed to pass checks. Once the 'GermaParl' package is accepted by CRAN, my package 'polmineR' can rely on the test data of the 'GermaParl' package.

Performing the download of the sample data at times took more than the 5s threshold on my machine (6-7 seconds). It seems that the download sometimes takes less than 5s, sometimes I see more. I hope this will still be tolerated.


## Test environments

* local MacOS 10.15.3 install, R 4.0.2
* Ubuntu 14.04 (on Travis CI), R 4.0.0
* Windows/AppVeyor, R 4.0.2 Patched
* R win-builder (devel and release), R 4.0.0
* Debian Linux, R-devel, GCC (R-hub builder), R 4.0.0
* Debian Linux, R-devel, GCC (local Docker container), R-devel (r78462)


## R CMD check results

Occasionally, I see the WARNING that checking the examples has taken more than 5 s (elapsed time > 5s), see explanation above.


## Downstream dependencies

Not yet relevant.
