#!/bin/sh
#
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=1:00:00
#PBS -k oe

cd $PBS_O_WORKDIR

for i in {1..22} {X..Y} M

do 

qsub make-db-${i}.sh

done