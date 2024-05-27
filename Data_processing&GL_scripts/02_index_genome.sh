#!/bin/bash
#SBATCH --time=8:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=0
#SBATCH --nodes=1
#SBATCH --job-name=genome_index_eel

#load variables
source eels_WGS_params.txt

# Load software modules
module load samtools

#change directory and align all reads
cd $projdir/genome

$bwamem2 index $genome
samtools faidx $genome
