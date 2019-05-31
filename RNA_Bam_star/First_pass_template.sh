
#!/bin/sh

#PBS -l select=1:ncpus=8:mem=50gb
#PBS -l walltime=50:00:00
#PBS -k oe

source /etc/profile.d/modules.sh
module load star

cd $PBS_O_WORKDIR

STAR --runThreadN 8 \
--genomeDir /home/c3244443/RNAseq/genomedir/ \
--readFilesIn \
/home/c3244443/RNAseq/fastqq/MCF-7-sh1-0hr_S17_L001_R1_001.fastq,\
/home/c3244443/RNAseq/fastqq/MCF-7-sh1-0hr_S17_L002_R1_001.fastq,\
/home/c3244443/RNAseq/fastqq/MCF-7-sh1-0hr_S17_L003_R1_001.fastq,\
/home/c3244443/RNAseq/fastqq/MCF-7-sh1-0hr_S17_L004_R1_001.fastq \
--outFileNamePrefix /home/c3244443/RNAseq/output/MCF-7-sh1-0hr_S17 \
--outSAMtype BAM SortedByCoordinate \
--quantMode TranscriptomeSAM GeneCounts \
--chimSegmentMin 20 \
--chimOutType WithinBAM \
--outSAMstrandField intronMotif \
            