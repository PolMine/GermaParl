## General remarks

The 'GermaParl' package has been archived a few weeks ago when the RcppCWB dependency failed to pass checks. Once the 'GermaParl' package makes it to CRAN again, the 'polmineR' package can use the data of the 'GermaParl' package as test data. That way, it will be possible to reduce the size of the polmineR package.

Performing a test download of sample data at times took more than the 5s threshold on my machine (6-7 seconds). It seems that the download sometimes takes less than 5s, sometimes a bit more. I hope this will still be tolerated.


## Test environments

* local MacOS 10.15.3 install, R 4.0.2
* Ubuntu 14.04 (on Travis CI), R 4.0.0
* Windows/AppVeyor, R 4.0.2 Patched
* R win-builder (devel and release), R 4.0.0


## R CMD check results

Occasionally, I see the WARNING that checking the examples has taken more than 5 s (elapsed time > 5s), see explanation above.


## Downstream dependencies

Not yet relevant.
