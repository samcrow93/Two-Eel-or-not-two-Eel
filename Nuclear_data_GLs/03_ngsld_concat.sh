#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --job-name=eel_ngsLD_concat

# Calculate LD using ngsLD
# have cloned git repository for ngsLD into subdirectory

/home/samcrow/programs/ngsLD/ngsLD --geno /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts/subsampled_eel.beagle.gz --pos /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts/subsampled_pos.txt.gz --probs --n_ind 815 \
--n_sites 2533886 --max_kb_dist 10 --n_threads 30 --out /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/ngsLD_out/eel_concat_like_subsample_LD.ld

