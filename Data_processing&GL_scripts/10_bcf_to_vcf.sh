#!/bin/bash
#SBATCH --time=4:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=bcf_to_vcf

#load variables
source $paramfile
source $angsdparam

module load nixpkgs/16.09 gcc/5.4.0 bcftools/1.4

cd $projdir/align/nuc_angsd_out2/

bcftools view $runname.$chromsnuc.bcf > $runname.$chromsnuc.vcf
