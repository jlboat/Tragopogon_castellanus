#!/bin/bash
#SBATCH --job-name=align_Cast_Lam_perl
#SBATCH --mail-user=lboat@ufl.edu
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH -o /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/Cast_to_Lam_align_%A_%a.out
#SBATCH -e /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/Cast_to_Lam_align_%A_%a.err
#SBATCH -t 0-96:00:00
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --qos=barbazuk-b
#SBATCH --mem-per-cpu=300gb
#SBATCH --array=1-12
#SBATCH -p bigmem
     ## 12 Cast samples 2, 10, 13, 31 (3 reps each)
   
module load bowtie/0.12.9
module load last/531
module load python/2.7.3

#### Store number of processors used -- i.e. number of files to split into to run LAST
    NUMPROCS=12

## Set directories
    PROJ=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare
    ORIG=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/T.castellanus_trimmed_reads

    OUTPUT=$PROJ/alignment_output
    if [ ! -e $OUTPUT ]; then mkdir -p $OUTPUT; fi
    ALN_LOGS=$OUTPUT/aln_logs
    if [ ! -e $ALN_LOGS ]; then mkdir -p $ALN_LOGS; fi

## Pull info from design file
    DESIGN_FILE=$PROJ/design_files/trago_cast_with_reps.txt
    DESIGN=$(cat $DESIGN_FILE | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)

    IFS=',' read -ra ARRAY <<< "$DESIGN"

    SP=${ARRAY[0]}
    REP=${ARRAY[1]}
    TMPDIR=/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/temp_files/${SP}_${REP}_temp
    if [ ! -e $TMPDIR ]; then mkdir -p $TMPDIR; fi
## Reference
    REF=$PROJ/references/Lamottei_post_compression_contigs.renamed.bowtie.ref
    LASTREF=$PROJ/references/Lamottei_post_compression_contigs.renamed.last531.ref

#### Create LOG directory and start log
    LOGS=$OUTPUT/job_logs              #script log information
    ALN_ERROR_LOG=$LOGS/size_errors.txt
    if [ ! -d $LOGS ]; then mkdir -p $LOGS; fi

    MYLOG=$LOGS/${SP}_${REP}_Lam_consensus.log
    printf "`date` $SP SGE_ID:$SLURM_ARRAY_TASK_ID HOSTNAME:$HOSTNAME \n\n" > $MYLOG

    ALNLOGS=$OUTPUT/aln_logs       
    if [ ! -d $ALNLOGS ]; then mkdir -p $ALNLOGS; fi


    cd $TMPDIR

    # PARSE LAST FILES
        echo "START Parsing LAST SAM file into unique and ambiguous [`date`]" >>$MYLOG
        perl /ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/scripts/parse_last_sam_v2.pl \
            ${SP}_${REP}_last.sam \
            ${SP}_${REP}_ambig_last.sam \
            ${SP}_${REP}_uniq_last.sam \
            >> $ALNLOGS/${SP}_${REP}_2_Lam_LAST.log

#            rm ${SP}_${REP}_last.sam 

        echo "FINISH Parsing LAST SAM file into unique and ambiguous [`date`]" >>$MYLOG

#### File Check
    cd $TMPDIR
    echo "FILE SIZE CHECK">>$MYLOG
    du -sh *.sam >>$MYLOG

#### Combine all Sam files
    echo "START Combine SAM files">>$MYLOG

    cat ${SP}_${REP}_aln_bt.sam ${SP}_${REP}_uniq_last.sam > $OUTPUT/${SP}_${REP}_uniq_2_Lam.sam 2>>$MYLOG
    mv ${SP}_${REP}_ambig_last.sam $OUTPUT/${SP}_${REP}_ambig_last_2_Lam.sam 2>>$MYLOG
    
echo "Script complete, [`date`]" >>$MYLOG

