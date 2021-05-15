libname trago '/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/sas_data';

/*
* create list of commonIDs 
* import filtered sam files
* add commonID to sam file using consensedID
*/

data Cast_ID_lam_croc ;
set trago.Lam_croc_bed_for_sam_compare ;
consensedID = scan(commonID,1,'|');
drop start end ;
run ;

data Cast_ID_croc_lam ;
set trago.Lam_croc_bed_for_sam_compare ;
consensedID = scan(commonID,2,'|');
drop start end ;
run ;

proc sort data = Cast_ID_lam_croc ;
by consensedID ;
proc sort data = Cast_ID_croc_lam ;
by consensedID ;
run ;

%macro add_commonid (reads, rep, ref, alt);

     data &reads._&rep._2_&ref._sam    ;
     %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
     infile  "/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/filter_sam_files/filtered_parent_sam_files/&reads._&rep._uniq_2_&ref._filter_for_Cast.sam"
 delimiter='09'x MISSOVER DSD lrecl=32767 ;
        informat readID $100. ;
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
        format readID $100. ;
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


proc sort data = &reads._&rep._2_&ref._sam  ;
by consensedID ;
run;

data add_ID missingID other;
merge &reads._ID_&ref._&alt (in=in1) &reads._&rep._2_&ref._sam  (in=in2);
by consensedID ;
if in1 and in2 then output add_ID ;
else if in2  then output missingID ;
else output other ;
run ;

data trago.&reads._&rep._unq_2_&ref._commonID ;
retain readID s_VAR2 commonID pos s_VAR5-s_VAR13 ;
set add_ID ;
drop consensedID  ;
run;

proc export data = trago.&reads._&rep._unq_2_&ref._commonID 
outfile= "/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/filter_sam_files/filtered_parent_sam_files/&reads._&rep._unq_2_&ref._commonID.sam"
dbms=tab replace ; 
putnames = no ;
run;
%mend ;

%add_commonID (Cast, 2_2_1, Lam, croc);
%add_commonID (Cast, 2_2_1, Croc, lam);
%add_commonID (Cast, 2_3_4, Lam, croc);
%add_commonID (Cast, 2_3_4, Croc, lam);
%add_commonID (Cast, 2_4_2, Lam, croc);
%add_commonID (Cast, 2_4_2, Croc, lam);
%add_commonID (Cast, 10_1_4, Lam, croc);
%add_commonID (Cast, 10_1_4, Croc, lam);
%add_commonID (Cast, 10_4_4, Lam, croc);
%add_commonID (Cast, 10_4_4, Croc, lam);
%add_commonID (Cast, 10_5_3, Lam, croc);
%add_commonID (Cast, 10_5_3, Croc, lam);
%add_commonID (Cast, 13_1_1, Lam, croc);
%add_commonID (Cast, 13_1_1, Croc, lam);
%add_commonID (Cast, 13_3_5, Lam, croc);
%add_commonID (Cast, 13_3_5, Croc, lam);
%add_commonID (Cast, 13_6_4, Lam, croc);
%add_commonID (Cast, 13_6_4, Croc, lam);
%add_commonID (Cast, 31_1_3, Lam, croc);
%add_commonID (Cast, 31_1_3, Croc, lam);
%add_commonID (Cast, 31_3_4, Lam, croc);
%add_commonID (Cast, 31_3_4, Croc, lam);
%add_commonID (Cast, 31_4_1, Lam, croc);
%add_commonID (Cast, 31_4_1, Croc, lam);
