#!/bin/sh
#
#PBS -l select=1:ncpus=4:mem=12gb
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

 gatk VariantRecalibrator \
	-R /home/c3244443/refs/ucsc.hg19.fasta \
	-V /home/c3244443/GVCFs/FAP_cohort_geno.vcf.gz \
	-L /home/c3244443/refs/truseq-exome-targeted-regions-manifest-v1-2.bed \
	--max-gaussians 4 \
	--resource mills,known=false,training=true,truth=true,prior=12.0:/home/c3244443/refs/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf\
	--resource dbsnp,known=true,training=false,truth=false,prior=2.0:/home/c3244443/refs/dbsnp_138.hg19.vcf\
	-an QD -an FS -an SOR -an ReadPosRankSum \
	-mode INDEL \
	-tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 \
	-O /home/c3244443/GVCFs/VQSR/FAPcohort.INDEL.recal.table \
	--tranches-file /home/c3244443/GVCFs/VQSR/FAP_cohort.INDEL.tranches \
	--rscript-file /home/c3244443/GVCFs/VQSR/FAP_cohort.plots.INDEL.R