#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=ngsadmix_ldpruned


cd /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts/ldpruned_out/

/home/samcrow/programs/NGSadmix -likes eel_concat_like_ldpruned.beagle.gz -K 2 -o ngsadmix/eel_concat_like_ldpruned -P 30
