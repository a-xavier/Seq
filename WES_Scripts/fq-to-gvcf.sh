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

#ENTER THE REFERENCE ASSEMBLY AND INFO HERE
REFERENCE=/home/c3244443/refs/ucsc.hg19.fasta;
FCBARCODE=FLOWCODE;
LIB=lib1;
#REFERENCE SNP AND INDEL DATABASE USING NON COMPRESSED VCF ALSO INTERVAL FILE (BED FILE)
DBSNP=/home/c3244443/refs/dbsnp_138.hg19.vcf;
MILLS=/home/c3244443/refs/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf;
TGEN=/home/c3244443/refs/1000G_phase1.indels.hg19.sites.vcf;
BED=/home/c3244443/refs/truseq-exome-targeted-regions-manifest-v1-2.bed;

#EVERYTHING HAPPENS IN A SINGLE DIRECTORY CONTAINING THE FASTQ FILES FOR A SINGLE SAMPLE

#STEP 1 : CREATE A MAPPED SAM FILE FROM EACH PAIR OF FASTQ FILES / ONE PER LANE IF THERE IS MULTIPLE LANES IN THE FLOW CELL
#USING BWA MEM AND THE -M FOR PICARD COMPATIBILITY

for fname in *_R1_001.fastq.gz;

do
	 base=${fname%_R1_001*}
	 bwa mem -M ${REFERENCE} ${base}_R1_001.fastq.gz  ${base}_R2_001.fastq.gz > ./${base}.sam

done

wait

#STEP 2 : USE PICARD TO ASSING PROPER READ GROUPS THEN SORT BY COORDINATE AND THEN OUTPUT BAM FILE

for fname in *.sam;

do
	 id=${fname%.sam}
	 samp=${id%%_*}
	 lane=${id##*_}
	 
	 picard AddOrReplaceReadGroups I=${id}.sam O=${id}_RG.bam RGID=${FCBARCODE}.${lane} RGLB=${LIB} RGPU=${FCBARCODE}.${lane}.${samp} RGPL=illumina RGCN=HMRI RGSM=${samp}_sample SORT_ORDER=coordinate

done


wait

#STEP 3 : USE PICARD TO MARK DUPLICATES (dedups) AND ALSO MERGE THE BAM FILES TOGETHER

for fname in *_L001_RG.bam;

do

	samp=${fname%%_*}
	id=${fname%_L001_RG.bam}
	
	picard MarkDuplicates I=${id}_L001_RG.bam I=${id}_L002_RG.bam I=${id}_L003_RG.bam I=${id}_L004_RG.bam O=${samp}_dedups.bam M=${samp}_metrics.txt
	
done

wait

#STEP 3.5 INDEX DEPUPED BAM WITH SAMTOOLS

for fname in *_dedups.bam

do

samtools index ${fname}

done

#STEP 4 : CREATE RECALIBRATION TABLE FOR BQSR (BASE QUALITY SCORE RECALIBRATION)
#ONLY APPLY TO GENOMIC INTERVAL PROVIDED BY BED FILE PLUS 100 BP BEFORE AND AFTER
for fname in *_dedups.bam

do

base=${fname%_dedups.bam}

gatk BaseRecalibrator -I ${fname} -R ${REFERENCE} \
	--known-sites ${DBSNP} \
	--known-sites ${MILLS} \
	--known-sites ${TGEN} \
	-L ${BED} \
	-ip 100 \
	-O ${base}_recal_data.table
	
done

wait

#STEP 5 : APPLY BQSR ON BAM FILES AND OUTPUT RECALIBRATED BAMS 
#ONLY APPLY TO GENOMIC INTERVAL PROVIDED BY BED FILE PLUS 100 BP BEFORE AND AFTER


for fname in *_dedups.bam

do

base=${fname%_dedups.bam}

gatk ApplyBQSR -I ${fname}\
	-R ${REFERENCE} \
	--bqsr-recal-file ${base}_recal_data.table \
	-L ${BED} \
	-ip 100 \
	-O ${base}_anal_ready.bam
	
done

wait

#STEP 6 : GENERATE GVCF FROM BAM FILE

for fname in *_anal_ready.bam

do

base=${fname%_anal_ready.bam}

gatk --java-options "-Xmx45g" HaplotypeCaller\
	-I ${fname}\
	-R ${REFERENCE} \
	-L ${BED} \
	-ip 100 \
	-O ${base}_sample.g.vcf.gz \
	-ERC GVCF
	
done






