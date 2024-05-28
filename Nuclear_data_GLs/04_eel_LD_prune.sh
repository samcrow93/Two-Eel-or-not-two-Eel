#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=0
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --job-name=eel_LD_prune

# Generate pruned SNP list using the prune_graph.pl script within ngsLD
cd /home/samcrow/projects/def-ibradbur/samcrow/eels/eels2.0/prune_graph/
./target/release/prune_graph --header --in /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/ngsLD_out/eel_concat_like_subsample_LD.ld \
 --weight-field "r2" --weight-filter "dist <= 10000 && r2 >= 0.1" --out /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/ngsLD_out/eel_concat_like_subsamp_unlinked.pos
