#!/bin/sh
#
#PBS -l select=1:ncpus=12:mem=64gb
#PBS -l walltime=100:00:00
#PBS -k oe

source /etc/profile.d/modules.sh
module load gatk/4.0.2.1

cd $PBS_O_WORKDIR

REF=/home/c3244443/refs/ucsc.hg19.fasta;

for fname in *_anal_ready.bam

do

base=${fname%_anal_ready.bam}

gatk --java-options "-Xmx50g" HaplotypeCaller\
	-I ${fname}\
	-R ${REF} \
	-L /home/c3244443/refs/truseq-exome-targeted-regions-manifest-v1-2.bed \
	-ip 100 \
	-O /home/c3244443/GVCFs/${base}_sample.g.vcf.gz \
	-ERC GVCF
	
done

