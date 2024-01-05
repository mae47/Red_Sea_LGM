library(abcrf)
library(abc)
base_path<-"/home/mae47/rds/hpc-work/C_melanopterus"
filename<-"11092023"

#read in files
sumstat0<-read.table(paste0(base_path,"/simulations/cosmo0_model/final_sumstats/final_sfs_10k_dadi_cut_",filename),header=F)
sumstat2<-read.table(paste0(base_path,"/simulations/cosmo2_model/final_sumstats/final_sfs_10k_dadi_cut_",filename),header=F)

#randomly sample pseudo-observed data (pods) row numbers
test_rows<-sample(1:nrow(sumstat2),1000)
#save out observed data (pods)
test_pods_sumstat0<-sumstat0[test_rows,]
test_pods_sumstat2<-sumstat2[test_rows,]
#remove test rows from datasets
sumstat0<-sumstat0[-test_rows,]
sumstat2<-sumstat2[-test_rows,]

sumstats<-rbind(sumstat0, sumstat2)

index0<-rep(0,9000)
index0<-as.matrix(index0)
index2<-rep(2,9000)
index2<-as.matrix(index2)
index<-rbind(index0,index2)
findex<-factor(index)

#make reference table required by abcrf
data1<-data.frame(findex,sumstats)
#make random forest
#[variable for indices] ~ [sumstats from reference table]. lda = FALSE = lda scores not added to list of sumstats
model.rf1<-abcrf(findex~., data=data1, ntree=1000, lda=FALSE)

#performing model selection
pred<-predict(model.rf1, test_pods_sumstat0, data1, ntree=1000)
pred<-as.data.frame(pred)
colnames(pred)<-c("selected_model","cosmo0","cosmo2","prob")



#this block uses counters to keep record of how many pods are assigned to model cosmo0 with a probability greater or equal of a certain threshold
print("counting cosmo0 probability")

cosmo0_95<-0 #probability >= 95%
for (y in 1:nrow(pred)){
  if (pred[y,"cosmo0"]>=950)   #NB: for each sim, check if 950 trees out of 1000
    cosmo0_95<-cosmo0_95+1
}

cosmo0_90<-0 #probability >= 90%
for (y in 1:nrow(pred)){
  if (pred$cosmo0[y]>=900)
    cosmo0_90<-cosmo0_90+1
}

cosmo0_80<-0 #probability >= 80%
for (y in 1:nrow(pred)){
  if (pred$cosmo0[y]>=800)
    cosmo0_80<-cosmo0_80+1
}

cosmo0_70<-0 #probability >= 70%
for (y in 1:nrow(pred)){
  if (pred$cosmo0[y]>=700)
    cosmo0_70<-cosmo0_70+1
}

cosmo0_60<-0 #probability >= 60%
for (y in 1:nrow(pred)){
  if (pred$cosmo0[y]>=600)
    cosmo0_60<-cosmo0_60+1
}

cosmo0_50<-0 #probability >= 50%
for (y in 1:nrow(pred)){
  if (pred$cosmo0[y]>=500)
    cosmo0_50<-cosmo0_50+1
}

#this block uses counters to keep record of how many pods are assigned to model cosmo2 with a probability greater or equal of a certain threshold
print("counting cosmo2 probability")

cosmo2_95<-0
for (y in 1:nrow(pred)){
  if (pred$cosmo2[y]>=950)
    cosmo2_95<-cosmo2_95+1
}

cosmo2_90<-0
for (y in 1:nrow(pred)){
  if (pred$cosmo2[y]>=900)
    cosmo2_90<-cosmo2_90+1
}

cosmo2_80<-0
for (y in 1:nrow(pred)){
  if (pred$cosmo2[y]>=800)
    cosmo2_80<-cosmo2_80+1
}

cosmo2_70<-0
for (y in 1:nrow(pred)){
  if (pred$cosmo2[y]>=700)
    cosmo2_70<-cosmo2_70+1
}

cosmo2_60<-0
for (y in 1:nrow(pred)){
  if (pred$cosmo2[y]>=600)
    cosmo2_60<-cosmo2_60+1
}

cosmo2_50<-0
for (y in 1:nrow(pred)){
  if (pred$cosmo2[y]>=500)
    cosmo2_50<-cosmo2_50+1
}



#create a summary table by binding all counters and adding row and column names 
#summarises number of pods that can be assigned to each model at different confidence thresholds (number of trees/1000)
summary=cbind(cosmo0_95,cosmo0_90,cosmo0_80,cosmo0_70,cosmo0_60,cosmo0_50,cosmo2_95,cosmo2_90,cosmo2_80,cosmo2_70,cosmo2_60,cosmo2_50)
rownames(summary)<-c("num_pods")
colnames(summary)<-c("cosmo0_95","cosmo0_90","cosmo0_80","cosmo0_70","cosmo0_60","cosmo0_50","cosmo2_95","cosmo2_90","cosmo2_80","cosmo2_70","cosmo2_60","cosmo2_50")
summary


print("writing out table")
write.table(summary, paste0(base_path,"/analysis/power_analysis/model_selection_pa/model_selection_summary_",filename,".csv"), col.names=T, row.names=T)



