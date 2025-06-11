#!/bin/bash
#SBATCH --time=
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=
#SBATCH --job-name=2mpileup_ngsparalog_eels

module load StdEnv/2020 gcc/9.3.0
module load samtools

genome=/home/samcrow/eel_genome/GCF_013347855.1_fAngAng1.pri_genomic.fna
bamfile=/home/samcrow/scratch/eels/angsd_properly_filtered/lowfilts/eel_final_samples.txt
sites2=/home/samcrow/scratch/eels/angsd_properly_filtered/lowfilts/ngsLD_out/sites/sites2.list

# Use this to generate an mpileup file to use in ngsparalog
# samtools mpileup is deprecated now, BUT ngsParalog requires samtools format mpileup file as input :/
# Run separately for each chromosome, and only consider sites for which ANGSD calculated genotype likelihoods already


# bamlist is samples that pass the low-depth cutoff (i.e. have already removed very low-depth samples from this list)
# Mapping/read quality is not parameterized for samtools mpileup because ngsParalog needs to see all the reads regardless of quality as per documen>
cd /home/samcrow/scratch/eels/realigned_bams/

samtools mpileup -f $genome -b $bamfile -q 0 -Q 0 -r NC_049202.1 -l $sites2 > /home/samcrow/scratch/eels/mpileup/chrom2_samtools.mpileup

echo "Finished samtools pileup"

# Next run ngsParalog on the output:
/home/samcrow/programs/ngsParalog/ngsParalog calcLR -infile /home/samcrow/scratch/eels/mpileup/chrom2_samtools.mpileup -outfile \
/home/samcrow/scratch/eels/mpileup/ngsparalog_out/chrom2.lr \
-minQ 30 -minind 670 -mincov 1

echo "Finished ngsparalog"
