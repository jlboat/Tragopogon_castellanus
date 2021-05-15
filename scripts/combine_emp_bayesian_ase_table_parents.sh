#!/bin/bash - 
#===============================================================================
# 
#   DESCRIPTION: Combine the split files from the ASE table 
# 
#===============================================================================

# Load python
module load python/2.7.6

# Set Variables
PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
PYGIT=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/scripts

for i in Croc Lam ;
do

    INPUT=$PROJ/empirical_bayesian_parents_output/split_${i}

    OUTDIR=$PROJ/empirical_bayesian_parents_output

    # combine table
    python $PYGIT/catTable.py -f $INPUT/split_*.csv --odir $OUTDIR --oname PG_emp_bayesian_results_${i}_parents.csv --header

done

