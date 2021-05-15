#!/bin/bash
#SBATCH --account=barbazuk
#SBATCH --qos=barbazuk-b
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --job-name=sam_parents
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/compare_%j.out
#SBATCH -e /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/compare_%j.err
#SBATCH -t 0-15:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G

module load python/2.7.3 

#### Set Directories
PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
SCRIPTS=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/scripts
TMPDIR=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/temp_files

OUTPUT=$PROJ/ase_counts
if [ ! -e $OUTPUT ]; then mkdir $OUTPUT; fi

#### Create LOG directory
LOGS=$OUTPUT/logs
if [ ! -e $LOGS ]; then mkdir $LOGS; fi

## Lam reads to Lam and Croc 
for i in 1 2 3 4 5
do
    ## Doing Tdu -- TDU and TPO alignments for comparing
    SAMA=$PROJ/filter_sam_files/filtered_parent_sam_files/LAM_${i}_unq_2_Lam_commonID.sam
    SAMB=$PROJ/filter_sam_files/filtered_parent_sam_files/LAM_${i}_unq_2_Croc_commonID.sam

    ### Concatenate reads for use in sam-compare
    zcat /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/copy_of_original_data/Trag_sample_${i}_Lamottei/*.fastq.gz | sed 's/ /_/g' > $TMPDIR/Lam${i}.fastq

    python $SCRIPTS/sam_compare.py \
        -d \
	-l 100 \
        -f $PROJ/references/Lam_croc_bed_for_sam_compare.bed \
        -q $TMPDIR/Lam${i}.fastq \
        -A $SAMA \
        -B $SAMB \
        -c $OUTPUT/ase_counts_Lam_${i}_2_Lam_Croc.csv \
        -t $OUTPUT/ase_totals_Lam_${i}_2_Lam_Croc.csv \
        -g $LOGS/ase_counts_Lam_${i}_2_Lam_Croc.log
done


## CROC reads to Lam and Croc
for i in 6 7 8
do
    SAMA=$PROJ/filter_sam_files/filtered_parent_sam_files/CROC_${i}_unq_2_Lam_commonID.sam
    SAMB=$PROJ/filter_sam_files/filtered_parent_sam_files/CROC_${i}_unq_2_Croc_commonID.sam

    ### Concatenate reads for use in sam-compare
    zcat /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/copy_of_original_data/Trag_sample_${i}_Crocifolius/*.fastq.gz | sed 's/ /_/g' > $TMPDIR/Croc${i}.fastq

    python $SCRIPTS/sam_compare.py \
        -d \
	-l 100 \
        -f $PROJ/references/Croc_lam_bed_for_sam_compare.bed \
        -q $TMPDIR/Croc${i}.fastq \
        -A $SAMA \
        -B $SAMB \
        -c $OUTPUT/ase_counts_Croc_${i}_2_Lam_Croc.csv \
        -t $OUTPUT/ase_totals_Croc_${i}_2_Lam_Croc.csv \
        -g $LOGS/ase_counts_Croc_${i}_2_Lam_Croc.log
done

