# Observed Data

## 1. Demultiplexing raw fastq.gz files (RADseq only)

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

## 2. Assemble de-novo loci (RADseq only)

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

* 1st scripts -  these scripts treat alleles as haploid individuals, to match later simulations which will be haploid individuals

Sharks, no missing data: [nd_from_vcf_haploid.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/nd_from_vcf_haploid.sh)  
Teleosts, some missing data: [nd_from_vcf_haploid_md.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/nd_from_vcf_haploid_md.sh)

* Output files named "pairwise_pi.dist"

* 2nd script - uses pairwise_pi.dist file to calculate within pop1 nd, within pop2 nd, between pop nd, and Fst

[calculate_obs_data_sumstats_plink_haploid.sh](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/calculate_obs_data_sumstats_plink_haploid.sh)

## 4. Calculating 2D SFS from vcf (and appending between pop nucleotide diversity)

* Adapted from function vcf2sfs

* Creates a genotype table from diploid vcf and popmap. Generates SFS not accounting for missing data (already filtered out of shark target gene capture data) or imputing ONLY the missing data. Folds SFS. Plots SFS. Writes to .dadi format. Previously calculated between-pop nucleotide diversity is manually added if required. Then removes/cuts unwanted columns of the MAF table from the folded .dadi file, as well as monomorphic sites

[2d-sfs_13112022_cut.Rmd](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/2d-sfs_13112022_cut.Rmd)

# Simulated Data

## 5. Generating model simulations

* See the readme.txt file in the root folder for instructions on file structure, which files vary between species (number of loci etc), how to check all the editable parameters, and the order of submission of scripts

*  Template simulation folders for each species can be found [here](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/simulations)

* Though varying in sample sizes and number/length of loci, the three teleost species - Dascyllus abudafur, Dascyllus trimaculatus, and Pomacanthus maculosus - had the same parameter priors. Carcharhinus melanopterus (cosmo0_model) had different priors (in the root > model > template > .tpl file) for a few of the parameters. For C. melanopterus, cosmo0_model, or model "bottleneck" in Supplementary information, is the focus model equivalent to the single model used in the main text for the other three species. cosmo2_model is alternative model "recolonisation" in Supplementary information.

* The two Dascyllus species simulations were run using an array job with 500 folders and 20 simulations per folder. Due to time constraints, P. maculosus simulations were run using an array job with 1000 folders and only 10 simulations per folder. See the readme.txt file for where to change the number of folders and the number of sims in each folder.

* Basic order of submission:

    root > script > create_multiple_folders.sh  
    root > array job submission file  
    root > script > mege_all_sfs_def.r

## 6. Completed 10k simulation datasets

* Include the def file, the 2D SFS only (dadi_cut_), and the 2D SFS with nucleotide diversity appended (dadi_cut_pi_), all with 10k rows/simulations

* Simulated datasets for each species can be found [here](https://github.com/mae47/Red_Sea_LGM/tree/main/data/10k_simulated_datasets)

* NB As above, for C. melanopterus, cosmo0_model, or model "bottleneck" in Supplementary information, is the focus model equivalent to the single model used in the main text for the other three species. cosmo2_model is alternative model "recolonisation" in Supplementary information.



