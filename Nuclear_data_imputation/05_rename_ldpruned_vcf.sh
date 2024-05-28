#!/bin/bash
#SBATCH --time=10:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=rename_vcf

module load StdEnv/2020 gcc/9.3.0 bcftools/1.9

bcftools annotate --rename-chrs chr_name_conv.txt eel_concat_lowfilt_ldpruned.vcf.gz -Oz -o eel_concat_lowfilt_ldpruned_rename.vcf.gz
