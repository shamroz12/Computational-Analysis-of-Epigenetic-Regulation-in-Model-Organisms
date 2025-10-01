#!/usr/bin/env python3
import sys, pandas as pd
from scipy.stats import fisher_exact
peaks_file = sys.argv[1]
deseq_file = sys.argv[2]
out = sys.argv[3]
peaks = pd.read_csv(peaks_file, sep='\t')
des = pd.read_csv(deseq_file, index_col=0)
# define DE genes padj < 0.05 and abs(lfc)>1 (adjust to realistic)
if 'padj' in des.columns:
    des['is_de'] = (des['padj'] < 0.05) & (des.get('log2FoldChange',0).abs() > 1)
else:
    des['is_de'] = False
peak_genes = set(peaks['nearest_gene'])
de_genes = set(des[des['is_de']].index)
a = len(peak_genes & de_genes)
b = len(peak_genes - de_genes)
c = len(de_genes - peak_genes)
total = len(des)
d = total - (a+b+c)
odr, p = fisher_exact([[a,b],[c,d]], alternative='greater')
res = pd.DataFrame([{'a':a,'b':b,'c':c,'d':d,'odds_ratio':odr,'p_value':p}])
res.to_csv(out, index=False)
print('Wrote', out)
