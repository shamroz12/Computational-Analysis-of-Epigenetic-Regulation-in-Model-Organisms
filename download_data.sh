#!/bin/bash
set -euo pipefail
mkdir -p data/raw data/chip data/rnaseq
echo "Downloading ENCODE narrowPeak (ENCSR000AKP -> ENCFF044JNJ) and GEO processed counts (GSE62944)..."
# ENCODE narrowPeak (replicated peaks) - download the bed.gz for ENCFF044JNJ
wget -O data/chip/ENCFF044JNJ.bed.gz "https://www.encodeproject.org/files/ENCFF044JNJ/@@download/ENCFF044JNJ.bed.gz"
gunzip -f data/chip/ENCFF044JNJ.bed.gz
# GEO GSE62944 processed counts (small sample files and counts)
wget -O data/rnaseq/GSE62944_06_01_15_TCGA_24_CancerType_Counts.txt.gz "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE62nnn/GSE62944/suppl/GSE62944_06_01_15_TCGA_24_CancerType_Counts.txt.gz"
gunzip -f data/rnaseq/GSE62944_06_01_15_TCGA_24_CancerType_Counts.txt.gz
echo "Downloads complete. Please verify files exist in data/chip and data/rnaseq."
