require(dada2)
require(ShortRead)

#Get the list of all files in the current directory and sort to ensure forward/reverse reads are in the same order
fastqs<-sort(list.files("."))

#Extract the forward and reverse reads
fnFs <- fastqs[grepl("_R1", fastqs)]
fnRs <- fastqs[grepl("_R2", fastqs)]

#Get the sample names
sample.names <- sapply(strsplit(fnFs, "_"), `[`, 1)

# Fully specify the path for the fnFs and fnRs
fnFs <- file.path(".", fnFs)
fnRs <- file.path(".", fnRs)

#Filter the forward and reverse reads
# Make directory and filenames for the filtered fastqs
filt_path <- file.path(".", "filtered")
if(!file_test("-d", filt_path)) dir.create(filt_path)
filtFs <- file.path(filt_path, paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(filt_path, paste0(sample.names, "_R_filt.fastq.gz"))
# Filter
for(i in seq_along(fnFs)) {
  fastqPairedFilter(c(fnFs[i], fnRs[i]), c(filtFs[i], filtRs[i]),
                    trimLeft=c(10, 10), truncLen=c(240,160),
                    maxN=0, maxEE=2, truncQ=2,
                    compress=TRUE, verbose=TRUE)
}

#Dereplicate the filtered fastq reads
derepFs <- derepFastq(filtFs, verbose=TRUE)
derepRs <- derepFastq(filtRs, verbose=TRUE)
# Name the derep-class objects by the sample names
names(derepFs) <- sample.names
names(derepRs) <- sample.names

#Perform joint sample inference and error rate estimation (takes a few minutes):
dadaFs <- dada(derepFs, err=NULL, selfConsist = TRUE)
dadaRs <- dada(derepRs, err=NULL, selfConsist = TRUE)
#The learned error rates are as follows
errF <- dadaFs[[1]]$err_out
errR <- dadaRs[[1]]$err_out
#Rerun with the error rates
dadaFs <- dada(derepFs, err=errF)
dadaRs <- dada(derepRs, err=errR)

#Merge the denoise forward and reverse reads:
mergers <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose=TRUE)

#Construct sequence table
seqtab <- makeSequenceTable(mergers)

#Remove chimeric sequences
seqtab.nochim <- removeBimeraDenovo(seqtab, verbose=TRUE)
#Assign taxonomy:
taxa <- assignTaxonomy(seqtab.nochim, "/home/opt/DADA2_assignTaxonomy/silva_nr_v123_train_set.fa.gz")
colnames(taxa) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus")
#Save sequence file:
sink("seqs.fa");cat(paste(">","SEQ_",seq(1:dim(seqtab.nochim)[2]),"\n",paste(colnames(seqtab.nochim),"\n",sep=""),sep=""),sep="");sink()

seqtab.final<-seqtab.nochim
colnames(seqtab.final)<-paste("SEQ_",seq(1:dim(seqtab.nochim)[2]),sep="")

#Save the sequence table:
write.csv(t(seqtab.final),"seq_table.csv",quote=F)

#Save the sequence taxonomy:
write.table(data.frame(row.names=paste("SEQ_",seq(1:dim(seqtab.nochim)[2]),sep=""),unname(taxa)),"seq_Taxonomy.csv",sep=",",col.names=F,quote=F,na="")
