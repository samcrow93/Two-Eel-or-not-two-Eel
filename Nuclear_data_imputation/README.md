## Workflow to process data output by ANGSD and impute genotypes
### 1) First, need to concatenate all chromosomes together into one vcf file (in /imputed directory):
```
bcftools concat -Oz  NC_0492*.1.vcf.gz > eel_concat.vcf.gz
```
### 2), Next, need to exclude samples that have very low depth (remove any with average coverage of any chromosome that is < 0.5X)
Use 01_remove_low_depth_nuc.sh script

### 2.5) How many variants? (full, un-pruned dataset):
```
bcftools stats eel_concat_lowfilt.vcf.gz
```

### 3) Convert file (eel_concat_lowfilt.vcf.gz) to PLINK format:
```
mkdir plinkfiles/
module load nixpkgs/16.09 plink/1.9b_4.1-x86_64
# The set-missing-var-ids flag renames variants to keep plink happy; @ is chromosome and # is bp position
plink -vcf eel_concat_lowfilt.vcf.gz -aec -make-bed -set-missing-var-ids @:# -out plinkfiles/eel_concat_lowfilt
```
### 4) Filter for LD
Can filter very stringently since there are >25 million markers; need far fewer for things to run and finish in reasonable time.
Prune based on R2 value of 0.1 (get rid of anyting above that).
Output file ending in .prune.in contains IDs of variants in linkage equilibrium (good guys); .prune.out=bad guys:
```
plink -bfile eel_concat_lowfilt -aec -indep-pairwise 50 5 0.1 -out eel_concat_lowfilt
```
Then, extract (and keep) those variants that are in the prune.in file:
```
plink -bfile eel_concat_lowfilt -aec -extract eel_concat_lowfilt.prune.in -make-bed -out eel_concat_lowfilt_ldpruned
```
### 5) PCA
Do a pca on both the full dataset and also the one filtered for LD:
```
mkdir pca
plink -vcf eel_concat_lowfilt.vcf.gz -aec -pca -out pca/eel_concat_lowfilt_pca
```
Need to convert plink files to vcf for pca on ld-pruned data:
```
plink --bfile eel_concat_lowfilt_ldpruned --aec --recode vcf --out eel_concat_lowfilt_ldpruned
```
Find how many variants left after LD pruning:
```
bcftools stats eel_concat_lowfilt_ldpruned.vcf.gz
```
Then, run 02_zip_eel.sh script to zip the vcf file.

Finally, run a pca on the ld-filtered data:
```
plink -vcf eel_concat_lowfilt_ldpruned.vcf.gz -aec -pca -out pca/eel_concat_lowfilt_ldpruned_pca
```
### 6) Admixture
Admixture will not accept alternative chromosomes names:
Run 03_rename_vcf.sh script.
Then, convert renamed vcf back to plink files:
```
module load nixpkgs/16.09 plink/1.9b_4.1-x86_64
plink -vcf eel_concat_lowfilt_rename.vcf.gz -aec -make-bed -out eel_concat_lowfilt_rename
```
Then, run 04_admixture.sh script

Next, do the same for the ld-filtered data (after renaming and converting back to plink files):
Start by running 05_rename_ldpruned.sh script to rename chromosomes:
```
module load nixpkgs/16.09 plink/1.9b_4.1-x86_64
plink -vcf eel_concat_lowfilt_ldpruned_rename.vcf.gz -aec -make-bed -out eel_concat_lowfilt_ldpruned_rename
```
Finally, run 06_admixture_ldpruned.sh script


