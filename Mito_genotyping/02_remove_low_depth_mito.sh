#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem-per-cpu=20G
#SBATCH --job-name=remove_low_depth_samples_mito

# find depth per sample
# use vcftools
module load vcftools
module load StdEnv/2020 intel/2020.1.217 bcftools/1.11

cd /home/samcrow/scratch/eels2.0/eels4.0/align/freebayes_out2

vcftools --remove-indv BIS22010 --remove-indv BIS22012 --remove-indv BTB22024 \
--remove-indv CNR22017 --remove-indv HRD22003 --remove-indv HRD22012 \
--remove-indv HRD22013 --remove-indv HRP22007 --remove-indv HRP22018 \
--remove-indv LMP22008 --remove-indv LMP22011 --remove-indv LMP22020 \
--remove-indv LMP22023 --remove-indv Negative2 --remove-indv Negative3 \
--remove-indv Negative4 --remove-indv NTC2 --remove-indv NTC --remove-indv NWT22017 \
--remove-indv QVD22004 --remove-indv SRR12854740 --remove-indv SRR12854745 \
--remove-indv SRR12854817 --remove-indv SRR12854843 --remove-indv SRR12854958 \
--remove-indv STC22002 --remove-indv STC22003 --remove-indv STC22004 \
--remove-indv STC22007 --remove-indv STC22010 --remove-indv STC22018 \
--remove-indv TRP22005 --vcf eel_mito_freebayes.vcf \
--recode --stdout | gzip -c > eel_mito_lowfilt.vcf.gz
