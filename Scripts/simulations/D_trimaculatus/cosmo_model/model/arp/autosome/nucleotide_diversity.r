#THIS SCRIPT READS PI FROM ARLSUMSTATS AND ATTAHC THE COLUMN OF PI TO THE SFS

base_path<-"/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/simulations/cosmo_model/island_1/model"

t<-read.table(paste0(base_path,"/arp/autosome/outSumStats.txt"), header=T)
sumstats<-matrix(rep(0,1*nrow(t)), ncol=1, nrow=nrow(t))
#sumstats[,1]<-t[,1]/(95*4595) #nucleotide diversity P1
#sumstats[,2]<-t[,2]/(95*4595) #nucleotide diversity P2
sumstats[,1]<-t[,1]/(95*4595) #nucleotide diversity P1&2
#sumstats[,4]<-1-((((26*t[,1])+(16*t[,2]))/(26+16))/t[,3]) #hudson's Fst

write.table(sumstats, file=paste0(base_path,"/final/pi"), col.names=F, row.names=F, quote=F, sep="\t")

print("done")

