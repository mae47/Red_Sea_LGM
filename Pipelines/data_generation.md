## 1. Demultiplexing raw fastq.gz files

* Used process_radtags: https://catchenlab.life.illinois.edu/stacks/comp/process_radtags.php

--renz = enzymes  
-c = clean data, remove any read with an uncalled base  
-q = discard reads with low quality scores  
-r = rescue barcodes and RAD-Tag cut sites  
default barcode option --inline_null: barcode is inline with sequence, occurs only on single-end read  
reads with phred-scores < an average of 10 (within a sliding window 0.15x the read length) were discarded by default

```
cd stacks-2.53

process_radtags -p filepath/raw_data/ -o filepath/clean_data/ --renz_1 sphI --renz_2 mluCI -c -q -r
```

* Remove unwanted samples from clean_data. Popmap files for all 4 species can be found here: [popmap_files](https://github.com/mae47/Red_Sea_LGM/tree/main/data/popmap_files)

## 2. Assemble de-novo loci

* Based on the ‘denovo_map.pl’ pipeline: https://catchenlab.life.illinois.edu/stacks/comp/denovo_map.php

* First, run up to the creation of the bam files (ustacks, cstacks, sstacks, tsv2bam): [denovo_assembly_manual.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/denovo_assembly_manual.sh)

* Options for building stacks were as described in Salas et al. (2019) https://royalsocietypublishing.org/doi/10.1098/rsos.172413
as below:

ustacks -M = 3, maximum number of mismatches allowed between stacks within individuals  
ustacks -m = 3, minimum depth of coverage to create a stack  
ustacks –N = 5 ('M' + 2), maximum number of mismatches allowed to align secondary reads to primary stacks  
cstacks -n = 2, maximum number of mismatches allowed between stacks between individuals

* STOPPED at tsv2bam step. Resulting bam files were filtered for a minimum coverage of eight using samtools v.1.9 (Danecek et al., 2021)

* [process_bam_files_8cov.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/process_bam_files_8cov.sh)

* Continued with the ‘gstacks’ and ‘populations’ components of the ‘denovo_map.pl’ pipeline: [denovo_assembly_manual.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/denovo_assembly_manual.sh)

Options for 'populations'  
-p = 2, number of populations the loci must be present in  
-r = 0.85, percentage of individuals in each population that must have the loci  
--vcf, output SNPs and haplotypes in a vcf file  
--fstats, enable SNP and haplotype-based F statistics

* Output files named "populations.snps.vcf"

## 3. Calculating observed nucleotide diversity from vcf

* First, these scripts treat alleles as haploid individuals, to match later simulations which will be haploid individuals

Sharks, no missing data: [nd_from_vcf_haploid.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/nd_from_vcf_haploid.sh)  
Teleosts, some missing data: [nd_from_vcf_haploid_md.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/nd_from_vcf_haploid_md.sh)

* Output files named "pairwise_pi.dist"

* 2nd script uses pairwise_pi.dist file to calculate within pop1 nd, within pop2 nd, between pop nd, and Fst

[calculate_obs_data_sumstats_plink_haploid.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/calculate_obs_data_sumstats_plink_haploid.sh)

## 4. Calculating 2D SFS from vcf (and appending between pop nucleotide diversity)

* Adapted from function vcf2sfs

* Creates a genotype table from diploid vcf and popmap. Generates SFS not accounting for missing data (already filtered out of shark target gene capture data) or imputing ONLY the missing data. Folds SFS. Plots SFS. Writes to .dadi format. Previously calculated between-pop nucleotide diversity is manually added if required. Then removes/cuts unwanted columns of the MAF table from the folded .dadi file, as well as monomorphic sites

[2d-sfs_13112022_cut.Rmd](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/2d-sfs_13112022_cut.Rmd)

## 5. Power Analysis

* power_analysis_in_R script for each species outputs a csv table with 95% coverage, the out-of-box (OOB) R2 value, median and mean R2 values for each of the 15 population parameters. It also outputs a pdf with plots of estimated vs simulated median and mean values for each parameter, with the axes scales roughly set to the range of possible values based on prior ranges.

* eg [power_analysis_in_R_Dt.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis_in_R_Dt.r)

* power_analysis_plots_only_in_R script for each species improves the pdf plots. It should be edited after viewing the first pdf, to adjust scales around the points, where the actual range is smaller than the possible range.

* eg [power_analysis_plots_only_in_R_Dt.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis_plots_only_in_R_Dt.r)


