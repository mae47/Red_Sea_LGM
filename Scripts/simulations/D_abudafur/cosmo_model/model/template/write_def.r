####create def for fsc
def_str<-c("/home/mae47/rds/hpc-work/RAD_seq/D_abudafur/simulations/cosmo_model/island_1/model/template/input_autosome.def") 


#write header of the def file
writeLines(paste("Nsource","Nsource_exp","Nanc","Nanc_exp","Nbott","Nbott_exp","Npop_RS","Npop_RS_exp","Npop_IO","Npop_IO_exp","split_IO","resize","resize_mod","tanc","tanc_exp","tbott","trec","tstop","tleng","gr","mig","mig_exp",sep="\t"), con=def_str, sep="\n")

#All times are in generations: Dt 1 gen = 1 year
for (y in 1:20){  #no. sims per folder

    npop_io<-runif(1,4,5.9) #10k to ~800k
    nanc<-runif(1,4,5.5) #10k to ~300k
    nsource_min<-log10(round(10^nanc) + round(10^npop_io))
    repeat {
	nsource<-runif(1,5.3,6.2) #~200k to ~1.6mil
	if (nsource > nsource_min) {
	break }
	}
	nbott<-runif(1,3.5,nanc) #~3k to nanc
	npop_rs<-runif(1,nbott,5.5) #nbott to ~300k

	
	trec<-runif(1,5750,7500) #time growth starts 11500ybp to 15000ybp
	tlengmax<-trec-1 #ensures tstop > 0
	tleng<-runif(1,75,tlengmax) #length of growth/growth period 150y to trec
	tstop<-trec-tleng #end of growth ybp
	

tbott<-runif(1,12000,18000) #24000-36000y
tanc<-runif(1,4.301,5.477) #log, 20000-300000gens ie 40000-600000y
mig<-runif(1,-6.70,-3.15) #prop per gen, log, 0.0000002-0.0007 per gen ie 0.0000001 - 0.00035 per year or 0.00001% - 0.035%

gr<-(log(round(10^nbott)/round(10^npop_rs)))/tleng #(popn before growth/popn after growth)/(time growth starts - time growth stops)
split_io<-round(10^nsource)/round(10^npop_io)
resize<-round(10^nanc)/round(10^nbott)
resize_mod<-round(10^nbott)/round(10^npop_rs)

#write set of parameters to the def file
write(paste(round(10^nsource),nsource,round(10^nanc),nanc,round(10^nbott),nbott,round(10^npop_rs),npop_rs,round(10^npop_io),npop_io,split_io,resize,resize_mod,round(10^tanc),tanc,round(tbott),round(trec),round(tstop),round(tleng),gr,(10^mig),mig,sep="\t"), file=def_str, append=T)


}




