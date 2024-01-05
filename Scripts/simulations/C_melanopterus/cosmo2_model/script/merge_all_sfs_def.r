#THIS SCRIPT MERGES ALL THE FINAL SFS AND DEF OF EACH DOSSIER/FOLDER

base_path<-"/home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo2_model"

sfs<-try(read.table(paste0(base_path,"/island_1/model/final/input_autosome_jointMAFpop1_0_dadi.obsSFS"), header=F))
d<-try(read.table(paste0(base_path,"/island_1/model/final/input_autosome.def"), header=T))


final_def<-c(paste0(base_path,"/final_sumstats/final_def"))
final_sfs<-c(paste0(base_path,"/final_sumstats/final_sfs"))

writeLines(paste("Nsource","Nsource_exp","Nanc","Nanc_exp","Nbott","Nbott_exp","Npop_RS","Npop_RS_exp","Npop_IO","Npop_IO_exp","split_IO","resize","resize_mod","tanc","tanc_exp","tbott","trec","tstop","tleng","gr","mig","mig_exp",sep="\t"), con=final_def, sep="\n")


if (class(d)!="try-error" && class(sfs)!="try-error" && nrow(d)==nrow(sfs))
{
write.table(sfs, file=final_sfs, col.names=F, row.names=F, sep="\t", quote=F, append=T)
write.table(d, file=final_def, col.names=F, row.names=F, sep="\t", quote=F, append=T)
print("1")
} else {
print ("island_1 missing files")
}


for (i in 2:100) #no. folders
{
sfs<-try(read.table(paste0(base_path,"/island_",i,"/model/final/input_autosome_jointMAFpop1_0_dadi.obsSFS", sep=""), header=F))
d<-try(read.table(paste0(base_path,"/island_",i,"/model/final/input_autosome.def", sep=""), header=T))

  if (class(d)!="try-error" && class(sfs)!="try-error" && nrow(d)==nrow(sfs))
  {
  write.table(sfs, file=final_sfs, col.names=F, row.names=F, sep="\t", quote=F, append=T)
  write.table(d, file=final_def, col.names=F, row.names=F, sep="\t", quote=F, append=T)
  print (i)	
  }
  else {
  print (paste("island_",i,"missing files", sep=""))
  }
}




