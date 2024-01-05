#This script creates a table of pairwise pi within and between population samples in similar stlye to plink output, with single alleles as haploid individuals, from snps vcf file generated from populations programme (within stacks). Rscript "calculate_obs_data_sumstats_plink_haploid.r" calculates population pairwise pi and Fst from this table.

#folder location of the populations.snps.vcf file with open end (no / )
path=/home/mae47/rds/hpc-work/RAD_seq/nd_from_vcf

##D_abudfur_pops
#monoSites=$(expr 901186 - 30332) #monomorphic sites remaining after filtering (minus variable sites (SNPs))
#seysamples=$(echo "MAD_DaBF016 MAD_DaBF015 MAD_DaBF014 MAD_DaBF013 MAD_DaBF012 MAD_DaBF011 MAD_DaBF010 MAD_DaBF008 MAD_DaBF007 MAD_DaBF006 MAD_DaBF005 MAD_DaBF004 MAD_DaBF003 MAD_DaBF002 MAD_DaBF001")
#rssamples=$(echo "HAQ_010905 HAQ_010904 HAQ_010903 HAQ_010902 HAQ_010901 HAQ_010606 HAQ_010304 KAUST11_180 KAUST11_179 KAUST11_178 KAUST11_177 KAUST11_176 KAUST11_166 KAUST11_158 KAUST11_155")

##D_marginatus_pops
#monoSites=$(expr ) #monomorphic sites remaining after filtering (minus variable sites (SNPs))
#seysamples=$(echo "SOC_010120 SOC_010119 SOC_010118 SOC_010117 SOC_010116 SOC_010115 SOC_010114 SOC_010113 SOC_010112 SOC_010111 SOC_010110 SOC_010109 SOC_010108 SOC_010107 SOC_010106")
#rssamples=$(echo "HAQ_010701 HAQ_010603 HAQ_010602 HAQ_010505 HAQ_010504 HAQ_010503 HAQ_010502 KAUST11_255 KAUST11_254 KAUST11_253 KAUST11_252 KAUST11_251 KAUST11_249 KAUST11_248 KAUST11_247")

#P_maculosus_pops
monoSites=$(expr 3794900 - 44685) #monomorphic sites remaining after filtering (minus variable sites (SNPs))
seysamples=$(echo "SRR9953120 SRR9953123 SRR9953126 SRR9953128 SRR9953130 SRR9953133 SRR9953134 SRR9953135 SRR9953136")
rssamples=$(echo "SRR9953023 SRR9953024 SRR9953026 SRR9953059 SRR9953060 SRR9953063 SRR9953064 SRR9953067 SRR9953085 SRR9953091 SRR9953092 SRR9953093 SRR9953094 SRR9953095 SRR9953096")

##DGApops
#monoSites=$(expr 437686 - 14954) #monomorphic sites remaining after filtering (minus variable sites (SNPs))
#seysamples=$(echo "SRR7226206 SRR7226207 SRR7226214 SRR7226215 SRR7226219 SRR7226228 SRR7226229 SRR7226230 SRR7226234 SRR7226235 SRR7226236 SRR7226237 SRR7226249 SRR7226254 SRR7226259")
#rssamples=$(echo "SRR7226261 SRR7226297 SRR7226298 SRR7226247 SRR7226250 SRR7226263 SRR7226264 SRR7226269 SRR7226291")

##ZANpops
#nSites=
#seysamples=$(echo "SRR7226217 SRR7226218 SRR7226226 SRR7226227 SRR7226231 SRR7226238 SRR7226239 SRR7226241 SRR7226252 SRR7226255 SRR7226294")
#rssamples=$(echo "SRR7226247 SRR7226250 SRR7226261 SRR7226263 SRR7226264 SRR7226269 SRR7226291 SRR7226297 SRR7226298")

##C_melanopteruspops
#nSites=607857  #no. sites in full vcf inc. monomorphic and SNPs (NA0)
#seysamples=$(echo "GN16279_S1 GN16280_S2 GN16281_S3 GN16282_S4 GN16283_S5 GN16284_S6 GN16285_S7 GN16286_S8 GN16287_S9 GN16288_S10 GN16289_S11 GN16290_S12 GN16291_S13 GN16292_S12")
#rssamples=$(echo "GN16309_S12 GN16310_S13 GN16311_S15 GN16312_S14 GN16313_S1 GN16314_S2 GN16315_S3 GN16316_S4 GN16317_S15 GN16318_S1 GN16320_S5 GN16321_S6 GN16322_S2 GN16323_S7") 

rm tmp*
rm pairwise_pi.dist
touch pairwise_pi.dist
samples=$(echo $seysamples $rssamples)


for sample in $samples
do
	echo -n " "$sample"-1 "$sample"-2" | tr " " '\t' >> pairwise_pi.dist
	
done
echo -e \n >> pairwise_pi.dist


rowID=2 #plus 1 for table header

for sample1 in $samples
do
echo "new sample row, cycling through columns"
echo "$sample1-1" | tr " " '\t' >> pairwise_pi.dist
echo "$sample1-2" | tr " " '\t' >> pairwise_pi.dist
#sample1=SRR7226206

	colID=2 #plus 1 for row names
	
	for sample2 in $samples
	do
	#sample2=SRR7226207 
		echo "Pairs $sample1 and $sample2"
		
		##cutting 2 samples from vcf, stacks vcf files with missing vals
		cat $path/populations.snps.vcf | awk 'NR==15 {for (i=1;i<=NF;i++) {f[$i]=i} } {print $(f["'$sample1'"]), $(f["'$sample2'"]) }' | tail -n +16 > tmp 
		##cutting 2 samples from vcf, sharks vcf files with NA0
		#cat $path/populations.snps.vcf | awk 'NR==38 {for (i=1;i<=NF;i++) {f[$i]=i} } {print $(f["'$sample1'"]), $(f["'$sample2'"]) }' | tail -n +39 > tmp
		
		#cutting genotypes
		cat tmp | awk -F " " '{sub(/:.*/,"",$1); sub(/:.*/,"",$2); print $1"/"$2}' > tmp_2 && mv tmp_2 tmp
		nSites_all=$(cat tmp | wc -l) #total sites for this pair with missing data
	
		##for stacks vcf files, don't know how many monomorphic sites with no missing vals so have to estimate based on % missing vals in SNP file:
		##no missing values
		grep -v "\." tmp > tmp_2 && mv tmp_2 tmp
		nSites=$(cat tmp | wc -l)   #number of sites for this pair after discarding missing vals
		

		nSites_na=$(expr $nSites_all - $nSites)   #number of missing vals in this pair
		percent_na=$(echo "scale=5; $nSites_na / $nSites_all" | bc)   #percent missing vals for this pair
		percent_remaining=$(echo "scale=5; 1 - $percent_na" | bc)   #percent complete SNPs
		monoSites_est=$(echo "scale=0; ($percent_remaining * $monoSites + 0.5)/1" | bc)   #monomorphic sites retained after discarding estimated number of missing vals of same percentage 
		
		
		
		nSites=$(expr $nSites + $monoSites_est)   #nSites is SNPs for this pair summed with monomorphic sites, after discarding missing vals and estimated missing vals respectively
		

		##for any vcf:
		echo "nSites $nSites"
		
		
		#sample1-1 and sample2-1 alleles differ"
		cat tmp | awk -F "/" '{if($1!=$3) print $0}' > tmp_1
		num1=$(cat tmp_1 | wc -l)
		num1=$(echo "scale=10; $num1/$nSites" | bc)
		

		#sample1-1 and sample2-2 alleles differ"
		cat tmp | awk -F "/" '{if($1!=$4) print $0}' > tmp_2
		num2=$(cat tmp_2 | wc -l)
		num2=$(echo "scale=10; $num2/$nSites" | bc)
		

		#sample1-2 and sample2-1 alleles differ" 
		cat tmp |  awk -F "/" '{if($2!=$3) print $0}' > tmp_3
		num3=$(cat tmp_3 | wc -l)
		num3=$(echo "scale=10; $num3/$nSites" | bc)
		

	       	#sample1-2 and sample2-2 alleles differ"
		cat tmp | awk -F "/" '{if($2!=$4) print $0}' > tmp_4
		num4=$(cat tmp_4 | wc -l)
		num4=$(echo "scale=10;  $num4/$nSites" | bc)
		
		
		rowID2=$(expr $rowID + 1)
		colID2=$(expr $colID + 1)
		cat pairwise_pi.dist | awk -v OFS='\t' 'NR=='$rowID'{$'$colID'="'$num1'"}1' > tmptable && mv tmptable pairwise_pi.dist
		cat pairwise_pi.dist | awk -v OFS='\t' 'NR=='$rowID'{$'$colID2'="'$num2'"}1' > tmptable && mv tmptable pairwise_pi.dist
		cat pairwise_pi.dist | awk -v OFS='\t' 'NR=='$rowID2'{$'$colID'="'$num3'"}1' > tmptable && mv tmptable pairwise_pi.dist
		cat pairwise_pi.dist | awk -v OFS='\t' 'NR=='$rowID2'{$'$colID2'="'$num4'"}1' > tmptable && mv tmptable pairwise_pi.dist

		colID=$(expr $colID + 2)
		
	done

#sed -n $rowID,$rowID2'p' pairwise_pi.dist
rowID=$(expr $rowID + 2)


done
#cat pairwise_pi.dist


#adding pop labels to sample names in table
for i in $rssamples
do
	sed -i 's/'$i'/rs'$i'/g' pairwise_pi.dist
done
for i in $seysamples
do
	sed -i 's/'$i'/sey'$i'/g' pairwise_pi.dist
done


#cat pairwise_pi.dist
rm tmp*
echo "end of script"

