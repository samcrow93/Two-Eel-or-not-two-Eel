#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=eel_bwamem_align


#load variables
source $paramfile

## Load software modules
module load samtools
module load StdEnv/2020
module load bwa-mem2/2.2.1

#change directory and align all reads
cd $projdir/trim

while read outfile;
  do echo $outfile\.bam ;
  bwa-mem2 mem \
  -t 32 \
  -R "@RG\tID:$outfile\tSM:$outfile\tLB:eel" \
  $genome \
  $outfile\_R1.trimmed.fastq.gz  $outfile\_R2.trimmed.fastq.gz\
  | samtools sort -o $projdir/align/$outfile\.sorted.bam -T $outfile -@ 32 -m 3G ;
  done < $projdir/sets/$set



