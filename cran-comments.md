## General remarks

This is a quick follow-up to GermaParl v1.5.0 I consider necessary to resolve issues I see on the check results page:

- The 'RcppCWB' had still been listed as a dependency, but was not used, causing a note. The dependency is resolved now.
- Checks failed on Windows because a data were included as a data.table, but the data.table package was not stated as a depenency. The data is now included as a data.frame.

My apologies for not having anticipated thes issues.


## Test environments

* local MacOS 10.15.3 install, R 4.0.2
* Ubuntu 14.04 (on Travis CI), R 4.0.0
* Windows/AppVeyor, R 4.0.2 Patched
* Windows release on R-hub
* Fedora R-devel, local docker container



## R CMD check results

Occasionally, depending on the quality of the internet connection, I see a WARNING that checking the examples has taken more than 5 s (elapsed time > 5s).


## Downstream dependencies

Not yet relevant.
