#!/bin/sh
#
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=1:00:00
#PBS -k oe

cd $PBS_O_WORKDIR

for i in {1..22} {X..Y} M

do 

echo '#!/bin/sh'>> make-db-${i}.sh
echo '#'\n>> make-db-${i}.sh
echo '#PBS -l select=1:ncpus=12:mem=50gb'>> make-db-${i}.sh
echo '#PBS -l walltime=50:00:00'>> make-db-${i}.sh
echo '#PBS -k oe' >> make-db-${i}.sh

echo 'source /etc/profile.d/modules.sh'>> make-db-${i}.sh
echo 'module load gatk/4.0.2.1' >> make-db-${i}.sh

echo 'cd $PBS_O_WORKDIR' >> make-db-${i}.sh

echo 'gatk --java-options "-Xmx20g -Xms20g" \' >> make-db-${i}.sh
echo        'GenomicsDBImport \' >> make-db-${i}.sh
echo       '--genomicsdb-workspace-path /home/c3244443/GVCFs/genomic_db_'${i}/' \' >> make-db-${i}.sh
echo        '--batch-size 50 \' >> make-db-${i}.sh
echo        '-L chr'${i}' \' >> make-db-${i}.sh
echo        '--sample-name-map /home/c3244443/GVCFs/map-db.sample_map \' >> make-db-${i}.sh
echo        '--reader-threads 5'>> make-db-${i}.sh

done 
