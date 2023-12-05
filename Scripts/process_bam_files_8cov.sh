#!/bin/bash

#Process Rad-Seq data from bam files. Script originally from yellow warblers project

module load samtools-1.9-gcc-5.4.0-vf6vvem
path_bam=/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/denovo_map_output/17122020_24ind/*bam
ext=".bam"
path=/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/denovo_map_output/17122020_24ind

for filename in $path_bam
do
cd $path
echo $filename

#create index
samtools index $filename
wait

#sort and index bam files
samtools sort $filename -o ${filename%"$ext"}"_sorted.bam"  #removes ext and adds _sorted.bam to filename
samtools index ${filename%"$ext"}"_sorted.bam"     #creates _sorted.bam.bai file

#calculate coverage per site
echo "calculating depth..."
samtools depth ${filename%"$ext"}"_sorted.bam" > ${filename%"$ext"}"_depth.txt"
wait

#calculate number of sites, total coverage and average coverage
sites=$(wc -l ${filename%"$ext"}"_depth.txt" | cut -d " " -f 1)
total_cov=$(cut -f 3 ${filename%"$ext"}"_depth.txt" | awk '{s+=$1}END{print s}')
avg_cov=$(echo "scale=2 ; $total_cov / $sites" | bc)

echo "writing average coverage to file..."
echo ${filename%"$ext"}"_sorted.bam" $sites $avg_cov >> average_coverage_normdup.txt

##define the coverage threshold as 2 X average coverage
#thresh=$(bc -l <<<"2*$avg_cov")

##select sites only with coverage lower than the threshold
#echo "create file with 2*mean average coverage"
#awk -v t="$thresh" '$3<t' ${filename%"$ext"}"_depth.txt" >  ${filename%"$ext"}"_depth_2avgcov"
#added this section to further select sites only with coverage of 8 or higher
echo "create file with min 8x coverage"
awk '$3>7' ${filename%"$ext"}"_depth.txt" >  ${filename%"$ext"}"_depth_min8cov"
wait

#create a bed file only with the positions that passed the maximum coverage filter
echo "create bed file"
cat ${filename%"$ext"}"_depth_min8cov" | awk '{print $1, $2, $2}' >  ${filename%"$ext"}".bed"
  
echo "extract positions based on coverage filter"  
samtools view -hb ${filename%"$ext"}"_sorted.bam" -L ${filename%"$ext"}".bed"  -o ${filename%"$ext"}"_covfilter.bam"
wait

#echo "writing sumstats"
#echo $filename "number of sites:"$sites "average coverage:"$avg_cov "threshold_2*avgCov:"$thresh >> summary_normdup

done
