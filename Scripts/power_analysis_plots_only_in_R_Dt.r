library("abc", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("abcrf", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")

base_path<-"/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA"
filename<-"11092023"
  

#load environment
load(file=paste0(base_path,"/analysis/power_analysis/power_analysis_environment_",filename,".RData"))




#COMBINED PLOTS: generate pdf of median and mode plots aside each other, for each param
paste("combined median and mean plots")
pdf(paste0(base_path,"/analysis/power_analysis/plots_combined_median_mean_",filename,".pdf"), width=5) #open connection to pdf file
#par columns and rows, mar plot borders: 1bottom,2left,3top,4right, oma page borders
par(mfrow = c(3,2),mar=c(4,4,4,4),oma=c(3,1,3,1)) 
plot(test_obs_data$Nsource_exp, predict_output_Nsource_exp$med, col="red", main="Nsource_exp_median", xlim=c(5.3,6.2), ylim=c(5.3,6.2), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nsource_exp, predict_output_Nsource_exp$expectation, col="red", main="Nsource_exp_mean", xlim=c(5.3,6.2), ylim=c(5.3,6.2), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nanc_exp, predict_output_Nanc_exp$med, col="red", main="Nanc_exp_median", xlim=c(4,5.5), ylim=c(4,5.5), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nanc_exp, predict_output_Nanc_exp$expectation, col="red", main="Nanc_exp_mean", xlim=c(4,5.5), ylim=c(4,5.5), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nbott_exp, predict_output_Nbott_exp$med, col="red", main="Nbott_exp_median", xlim=c(3.5,5.5), ylim=c(3.5,5.5), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nbott_exp, predict_output_Nbott_exp$expectation, col="red", main="Nbott_exp_mean", xlim=c(3.5,5.5), ylim=c(3.5,5.5), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Npop_RS_exp, predict_output_Npop_RS_exp$med, col="red", main="Npop_RS_exp_median", xlim=c(3.5,5.55), ylim=c(3.5,5.55), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Npop_RS_exp, predict_output_Npop_RS_exp$expectation, col="red", main="Npop_RS_exp_mean", xlim=c(3.5,5.55), ylim=c(3.5,5.55), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Npop_IO_exp, predict_output_Npop_IO_exp$med, col="red", main="Npop_IO_exp_median", xlim=c(4,5.95), ylim=c(4,5.95), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Npop_IO_exp, predict_output_Npop_IO_exp$expectation, col="red", main="Npop_IO_exp_mean", xlim=c(4,5.95), ylim=c(4,5.95), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$split_IO, predict_output_split_IO$med, col="red", main="split_IO_median", xlim=c(0,155), ylim=c(0,155), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$split_IO, predict_output_split_IO$expectation, col="red", main="split_IO_mean", xlim=c(0,155), ylim=c(0,155), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$resize, predict_output_resize$med, col="red", main="resize_median", xlim=c(0,95), ylim=c(0,95), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$resize, predict_output_resize$expectation, col="red", main="resize_mean", xlim=c(0,95), ylim=c(0,95), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$resize_mod, predict_output_resize_mod$med, col="red", main="resize_mod_median", xlim=c(0,1), ylim=c(0,1), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$resize_mod, predict_output_resize_mod$expectation, col="red", main="resize_mod_mean", xlim=c(0,1), ylim=c(0,1), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tanc_exp, predict_output_tanc_exp$med, col="red", main="tanc_exp_median", xlim=c(4.1,5.3), ylim=c(4.1,5.3), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2) 
plot(test_obs_data$tanc_exp, predict_output_tanc_exp$expectation, col="red", main="tanc_exp_mean", xlim=c(4.1,5.3), ylim=c(4.1,5.3), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2) 
plot(test_obs_data$tbott, predict_output_tbott$med, col="red", main="tbott_median", xlim=c(8000,12000), ylim=c(8000,12000), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tbott, predict_output_tbott$expectation, col="red", main="tbott_mean", xlim=c(8000,12000), ylim=c(8000,12000), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$trec, predict_output_trec$med, col="red", main="trec_median", xlim=c(3830,5000), ylim=c(3830,5000), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$trec, predict_output_trec$expectation, col="red", main="trec_mean", xlim=c(3830,5000), ylim=c(3830,5000), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tstop, predict_output_tstop$med, col="red", main="tstop_median", xlim=c(1,4901), ylim=c(1,4901), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tstop, predict_output_tstop$expectation, col="red", main="tstop_mean", xlim=c(1,4901), ylim=c(1,4901), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tleng, predict_output_tleng$med, col="red", main="tleng_median", xlim=c(50,4974), ylim=c(50,4974), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tleng, predict_output_tleng$expectation, col="red", main="tleng_mean", xlim=c(50,4974), ylim=c(50,4974), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$gr, predict_output_gr$med, col="red", main="gr_median", xlim=c(-0.04,0), ylim=c(-0.04,0), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$gr, predict_output_gr$expectation, col="red", main="gr_mean", xlim=c(-0.04,0), ylim=c(-0.04,0), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$mig_exp, predict_output_mig_exp$med, col="red", main="mig_exp_median", xlim=c(-6.51,-2.97), ylim=c(-6.51,-2.97), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$mig_exp, predict_output_mig_exp$expectation, col="red", main="mig_exp_mean", xlim=c(-6.51,-2.97), ylim=c(-6.51,-2.97), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
dev.off()


print("end of script")

