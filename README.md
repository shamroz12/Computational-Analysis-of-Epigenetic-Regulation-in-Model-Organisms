# Computational Analysis of Epigenetic Regulation — Real-data-ready Repo

This repository provides a research-grade, reproducible skeleton to analyze how enhancer-associated histone modifications (H3K27ac) relate to differential gene expression in cancer (example: breast cancer).

## Contents
- `download_data.sh` — scripts to download ENCODE narrowPeak (ENCFF044JNJ) and GEO GSE62944 processed counts.
- `workflows/Snakefile` — Snakemake pipeline that ties download → DESeq2 → peak-to-gene → integration → plotting.
- `src/` — scripts:
  - `rnaseq_real.R` — DESeq2 analysis skeleton.
  - `peaks_to_genes.py` — map peaks to nearest genes (placeholder; use bedtools with GTF for production).
  - `integration_real.py` — Fisher's exact test for enrichment of peaks near DE genes.
  - `plotting_real.py` — volcano plot and other figures.
- `docs/methods.md` — methods & parameters.
- `results/` — outputs (generated after running pipeline locally).

## Biological significance (summary)
H3K27ac is a histone modification associated with active enhancers and promoters. Enhancers marked by H3K27ac are often located distal to transcription start sites and can regulate gene expression via chromatin looping. By integrating ChIP-seq peak calls (H3K27ac) with RNA-seq differential expression results (Tumor vs Normal), we can test whether genes near active enhancer marks are over-represented among differentially expressed genes in cancer. A significant enrichment (Fisher's exact test p-value << 0.05) would suggest that enhancer activity — as measured by H3K27ac — contributes to transcriptional dysregulation in tumor samples.

## How to run (local or HPC)
1. Install dependencies (conda recommended). See `environment.yml` for R/Python packages.
2. Run `./download_data.sh` to fetch the necessary public files.
3. Run `snakemake -s workflows/Snakefile --cores 8` to execute the pipeline.
4. Inspect `results/` for DE results, peak->gene mapping, enrichment summary, and figures.

## Notes & caveats
- This repo is *real-data-ready*: it provides commands to download actual ENCODE/GEO files but does not include large raw files in the ZIP.
- For robust results, use the ENCODE processing pipeline outputs, a proper GTF for gene coordinates (e.g., GENCODE), and DESeq2 with careful sample selection and covariate handling.
- Contact: add your name/contact when pushing to GitHub.



## Example Results Included
This repository already includes example outputs in the `results/` folder:
- `results/rnaseq/deseq2_results.csv`: mock DESeq2 results (500 genes).
- `results/chip/ENCFF044JNJ_peaks_nearest_genes.tsv`: example H3K27ac peaks mapped to genes.
- `results/integration/enrichment_summary.csv`: Fisher's exact test enrichment results.
- `results/figures/volcano.png`: a volcano plot figure.

These files were generated from a mini simulated run using real pipeline structure. 
They demonstrate the expected output format and visualization for your GitHub repo.
