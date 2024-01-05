####create def for fsc
def_str<-c("/home/mae47/rds/hpc-work/C_melanopterus/simulations/cosmo0_model/island_1/model/template/input_autosome.def") 



#write header of the def file
writeLines(paste("Nsource","Nsource_exp","Nanc","Nanc_exp","Npop_RS","Npop_RS_exp","Npop_IO","Npop_IO_exp","split_IO","tanc","trec","tstop","tleng","gr","mig","mig_exp",sep="\t"), con=def_str, sep="\n")

for (y in 1:100){  #no. sims per folder
print(y)

    npop_io<-runif(1,3.7,5) #~5k to 100k
    nanc<-runif(1,3.7,5) #~5k to 100k
    nsource_min<-log10(round(10^nanc) + round(10^npop_io))
    repeat {
	nsource<-runif(1,4.7,5.6) #~50k to ~400k
	if (nsource > nsource_min) {
	break }
	}
    npop_rs<-runif(1,nanc,5.5) #nanc to ~300k
   
        
	tanc<-runif(1,1650,2150) #enter RS after LGM ~11.5kya - ~15kya. NOT sampled from exponent in this model
	trec<-tanc-1 #growth starts almost immediately
	tlengmax<-trec-1 
	tleng<-runif(1,21,tlengmax) #length of growth/growth period ~150y to ~15ky
	tstop<-trec-tleng #end of growth
	 

mig<-runif(1,-6.15,-2.61) #prop per gen, log, 0.0000007-0.00245gens ie 0.0000001 - 0.00035 per year
gr<-(log(round(10^nanc)/round(10^npop_rs)))/tleng #(popn before growth/popn after growth)/(time growth starts - time growth stops)
split_io<-round(10^nsource)/round(10^npop_io)


#write set of parameters to the def file
write(paste(round(10^nsource),nsource,round(10^nanc),nanc,round(10^npop_rs),npop_rs,round(10^npop_io),npop_io,split_io,round(tanc),round(trec),round(tstop),round(tleng),gr,(10^mig),mig,sep="\t"), file=def_str, append=T)


}




