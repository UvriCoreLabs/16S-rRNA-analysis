
### Workflows for analysis of 16S rRNA sequence data

Here we use two pipelines to do bioinformaic and statistical analyses of 16S rRNA sequence data.
Both workflows follow a generic analysis sub processes including but not limited to data preprocessing, quality control, adapter and quality trimming, removal of chimeras, otu-picking and taxonomic classification/identification.

One of the workflows hugely depends on qiime in addition to a few other stand alone tools. The second workflow entirely focused on dada2 a dedicated pipeline to 16S analysis built in R. See `dada2analysis.R` .

Once these pipelines are stable and properly implemented, we hope to have them run on local galaxy instance. These will be updated through time as may deem necessary.

See full description at the [wiki](https://github.com/AlfredUg/16S-rRNA-analysis/wiki).
