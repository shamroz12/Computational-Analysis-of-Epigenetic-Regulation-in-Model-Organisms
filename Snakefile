rule all:
    input:
        "results/rnaseq/deseq2_results.csv",
        "results/chip/ENCFF044JNJ_peaks_nearest_genes.tsv",
        "results/integration/enrichment_summary.csv",
        "results/figures/volcano.png"

rule download_data:
    output:
        "data/rnaseq/GSE62944_06_01_15_TCGA_24_CancerType_Counts.txt",
        "data/chip/ENCFF044JNJ.bed"
    shell:
        "./download_data.sh"

rule rnaseq_deseq2:
    input:
        counts="data/rnaseq/GSE62944_06_01_15_TCGA_24_CancerType_Counts.txt",
        meta="data/rnaseq/GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt"
    output:
        "results/rnaseq/deseq2_results.csv"
    shell:
        "Rscript src/rnaseq_real.R {input.counts} {input.meta} {output}"

rule chip_peaks_nearest:
    input:
        "data/chip/ENCFF044JNJ.bed"
    output:
        "results/chip/ENCFF044JNJ_peaks_nearest_genes.tsv"
    shell:
        "python3 src/peaks_to_genes.py {input} results/chip/ENCFF044JNJ_peaks_nearest_genes.tsv"

rule integrate_enrichment:
    input:
        peaks="results/chip/ENCFF044JNJ_peaks_nearest_genes.tsv",
        deseq="results/rnaseq/deseq2_results.csv"
    output:
        "results/integration/enrichment_summary.csv"
    shell:
        "python3 src/integration_real.py {input.peaks} {input.deseq} {output}"

rule plotting:
    input:
        deseq="results/rnaseq/deseq2_results.csv",
        counts="data/rnaseq/GSE62944_06_01_15_TCGA_24_CancerType_Counts.txt"
    output:
        "results/figures/volcano.png"
    shell:
        "python3 src/plotting_real.py {input.deseq} {input.counts} results/figures/volcano.png"
