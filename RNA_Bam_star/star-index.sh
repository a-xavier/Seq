#!/bin/sh
#
#PBS -l select=1:ncpus=8:mem=24gb
#PBS -l walltime=20:00:00
#PBS -k oe

source /etc/profile.d/modules.sh
module load star

cd $PBS_O_WORKDIR
# overhang should be reads length minus 1

star --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir /home/c3244443/RNAseq/genomedir/ \
--genomeFastaFiles /home/c3244443/refs/ucsc.hg19.fasta \
--sjdbGTFfile /home/c3244443/refs/gencode.v29.annotation.gtf \
--sjdbOverhang 74