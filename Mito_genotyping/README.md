## Genotype and analyze mitochondrial genomes from low coverage data

### 1) Depth for mito genomes is sufficient to call genotypes
Use realigned .bam files (in /align) and 01_freebayes2.sh script to call SNPs and generate one vcf file with all samples

### 2) Remove low-depth (i.e. < 15x, as identified in above section): run 02_remove_low_depth_mito.sh script

### 3) Convert to plink format:
```
module load nixpkgs/16.09 plink/1.9b_4.1-x86_64
# The set-missing-var-ids flag renames variants to keep plink happy; @ is chromosome and # is bp position
plink -vcf eel_mito_lowfilt.vcf.gz -aec -make-bed -set-missing-var-ids @:# -out eel_mito_lowfilt
```
### 4) PCA
```
mkdir pca
plink -vcf eel_mito_lowfilt.vcf.gz -aec -pca -out pca/eel_mito_lowfilt_pca
```
The above code will run a PCA on only the first 20 principal components; to run on all (813) components:
```
plink -vcf eel_mito_lowfilt.vcf.gz -aec -pca 813 -out pca/eel_mito_lowfilt_pca
```

### 5) How many variants in vcf file with low-depth samples removed?
```
bcftools stats eel_mito_lowfilt.vcf.gz
```
### 6) Summary Stats
For stats on proportion of mapped reads and depth, use R to analyse files in /depth_files directory
```
depth <- read.table("/home/samcrow/scratch/eels2.0/eels4.0/align/depth_files/concat_depth.txt")
colnames(depth) <- c("chrom","startpos","endpos","numreads","covbases","coverage","meandepth","meanbaseq","meanmapq","sample")
library(dplyr)
depth2 <- depth %>% select(chrom,numreads,sample) %>% group_by(sample) %>% mutate(tot_reads=sum(numreads)) %>% as.data.frame()
depth3 <- depth2 %>% mutate(chrom_read_prop=(numreads/tot_reads)*100)
depth3$chrom <- as.factor(depth3$chrom)
depth4 <- depth3 %>% group_by(chrom) %>% summarise(mean_chrom_read_prop=mean(chrom_read_prop,na.rm=TRUE)) %>% as.data.frame()
```
Do same thing but for mean coverage on a per-chromosome basis across all samples:
```
depth5 <- depth %>% select(chrom,meandepth,sample) %>% group_by(chrom) %>% summarise(mean_depth_allsamp=mean(meandepth))
```













