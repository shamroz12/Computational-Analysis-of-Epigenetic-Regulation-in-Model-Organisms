#!/usr/bin/env python3
import sys, pandas as pd, matplotlib.pyplot as plt, numpy as np, os
deseq = sys.argv[1]
counts = sys.argv[2]
out = sys.argv[3]
os.makedirs(os.path.dirname(out), exist_ok=True)
des = pd.read_csv(deseq, index_col=0)
if 'padj' not in des.columns and 'pvalue' in des.columns:
    des['padj'] = des['pvalue']
des = des.dropna(subset=['padj','log2FoldChange'])
des['-log10padj'] = -np.log10(des['padj'] + 1e-300)
plt.figure(figsize=(6,5))
plt.scatter(des['log2FoldChange'], des['-log10padj'], s=6, alpha=0.6)
top = des.nsmallest(50, 'padj')
plt.scatter(top['log2FoldChange'], -np.log10(top['padj']+1e-300), s=12, color='red')
plt.xlabel('log2 fold change')
plt.ylabel('-log10 adj p')
plt.title('Volcano plot (real-data-ready)')
plt.savefig(out, bbox_inches='tight')
print('Saved', out)
