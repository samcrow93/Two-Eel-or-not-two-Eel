## This section outlines steps taken from processing raw fastq files through to generation of genotype likelihoods with ANGSD

## Data Processing
### 1.1) Set up directory structure:
Within directory where raw files are stored, create the following subdirectories:
```
mkdir sets
mkdir trim
mkdir align
mkdir angsd_out
mkdir angsd_in
```
### 1.2) Create parameters file (eels_WGS_params.txt)
The following text is within the parameters file (specify where software and genome is located):
```
#locations
#main directory for project (where raw fastq files are stored)
projdir=/home/samcrow/scratch/eels2.0/eels4.0

#sample info
#genome file location (includes mitogenome)
genome=/home/samcrow/scratch/eels2.0/eels4.0/genome/GCF_013347855.1_fAngAng1.pri_genomic.fna

#genus
genus=$(echo Anguilla)

#software
#trimming
fastp=/home/samcrow/programs/fastp

#aligning
bwamem2=/home/samcrow/programs/bwa-mem2-2.2.1_x64-linux/bwa-mem2

#gatk
gatk=/home/samcrow/programs/gatk-4.4.0.0/gatk
```
### 1.3) Create set files
This needs to be done because there are so many large files, so split them into sets to run on separate jobs.
Change into main working directory:
```
cd /home/samcrow/scratch/eels2.0/eels4.0

ls *R1.fastq.gz | \
 sed 's/\_R1.fastq.gz//' > ../sets/eel_inds.tsv

split -l 100 \
 -d \
../sets/eel_inds.tsv \
../sets/eel.set
```
This will generate sets 00 to 08.

### 2.0) Read Trimming
Use job script 01_fastp.sh. Trimmed files will be output into trim/ directory

### 3.0) Alignment
First, need to index the genome- run script 02_index_genome.sh

Next, do the alignment using the 03_bwamem2_align.sh script
Submit using the following command instead of normal sbatch:
```
for i in {00..08}
do
sbatch --export=ALL,set=eel.set$i,paramfile=eels_WGS_params.txt 03_bwamem2_align.sh
done
```
This will generate .bam files sorted by position in the align/ directory

### 4.0) Refining alignments - Preparation
Use the genome analysis toolkit (gatk) to remove sequence duplicates.
First, need to create a directory for the temporary files made by gatk:
```
mkdir gatktemp
```
Next, submit the 04_mark_duplicates.sh jobscript as follows:
```
for i in {00..08}
do
sbatch --export=ALL,set=eel.set$i,paramfile=eels_WGS_params.txt 04_mark_duplicates.sh
done
```
Next, create a sequence dictionary for use in indel realignment using the 05_genome_sequencedictionary.sh script:
```
sbatch --export=ALL,paramfile=eels_WGS_params.txt 05_genome_sequencedictionary.sh
```
The deduplicated alignment files also needs to be indexed (using the 06_index_dedup.sh script):
```
for i in {00..08}
do
sbatch --export=ALL,set=eel.set$i,paramfile=eels_WGS_params.txt 06_index_dedup.sh
done
```
### 5.0) Refining alignments- indel realignment
First, need to identify realignment targets using GATK (deprecated version) using 07_indel_target.sh script:
```
for i in {00..08}
do
sbatch --export=ALL,set=eel.set$i,paramfile=eels_WGS_params.txt 07_indel_target.sh
done
```
Then, actually update the alignments (using 08_indel_realign.sh script):
```
for i in {00..08}
do
sbatch --export=ALL,set=eel.set$i,paramfile=eels_WGS_params.txt 08_indel_realign.sh
done
```
## Genotyping nuclear data using ANGSD
### 1) Create ANGSD parameters file called angsd_params.txt with the following paramters:
```
bamfile=/home/samcrow/scratch/eels2.0/eels4.0/bamlist.tsv
runname=eels
midInd=670
minDepth=1700
```
Also need to create bamlist.tsv:
```
ls /home/samcrow/scratch/eels2.0/eels4.0/align/*.realigned.bam > bamlist.tsv
```
Also need to create list of chromosomes (only want nuclear chromosomes for this):
```
cut -f1 /home/samcrow/scratch/eels2.0/eels4.0/genome/GCF_013347855.1_fAngAng1.pri_genomic.fna.fai | grep "NC" | grep -v "006531" > chromsnuc
```
### 2) Run ANGSD
Submit 09_angsd_eel.sh script as follows:
```
while read chromsnuc
do
sbatch --export=ALL,chromsnuc=$chromsnuc,paramfile=eels_WGS_params.txt,angsdparam=angsd_params.txt 09_angsd_eel.sh
done < chromsnuc
```
### 3) Convert bcf files output by ANGSD to vcf files.
Submit 10_bcf_to_vcf.sh script as follows:
```
while read chromsnuc
do
sbatch --export=ALL,chromsnuc=$chromsnuc,paramfile=eels_WGS_params.txt,angsdparam=angsd_params.txt 10_bcf_to_vcf.sh
done < chromsnuc
```
## Filtering for depth
### 1) Filter for super low-depth samples (to be removed prior to further analysis).
a) First, need to calculate depths for each sample (nuclear and mito chromosomes)
```
cd /home/samcrow/scratch/eels2.0/eels4.0/align
mkdir depth_files
```
Run 11_eel_depth_from_bams.sh script on *.realigned.bam files in /align directory; outputs to depth_files directory

b) Next, need to concatenate all .txt files with depth and coverage info
```
cd depth_files
output_file="concat_depth.txt"
touch $output_file

for f in *realigned.bam.txt
do filename=$(basename "$f")
filename="${filename%.*}"
echo "Appending file: $f"
tail -n +2 "$f" | awk -v filename="$filename" '{print $0 "\t" filename}' >> "$output_file"
done
```
This will return a file of all the coverage/depth info per sample concatenated, with the file name in a new column

c) Next, need to search for samples with very low depth (do this for mito genomes and nuclear chromosomes).
The following code searches for samples with mito genome coverage less than 15x (defined as "mid-coverage" by Watowich et al. 2023)
```
awk '$7 < 15 && /NC_006531.1/' concat_depth.txt | awk '{print $10}' | sort -u > lowmito_samples.txt
```
Same thing for nuclear chromosomes, but use coverage= 0.5x (imputation found to be reliable to this level by Watowich et al. 2023)
```
awk '$7 < 0.5 && /NC_049/' concat_depth.txt | awk '{print $10}' | sort -u >> lownuc_samples.txt
```
Cleanup: Delete the ".realigned.bam" from each line in the file
```
sed -i 's/\.realigned\.bam//g' lowmito_samples.txt
```
The above code will generate samples that need to be removed from analysis further on.
Proceed to either 'B) Nuclear data: genotype likelihoods'; 'C) Nuclear data: genotype imputation'; or 'D) Mitochondrial data genotyping' sections for next steps


