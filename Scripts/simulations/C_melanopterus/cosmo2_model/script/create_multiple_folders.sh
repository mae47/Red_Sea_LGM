#!/bin/bash
#NB before running! Check folders below, sims in write_def.r & convert_bases, and convert_structure & nucleotide_diversity.r files

for b in `seq 1 100`
do

echo "$b"
mkdir /home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo2_model/island_"$b"/
cd /home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo2_model/
cp -r model/ /home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo2_model/island_"$b"/

cd /home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo2_model/island_"$b"/model/template/
sed -i s/island_1/island_"$b"/g *.sh
sed -i s/island_1/island_"$b"/g *.r

cd /home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo2_model/island_"$b"/model/arp/
sed -i s/island_1/island_"$b"/g *.r
sed -i s/island_1/island_"$b"/g *.sh

cd /home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo2_model/island_"$b"/model/arp/autosome/
sed -i s/island_1/island_"$b"/g *.r

done

