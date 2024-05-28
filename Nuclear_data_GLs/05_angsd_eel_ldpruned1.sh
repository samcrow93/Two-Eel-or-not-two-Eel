#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=1angsd_concat_ldpruned

# This script will run ANGSD on the bamfiles and output files only containing sites that have been selected through LD pruning (and after subsetting all markers)
# this run does not contain any of the original filtering parameters (since these have already been taken into effect in previous runs for the site>

#load variables

cd /home/samcrow/scratch/eels2.0/eels4.0/align

module load StdEnv/2023 angsd/0.940

bamfile=/home/samcrow/scratch/eels2.0/eels4.0/bamlist_pruned.tsv
sites=/home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/ngsLD_out/sites/sites1.list
chroms1=/home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/ngsLD_out/sites/chroms1.txt

angsd \
  -nThreads 8 \
  -bam $bamfile \
  -out /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts/ldpruned_out/NC_049201_ldpruned \
  -dobcf 1 \
  -gl 1 \
  -dopost 1 \
  -doGlf 2 \
  -domajorminor 1 \
  -domaf 1 \
  -docounts 1 \
  -dumpCounts 2 \
  -doQsDist 1 \
  -rf $chroms1 \
  -sites $sites
