## Workflow for running ngsParalog on eel genotype likelihood data

### 1) Use mpileup_samtools.sh scripts to a) generate mpileup files for each chromosome (required input for ngsParalog), and b) subsequently run ngsParalog on each chromosome mpileup file


### 2) Once .lr files have been generated using ngsParalog, need to filter out loci that have a 'significant' likelihood of having mismapped reads
Using R to generate a list of okay sites (i.e. not significantly likely to have mismapped reads)
```
lr <- read.table('chrom.lr')
lr$pval <- 0.5*pchisq(lr$V5,df=1,lower.tail=FALSE)
lr$pval.adj <- p.adjust(lr$pval, method="bonferroni")
qc.sites <- lr[-which(lr$pval.adj < 0.05),1:2]
write.table(qc.sites,"qc_sites.txt", sep="\t", row.names=F, col.names=F, quote=F)
```

Then, use generated qc_sites files to filter the beagle files with genotype likelihoods for only 'good' sites:
```
# # remove spaces between chrom and position and replace with _
sed -e 's/\s\+/_/g' /home/samcrow/scratch/eel_ngsLD_out/ngsParalog/qc_sites.txt > goodsites.txt

# Filter beagle files:
zcat ../chr.beagle.gz | grep -f goodsites.txt -Fw | gzip > para_filt_chr.beagle.gz
```

### These filtered beagle files can then be used as input for a final run of ngsadmix to ensure that patterns of admixture are not influenced by likely paralogous loci.
