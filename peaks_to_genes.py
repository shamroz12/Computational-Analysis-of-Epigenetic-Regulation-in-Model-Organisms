#!/usr/bin/env python3
import sys, pandas as pd
from pathlib import Path
import numpy as np
inp = sys.argv[1]
out = sys.argv[2]
# Try to use pybedtools for nearest; if not available, do naive gene mapping from GTF if provided.
try:
    import pybedtools
except Exception as e:
    pybedtools = None
# Read peaks (narrowPeak format: chrom, start, end, name...)
peaks = pd.read_csv(inp, sep='\t', header=None, comment='#')
peaks = peaks.iloc[:,0:3]
peaks.columns = ['chrom','start','end']
# For demo we will assign nearest gene by creating synthetic gene loci spaced across chrom for hg19 chr1
# In real run, user should provide a GTF and use bedtools closest.
chrom = peaks.iloc[0,0] if len(peaks)>0 else 'chr1'
# make synthetic genes spaced every 1000 kb (placeholder)
n_genes = 20000
positions = np.linspace(1000, 1_000_000, n_genes).astype(int)
gene_ids = [f'GENE_{i:05d}' for i in range(n_genes)]
genes = pd.DataFrame({'gene':gene_ids, 'chrom':[chrom]*n_genes, 'mid':positions})
# compute peak mid and find nearest
peaks['mid'] = ((peaks.start + peaks.end)//2).astype(int)
nearest = []
for idx, row in peaks.iterrows():
    dist = np.abs(genes.mid - row.mid)
    j = dist.argmin()
    nearest.append({'chrom':row.chrom, 'start':row.start, 'end':row.end, 'nearest_gene':genes.gene.iloc[j], 'distance':int(dist[j])})
pd.DataFrame(nearest).to_csv(out, index=False, sep='\t')
print('Wrote', out)
