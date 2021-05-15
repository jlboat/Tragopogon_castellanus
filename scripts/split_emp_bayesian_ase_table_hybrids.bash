#!/bin/bash - 
#===============================================================================
# 
#   DESCRIPTION: Split the ASE table into chunks of rows for faster processing
#   in the Bayesian machine.
# 
#===============================================================================

# Load python
module load python/2.7.6

# Set Variables
PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
PYGIT=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/scripts/

for i in Cast2 Cast10 Cast13 Cast31;
do
 
    INPUT=$PROJ/empirical_bayesian_hybrid_input/ase_bayes_${i}_lam_croc_flag.csv
    OUTDIR=$PROJ/empirical_bayesian_hybrid_input/output/split_${i}
    if [ ! -e $OUTDIR ]; then mkdir -p $OUTDIR; fi 

    # Split table
    python $PYGIT/splitTable.py -f $INPUT -o $OUTDIR --prefix split --header --nfiles 500
done

