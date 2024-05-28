#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-ibradbur
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samantha.crowley@dal.ca
#SBATCH --mem=0
#SBATCH --cpus-per-task=32
#SBATCH --nodes=1
#SBATCH --job-name=remove_lowdepth_indivs_beagle


for f in eels.NC_049*.beagle.gz
do
zcat $f | cut -f31,32,33,169,170,171,238,239,240,427,428,429,454,455,456,457,458,459,493,494,495,508,509,510,526,527,528,610,611,612,619,620,621,646,647,648,655,656,657,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,796,797,798,817,818,819,1576,1577,1578,1591,1592,1593,1807,1808,1809,1885,1886,1887,2227,2228,2229,2416,2417,2418,2428,2429,2430,2455,2456,2457,2500,2501,2502,2533,2534,2535 --complement | gzip > lowfilts/$f.lowfilt.beagle.gz
done


# Explanation of what is happening here:
### Below are the individuals (and non-sample samples) to remove and their order (row numbers):
### **IMPORTANT** note that beagle file starts listing individuals at "IND0" (so, in list below, every ind should be numbered one less)**
### Individuals will be in columns based on this: ind0=4, ind1=7, ind2=10, ind3=13 (i.e. column=ind*3 +4) (OR, column=ind*3 +1 to account for numbering issue
#### BIS22010.realigned.bam 10  ** but actually want Ind9 in beagle file since it starts numbering at Ind0
#### BTB22024.realigned.bam 56
#### CNR22017.realigned.bam 79
#### HRD22003.realigned.bam 142
#### HRD22012.realigned.bam 151
#### HRD22013.realigned.bam 152
#### HRP22007.realigned.bam 164
#### HRP22012.realigned.bam 169
#### HRP22018.realigned.bam 175
#### LMP22008.realigned.bam 203
#### LMP22011.realigned.bam 206
#### LMP22020.realigned.bam 215
#### LMP22023.realigned.bam 218
#### Negative2.realigned.bam 246
#### Negative3.realigned.bam 247
#### Negative4.realigned.bam 248
#### NTC2.realigned.bam 249
#### NTC.realigned.bam 250
#### NWT22017.realigned.bam 265
#### QVD22004.realigned.bam 272
#### SRR12854740.realigned.bam 525
#### SRR12854745.realigned.bam 530
#### SRR12854817.realigned.bam 602
#### SRR12854843.realigned.bam 628
#### SRR12854958.realigned.bam 742
#### STC22004.realigned.bam 805
#### STC22008.realigned.bam 809
#### STC22017.realigned.bam 818
#### TRP22005.realigned.bam 833
#### TRP22016.realigned.bam 844

