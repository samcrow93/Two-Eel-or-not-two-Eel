#!/bin/bash
#SBATCH --time=10:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
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
   --jobs 32 \
  ' java -Xmx5g \
  -Djava.io.tmpdir=$projdir/gatktemp\
  -jar $EBROOTGATK/GenomeAnalysisTK.jar  \
  -T RealignerTargetCreator \
  -R $genome \
  -I align/{}.deDup.bam \
  -o align/{}.intervals'
