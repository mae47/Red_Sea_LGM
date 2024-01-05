library("abc", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("abcrf", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")

base_path<-"/home/mae47/rds/hpc-work/RAD_seq/D_abudafur"
filename<-"11092023"
  
#read in files
def<-read.table(paste0(base_path,"/simulations/cosmo_model/final_sumstats/final_def_10k"),header=T)
sfs<-read.table(paste0(base_path,"/simulations/cosmo_model/final_sumstats/final_sfs_10k_dadi_cut_11092023"),header=F)

#name params
params=c("Nsource_exp","Nanc_exp","Nbott_exp","Npop_RS_exp","Npop_IO_exp","split_IO","resize","resize_mod","tanc_exp","tbott","trec","tstop","tleng","gr","mig_exp")


n=length(params)
#prepare matrix to store R2 results
R2<-matrix(rep(NA,n*4), ncol=n, nrow=4)
colnames(R2)<-params
rownames(R2)<-c("coverage95%","R2_OOB","R2_median","R2_mean")
#randomly sample pseudo-observed data (pods)
test_rows<-sample(1:nrow(def),1000)
#save out real values, all params, test rows
test_obs_data<-def[test_rows,]


for (param in params) {
print(param)
  param_input<-sfs
  param_input$param<-def[,param]

#set training dataset
rf_training<-param_input[-test_rows,]
#set test dataset
rf_test<-param_input[test_rows,]

#create rf model
param_rf<-regAbcrf(param~.,data=rf_training)
print("OOB R squared is ")
print(param_rf$model.rf$r.squared)
R2["R2_OOB",param] <- param_rf$model.rf$r.squared

#predict param
predict_output<-predict(param_rf, obs=rf_test, training=rf_training)
assign(paste0("predict_output_",param),predict_output)

#calculate the 95% coverage for each parameter
print("calculating coverage")
cov95<-0
len=(length(rf_test[,"param"]))
for (j in 1:len) {
  if ((rf_test[j,"param"])<=predict_output$quantiles[j,2] && (rf_test[j,"param"])>=predict_output$quantiles[j,1])
    cov95<-cov95+1
  else
    print(paste0("not within 95%: row ",j," ",param))
}

cov95<-cov95/len
R2["coverage95%",param] <- cov95

#calculate r squared (simulated vs estimated param vals) 1-(sum of squares of residuals/total sum of squared deviations)
R2["R2_median",param] <- 1 - sum((rf_test$param-predict_output$med)^2) / sum((rf_test$param-mean(rf_test$param))^2)
R2["R2_mean",param] <- 1 - sum((rf_test$param-predict_output$expectation)^2) / sum((rf_test$param-mean(rf_test$param))^2)

print(R2)
}


write.table(R2, file=paste0(base_path,"/analysis/power_analysis/R2_",filename,".csv"), col.names=T, row.names=T)
save.image(file=paste0(base_path,"/analysis/power_analysis/power_analysis_environment_",filename,".RData"))




#COMBINED PLOTS: generate pdf of median and mode plots aside each other, for each param
paste("combined median and mean plots")
pdf(paste0(base_path,"/analysis/power_analysis/plots_combined_median_mean_",filename,".pdf"), width=5) #open connection to pdf file
#par columns and rows, mar plot borders: 1bottom,2left,3top,4right, oma page borders
par(mfrow = c(3,2),mar=c(4,4,4,4),oma=c(3,1,3,1)) 
plot(test_obs_data$Nsource_exp, predict_output_Nsource_exp$med, col="red", main="Nsource_exp_median", xlim=c(5.1,6.4), ylim=c(5.1,6.4), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nsource_exp, predict_output_Nsource_exp$expectation, col="red", main="Nsource_exp_mean", xlim=c(5.1,6.4), ylim=c(5.1,6.4), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nanc_exp, predict_output_Nanc_exp$med, col="red", main="Nanc_exp_median", xlim=c(3.8,5.7), ylim=c(3.8,5.7), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nanc_exp, predict_output_Nanc_exp$expectation, col="red", main="Nanc_exp_mean", xlim=c(3.8,5.7), ylim=c(3.8,5.7), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nbott_exp, predict_output_Nbott_exp$med, col="red", main="Nbott_exp_median", xlim=c(3.3,5.7), ylim=c(3.3,5.7), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Nbott_exp, predict_output_Nbott_exp$expectation, col="red", main="Nbott_exp_mean", xlim=c(3.3,5.7), ylim=c(3.3,5.7), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Npop_RS_exp, predict_output_Npop_RS_exp$med, col="red", main="Npop_RS_exp_median", xlim=c(3.3,5.7), ylim=c(3.3,5.7), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Npop_RS_exp, predict_output_Npop_RS_exp$expectation, col="red", main="Npop_RS_exp_mean", xlim=c(3.3,5.7), ylim=c(3.3,5.7), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Npop_IO_exp, predict_output_Npop_IO_exp$med, col="red", main="Npop_IO_exp_median", xlim=c(3.8,6.1), ylim=c(3.8,6.1), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$Npop_IO_exp, predict_output_Npop_IO_exp$expectation, col="red", main="Npop_IO_exp_mean", xlim=c(3.8,6.1), ylim=c(3.8,6.1), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
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
plot(test_obs_data$tanc_exp, predict_output_tanc_exp$med, col="red", main="tanc_exp_median", xlim=c(4.1,5.7), ylim=c(4.1,5.7), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2) 
plot(test_obs_data$tanc_exp, predict_output_tanc_exp$expectation, col="red", main="tanc_exp_mean", xlim=c(4.1,5.7), ylim=c(4.1,5.7), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2) 
plot(test_obs_data$tbott, predict_output_tbott$med, col="red", main="tbott_median", xlim=c(12000,18000), ylim=c(12000,18000), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tbott, predict_output_tbott$expectation, col="red", main="tbott_mean", xlim=c(12000,18000), ylim=c(12000,18000), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$trec, predict_output_trec$med, col="red", main="trec_median", xlim=c(5750,7500), ylim=c(5750,7500), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$trec, predict_output_trec$expectation, col="red", main="trec_mean", xlim=c(5750,7500), ylim=c(5750,7500), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tstop, predict_output_tstop$med, col="red", main="tstop_median", xlim=c(1,7395), ylim=c(1,7395), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tstop, predict_output_tstop$expectation, col="red", main="tstop_mean", xlim=c(1,7395), ylim=c(1,7395), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tleng, predict_output_tleng$med, col="red", main="tleng_median", xlim=c(77,7432), ylim=c(77,7432), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$tleng, predict_output_tleng$expectation, col="red", main="tleng_mean", xlim=c(77,7432), ylim=c(77,7432), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$gr, predict_output_gr$med, col="red", main="gr_median", xlim=c(-0.05,0), ylim=c(-0.05,0), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$gr, predict_output_gr$expectation, col="red", main="gr_mean", xlim=c(-0.05,0), ylim=c(-0.05,0), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$mig_exp, predict_output_mig_exp$med, col="red", main="mig_exp_median", xlim=c(-6.7,-3.1), ylim=c(-6.7,-3.1), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
plot(test_obs_data$mig_exp, predict_output_mig_exp$expectation, col="red", main="mig_exp_mean", xlim=c(-6.7,-3.1), ylim=c(-6.7,-3.1), xlab="simulated values", ylab="estimated values",cex.main=1,cex.lab=0.9,cex.axis=0.9)
abline(a=0, b=1, col="black", lwd=2)
dev.off()


print("end of script")

