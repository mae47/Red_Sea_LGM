#Need to edit last few lines of .arp files to have double quotes or Arlsumstat cant read the file correctly
cd /home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo0_model/island_1/model/arp/autosome

filenames=$(ls | grep .arp)

for file in $filenames
do
echo $file
leng=$(cat $file | wc -l)

#One row up from last line
a=$(($leng - 1))
	sed -i "${a}s/Sample 2/\"Sample 2\"/" $file
#One row up from previous line
a=$(($a - 1))
	sed -i "${a}s/Sample 1/\"Sample 1\"/" $file

done
