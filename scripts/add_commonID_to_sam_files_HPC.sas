libname trago '/scratch/lfs/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/sas_data';

/*
(1) create list of commonIDs 
(2) import filtered sam files
(3)add commonID to sam file using consensedID
*/

data Lam_ID ;
set trago.Lam_croc_bed_for_sam_compare ;
consensedID = scan(commonID,1,'|');
drop start end ;
run ;

data Croc_ID ;
set trago.Croc_lam_bed_for_sam_compare ;
consensedID = scan(commonID,2,'|');
drop start end ;
run ;

/*
# From original script
data TPR_ID ;
set trago.Tpr_tdu_bed_for_sam_compare ;
consensedID = scan(commonID,2,'|');
drop start end ;
run ;
*/

proc sort data = Lam_ID ;
by consensedID ;
proc sort data = Croc_ID ;
by consensedID ;
run ;


%macro input_sam (hybrid, rep, against) ;

     data WORK.&hybrid._&rep._2_&against._sam    ;
     %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
     infile  "/scratch/lfs/mcintyre/trago/trago_output/filtered_hybrid_sam_files/&hybrid._&rep._uniq_2_&against._filter.sam"
 delimiter='09'x MISSOVER DSD lrecl=32767 ;
        informat readID $42. ;
        informat s_VAR2 best32. ;
        informat consensedID $36. ;
        informat pos best32. ;
        informat s_VAR5 best32. ;
        informat s_VAR6 $8. ;
        informat s_VAR7 $1. ;
        informat s_VAR8 best32. ;
        informat s_VAR9 best32. ;
        informat s_VAR10 $100. ;
        informat s_VAR11 $100. ;
        informat s_VAR12 $7. ;
        informat s_VAR13 $8. ;
        format readID $42. ;
        format s_VAR2 best12. ;
        format consensedID $36. ;
        format pos best12. ;
        format s_VAR5 best12. ;
        format s_VAR6 $8. ;
        format s_VAR7 $1. ;
        format s_VAR8 best12. ;
        format s_VAR9 best12. ;
        format s_VAR10 $100. ;
        format s_VAR11 $100. ;
        format s_VAR12 $7. ;
        format s_VAR13 $8. ;
     input
                 readID $
                 s_VAR2
                 consensedID $
                 pos
                 s_VAR5
                 s_VAR6 $
                 s_VAR7 $
                 s_VAR8
                 s_VAR9
                 s_VAR10 $
                 s_VAR11 $
                 s_VAR12 $
                 s_VAR13 $
     ;
     if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
     run;


proc sort data = &hybrid._&rep._2_&against._sam;
by consensedID ;
run;

data add_ID missingID other;
merge &against._ID (in=in1) &hybrid._&rep._2_&against._sam (in=in2);
by consensedID ;
if in1 and in2 then output add_ID ;
else if in2  then output missingID ;
else output other ;
run ;

data trago.&hybrid._&rep._uniq_2_&against._filter_commomID ;
retain readID s_VAR2 commonID pos s_VAR5-s_VAR13 ;
set add_ID ;
drop consensedID  ;
run;

proc export data = trago.&hybrid._&rep._uniq_2_&against._filter_commomID 
outfile= "/scratch/lfs/mcintyre/trago/trago_output/filtered_hybrid_sam_files/&hybrid._&rep._uniq_2_&against._filter_commomID.sam"
dbms=tab replace ; 
putnames = no ;
run;

%mend ;

%input_sam (Cast, 1, Lam) ;
%input_sam (Cast, 1, Croc) ;
%input_sam (Cast, 2, Lam) ;
%input_sam (Cast, 2, Croc) ;
%input_sam (Cast, 3, Lam) ;
%input_sam (Cast, 3, Croc) ;

/*
%input_sam (Tms, 1, TDU) ;
%input_sam (Tms, 1, TPR) ;
%input_sam (Tms, 2, TDU) ;
%input_sam (Tms, 2, TPR) ;
%input_sam (Tms, 3, TDU) ;
%input_sam (Tms, 3, TPR) ;
*/


