## GENOTYPE LIKELIHOODS (I.E. NON-IMPUTED DATA)
### 1) Need to remove low-depth individuals
To remove individuals from a beagle file is very clunky:
First, need to match sample names to "Ind#" names used in beagle file:
```
bcftools query -l eels.NC_049201.1.vcf > all_samples.tsv
awk '{print $0,NR}' all_samples.tsv > all_samples.txt
```
Have to go through the all_samples.txt file manually to figure out the numbers for the samples listed in the lownuc_samples.txt file above
Explanation for how this is done is given in actual jobscript
### a) Ultimately to do do the above (i.e. removing samples), run script 01_remove_lowdepth_indivs_beagle.sh

### b) Rename files so they aren't so unwieldy (first chromo listed below, repeat for all other chromosome files too)
```
mv eels.NC_049201.1.beagle.gz.lowfilt.beagle.gz NC_049201.1.beagle.gz
```
### c) Combine all chromosome beagle files together by running 02_combine_beagle.sh script



### 2) NGSLD
### a) subsample concatenated, low-filtered beagle file to very roughly 2.5 million markers by selecting every 10th line
also remove first three columns (recommendation from https://github.com/therkildsen-lab/genomic-data-analysis/blob/master/markdowns/ld.md#ld-estimation)
```
zcat eel_concat_like_copy.beagle.gz | awk 'NR % 10 == 0' | cut -f 4- | gzip  > subsampled_eel.beagle.gz
```

### b) create position file that matches subsampled beagle file (which no longer has position info):
The line below will separate the position from chromosome by replacing _ with tab, then selects only the first 2 cols, then every 10 lines
```
zcat eel_concat_like_copy.beagle.gz | sed 's/_/\t/2' | cut -f 1,2 | awk 'NR % 10 == 0' | gzip > subsampled_pos.txt.gz
```

c) run 03_ngsld_concat.sh script

### d) run 04_eel_LD_prune.sh script
This will output a file with a list of chromosomes and positions of sites that are in linkage equilibrium
Modify this file so that chromosomes and positions are separated by a tab instead of a :
```
cat *.pos | sed 's/:/\t/' > unlinked_sites.txt
```
Next, need to run angsd again to output beagle files with only pruned sites and samples with sufficient depth
Run on a per-chromosome basis (submit separate jobs)
Use pruned_sites.list (modified in R) to generate sites files for each chromosome:
```
grep "NC_049201.1" pruned_sites.list > sites/sites1.list #etc
```
Also need to index these
```
module load StdEnv/2023 angsd/0.940
angsd sites index sites#.list #etc
```
Also generate chromosome files to specify region for each new angsd run:
```
echo "NC_049201.1" > sites/chroms1.txt # etc
```
Then, run 05_angsd_eel_ldpruned#.sh scripts (one for each chromosome, example for NC_049201 in this repository)


### 3) PCANGSD
### a) need to create a virtual environment to run python
Create this virtual environment under the /home/samcrow directory:
```
virtualenv --no-download python_env

# Load python interpreter:
module load StdEnv/2020 python/3.10.2

# Activate the virtual environment:
source python_env/bin/activate

# Upgrade pip in the environment:
pip install --no-index --upgrade pip

# Install latest version of Numpy:
pip install numpy --no-index

# To deactivate virtual environment:
deactivate
```

### b) run PCANGSD
Copy chromsnuc object from /home/samcrow/scratch/eels2.0/eels4.0 into ./align/nuc_angsd_out2 directory
Submit jobs (one per chromosome file) for all (non-pruned) data:
```
while read chromsnuc; do sbatch --export=ALL,chromsnuc=$chromsnuc 06_pcangsd_allchr.sh ; done < chromsnuc
```
Repeat with ld-pruned data:
First need to create chromsnuc_pruned with "NC_049201_ldpruned" etc; then submit 07_pcangsd_ldpruned.sh script as follows:
```
while read chromsnuc_pruned; do sbatch --export=ALL,chromsnuc_pruned=$chromsnuc_pruned 07_pcangsd_ldpruned.sh; done < chromsnuc_pruned
```

### c) run PCANGSD on all chromosomes together (concatenate beagle files):
Run 08_combine_beagle.sh and 09_combine_beagle_ldpruned.sh scripts
Then run 10_pcangsd_concat_like_all.sh script (****NOTE: it will run out of memory even on a 500G node for the script as-is (i.e. with admixture etc.), BUT it will complete the covariance matrix which is all we need for the PCA**)


### 4) NGSadmix
Run ngsAdmix on concatenated, ld-pruned beagle file using 11_admix_ldpruned.sh script






