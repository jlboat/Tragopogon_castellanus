#!/bin/bash
#SBATCH --account=barbazuk
#SBATCH --qos=barbazuk-b
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --job-name=sam_hybrid
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/compare_%j.out
#SBATCH -e /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/compare_%j.err
#SBATCH -t 0-30:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=50G
#SBATCH --partition=bigmem

module load python/2.7.3 

#### Set Directories
PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
SCRIPTS=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/scripts
ORIG=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/T.castellanus_trimmed_reads
TMPDIR=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/temp_files

OUTPUT=$PROJ/ase_counts
if [ ! -e $OUTPUT ]; then mkdir $OUTPUT; fi

#### Create LOG directory
LOGS=$OUTPUT/logs
if [ ! -e $LOGS ]; then mkdir $LOGS; fi

## Cast reads to Lam and Croc 
for i in 2_2_1 2_3_4 2_4_2 10_1_4 10_4_4 10_5_3 13_1_1 13_3_5 13_6_4 31_1_3 31_3_4 31_4_1
do
    ## Doing CAST -- Lam and Croc alignments for comparing
    SAMA=$PROJ/filter_sam_files/filtered_parent_sam_files/Cast_${i}_unq_2_Lam_commonID.sam
    SAMB=$PROJ/filter_sam_files/filtered_parent_sam_files/Cast_${i}_unq_2_Croc_commonID.sam

    SAMPLE=$(echo $i | sed 's/_/-/g')

    ### Concatenate reads for use in sam-compare
    zcat $ORIG/Cast$SAMPLE/*.fq.gz | sed 's/ /_/g' > $TMPDIR/Cast$i.fastq

    python $SCRIPTS/sam_compare.py \
        -d \
	-l 100 \
        -f $PROJ/references/Lam_croc_bed_for_sam_compare.bed \
        -q $TMPDIR/Cast$i.fastq \
        -A $SAMA \
        -B $SAMB \
        -c $OUTPUT/ase_counts_Cast_${i}_2_Lam_Croc.csv \
        -t $OUTPUT/ase_totals_Cast_${i}_2_Lam_Croc.csv \
        -g $LOGS/ase_counts_Cast_${i}_2_Lam_Croc.log
done



