#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --job-name=genome_sequence_dictionary_eel

#get source data
source $paramfile

module load StdEnv/2023 gatk/4.4.0.0

#make a sequence dictionary using gatk
gatk CreateSequenceDictionary -R $genome
