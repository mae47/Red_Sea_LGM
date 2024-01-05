#!/bin/bash
#NB before running! Check folders below, sims in write_def.r & convert_bases, and convert_structure & nucleotide_diversity.r files

base_path="/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/simulations/cosmo_model"

for b in `seq 1 500`
do

echo "$b"
mkdir $base_path/island_"$b"/
cd $base_path
scp -r model/ $base_path/island_"$b"/

cd $base_path/island_"$b"/model/template/
sed -i s/island_1/island_"$b"/g *.sh
sed -i s/island_1/island_"$b"/g *.r

cd $base_path/island_"$b"/model/arp/
sed -i s/island_1/island_"$b"/g *.r
sed -i s/island_1/island_"$b"/g *.sh

cd $base_path/island_"$b"/model/arp/autosome/
sed -i s/island_1/island_"$b"/g *.r

done

