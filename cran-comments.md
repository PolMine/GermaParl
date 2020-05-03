## General remarks

This is the second submission of the 'GermaParl' package. It is a data package with essential functionality to download and augment the GermaParl dataset (a ~1GB corpus). Once the 'GermaParl' package is accepted by CRAN, my package 'polmineR' can rely on the test data of the 'GermaParl' package, which is a solution for reducing the package size of 'polmineR' which is  somewhat above the 5MB limit at present.

UPDATE: I received valuable feedback from Martina Schmirl on v1.4.0 that is addressed to the best of my knowledge.

1. The previous version used the directory structure of the GermaParl package to store downloaded data. This is not in line with CRAN policies, as explained by Martina. The new version will store the data externally. It will rely on a modified function of the 'cwbtools' package that I have reworked for that purpose (cwbtools v0.2.0).

2. I had `setwd()` command in a demo, without resetting the working directory to its initial condition. As I realized that the demo requires user credentials and would not run on other users' machines, I removed the demo altogether. 

3. The \dontrun{} sections in examples are replaced by \donttest{}. The examples do work, but as they require downloading 1 GB of data, I wanted to prevent that these examples are executed when the package is checked in CRAN machines. Thanks to Martina for explaining the difference, and my apologies for not being aware of it.

4. The return values of functions are now described in \value{} sections of the documentation objects throughout, as suggeested by Martina.


## Test environments

* local MacOS 10.15.3 install, R 3.6.1
* Ubuntu 14.04 (on travis-ci), R 3.6.2
* MacOS 10.12.6 (on travis-ci), 3.6.2
* Windows/AppVeyor, R 3.6.1 Patched
* R win-builder (devel and release), R. 3.6.1


## R CMD check results

There were no ERRORs, WARNINGs or NOTEs on the Linux / macOS / Windows environments I used. 


## Downstream dependencies

Not yet relevant.
