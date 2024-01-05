
#ABC random forest - machine learning ABC with blacktips
#install.packages("abcrf")
library("abc", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("abcrf", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("ggplot2", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("gridExtra", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("stringr", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")
library("knitr", lib.loc="/home/mae47/R/x86_64-pc-linux-gnu-library/4.0")


base_path<-"/home/mae47/rds/hpc-work/C_melanopterus"

#For model selection:

#forming model.rf abcrf object (containing trained forest and reference table)

sumstat0<-read.table(paste0(base_path,"/simulations/cosmo0_model/final_sumstats/final_sfs_10k_dadi_cut_11092023"), header=FALSE) #load full sumstat for model 0
summary(sumstat0)

sumstat2<-read.table(paste0(base_path,"/simulations/cosmo2_model/final_sumstats/final_sfs_10k_dadi_cut_11092023"), header=FALSE) #load full sumstat for model 2
summary(sumstat2)

sumstats<-rbind(sumstat0,sumstat2) #combine sumstats together

index0<-rep(0,10000) #create index for model 0
index0<-as.matrix(index0)
#index1<-rep(1,10000) #create index for model 1
#index1<-as.matrix(index1)
index2<-rep(2,10000) #create index for model 2
index2<-as.matrix(index2)
index<-rbind(index0,index2) #combine indices together
findex<-factor(index) #NB model1 = cosmo0, model2 = cosmo2

data1<-data.frame(findex,sumstats) #reference table required by abcrf
model.rf1<-abcrf(findex~., data=data1, ntree=1000, lda=FALSE) #[variable for indices] ~ [sumstats from reference table]. lda = FALSE = lda scores not added to list of sumstats


#performing model selection

target<-read.table(paste0(base_path,"/analysis/abcrf_sfs_model_selection/C_melanopterus_sfs_NA0_folded_dadi_cut_31122021.txt")) #load real data sumstats

predict(model.rf1, target, data1, ntree=1000)

print("end of script")
