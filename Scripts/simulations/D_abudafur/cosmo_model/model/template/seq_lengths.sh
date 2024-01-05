#!/bin/bash
#Checking max sequence lengths 
#Splits .arp files from template/input_autosome folder which have sequences >1mil characters (not valid for arlsumstat later on)
#All .arp files have different number of info lines at top so script checks length of last sequence line which is always 11 lines up from end of file
#creates txt file to save sequence length of arp files and note which were split


base_path="/home/mae47/rds/hpc-work/RAD_seq/D_abudafur/simulations/cosmo_model/island_1/model"

cd $base_path/template/input_autosome/
touch list_arp_lengths.txt



for file in *.arp
do
#file=input_autosome_8_1.arp

name=$(echo ${file:0:-6}) #filename prior to *_1.arp eg input_autosome_8
lines=$(cat $file | wc -l) #length of file
seqline=$(($lines - 11)) #line number of last sequence
num=1  #file number counter either original arp file or split file


while  [ $num -ge 1 ]
do

seqchar=$(sed -n $seqline'p' $file | wc -c) #number of characters in last sequence line (including line label tab) of original arp file

	if [ $seqchar -gt 1000000 ]
	then
		if [ $num -eq 1 ]  #if this is the first split of this arp file, record it 
		then
		echo "$file sequence length $seqchar so split" >> list_arp_lengths.txt	
		echo $file" sequence length > 1000000 ("$seqchar") so split in "$base_path >> ./../../../../list_split_arp_files.txt   #in root cosmo_model folder
		echo $file" sequence length > 1000000 ("$seqchar") so split in "$base_path
		fi
	row=0
	numplus=$(($num +1))
	touch $name"_"$numplus".arp"  #make new split file
		while read -r line  #NB -r ensures any backslashes are treated as regular characters
		do
		row=$(($row + 1))
		if [ ${#line} -lt 1000001 ]  #short text lines
		then
		echo $line >> $name"_"$numplus".arp"
		elif [ ${#line} -gt 1000000 ]  #too long sequences
		then
		#prefix=$(echo $line | awk '{print $1}')  #line label tab
		#echo "line $prefix"
		#echo "row $row split"
		#print line label tab, space, and 1st million characters of sequence to a tempfile
		echo $line | awk '{print $1,$2,substr($3,1,1000000)}' > $file"_temp.txt"
		#print line label tab, space, and rest of sequence to new split file
		echo $line | awk '{print $1,$2,substr($3,1000001)}' >> $name"_"$numplus".arp" 
		tempfile=$file"_temp.txt"
		#Following specific row number (Xr) of original $file, insert only label tab and 1st million characters as just printed in tempfile
		sed -i -e "${row}r $tempfile" $file
		#can now delete original line number with too long sequence
		sed -i $row'd' $file
		rm $tempfile
		fi
		done < $file
	num=$(($num + 1))
	file=$name"_"$numplus".arp"

	else  #if file <1mil characters
		if [ $num -eq 1 ]  #if this is the original arp file (not a new split file), record it 
                then
                echo "$file sequence length $seqchar" >> list_arp_lengths.txt       
                fi
	break  #exit 'while' loop
	fi

done #end of 'while' loop checking length of original arp file and each new split file
                	

done
echo "finished looping all arp files, end of script checking seq lengths"
 


