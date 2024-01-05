library("gridExtra")
library(tidyverse)
library(ggmosaic)
library(ggpubr)
library(ggplot2)

base_path<-"/home/maddie/Documents/PhD/LGM_paper/new_plots/nucleotide_diversity_plots_11092023"
#output file
filename<-"/nd_10ksims_11092023_multiplot.png"

plots<-list()

####Da
#between pop nucleotide diversity of obs data:
obs_sumstats<-as.numeric("0.005483947242") #Da
sim_sumstats<-read.table(paste0(base_path,"/pi_Da"), header=F)
p <- ggplot(sim_sumstats, aes(x=V1)) + 
  geom_histogram(binwidth=0.0006,color="black",fill="white") +
  geom_vline(xintercept=obs_sumstats,color="red") +
  labs(x="Between-population π",title="Dascyllus abudafur") +
  xlim(0,0.035) + 
  theme(plot.title=element_text(face="italic",size=12),plot.margin=unit(c(0.5,0.5,0.5,0.1),"cm"))
p
#and save to list created at the start in the correct order to be printed: Da,Dt,Pm,Cm
plots[[1]]<-p

####Dt
#between pop nucleotide diversity of obs data:
obs_sumstats<-as.numeric("0.00481223175259259") #Dt
sim_sumstats<-read.table(paste0(base_path,"/pi_Dt"), header=F)
p <- ggplot(sim_sumstats, aes(x=V1)) + 
  geom_histogram(binwidth=0.0006,color="black",fill="white") +
  geom_vline(xintercept=obs_sumstats,color="red") +
  labs(x="Between-population π",title="Dascyllus trimaculatus") +
  xlim(0,0.035) +
  theme(plot.title=element_text(face="italic",size=12),plot.margin=unit(c(0.5,0.5,0.5,0.1),"cm"))
p
#and save to list created at the start in the correct order to be printed: Da,Dt,Pm,Cm
plots[[2]]<-p

####Pm
#between pop nucleotide diversity of obs data:
obs_sumstats<-as.numeric("0.00274512082462963") #Pm
sim_sumstats<-read.table(paste0(base_path,"/pi_Pm"), header=F)
p <- ggplot(sim_sumstats, aes(x=V1)) + 
  geom_histogram(binwidth=0.0006,color="black",fill="white") +
  geom_vline(xintercept=obs_sumstats,color="red") +
  labs(x="Between-population π",title="Pomacanthus maculosus") +
  xlim(0,0.035) +
  theme(plot.title=element_text(face="italic",size=12),plot.margin=unit(c(0.5,0.5,0.5,0.1),"cm"))
p
#and save to list created at the start in the correct order to be printed: Da,Dt,Pm,Cm
plots[[3]]<-p

####Cm
#between pop nucleotide diversity of obs data:
obs_sumstats<-as.numeric("0.000590645546173469") #Cm
sim_sumstats<-read.table(paste0(base_path,"/pi_Cm"), header=F)
p <- ggplot(sim_sumstats, aes(x=V1)) + 
  geom_histogram(binwidth=0.0006,color="black",fill="white") +
  geom_vline(xintercept=obs_sumstats,color="red") +
  labs(x="Between-population π",title="Carcharhinus melanopterus") +
  xlim(0,0.035) +
  theme(plot.title=element_text(face="italic",size=12),plot.margin=unit(c(0.5,0.5,0.5,0.1),"cm"))
p
#and save to list created at the start in the correct order to be printed: Da,Dt,Pm,Cm
plots[[4]]<-p

####Dm
#obs_sumstats<-as.numeric("0.0065445213212") #Dm time of split
#obs_sumstats<-as.numeric(c("0.00519444739311111","0.00560697604922222","0.00424695076511111")) #Dm refugia 0_1, 0_2, 1_2
#obs_sumstats<-t(obs_sumstats) #Dm refugia needs this extra line

#sim_sumstats<-read.table("/home/maddie/Documents/PhD/LGM_paper/new_plots/nucleotide_diversity_plots_21082023/pi_Pm", header=F)

# create a histogram to check it, 
#NB geom_vline(aes(xintercept=mean(V1)),color="red") = #plotting mean value from simulations
#p <- ggplot(sim_sumstats, aes(x=V1)) + 
#  geom_histogram(binwidth=0.009,color="black",fill="white") +
#  geom_vline(xintercept=obs_sumstats,color="red") +
#  labs(x="Between-population π") +
#  xlim(0,0.02)
#p

#and save to list created at the start in the correct order to be printed: Da,Dt,Pm,Cm
#plots[[?]]<-p





#######print multiplot
png(paste0(base_path,filename), height=400, width=1300)
#lay <- rbind(c(NA,1,NA),c(2,3,4)) #4 plots, 1 above, for Dm refugia chapter
all_plots <- ggarrange(plots[[1]],plots[[2]],plots[[3]],plots[[4]],ncol=4,labels=c("a)","b)","c)","d)"),font.label=list(sie=12)) #plots side by side
print(all_plots)

dev.off()

