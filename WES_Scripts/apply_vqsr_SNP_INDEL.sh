#!/bin/sh
#
#PBS -l select=1:ncpus=4:mem=8gb
#PBS -l walltime=100:00:00
#PBS -k oe

#LOAD MODULES NEEDED (IF THERE IS MULTIPLE VERSIONS YOU NEED TO SPECIFY THE VERSION / USE module avail 'nameofmodule' TO CHECK)
source /etc/profile.d/modules.sh
module load bwa
module load picard
module load samtools/1.6
module load gatk/4.0.2.1
module load R/3.4.0

#CHANGE DIRECTORY TO THE DIRECTORY WHERE THE qsub COMMAND IS SUBMITED
cd $PBS_O_WORKDIR

 gatk ApplyVQSR \
	-R /home/c3244443/refs/ucsc.hg19.fasta \
	-V /home/c3244443/GVCFs/FAP_cohort_geno.vcf.gz \
	-O /home/c3244443/GVCFs/VQSR/FAP_SNP_filtered.vcf.gz \
	-L /home/c3244443/refs/truseq-exome-targeted-regions-manifest-v1-2.bed \
	-ts-filter-level 90.0 \
	--tranches-file /home/c3244443/GVCFs/VQSR/FAP_cohort.SNP.tranches \
	--recal-file /home/c3244443/GVCFs/VQSR/FAPcohort.SNP.recal.table \
	--exclude-filtered true \
	-mode SNP 
	
 gatk ApplyVQSR \
	-R /home/c3244443/refs/ucsc.hg19.fasta \
	-V /home/c3244443/GVCFs/FAP_cohort_geno.vcf.gz \
	-O /home/c3244443/GVCFs/VQSR/FAP_INDEL_filtered.vcf.gz \
	-L /home/c3244443/refs/truseq-exome-targeted-regions-manifest-v1-2.bed \
	-ts-filter-level 90.0 \
	--tranches-file /home/c3244443/GVCFs/VQSR/FAP_cohort.INDEL.tranches \
	--recal-file /home/c3244443/GVCFs/VQSR/FAPcohort.INDEL.recal.table \
	--exclude-filtered true \
	-mode INDEL