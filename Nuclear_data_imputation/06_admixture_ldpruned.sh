#!/bin/bash
#SBATCH --time=144:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=eel_admixture_ldpruned_k1:3


# Run admixture testing K1-3:
module load admixture/1.3.0 StdEnv/2020

for K in {1..3};
do
admixture --cv eel_concat_lowfilt_ldpruned_rename.bed $K -j16
done
