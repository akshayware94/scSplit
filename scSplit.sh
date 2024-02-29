#!/usr/bin/bash

clear

echo "";
echo "########################################################";
echo "";
echo " +-+-+-+-+-+-+-+-+-+";
echo "  | scSplit v1.0 |";
echo " +-+-+-+-+-+-+-+-+-+";
echo "";
echo "Developed by: ";
echo "Dr. Akshay Ware and Prof. Dr. Wesley Abplanalp  ";
echo "Institute of Cardiovascular Regeneration";
echo "Goethe University, Frankfurt am Main - 60596";
echo "For more information, visit:";
echo "https://github.com/akshayware94/scSplit";
echo "";
echo "For help, inqueries and suggestions, please contact:";
echo "Ware@med.uni-frankfurt.de or abplanalp@em.uni-frankfurt.de";
echo "";
echo "########################################################";
echo "";
echo "Starting Analysis..";
echo "Loading Dependencies..";
echo "";

helpFunction()
{
   echo "";
   echo "Usage: $0 [-f] [-b] [-c] [-g] [-n]";
   echo "";
   echo -e "\t-f Provide BAM file scRNASeq run";
   echo -e "\t-b Provide text file conatin list of barcode, one barcode per line";
   echo -e "\t-c Provide BED file conatin chromosome coordinates (user specified genomic regions)";
   echo -e "\t-g This File contain, first column consists of the chromosome name (chr1, chr2, chr3…) and the second column consists of the chromosome size or length";
   echo -e "\t-n Provide no of threads to run this program";
   echo "";
   exit 1 
}

while getopts "f:b:c:g:n:" opt
do
   case "$opt" in
      f) parf="$OPTARG" ;;
      b) parb="$OPTARG" ;;
      c) parc="$OPTARG" ;;
      g) parg="$OPTARG" ;;
      n) parn="$OPTARG" ;;
      ? ) helpFunction ;;
   esac
done

if [ -z "$parf" ] || [ -z "$parb" ] || [ -z "$parc" ] || [ -z "$parg" ] || [ -z "$parn" ]
then
   echo ""
   echo "Some or all of the parameters are empty";
   helpFunction
fi

di=$(pwd)

echo "";
echo "------Parameter Details------";
echo "1) BAM File: $parf"
echo "2) Barcode File: $parb"
echo "3) Coordinate File: $parc"
echo "4) Genome File: $parg"
echo "5) No of threads: $parn"
echo "";
	
echo "------Input Details------";


samtools view -H $parf > $di/header.txt

sort -k1,1 -k2,2n $parc > $di/tmp_coor_bed.bed
parc="$di/tmp_coor_bed.bed"

#awk '{print $1,"\t"$2,"\t"$3}' $parc > $di/tmp_coor.txt

tmp_coor="$di/tmp_coor_bed.bed"

b_lines=$(wc -l < "$parb")
c_lines=$(wc -l < "$tmp_coor")

echo "";
echo "Total no of barcode detected: $b_lines"
echo "Total no of coordinates detected: $c_lines"
echo "";

echo "------Progress Details------";
mkdir -p $di/Tmp
mkdir -p $di/Tmp/SAM
mkdir -p $di/Tmp/BAM
mkdir -p $di/Tmp/BEDTools_RI_Count
mkdir -p $di/Tmp/RI_Counts


while read -r line; do
    name="$line"
    
	for i in $name
	do
		
		var=$((var+1))
		echo "Processing CB No: $var CB: $i"

		samtools view -@ $parn $parf | grep "$i" > $di/Tmp/SAM/$i.sam
		cat $di/header.txt $di/Tmp/SAM/$i.sam > $di/Tmp/SAM/$i.tmp && mv $di/Tmp/SAM/$i.tmp $di/Tmp/SAM/$i.sam
		samtools view -@ $parn -b $di/Tmp/SAM/$i.sam | samtools sort --write-index -o $di/Tmp/BAM/$i.bam
		samtools index -@ $parn Tmp/BAM/$i.bam
  	
		bedtools coverage \
	       		-g $parg \
               		-split \
               		-sorted \
               		-a $parc \
               		-b $di/Tmp/BAM/$i.bam > \
                  	$di/Tmp/BEDTools_RI_Count/$i.txt \
               		-d

  		rm -f $di/Tmp/SAM/$i.sam
		rm -f $di/Tmp/BAM/$i.bam
		rm -f $di/Tmp/BAM/$i.bam.bai
		rm -f $di/Tmp/BAM/$i.bam.csi

done

while read -r line1; do
	name1="$line1"

	
		mkdir -p $di/Tmp/Count/
		mkdir -p $di/Tmp/Count/$name
		mkdir -p $di/Tmp/Final_Counts/
		
		grep "$name1" $di/Tmp/BEDTools_RI_Count/$i.txt > $di/Tmp/Count/$name/"$name1".txt
		
		count=$(awk '{sum += $7} END {print sum}' $di/Tmp/Count/$name/"$name1".txt)  		
 		
 		printf "%s\t%s\n" "$name1" "$count" >> $di/Tmp/Final_Counts/"$name"_temp.txt
  		echo -e "\t\t\t$name" > $di/Tmp/Final_Counts/"$name".txt && cat $di/Tmp/Final_Counts/"$name"_temp.txt >> $di/Tmp/Final_Counts/"$name".txt
  		
             	rm -f $di/Tmp/Count/$name/"$name1".txt
      
done < "$tmp_coor"
		
		rm -f $di/Tmp/BEDTools_RI_Count/$i.txt
		rm -f $di/Tmp/Final_Counts/"$name"_temp.txt
  		
  		

done < "$parb"

		rm -f $di/tmp_coor_bed.bed
		rm -f $di/tmp_coor.txt
		rm -f $di/header.txt

