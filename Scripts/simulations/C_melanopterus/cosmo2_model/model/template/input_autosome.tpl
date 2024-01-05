//Parameters for the coalescence simulation program : simcoal.exe
2 samples to simulate : Exponential growth : 1000 to 100,000,000 started 3000 generations ago
//Population effective sizes (number of genes 2*diploids)
Npop_IO
Npop_RS
//Samples sizes (number of genes 2*diploids)
28
28
//Growth rates  : negative growth implies population expansion
0
0
//Number of migration matrices : 0 implies no migration between demes
2
//migration matrix 0
0 mig
mig 0
//migration matrix 1
0 0 
0 0
//historical event: time, source, sink, migrants, new deme size, new growth rate, migration matrix index
4 events
tstop 1 1 1 1 gr 0	
trec 1 1 1 1 0 1
tbott 1 1 1 resize 0 0
tanc 1 0 1 split_IO 0 1
//Number of independent loci [chromosome]
976 0
//Per chromosome: Number of linkage blocks
1
//per Block: data type, num loci, rec. rate and mut rate + optional parameters
DNA 620 0.000000005 0.0000000083

