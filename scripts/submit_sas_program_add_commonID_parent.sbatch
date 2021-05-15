#!/bin/bash 
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --job-name=sas_commonID
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/parent_commonID.out
#SBATCH -e /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/parent_commonID.err
#SBATCH -t 0-15:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --qos=barbazuk-b
#SBATCH --mem-per-cpu=5G

module load sas/9.4

PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
LOGS=$PROJ/sas_data/logs
OUTPUT=$PROJ/sas_data/output
TMPDIR=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/temp_files/commonID_parent_temp

cd $SLURM_SUBMIT_DIR

## add commonID to parent sam files
sas -log $LOGS/add_commonID_to_parent_sam_files_HPC.log \
    -print $OUTPUT/add_commonID_to_parent_sam_files_HPC.prt \
    -work $TMPDIR \
    -sysin $PROJ/scripts/add_commonID_to_parent_sam_files_HPC.sas

