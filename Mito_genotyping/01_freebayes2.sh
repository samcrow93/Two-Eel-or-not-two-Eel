#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=191840M
#SBATCH --cpus-per-task=44
#SBATCH --nodes=1
#SBATCH --job-name=mito_freebayes2

module load StdEnv/2020 freebayes/1.2.0

cd /home/samcrow/scratch/eels2.0/eels4.0/align/

freebayes -f /home/samcrow/scratch/eels2.0/eels4.0/genome/GCF_013347855.1_fAngAng1.pri_genomic.fna -r NC_006531.1 -L bamfiles --ploidy 1 --min-alternate-count 3 \
--min-base-quality 30 --min-mapping-quality 30 --vcf /home/samcrow/scratch/eels2.0/eels4.0/align/freebayes_out2/eel_mito_freebayes.vcf
