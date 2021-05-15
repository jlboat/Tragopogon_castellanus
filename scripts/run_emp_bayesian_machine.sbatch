#!/bin/bash
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --mail-type=
#SBATCH -p bio
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS
#SBATCH -e /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS
#SBATCH -t 0-24:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1

#SBATCH --mem-per-cpu=600mb
#SBATCH --array=1-500

module load R/3.0.2

# Set Directories
    PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
    RPROG=$PROJ/scripts/PG_model_empirical_q456.r

for i in Cast;
do
    OUTDIR=$PROJ/empirical_bayesian_hybrid_output/split_${i}
    if [ ! -e $OUTDIR ] ; then mkdir -p $OUTDIR; fi
    
    LOGS=$OUTDIR/logs
    if [ ! -e $LOGS ] ; then mkdir -p $LOGS; fi

# Set Files
    INPUT=$PROJ/empirical_bayesian_hybrid_input/output/split_${i}/split_${SLURM_ARRAY_TASK_ID}.csv
    OUTPUT=$OUTDIR/split_${SLURM_ARRAY_TASK_ID}.csv
    MYLOG=$LOGS/split_${SLURM_ARRAY_TASK_ID}.log

    echo "Running $INPUT [`date`]" > $MYLOG
    Rscript $RPROG $INPUT $OUTPUT &>>$MYLOG
done

