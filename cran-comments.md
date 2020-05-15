## General remarks

This is the fourth submission of the 'GermaParl' package. It is a data package with functionality to download and augment the GermaParl dataset (a ~1GB corpus) from an open data repository. Once the 'GermaParl' package is accepted by CRAN, my package 'polmineR' can rely on the test data of the 'GermaParl' package, which is a solution for reducing the package size of 'polmineR' which is  somewhat above the 5MB limit at present.

UPDATES:

- In order to respond to suggestions of Martina Schmirl and Uwe Ligges, I created a small sample dataset with supplementary data that I have deposited at Zenodo (DOI: https://doi.org/10.5281/zenodo.3823245). The workflow presented in the package documentation object now relies on the smaller sample dataset, and is not wrapped in donttest sections any more. It can be applied on the full dataset with minimal modifications explained at the beginning of the example section.

- Performing the download of the sample data at times took more than the 5s threshold on my machine (6-7 seconds). It seems that the download sometimes takes less than 5s, sometimes I see more. I hope this will still be tolerated.

- A comprehensive test to check whether downloading the full corpus works is included in the package tests but will not be run on CRAN machines. It is skipped by calling `testthat::skip_on_cran()`. Tests with the large data set work on my local machine, and on Travis CI and on Appveyor.

- My last submission evoked an error on Debian R-devel that I cannot reproduce via R-hub nor via a Docker container with Debian and a freshly compiled R-devel (r78462). I strongly suspect that Zenodo may have been unavailble for a moment. This is why I submit the package unchanged.

Thanks to the CRAN team - to Uwe and Martina - for their scrutiny that helps to improve the package.


## Test environments

* local MacOS 10.15.3 install, R 4.0.0
* Ubuntu 14.04 (on Travis CI), R 3.6.2
* Windows/AppVeyor, R 3.6.3 Patched
* R win-builder (devel and release), R 4.0.0
* Debian Linux, R-devel, GCC (R-hub builder), R 4.0.0
* Debian Linux, R-devel, GCC (local Docker container), R-devel (r78462)


## R CMD check results

Occasionally, I see the WARNING that checking the examples has taken more than 5 s (elapsed time > 5s), see explanation above.


## Downstream dependencies

Not yet relevant.
