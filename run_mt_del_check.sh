#!/bin/bash -l
#SBATCH -c 1
#SBATCH -t 00:10:00
#SBATCH -J run_mitodel
#SBATCH --mail-type=ALL
#SBATCH --mail-user=daniel.nilsson@scilifelab.se
#SBATCH --qos=normal

BAM_FILE=$1
OUT_DIR=$2

BAM_FILE_BASE=`basename ${BAM_FILE}`
SAMPLE=${BAM_FILE_BASE%%_*.bam}

source activate samtools
samtools stats -i 16000 $BAM_FILE MT > ${OUT_DIR}/${SAMPLE}.mt_bam_stat

grep ^IS ${OUT_DIR}/${SAMPLE}.mt_bam_stat |awk '($2>=1200 && $2<=15000) {sum=sum+$3} ($2<1200 || $2>15000) {sum_norm=sum_norm+$3} END {print "intermediate discordant ", sum, "normal ", sum_norm, "ratio ppk", sum*1000/(sum_norm+sum)}' > ${OUT_DIR}/${SAMPLE}.mt_del_summary

