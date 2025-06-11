#!/bin/bash
#SBATCH --time=
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --job-name=beagle_impute

#load variables
source $paramfile
source $angsdparam

cd $projdir/align/nuc_angsd_out2


java -Xmx80g -jar /home/samcrow/programs/beagle/beagle.27Jan18.7e1.jar \
gl=$projdir/align/nuc_angsd_out2/$runname.$chromsnuc.vcf \
nthreads=32 out=imputed/$runname.$chromsnuc
