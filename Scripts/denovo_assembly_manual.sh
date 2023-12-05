#!/bin/bash
#After processing RADtags with script
#Runs denovo_map.pl pipeline components by hand to obtain bam files: ustacks, cstacks, sstacks, tsv2bam

samples='SRR7226206 SRR7226207 SRR7226214 SRR7226215 SRR7226219 SRR7226228 SRR7226229 SRR7226230 SRR7226234 SRR7226235 SRR7226236 SRR7226237 SRR7226247 SRR7226249 SRR7226250 SRR7226254 SRR7226259 SRR7226261 SRR7226263 SRR7226264 SRR7226269 SRR7226291 SRR7226297 SRR7226298'

cd /home/mae47/rds/hpc-work/software/stacks-2.53/bin 



##ustacks
##Build loci de novo in each sample for the single-end reads only

#-m Minimum depth of coverage required to create a stack (default 3)
#-M Maximum distance (in nucleotides) allowed between stacks (default 2)
#-N Maximum distance allowed to align secondary reads to primary stacks (default: M + 2)
echo "ustacks"
id=1
for sample in $samples
do
ustacks -f ./clean_data/$sample.fq.gz -i $id -o ./denovo_map_output -m 3 -M 3 -N 5
let "id+=1"
done

##cstacks
##Build the catalog of loci available in the metapopulation from the samples contained in the population map. To build the catalog from a subset of individuals, supply a separate population map only containing those samples

#-n maximum number of mismatches allowed between stacks between individuals
echo "cstacks"
cstacks -P /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/denovo_map_output/17122020_24ind -M /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/popmap_24ind -n 2 #-p 8

##sstacks
##Match all samples supplied in the popmap against the catalog. ie. sets of stacks (putative loci) can be searched against the catalog

echo "sstacks"
sstacks -P /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/denovo_map_output/17122020_24ind -M /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/popmap_24ind #-p 8

##tsv2bam
##transpose the data so it is stored by locus instead of by sample. can handle paired-end

echo "tsv2bam"
tsv2bam -P /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/denovo_map_output/17122020_24ind -M /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/popmap_24ind #-t 8

##gstacks
##align reads per sample, call variant sites, genotypes each individual

#echo "gstacks"
#gstacks -P /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/denovo_map_output/17122020_24ind/gstacks_popns -M /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/popmap_24ind

##populations
##calculate population stats

#echo "populations"
#populations -P /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/denovo_map_output/17122020_24ind/gstacks_popns -M /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/popmap_24ind -p 2 -r 0.85 --vcf --fstats

##NB for reference, if running all denovo_map.pl pipeline together without filtering for minimum coverage in the middle:
#echo "denovo pipeline"
#denovo_map.pl --samples /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/clean_data --popmap /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/popmap_new -o /home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/denovo_map_output/15102020 -X "ustacks: -m 3 -M 2" -X "cstacks: -n 1" -X "populations: -p 2 -r 0.65"
