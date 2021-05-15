#!/bin/bash
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --job-name=filter_sam
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/filter_sam_files_parents_%A_%a.out
#SBATCH -e /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/filter_sam_files_parents_%A_%a.err
#SBATCH -t 0-15:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --account=barbazuk
#SBATCH --qos=barbazuk-b
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G 

## TDU (1-3)
## TPO (4-6)
## TPR (7-9)


module load perl 

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

# 5 reps for Lam
for REP in 1 2 3 4 5
do 

# filter sam file of Lam reads to Lam with Lam bed file
    perl $SCRIPTS/sam-filter-by-bed.pl \
	-b $REF/Lamottei_overlaps_WRT_orthologs.renamed.bed \
	-s $SAM/Lamottei_${REP}_uniq_2_Lam.sam \
	>$OUTPUT/Lamottei_${REP}_uniq_2_Lam_filter_for_Cast.sam \
	2> $LOGS/Lamottei_${REP}_uniq_2_Lam_filter_for_Cast.log

# filter sam file of Lam reads to Croc with Croc bed file
    perl $SCRIPTS/sam-filter-by-bed.pl \
        -b $REF/Crocifolius_overlaps_WRT_orthologs.renamed.bed \
        -s $SAM/Lamottei_${REP}_uniq_2_Croc.sam \
        >$OUTPUT/Lamottei_${REP}_uniq_2_Croc_filter_for_Cast.sam \
        2> $LOGS/Lamottei_${REP}_uniq_2_Croc_filter_for_Cast.log

done

# 3 reps for Croc
for REP in 6 7 8 
do 

# filter sam file of Croc reads to Lam with Lam bed file
    perl $SCRIPTS/sam-filter-by-bed.pl \
        -b $REF/Lamottei_overlaps_WRT_orthologs.renamed.bed \
        -s $SAM/Crocifolius_${REP}_uniq_2_Lam.sam \
        >$OUTPUT/Crocifolius_${REP}_uniq_2_Lam_filter_for_Cast.sam \
        2> $LOGS/Crocifolius_${REP}_uniq_2_Lam_filter_for_Cast.log

# filter sam file of Croc reads to Croc with Croc bed file
    perl $SCRIPTS/sam-filter-by-bed.pl \
        -b $REF/Crocifolius_overlaps_WRT_orthologs.renamed.bed \
        -s $SAM/Crocifolius_${REP}_uniq_2_Croc.sam \
        >$OUTPUT/Crocifolius_${REP}_uniq_2_Croc_filter_for_Cast.sam \
        2> $LOGS/Crocifolius_${REP}_uniq_2_Croc_filter_for_Cast.log
done


