#!/bin/bash

base_path="/home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo0_model/island_1/model"

echo "writing def file"
Rscript --vanilla $base_path/template/write_def.r

echo "running fastsimcoal"
#run fastsimcoal, -t=tpl file, -n1=perform 1 sim per def values, -f=def file, -s0=output all snps, -I=infinite site model, 
cd $base_path/template
./fsc25221 -t input_autosome.tpl  -n1 -f input_autosome.def -s0 -I -m -D > fsc_output

echo "checking max sequence lengths"
bash ./seq_lengths.sh

echo "moving sfs and list of arp file lengths to final folder"
cd ./input_autosome
mv input_autosome_jointMAFpop1_0_dadi.obsSFS $base_path/final/
mv list_arp_lengths.txt $base_path/final/
echo "convert arp bases and make copies in model/arp/autosome folder"
cd $base_path/arp
Rscript --vanilla ./convert_bases_autosome_arp.r
echo "convert structure group names to have quotations in arp copies"
bash ./convert_structure_names.sh

echo "LaunchArlSumStat.sh script"
cd $base_path/arp/autosome/
./LaunchArlSumStat.sh #lanch arlsumstat to calculate sumstats

echo "running nucleotide_diversity.r script"
Rscript --vanilla $base_path/arp/autosome/nucleotide_diversity.r
cd $base_path/final/
paste input_autosome_jointMAFpop1_0_dadi.obsSFS pi > ./final_sfs
mv final_sfs ./input_autosome_jointMAFpop1_0_dadi.obsSFS
#rm pi

cd $base_path/arp/autosome/
rm -r *.res/ *.arp randseed.txt arl_run.ars arlsumstat3522* LaunchArlSumStat.sh ssdefs.txt
#rm arlProjectsList.txt

cd $base_path/template/  #delete fil
rm -r seed.txt fsc25221
cd ./input_autosome
rm *.arp *.arb *.par
#copy def files
cd $base_path/template/
scp *.def $base_path/final/
echo "moved def file to final folder"


echo "end of script"

