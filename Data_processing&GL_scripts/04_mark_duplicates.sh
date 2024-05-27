#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=100G
#SBATCH --cpus-per-task=5
#SBATCH --nodes=1
#SBATCH --job-name=mark_duplicates_eel

source $paramfile

module load StdEnv/2023 gatk/4.4.0.0

#export variables to keep parallel happy
export gatk
export projdir

#deduplicate in parallel
cat $projdir/sets/$set | \
  parallel --tmpdir $projdir/gatktemp \
  --jobs 5 \
  'gatk  --java-options "-Xmx5G" \
  MarkDuplicates \
  I=align/{}.sorted.bam \
  O=align/{}.deDup.bam M=align/{}_deDupMetrics.txt \
  REMOVE_DUPLICATES=true \
  TMP_DIR=$projdir/gatktemp '
