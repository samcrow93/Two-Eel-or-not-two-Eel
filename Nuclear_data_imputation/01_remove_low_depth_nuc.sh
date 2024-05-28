#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem-per-cpu=20G
#SBATCH --job-name=remove_low_depth_samples

# find depth per sample
# use vcftools
module load vcftools
module load StdEnv/2020 intel/2020.1.217 bcftools/1.11

cd /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/imputed

vcftools --remove-indv BIS22010.realigned.bam --remove-indv BTB22024.realigned.bam --remove-indv CNR22017.realigned.bam \
--remove-indv HRD22003.realigned.bam --remove-indv HRD22012.realigned.bam --remove-indv HRD22013.realigned.bam \
--remove-indv HRP22007.realigned.bam --remove-indv HRP22012.realigned.bam --remove-indv HRP22018.realigned.bam \
--remove-indv LMP22008.realigned.bam --remove-indv LMP22011.realigned.bam --remove-indv LMP22020.realigned.bam \
--remove-indv LMP22023.realigned.bam --remove-indv Negative2.realigned.bam --remove-indv Negative3.realigned.bam \
--remove-indv Negative4.realigned.bam --remove-indv NTC2.realigned.bam --remove-indv NTC.realigned.bam --remove-indv NWT22017.realigned.bam \
--remove-indv QVD22004.realigned.bam --remove-indv SRR12854740.realigned.bam --remove-indv SRR12854745.realigned.bam \
--remove-indv SRR12854817.realigned.bam --remove-indv SRR12854843.realigned.bam --remove-indv SRR12854958.realigned.bam \
--remove-indv STC22004.realigned.bam --remove-indv STC22008.realigned.bam --remove-indv STC22017.realigned.bam \
--remove-indv TRP22005.realigned.bam --remove-indv TRP22016.realigned.bam --gzvcf eel_concat.vcf.gz \
--recode --stdout | gzip -c > eel_concat_lowfilt.vcf.gz
