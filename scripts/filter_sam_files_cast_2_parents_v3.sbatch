#!/bin/bash
#SBATCH --account=barbazuk
#SBATCH --qos=barbazuk-b
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --job-name=filter_sam
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/filter_sam_cast_2_parents_%A_%a.out
#SBATCH -e /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/filter_sam_cast_2_parents_%A_%a.err
#SBATCH -t 0-15:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --mem-per-cpu=5G 

module load perl/5.16.0

#### Set Directories
PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
SCRIPTS=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/scripts
REF=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/filter_sam_files
SAM=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/alignment_output

OUTPUT=$PROJ/filter_sam_files/filtered_parent_sam_files
if [ ! -e $OUTPUT ]; then mkdir $OUTPUT; fi

#### Create LOG directory
LOGS=$OUTPUT/logs
if [ ! -e $LOGS ]; then mkdir $LOGS; fi

# 12 reps for Cast
for REP in 2-2-1 2-3-4 2-4-2 10-1-4 10-4-4 10-5-3 13-1-1 13-3-5 13-6-4 31-1-3 31-3-4 31-4-1
do 

# filter sam file of Lam reads to Lam with Lam bed file
    perl $SCRIPTS/sam-filter-by-bed.pl \
	-b $REF/Lamottei_overlaps_WRT_orthologs.renamed.bed \
	-s $SAM/Cast_${REP}_uniq_2_Lam.sam \
	>$OUTPUT/Cast_${REP}_uniq_2_Lam_filter_for_Cast.sam \
	2> $LOGS/Cast_${REP}_uniq_2_Lam_filter_for_Cast.log

# filter sam file of Lam reads to Croc with Croc bed file
    perl $SCRIPTS/sam-filter-by-bed.pl \
        -b $REF/Crocifolius_overlaps_WRT_orthologs.renamed.bed \
        -s $SAM/Cast_${REP}_uniq_2_Croc.sam \
        >$OUTPUT/Cast_${REP}_uniq_2_Croc_filter_for_Cast.sam \
        2> $LOGS/Cast_${REP}_uniq_2_Croc_filter_for_Cast.log

done



