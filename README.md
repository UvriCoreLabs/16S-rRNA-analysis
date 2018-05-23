# 16S-rRNA-analysis
Basic analysis of 16S rRNA sequencing data

## Data Pre-processing
This basically entails three sub-stages which include: quality check, adapter and quality trimming.
We check the quality of the sequencing reads using `fastqc`. `Trim_galore` is used to trim low quality reads and adapter sequences. The lines indicated below show the basic usage for paired end reads with arbitrary values for the parameters of these programs. One may want to sdjust accordingly.

##### Quality control
```
fastqc <input.fq> -o <output_dir>
```
##### Adapter and quality trimming
```
trim_galore -q 25 --length 75 --dont_gzip --clip_R1 16 --clip_R2 16 --paired forward.fq reverse.fq -o <output_dir>
```

## Chimera removal
Chimeric sequences are removed using uchime

## Taxonomic classification
This is achieved by using qiime (specifically assign_taxonomy.py script). Alternatives include: morthur, uclust, RDP classifier among others.

## Statistical analysis
In addition to qiime, R packages such as phyloseq, vegan are used.
