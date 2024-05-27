#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=get_depthcoverage_from_bams

cd /home/samcrow/scratch/eels2.0/eels4.0/align

module load StdEnv/2023 samtools/1.18

for bam in *.realigned.bam; do samtools coverage $bam -o depth_files/$bam.txt; done
