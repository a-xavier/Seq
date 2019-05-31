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
	--resource hapmap,known=false,training=true,truth=true,prior=15.0:/home/c3244443/refs/hapmap_3.3.hg19.sites.vcf \
	--resource omni,known=false,training=true,truth=true,prior=12.0:/home/c3244443/refs/1000G_omni2.5.hg19.sites.vcf \
	--resource 1000G,known=false,training=true,truth=false,prior=10.0:/home/c3244443/refs/1000G_phase1.snps.high_confidence.hg19.sites.vcf \
	--resource dbsnp,known=true,training=false,truth=false,prior=2.0:/home/c3244443/refs/dbsnp_138.hg19.vcf \
	-an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
	-mode SNP \
	-tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 -tranche 88.0 -tranche 86.0 -tranche 84.0 -tranche 82.0 -tranche 80.0 \
	-O /home/c3244443/GVCFs/VQSR/FAPcohort.SNP.recal.table \
	--tranches-file /home/c3244443/GVCFs/VQSR/FAP_cohort.SNP.tranches \
	--rscript-file /home/c3244443/GVCFs/VQSR/FAP_cohort.plots.SNP.R