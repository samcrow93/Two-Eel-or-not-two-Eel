#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=pcangsd_ldpruned

module load StdEnv/2020 python/3.10.2
module load scipy-stack/2023b
source /home/samcrow/python_env/bin/activate

cd /home/samcrow/programs/pcangsd

pcangsd \
  --beagle /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts/ldpruned_out/$chromsnuc_pruned.beagle.gz \
  --threads 32 \
  --admix \
  -o /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts/ldpruned_out/pcangsd_out/$chromsnuc_pruned.pcangsd.out \
  --sites_save \
  --snp_weights

deactivate
