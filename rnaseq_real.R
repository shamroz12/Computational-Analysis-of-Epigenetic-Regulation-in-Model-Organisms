#!/usr/bin/env Rscript
# Usage: Rscript rnaseq_real.R counts.txt samples.txt out.csv
args <- commandArgs(trailingOnly=TRUE)
counts_file <- args[1]
samples_file <- args[2]
out_file <- args[3]
library(DESeq2)
library(data.table)
counts <- fread(counts_file, data.table=FALSE)
# Expecting first column as gene and sample columns after; adjust as needed.
rownames(counts) <- counts[,1]
counts <- counts[,-1]
# Load sample metadata to select breast cancer vs normal (user should prepare samples file)
if (file.exists(samples_file)) {
  samples <- fread(samples_file, data.table=FALSE)
  # samples should have columns: sample, condition (Tumor/Normal)
  samples <- samples[samples$sample %in% colnames(counts),]
  coldata <- data.frame(row.names=samples$sample, condition=factor(samples$condition))
  dds <- DESeqDataSetFromMatrix(countData=as.matrix(counts[,samples$sample]), colData=coldata, design=~condition)
} else {
  # fallback: treat first half samples as control, second half as treated
  cn <- colnames(counts)
  n <- length(cn)
  cond <- c(rep('Normal', n/2), rep('Tumor', n - n/2))
  coldata <- data.frame(row.names=cn, condition=factor(cond))
  dds <- DESeqDataSetFromMatrix(countData=as.matrix(counts), colData=coldata, design=~condition)
}
dds <- DESeq(dds)
res <- results(dds)
res_df <- as.data.frame(res)
write.csv(res_df, out_file)
cat('Wrote', out_file, '\n')
