Before starting any simulations:

Check root folder contains: empty final_sumstats folder, model folder, script folder, empty list_split_arp_files file, readme file and submission file
In model > template: check write_def.r for parameter names at top and bottom, prior ranges, and no. sims in each folder. Check fastsimcoal template file input_autosome.tpl for model events, sample sizes, number of loci etc
In model > arp > autosome: check nucleotide_diversity.r for appropriate length and number of loci. Check LaunchArlSumStat.sh for no. sims in each folder.
In script: check create_multiple_folders.sh for number of folders. Check merge_all_sfs_def.r for parameter names as in def file and number of folders

Order of submission:
Run script > create_multiple_folders.sh
Send submission file in root folder
Run script > merge_all_sfs_def.r
