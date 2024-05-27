#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --job-name=index_dedup_eel


#load variables
source $paramfile

module load samtools

##export to keep parallel happy
export projdir

cat $projdir/sets/$set | \
   parallel --jobs 32  'samtools index align/{}.deDup.bam '

