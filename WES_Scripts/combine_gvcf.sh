#!/bin/sh
#
#PBS -l select=1:ncpus=12:mem=24gb
#PBS -l walltime=100:00:00
#PBS -k oe

source /etc/profile.d/modules.sh
module load bwa
module load picard
module load samtools/1.6
module load gatk/4.0.2.1


cd $PBS_O_WORKDIR

REFERENCE=/home/c3244443/refs/ucsc.hg19.fasta;

gatk CombineGVCFs \
	-R ${REFERENCE} \
	-V AM_sample.g.vcf.gz \
-V AS_sample.g.vcf.gz \
-V AY_sample.g.vcf.gz \
-V AU_sample.g.vcf.gz \
-V V_sample.g.vcf.gz \
-V BP_sample.g.vcf.gz \
-V AE_sample.g.vcf.gz \
-V R_sample.g.vcf.gz \
-V T_sample.g.vcf.gz \
-V AC_sample.g.vcf.gz \
-V BQ_sample.g.vcf.gz \
-V AN_sample.g.vcf.gz \
-V W_sample.g.vcf.gz \
-V BX_sample.g.vcf.gz \
-V AH_sample.g.vcf.gz \
-V P_sample.g.vcf.gz \
-V M_sample.g.vcf.gz \
-V O_sample.g.vcf.gz \
-V BS_sample.g.vcf.gz \
-V AB_sample.g.vcf.gz \
-V BU_sample.g.vcf.gz \
-V N_sample.g.vcf.gz \
-V BT_sample.g.vcf.gz \
-V BR_sample.g.vcf.gz \
-V BZ_sample.g.vcf.gz \
-V BB_sample.g.vcf.gz \
-V AV_sample.g.vcf.gz \
-V BW_sample.g.vcf.gz \
-V BE_sample.g.vcf.gz \
-V BY_sample.g.vcf.gz \
-V BK_sample.g.vcf.gz \
-V BL_sample.g.vcf.gz \
-V CA_sample.g.vcf.gz \
-V BM_sample.g.vcf.gz \
-V BG_sample.g.vcf.gz \
-V BC_sample.g.vcf.gz \
-V AX_sample.g.vcf.gz \
-V BN_sample.g.vcf.gz \
-V BO_sample.g.vcf.gz \
-V BF_sample.g.vcf.gz \
-V BJ_sample.g.vcf.gz \
-V AQ_sample.g.vcf.gz \
-V BI_sample.g.vcf.gz \
-V BA_sample.g.vcf.gz \
-V BD_sample.g.vcf.gz \
-V AR_sample.g.vcf.gz \
-V BV_sample.g.vcf.gz \
-V BH_sample.g.vcf.gz \
	-O FAPcohort.g.vcf.gz 