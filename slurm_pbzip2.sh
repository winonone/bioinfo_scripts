#!/bin/bash

# @Author: Tobias Jakobi <tjakobi>
# @Email:  tobias.jakobi@med.uni-heidelberg.de
# @Project: University Hospital Heidelberg, Section of Bioinformatics and Systems Cardiology
# @License: CC BY-NC-SA

#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 20
#SBATCH --mem=20G
#SBATCH -J "pbzip2"
#SBATCH --mail-type=END,FAIL,TIME_LIMIT_80
#SBATCH --mail-user=tobias.jakobi@med.uni-heidelberg.de

# module load R

# check if we have 6 arguments
#if [ ! $# == 1 ]; then
#  echo "Usage: $0 file"
#  exit
#fi

pbzip2 -p20 $@
