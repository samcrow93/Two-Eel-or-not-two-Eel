#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=bgzip_eel

module load StdEnv/2023 samtools/1.18
module load tabix/0.2.6 StdEnv/2020 intel/2020.1.217

bgzip -c eel_concat_lowfilt_ldpruned.vcf > eel_concat_lowfilt_ldpruned.vcf.gz
