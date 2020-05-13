## General remarks

This is the third submission of the 'GermaParl' package. It is a data package with functionality to download and augment the GermaParl dataset (a ~1GB corpus) from an open data repository. Once the 'GermaParl' package is accepted by CRAN, my package 'polmineR' can rely on the test data of the 'GermaParl' package, which is a solution for reducing the package size of 'polmineR' which is  somewhat above the 5MB limit at present.

UPDATE: In order to respond to suggestions of Martina Schmirl and Uwe Ligges, I created a small sample dataset with supplementary data that I have uploaded to Zenodo (DOI: https://doi.org/10.5281/zenodo.3823245). The workflow presented in the package documentation object now relies on the smaller sample dataset, and is not wrapped in donttest sections any more. It can be applied on the full dataset with minimal modifications explained at the beginning of the example section.

Performing the download of the sample data at times took more than the 5s threshold on my machine (6-7 seconds). I hope this will still be tolerated.

A comprehensive test to check whetheer downloading the full corpus works is included in the package tests but will not be run on CRAN machines.

Thanks to the CRAN team - to Uwe and Martina - for their scrutiny that helps to improve the package.


## Test environments

* local MacOS 10.15.3 install, R 4.0.0
* Ubuntu 14.04 (on travis-ci), R 3.6.2
* Windows/AppVeyor, R 3.6.3 Patched
* R win-builder (devel and release), R. 4.0.0


## R CMD check results

There were no ERRORs, WARNINGs or NOTEs on the Linux / macOS / Windows environments I used. 


## Downstream dependencies

Not yet relevant.
