# scSplit: Program for spliting BAM file by cell barcodes (CB)
## Overview

The Bash script is created to divide the BAM file generated from single-cell RNA sequencing (scRNASeq) according to individual cell barcodes (CB). Additionally, the program counts the reads mapping to user-specified genomic coordinates.

## Getting Started

#### Prerequisite
  ```
   Please make sure that the `conda` or `mamba` is installed and available on your system prior to run the requirements.yml
  ```
If the above prerequisites are satisfied, you are ready to install conda packages/dependencies and build the program.

To obtain *scSplit*, Use: <br />
```
git clone https://github.com/akshayware94/scSplit.git
cd scSplit/
```
Assuming that you have downloaded the source code and it is in a directory `scSplit/`, to install all dependencies run the following command: <br />

```
mamba env create -f requirements.yml
```
After the successful execution of `requirements.yml` you are ready to run the main script `scSplit.sh`.


