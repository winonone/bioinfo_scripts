#!/bin/bash

# @Author: Tobias Jakobi <tjakobi>
# @Date:   Friday, May 6, 2016 4:10 PM
# @Email:  tobias.jakobi@med.uni-heidelberg.de
# @Project: University Hospital Heidelberg, Section of Bioinformatics and Systems Cardiology
# @Last modified by:   tjakobi
# @Last modified time: Friday, May 6, 2016 4:22 PM
# @License: CC BY-NC-SA

#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 20
#SBATCH --mem=200G
#SBATCH -J "circtools postprocess"
#SBATCH --mail-type=END,FAIL,TIME_LIMIT_80
#SBATCH --mail-user=tobias.jakobi@med.uni-heidelberg.de

module load star

# check if we have 6 arguments
if [ ! $# == 6 ]; then
  echo "Usage: $0 [STAR index] [Read 1 file] [Read 2 file] [target dir e.g. /tmp/] [Read 1 marker, e.g. R1] [GTF file]"
  exit
fi

# $1 -> Genome index
# $2 -> Read 1
# $3 -> Read 2
# $4 -> Target directory

# remove the file extension and potential "R1" markings
# (works for double extension, e.g. .fastq.gz)
target=`expr ${2/$5/} : '\(.*\)\..*\.'`

# create the target directory, STAR will not do that for us
#mkdir -pv $4/$target
#mkdir -pv $4/$target/mate1/
#mkdir -pv $4/$target/mate2/

#mkdir -pv $4/$target/mate2_new/
#mkdir -pv $4/$target/mate1_new/

cd $4/$target

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Aligned.out.sam > Aligned.noS.sam

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Chimeric.out.sam > Chimeric.noS.sam

grep "^@" Aligned.out.sam > header.txt

rm -f Aligned.out.sam
rm -f Chimeric.out.sam

rm -f -r _STARgenome
rm -f -r _STARpass1

samtools view -bS Aligned.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Aligned.noS.bam /dev/stdin
samtools reheader header.txt Aligned.noS.bam > Aligned.noS.tmp
mv Aligned.noS.tmp Aligned.noS.bam
samtools index Aligned.noS.bam

samtools view -bS Chimeric.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Chimeric.noS.bam /dev/stdin
samtools reheader header.txt Chimeric.noS.bam > Chimeric.noS.tmp
mv Chimeric.noS.tmp Chimeric.noS.bam
samtools index Chimeric.noS.bam

rm -f Aligned.noS.sam
rm -f Chimeric.noS.sam

cd mate1/

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Aligned.out.sam > Aligned.noS.sam

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Chimeric.out.sam > Chimeric.noS.sam

grep "^@" Aligned.out.sam > header.txt

rm -f Aligned.out.sam
rm -f Chimeric.out.sam

rm -f -r _STARgenome
rm -f -r _STARpass1

samtools view -bS Aligned.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Aligned.noS.bam /dev/stdin
samtools reheader header.txt Aligned.noS.bam > Aligned.noS.tmp
mv Aligned.noS.tmp Aligned.noS.bam
samtools index Aligned.noS.bam

samtools view -bS Chimeric.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Chimeric.noS.bam /dev/stdin
samtools reheader header.txt Chimeric.noS.bam > Chimeric.noS.tmp
mv Chimeric.noS.tmp Chimeric.noS.bam
samtools index Chimeric.noS.bam

rm -f Aligned.noS.sam
rm -f Chimeric.noS.sam

cd ../
cd mate2/

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Aligned.out.sam > Aligned.noS.sam

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Chimeric.out.sam > Chimeric.noS.sam

grep "^@" Aligned.out.sam > header.txt

rm -f Aligned.out.sam
rm -f Chimeric.out.sam

rm -f -r _STARgenome
rm -f -r _STARpass1

samtools view -bS Aligned.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Aligned.noS.bam /dev/stdin
samtools reheader header.txt Aligned.noS.bam > Aligned.noS.tmp
mv Aligned.noS.tmp Aligned.noS.bam
samtools index Aligned.noS.bam

samtools view -bS Chimeric.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Chimeric.noS.bam /dev/stdin
samtools reheader header.txt Chimeric.noS.bam > Chimeric.noS.tmp
mv Chimeric.noS.tmp Chimeric.noS.bam
samtools index Chimeric.noS.bam

rm -f Aligned.noS.sam
rm -f Chimeric.noS.sam

cd ..
cd mate1_new/

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Aligned.out.sam > Aligned.noS.sam

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Chimeric.out.sam > Chimeric.noS.sam

grep "^@" Aligned.out.sam > header.txt

rm -f Aligned.out.sam
rm -f Chimeric.out.sam

rm -f -r _STARgenome
rm -f -r _STARpass1

samtools view -bS Aligned.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Aligned.noS.bam /dev/stdin
samtools reheader header.txt Aligned.noS.bam > Aligned.noS.tmp
mv Aligned.noS.tmp Aligned.noS.bam
samtools index Aligned.noS.bam

samtools view -bS Chimeric.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Chimeric.noS.bam /dev/stdin
samtools reheader header.txt Chimeric.noS.bam > Chimeric.noS.tmp
mv Chimeric.noS.tmp Chimeric.noS.bam
samtools index Chimeric.noS.bam

rm -f Aligned.noS.sam
rm -f Chimeric.noS.sam

cd ..

cd mate2_new/

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Aligned.out.sam > Aligned.noS.sam

awk 'BEGIN {OFS="\t"} {split($6,C,/[0-9]*/); split($6,L,/[SMDIN]/); if (C[2]=="S") {$10=substr($10,L[1]+1); $11=substr($11,L[1]+1)}; if (C[length(C)]=="S") {L1=length($10)-L[length(L)-1]; $10=substr($10,1,L1); $11=substr($11,1,L1); }; gsub(/[0-9]*S/,"",$6); print}' Chimeric.out.sam > Chimeric.noS.sam

grep "^@" Aligned.out.sam > header.txt

rm -f Aligned.out.sam
rm -f Chimeric.out.sam

rm -f -r _STARgenome
rm -f -r _STARpass1

samtools view -bS Aligned.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Aligned.noS.bam /dev/stdin
samtools reheader header.txt Aligned.noS.bam > Aligned.noS.tmp
mv Aligned.noS.tmp Aligned.noS.bam
samtools index Aligned.noS.bam

samtools view -bS Chimeric.noS.sam | samtools sort -@ 10 -m 2G -T tempo -o Chimeric.noS.bam /dev/stdin
samtools reheader header.txt Chimeric.noS.bam > Chimeric.noS.tmp
mv Chimeric.noS.tmp Chimeric.noS.bam
samtools index Chimeric.noS.bam

rm -f Aligned.noS.sam
rm -f Chimeric.noS.sam

