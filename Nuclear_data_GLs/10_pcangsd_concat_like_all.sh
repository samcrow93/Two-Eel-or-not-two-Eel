#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=514500M
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=pcangsd_concat_all

module load StdEnv/2020 python/3.10.2
module load scipy-stack/2023b
source /home/samcrow/python_env/bin/activate

cd /home/samcrow/programs/pcangsd

pcangsd \
  --beagle /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts/eel_concat_like_copy.beagle.gz \
  --threads 32 \
  -o /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/pcangsd_out/eel_concat_like.pcangsd.out \
  --sites_save \
  --snp_weights


deactivate
