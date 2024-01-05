#This script calculates obs_data within and between population nucleotide diversity and hudsons Fst 
#from output file pairwise_pi.dist from angsd genotype distribution

#upload table
genodist_table<-read.table("/home/maddie/Desktop/sims/Cm/pairwise_pi.dist", sep="\t", row.names=1, header=T)

#set population names
p1_name<-"sey"
p2_name<-"rs"

#calculate nucleotide diversity within each population
within_p1<-genodist_table[grep(p1_name, rownames(genodist_table)), ]
within_p1<-within_p1[,grep(p1_name, colnames(genodist_table))]
num_p1<-nrow(within_p1)
x<-c(1:(num_p1-1))
count<-0
for (val in x) {
count=count+sum(within_p1[val,(val+1):num_p1])
}
total<-(num_p1-1)*(num_p1/2)
nd_p1<-count/total


within_p2<-genodist_table[grep(p2_name, rownames(genodist_table)), ]
within_p2<-within_p2[,grep(p2_name, colnames(genodist_table))]
num_p2<-nrow(within_p2)
x<-c(1:(num_p2-1))
count<-0
for (val in x) {
  count=count+sum(within_p2[val,(val+1):num_p2])
}
total<-(num_p2-1)*(num_p2/2)
nd_p2<-count/total


#calculate nucleotide diversity between populations
between_p1_2<-genodist_table[grep(p1_name, rownames(genodist_table)), ]
between_p1_2<-between_p1_2[,grep(p1_name, colnames(between_p1_2), invert=TRUE)] #select all rows where ind1 is from a different popn than ind2
count<-colSums(between_p1_2)
count<-sum(count)
total<-nrow(between_p1_2)*ncol(between_p1_2)
nd_p1_2<-count/total


#hudsons Fst. Using total number of pairwise differences, not divided by nSites
#Weighted by number of chromosomes
correctFst<- (nd_p1_2-((nd_p1+nd_p2)/2))/nd_p1_2
hudsonsFst<- 1-(((num_p1*nd_p1+num_p2*nd_p2)/(num_p1+num_p2))/nd_p1_2)
