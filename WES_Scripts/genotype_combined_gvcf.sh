#!/bin/sh
#
#PBS -l select=1:ncpus=4:mem=50gb
#PBS -l walltime=100:00:00
#PBS -k oe

#LOAD MODULES NEEDED (IF THERE IS MULTIPLE VERSIONS YOU NEED TO SPECIFY THE VERSION / USE module avail 'nameofmodule' TO CHECK)
source /etc/profile.d/modules.sh
module load bwa
module load picard
module load samtools/1.6
module load gatk/4.0.2.1

#CHANGE DIRECTORY TO THE DIRECTORY WHERE THE qsub COMMAND IS SUBMITED
cd $PBS_O_WORKDIR

gatk IndexFeatureFile -F FAP_cohort.g.vcf.gz

gatk --java-options "-Xmx45g" GenotypeGVCFs \
	-R /home/c3244443/refs/ucsc.hg19.fasta \
	-V FAP_cohort.g.vcf.gz \
	-O FAP_cohort_geno.vcf.gz