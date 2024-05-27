#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=angsd_full

#load variables
source $paramfile
source $angsdparam

cd $projdir/align

module load StdEnv/2023 angsd/0.940


angsd \
  -nThreads 8 \
  -bam $bamfile \
  -out $projdir/align/nuc_angsd_out2/$runname.$chromsnuc \
  -dobcf 1 \
  -gl 1 \
  -dopost 1 \
  -doGlf 2 \
  -domajorminor 1 \
  -domaf 1 \
  -docounts 1 \
  -dumpCounts 2 \
  -doQsDist 1 \
  -minMapQ 30 \
  -minQ 30 \
  -minInd $minInd \
  -SNP_pval 2e-6 \
  -uniqueOnly 1 \
  -minMaf 0.05 \
  -setMinDepth $minDepth \
  -r $chromsnuc \
  -remove_bads 1 \
  -only_proper_pairs 1
