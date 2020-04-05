## General remarks

This is the initial submission of the GermaParl package. It is a data package with minimal 
functionality to download and augment that actual dataset (a ~1GB corpus). 

Once GermaParl is accepted by CRAN, my package "polmineR" can rely on the test data of the 
GermaParl package, which is a solution for reducing the package size of polmineR which is 
somewhat above the 5MB limit at present.


## Test environments

* local MacOS 10.15.3 install, R 3.6.1
* Ubuntu 14.04 (on travis-ci), R 3.6.2
* MacOS 10.12.6 (on travis-ci), 3.6.2
* Windows/AppVeyor, R 3.6.1 Patched
* R win-builder (devel and release), R. 3.6.1


## R CMD check results

There were no ERRORs, WARNINGs or NOTEs on the Linux / macOS / Windows environments I used. 


## Downstream dependencies

Not relevant at this stage.
