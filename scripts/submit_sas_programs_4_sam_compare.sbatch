#!/bin/bash 
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --job-name=sas
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/PBS_LOGS/
#SBATCH -t 0-15:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1

#SBATCH --mem-per-cpu=1G

module load sas/9.4

PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
LOGS=${PROJ}/sas_data/logs
OUTPUT=${PROJ}/sas_data/output
TMPDIR=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/temp_files/commonID_parent_temp

cd $SLURM_SUBMIT_DIR

## fix bed file coordinates
sas -log ${LOGS}/import_bed_fix_coord_for_sam_compare_v2.log \
    -print ${OUTPUT}/import_bed_fix_coord_for_sam_compare_v2.prt \
    -work $TMPDIR \
    -sysin ${PROJ}/scripts/import_bed_fix_coord_for_sam_compare_v2.sas

## add commonID to hybrid sam files
#sas -log ${LOGS}/add_commonID_to_sam_files_HPC.log \
#    -print ${OUTPUT}/add_commonID_to_sam_files_HPC.prt \
#    -work $TMPDIR \
#    -sysin ${PROJ}/sas_programs/add_commonID_to_sam_files_HPC.sas


