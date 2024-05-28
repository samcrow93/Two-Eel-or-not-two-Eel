#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=combine_beagles_ldpruned

cd /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts/ldpruned_out/

cp NC_049201_ldpruned.beagle.gz eel_concat_like_ldpruned.beagle.gz

for file in NC_049202_ldpruned.beagle.gz NC_049203_ldpruned.beagle.gz NC_049204_ldpruned.beagle.gz NC_049205_ldpruned.beagle.gz NC_049206_ldpruned.beagle.gz \
NC_049207_ldpruned.beagle.gz NC_049208_ldpruned.beagle.gz NC_049209_ldpruned.beagle.gz NC_049210_ldpruned.beagle.gz NC_049211_ldpruned.beagle.gz \
NC_049212_ldpruned.beagle.gz NC_049213_ldpruned.beagle.gz NC_049214_ldpruned.beagle.gz NC_049215_ldpruned.beagle.gz NC_049216_ldpruned.beagle.gz \
NC_049217_ldpruned.beagle.gz NC_049218_ldpruned.beagle.gz NC_049219_ldpruned.beagle.gz
do
echo "Concatenating $file"
zcat "$file" | tail -n +2 | gzip >> eel_concat_like_ldpruned.beagle.gz
done
