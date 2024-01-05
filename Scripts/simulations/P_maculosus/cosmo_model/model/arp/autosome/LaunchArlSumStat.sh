#!/bin/bash

nsim=10

#Laurent Excoffier April 2015
#
#The script will compute summary statistics on all arlequin project files in turn
#It assumes that it is launched in a directory containing:
#         - a series of *.arp files to be analysed
#         - a file arl_run.ars, containing the settings specifying which 
#           computations are to be performed (usually obtained through the WinArl35.exe
#           graphical interface).

#Modify the following line to state which version of arlsumstat you are using
arlsumstat=arlsumstat3522_64bit #Windows version
#Modify the follwing name to specify the name of the output file for the summary statistics 
outss=outSumStats.txt

#Iterate over all project files
fileList='arlProjectsList.txt'

#Change the following line if you want to use another settings file  for the computations
settingsFile=arl_run.ars
if [ "$settingsFile" != "arl_run.ars" ]; then 
	if [ -f $settingsFile ]; then
		echo "copying file $settingsFile to arl_run.ars"
		cp $settingsFile arl_run.ars
	else 
		echo "file $settingsFile does not exist, cannot copy it to arl_run.ars"	
		echo "using existing arl_run.ars file for computations"
	fi
fi


counter=1;


for i in `seq -w 1 1 $nsim`  #-w fills in zeros meaning 001 to 200 or 01 to 20
do


file=$(ls | grep $i"_".".arp")  #lists arp files associated to that simulation number in a single line
numfiles=$(echo $file | awk '{print NF}')  #counts number of arp files associated to that simulation number
echo "sim $counter $numfiles files"


if [ $counter -eq 1 ]; then

	if [ $numfiles -gt 1 ]; then  
	#if counter = 1 and numfiles > 1
	
		sub=1
		for i in $file
		do
  		if [ $sub -eq 1 ]; then 
			#Reset file list
			(echo "$counter $i") > $fileList
			echo "Processing file $i to new temp folder" 
			#Compute stats, write to temp output file, with header
			#deleted run_silent off the end of following row
			./$arlsumstat  ./$i ./outSumStats_"$counter".txt 0 1 	
		else
			echo "Processing file $i to temp folder"
			#Compute stats and just append stats in temp output file assuming that all project files are of the same type
			#and will output the same statistics
			#deleted run_silent off the end of following row
			./$arlsumstat ./$i ./outSumStats_"$counter".txt 1 0
		fi  
		#end of subcount=1 else subcount > 1 loop

		#Remove result directory created by arlsumstat
		#%.* removes the shortest match of '.*' ie removes file extension at end, then .res is added instead 
		rm ${i%.*}.res -r
		let sub=sub+1
		done
		

		echo "PI_2_1" > ./$outss
		#sum multiple stats in temp file, from split arp files, and write single line to first line of $outss 
		cat ./outSumStats_"$counter".txt | tail -n +2 | awk '{ sum += $1} END { print sum }' >> ./$outss
		#rm ./outSumStats_"$counter".txt
		echo "manually added header line and written sum of temp file to first line of $outss"

	else   
	#if counter = 1 and numfiles = 1
		
		#Reset file list
		(echo "$counter $file") > $fileList
		echo "Processing file $file to first line of $outss"
		#Compute stats, reset output file and include header
		./$arlsumstat ./$file ./$outss 0 1
		rm ${file%.*}.res -r

	fi  
	#end of counter=1 loop, numfiles > 1 elif numfiles = 1 else numfiles = 0 

else  
#counter > 1
	
	if [ $numfiles -gt 1 ]; then  
	#if counter > 1 and numfiles > 1
	
		sub=1
		for i in $file
		do
		if [ $sub -eq 1 ]; then
			#Append file list
			(echo "$counter $i") >> $fileList
			echo "Processing file $i to new temp folder"
			#Compute stats, write to temp output file with header
			./$arlsumstat ./$i ./outSumStats_"$counter".txt 0 1
		else
			echo "Processing file $i to temp folder"
			#Compute stats and just append stats in temp output file assuming that all project files are of the same type
			#and will output the same statistics
			./$arlsumstat ./$i ./outSumStats_"$counter".txt 1 0
		fi 
		# end of subcount=1 else subcount > 1 loop
	

		#Remove result directory created by arlsumstat
		rm ${i%.*}.res -r
		let sub=sub+1
		done
	
		cat ./outSumStats_"$counter".txt | tail -n +2 | awk '{ sum += $1} END { print sum }' >> ./$outss
		#rm ./outSumStats_"$counter".txt
		echo "appended sum of temp file to $outss"

	else  
	#if counter > 1 and numfiles=1

		#Append file list
		(echo "$counter $file") >> $fileList
		echo "Processing file $file and appending to outss"
		#Compute stats and just append stats in output file assuming that all project files are of the same type
		#and will output the same statistics
		./$arlsumstat ./$file ./$outss 1 0
		rm ${file%.*}.res -r
	fi 
	#end of counter>1 loop, numfiles > 1 else numfiles = 1
	
fi  
#end of counter = 1 or else counter > 1 loop


		

let counter=counter+1
#cat $outss

done   
echo "end of LaunchArlSumStat script"

