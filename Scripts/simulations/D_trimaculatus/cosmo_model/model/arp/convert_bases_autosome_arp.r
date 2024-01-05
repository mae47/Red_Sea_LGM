# THIS SCRIPT READS ALL THE ARP FILE AND CONVERT NUMBERS (0,1,2,3) INTO (a,c,g,t) BEFORE SAVING INTO DIFFERENT DIRECTORY TO CALCULATE NUCLEOTIDE DIVERSITY

base_path<-"/home/mae47/rds/hpc-work/RAD_seq/D_trimaculatus/NRS_DGA/simulations/cosmo_model/island_1/model"

filenames<-list.files(path=paste(base_path,"/template/input_autosome/",sep=""),pattern="arp$")

for (file in filenames)
{
print(file)
t<-try(read.table(paste(base_path,"/template/input_autosome/",file, sep=""), fill=T, colClasses="character"))

  if (class(t)!="try-error")
  {	
    ##NB sample sequences always start at row 12: Per population: 3 info lines, no. of individuals, 1 close bracket. Plus 7 "structure" lines at end
    for (i in 12:nrow(t))
	{
    t[i,3]<-gsub("0","A",t[i,3],fixed=T)
    t[i,3]<-gsub("1","C",t[i,3],fixed=T)
    t[i,3]<-gsub("2","G",t[i,3],fixed=T)
    t[i,3]<-gsub("3","T",t[i,3],fixed=T)
    }

sim<-strsplit(file,"autosome_")[[1]][2]  #input_autosome_$sim_1.arp > $sim_1.arp
k<-as.numeric(strsplit(sim,"_")[[1]][1])  #$sim_1.arp > $sim

   if (k<10)
  {
  write.table(t, file=paste(base_path,"/arp/autosome/input_00",sim,sep=""), col.names=F, row.names=F, sep=" ", quote=F)
  }
  else if (k>=10 && k<100)
  {
  write.table(t, file=paste(base_path,"/arp/autosome/input_0",sim,sep=""), col.names=F, row.names=F, sep=" ", quote=F)
  }
  else if (k>=100)
  {
  write.table(t, file=paste(base_path,"/arp/autosome/input_",sim,sep=""), col.names=F, row.names=F, sep=" ", quote=F)
  }
 }
}


