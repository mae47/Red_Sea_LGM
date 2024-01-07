####ABC random forest for model end3, RAD_seq/D_abudafur
####script from Yellow_Warbler_Project/code/R_scripts/ABCRandomForest.Rmd

library("abc", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("abcrf", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("ggplot2", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("gridExtra", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("stringr", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("knitr", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")

knitr::opts_chunk$set(echo = TRUE)

base_path<-"/home/mae47/rds/hpc-work/RAD_seq/D_abudafur"


#load simulated sumstats
print("loading sim sumstats")
sim_summary_stats<-read.table(paste0(base_path,"/simulations/cosmo_model/final_sumstats/final_sfs_10k_dadi_cut_11092023"), header=F)
sim_summary_stats<-sim_summary_stats[1:10000,]


#load params
print("loading sim params")
sim_params<-read.table(paste0(base_path,"/simulations/cosmo_model/final_sumstats/final_def_10k"), header=T)
sim_params<-sim_params[1:10000,]


#load observed sumstats
print("loading obs sumstats")
obs_summary_stats<-read.table(paste0(base_path,"/analysis/abcrf/D_abudafur_sfs_impute_folded_dadi_cut_07122021.txt"))


#ABC
#First build an RF model to link the sumstats to a given parameter
print("building RF model for first param")
one_param_input<-data.frame(c=sim_params$tanc_exp,sim_summary_stats)
one_param_rf<-regAbcrf(c~.,data=one_param_input,ntree=1000,paral=TRUE)


#plot and explore data
print("built RF model, plotting data:")
densityPlot(one_param_rf,obs=obs_summary_stats,training = one_param_input, adjust = 2)
predict(one_param_rf,obs=obs_summary_stats,training = one_param_input)
variableImpPlot(one_param_rf,n.var=16)


#convert files to have good labels for saving out the environment
print("naming and saving out environment")
tanc_param_rf <- one_param_rf
predict_output_tanc <- predict(one_param_rf,obs=obs_summary_stats,training = one_param_input)
rm(one_param_rf)
#save environment
save.image(paste0(base_path,"/analysis/abcrf/environments/tanc_param_rf_11092023.RData"))



print("end of script!")
###end of script

