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

for i in Cast2 Cast10 Cast13 Cast31 ;
do

    INPUT=$PROJ/empirical_bayesian_hybrid_output/split_${i}

    OUTDIR=$PROJ/empirical_bayesian_hybrid_output

    # combine table
    python $PYGIT/catTable.py -f $INPUT/split_*.csv --odir $OUTDIR --oname PG_emp_bayesian_results_${i}_hybrid.csv --header

done

