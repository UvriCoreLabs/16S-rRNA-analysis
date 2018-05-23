# 16S-rRNA-analysis
Basic analysis of 16S rRNA sequencing data

## Data Pre-processing
This basically entails three sub-stages which include: quality check, adapter and quality trimming.
We check the quality of the sequencing reads using fastqc. Trim_galore is used to trim low quality reads and adapter sequences.

## Chimera removal
Chimeric sequences are removed using uchime

## Taxonomic classification
This is achieved by using qiime (specifically assign_taxonomy.py script). Alternatives include: morthur, uclust, RDP classifier among others.

## Statistical analysis
In addition to qiime, R packages such as phyloseq, vegan are used.
