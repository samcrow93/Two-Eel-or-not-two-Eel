#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=combine_beagles

cd /home/samcrow/scratch/eels2.0/eels4.0/align/nuc_angsd_out2/lowfilts

cp NC_049201.1.beagle.gz eel_concat_like.beagle.gz

for file in NC_049202.1.beagle.gz NC_049203.1.beagle.gz NC_049204.1.beagle.gz NC_049205.1.beagle.gz NC_049206.1.beagle.gz \
NC_049207.1.beagle.gz NC_049208.1.beagle.gz NC_049209.1.beagle.gz NC_049210.1.beagle.gz NC_049211.1.beagle.gz \
NC_049212.1.beagle.gz NC_049213.1.beagle.gz NC_049214.1.beagle.gz NC_049215.1.beagle.gz NC_049216.1.beagle.gz \
NC_049217.1.beagle.gz NC_049218.1.beagle.gz NC_049219.1.beagle.gz
do
echo "Concatenating $file"
zcat "$file" | tail -n +2 | gzip >> eel_concat_like.beagle.gz
done
