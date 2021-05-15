#!/bin/bash
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --job-name=emp_bayes_machine
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --qos=barbazuk-b
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/emp_bayes_l3.out
#SBATCH -e /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/emp_bayes_l3.err
#SBATCH -t 0-24:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --mem-per-cpu=600mb
#SBATCH --array=1-500

module load R/3.0.2

# Set Directories
    PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/
    RPROG=$PROJ/scripts/emp_bayesian/PG_model_empirical_q456.r

## only have Cast

for i in Croc ;
do
    OUTDIR=$PROJ/empirical_bayesian_parents_output/split_${i}_l3
    if [ ! -e $OUTDIR ] ; then mkdir -p $OUTDIR; fi

    LOGS=$OUTDIR/logs
    if [ ! -e $LOGS ] ; then mkdir -p $LOGS; fi

# Set Files
    INPUT=$PROJ/empirical_bayesian_parents_input/output/split_${i}_l3/split_${SLURM_ARRAY_TASK_ID}.csv
    OUTPUT=$OUTDIR/split_${SLURM_ARRAY_TASK_ID}_l3.csv
    MYLOG=$LOGS/split_${SLURM_ARRAY_TASK_ID}_l3.log

    echo "Running $INPUT ['date']" > $MYLOG
    Rscript $RPROG $INPUT $OUTPUT &>> $MYLOG
done

for i in Lam ;
do
    OUTDIR=$PROJ/empirical_bayesian_parents_output/split_${i}_l3
    if [ ! -e $OUTDIR ] ; then mkdir -p $OUTDIR; fi
    
    LOGS=$OUTDIR/logs
    if [ ! -e $LOGS ] ; then mkdir -p $LOGS; fi

# Set Files
    INPUT=$PROJ/empirical_bayesian_parents_input/output/split_${i}_l3/split_${SLURM_ARRAY_TASK_ID}.csv
    OUTPUT=$OUTDIR/split_${SLURM_ARRAY_TASK_ID}_l3.csv
    MYLOG=$LOGS/split_${SLURM_ARRAY_TASK_ID}_l3.log

    echo "Running $INPUT ['date']" > $MYLOG
    Rscript $RPROG $INPUT $OUTPUT &>> $MYLOG
done

