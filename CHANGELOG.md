CHANGELOG
---------

#### Version 1.1.3 (2024.05.31)
* Refactoring of `coverage` to an R6 class
* Updates to how outliers are handled for artifacts created by `scripts_for_figures_tables`

#### Version 1.1.2 (2024.05.25)
* Updates to summary tabular statistics files
  * Inclusion of unpartitioned statistics for coding and noncoding regions summaries
  * Standardize name of summary groups to `Chromosome`
  * Update WRSD metric to in terms of kilobases
* Updates to `scripts_for_figures_tables`
  * `Figure1` updated to use manual jittering for boxplot with outlier labels
  * Include `Figure1b` in output file
  * Changes to value exactness in some tables
  
#### Version 1.1.1 (2024.05.21)
* Minor fixes to tabular statistics file creation
* A coverage of 0 for a window is always labeled as low coverage

#### Version 1.0.10 (2024.03.23)
* Dynamic changes to `IRCheck` as `PACVr.complete()` progresses
  * If no samples from `gbkFile` contain the qualifiers needed for specified analysis, continues with `IRCheck = NA`
  * If no IR regions are identified, continues with `IRCheck = NA`
  * If there are missing IR regions needed for synteny test, continues with `IRCheck = 0`
  * If no synteny is found, continues with `IRCheck = 0`
  * When `tabularCovStats = TRUE`, if IR mismatches are identified, continues with `IRCheck = NA`
* For `tabularCovStats = TRUE`, summary data corresponding to the complete genome is included in `<sampleName>_summary.regions`
  * `<sampleName>_coverage.summary.regions` has been renamed `<sampleName>_summary.regions`
  * The number of ambiguous nucleotides is always counted, named `N_count`
  * When synteny testing is indicated by `IRCheck` and possible, as detailed above, the number of mismatches between the IRs is counted as `IR_mismatches`
* The evenness metric for `tabularCovStats` has been renamed `E_score`

#### Version 1.0.9 (2024.03.01)
* Improving variable and file names
* Correcting output plot specifications
* Increase logger use, improve logger format

#### Version 1.0.8 (2024.02.28)
* Handling of GenBank features with multiple qualifiers of the same name
* Coverage summaries added to `verbose` output files
* Parameters `syntenyLineType` and `regionsCheck` for `PACVr.complete()` have been combined into `IRCheck`
* Support for PNG `output`
* Samples without `note` can be used for standard coverage analysis
* Sample name in BAM file can match either `VERSION` or `ACCESSION` of GenBank file for `verbose` analysis
* Analysis continues without regions when IR presence test unsuccessful 

#### Version 1.0.7 (2024.02.01)
* More robust parsing of feature sequence locations using INSDC standards
* Exception handling for attempted reading of GenBank data
* "Repair" GenBank data with unqualified features to handle `read.gb` bug 
* Preemptively checks for presence of data property necessary for specified analysis, with `logger` info in case of issues

#### Version 1.0.6 (2024.01.07)
* Moved functions reg. IRs, quadripartite structure into separate file
* Made various plastid-specific functions optional

#### Version 1.0.5 (2023.12.07)
* Minor bugfixes
* New version submitted to CRAN

#### Version 1.0.4 (2023.12.06)
* Implemented a logger
* Several bug fixes (e.g., error caused by function masking)
* Resolve warning caused by depreciated 'dplyr' use
* Resolve need for library calls to RCircos within the code

#### Version 1.0.3 (2023.10.05)
* Replacing dependency 'genbankr' with 'read.gb' and custom functions
* Addition of new contributor: Gregory Smith

#### Version 1.0.2 (2023.10.04)
* Cleaning up of code

#### Version 1.0.1 (2021.04.30)
* Merging changes by Nils Jenke into master

#### Version 1.0.0 (2021.04.16)
* Updates to allow new analyses

#### Version 0.9.5 (2020.11.18)
* Minor updates to keep PACVr compatible with CRAN

#### Version 0.9.4 (2020.09.18)
* Updated README file
* Updated PACVr_Rscript.R
* Updated PACVr-complete.Rd file
* Updated PACVr_Vignette.Rnw
* Replaced flag delete with verbose
* Added additional output regarding the quality of the assembly

#### Version 0.9.3 (2020.07.27)
* Updated README file
* Updated DESCRIPTION file
* Updated PACVr-complete.Rd file
* Updated PACVr-package.rd file
* Updated package vignette
* Updated Unix command-line shell script of PACVr
* Removed system requirement mosdepth
* Added Windows compatibility
* Added low coverage output

#### Version 0.9.2 (2020.02.10)
* Updated README file
* Updated and improved package vignette
* Updated Unix command-line shell script of PACVr

#### Version 0.9.1 (2020.02.07)
* Updated README file
* Updated and improved package vignette

#### Version 0.9.0 (2020.01.31)
* Added functions that add tick marks and position information (in kb) in regular intervals to the genome visualization
* Added functions that evaluate sequence equality among inverted repeats and, if detected, provide reports on differences
* Added functions that enable users to specify the threshold value below which histogram bars are displayed in red as relative value
* Improved the scaling of various vector elements (e.g., fonts) for visualizations of unusually small (<100kb) or unusually large (>200kb) plastid genomes

#### Version 0.8.2 (2019.09.12)
* Several minor bug fixes

#### Version 0.8.0 (2019.07.09)
* Several minor changes to make package compatible with CRAN

#### Version 0.7.5 (2019.07.05)
* Several minor changes to make package compatible with CRAN
* Several minor improvements to DESCRIPTION and NAMESPACE
* Bug fix to import RCircos.Env

#### Version 0.7.0 (2019.07.03)
* Several minor bug fixes

#### Version 0.6.0 (2019.06.14)
* Several minor code improvements
* Several minor improvements to DESCRIPTION and NAMESPACE

#### Version 0.5.0 (2019.06.13)
* Several minor improvements to DESCRIPTION and NAMESPACE
* Several minor improvements to manual and vignette

#### Version 0.4.0 (2019.06.12)
* Several minor code improvements
* Several minor improvements to DESCRIPTION and NAMESPACE
* Added example data (inst/extdata)

#### Version 0.3.0 (2019.05.24)
* Several minor code improvements
* Added preliminary manual
* Added preliminary vignette

#### Version 0.2.0 (2019.03.15)
* Added function PACVr.complete
* Added function SplitCovAtRegionBorders in calcCoverage.R
* Added preliminary documentation files.
