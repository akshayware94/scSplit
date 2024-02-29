# scSplit: Program for spliting BAM file by cell barcodes (CB) and retrive the read counts for user specified genomic coordinates
## Overview

The Bash script is created to divide the BAM file generated from single-cell RNA sequencing (scRNASeq) according to individual cell barcodes (CB). Additionally, the program counts the reads mapping to user-specified genomic coordinates.
This program is also utilized to compute the intron coverage which is required to run the tools for alternative splicing analysis such as, [MARVEL](https://wenweixiong.github.io/MARVEL_Plate.html)

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

#### Load the environment
Activate the conda environment *scSplit* <br />

```
conda activate scSplit
```

#### Running the program

```
bash scSplit.sh [-f] [-b] [-c] [-g] [-n]

	-f Provide BAM file scRNASeq run
	-b Provide text file conatin list of barcode, one barcode per line
	-c Provide BED file conatin chromosome coordinates (user specified genomic regions)
	-g This File contain, first column consists of the chromosome name (chr1, chr2, chr3…) and the second column consists of the chromosome size or length
	-n Provide no of threads to run this program

```

#### Input files

The demo data is containing a BAM file with aligned reads for 5 barcodes given here.

