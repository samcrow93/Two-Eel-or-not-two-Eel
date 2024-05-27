#!/bin/bash
#SBATCH --time=8:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=191840M
#SBATCH --cpus-per-task=44
#SBATCH --nodes=1
#SBATCH --job-name=indel_realign_eel

#load variables
source $paramfile

#load packages
module load nixpkgs/16.09 gatk/3.7

##export to keep parallel happy
export projdir
export genome

cat $projdir/sets/$set | \
   parallel --tmpdir $projdir/gatktemp \
   --jobs 44 \
  ' java -Xmx5g \
  -Djava.io.tmpdir=$projdir/gatktemp\
  -jar $EBROOTGATK/GenomeAnalysisTK.jar  \
 -T IndelRealigner \
 -R $genome \
 -I align/{}.deDup.bam  \
 -targetIntervals align/{}.intervals \
 -o align/{}.realigned.bam '
