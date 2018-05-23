# 16S-rRNA-analysis
Basic analysis of 16S rRNA sequencing data

## Data pre-processing
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
In this case we are using paired end information, therefore, we may want to merge forward and backward reads. We do this using a program `fq2fa` with `merge` option.
```
fq2fa --merge <forward.fq> <reverse.fq> read12.fa
```

## Chimera detection and removal
Chimeric sequences are removed using uchime
This requires that our sequences are aligned prior to identifying and removing chimeras. Alignment proceeds with pyNast. Alternatives can be used.

##### Alignment
See full documentation by typing `align_seqs.py --help` for other arguments and parameters specific to certain alignment methods. Look up the reference database used for alignment, the same database should be referred to while identifying chimeric reads (`a - argument`)
```
align_seqs.py -i <input_seq.fasta> -m <align.method> -o <align_dir/rep_set_aligned.fasta>
```

Detect and remove chimeric sequences using chimeraslayer. This requires a reference database, an alternative to this is USEARCH which can detect with reference based or de novo. 
```
identify_chimeric_seqs.py -m ChimeraSlayer -i rep_set_aligned.fasta -a reference_set_aligned.fasta -o chimeric_seqs.txt

filter_fasta.py -f rep_set_aligned.fasta -o non_chimeric_rep_set_aligned.fasta -s chimeric_seqs.txt -n
```

## OTU picking 
Here we use usearch, but qiime implements a lot more methods for OTU picking.
```
pick_otus.py -i input.fa -m usearch --word_length 64 --suppress_reference_chimera_detection --minsize 2 -o output_dir/otu_map.txt
```

## Taxonomic classification
This is achieved by using qiime (specifically assign_taxonomy.py script). Alternatives include: morthur, uclust, RDP classifier among others.
```
assign_taxonomy.py -i <input_fasta> -r <ref_outs.fa> -t <map_seq_tax.txt> -o <output_dir>

make_otu_table.py -i otu_map.txt -o otu_table.biom -e chimeric_seqs.txt -t taxonomy.txt
```

## Statistical analysis
In addition to qiime, R packages such as phyloseq, vegan are used.
