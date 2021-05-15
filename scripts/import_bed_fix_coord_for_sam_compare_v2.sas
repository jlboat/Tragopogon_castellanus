
 libname trago '/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/sas_data';


 /*
 bed files converted to csv in terminal window (using sed)
 import trago bed files containing commonID
 'fix' start and end so all starts are 0

 */


 %macro bed_in (ONE, TWO) ;

 data WORK.bed_&ONE._&TWO    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile "/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/filter_sam_files/&ONE.-&TWO._overlaps_WRT_orthologs.renamed.csv" delimiter = ','
  MISSOVER DSD lrecl=32767 ;
         informat consensedID $36. ;
         informat start best32. ;
         informat end best32. ;
         informat commonID $54. ;
         informat  b_VAR5 best32. ;
         informat strand $1. ;
         format consensedID $36. ;
         format start best32. ;
         format end best32. ;
         format commonID $54. ;
         format  b_VAR5 best32. ;
         format strand $1. ;
      input
                  consensedID $
                  start
                  end
                  commonID $
                  b_VAR5
                  strand $
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;


 %mend ;

 %bed_in (Lam, croc) ;
 %bed_in (Croc, lam) ;


 /* 'fix' the lam coordinates in the bed file for sam compare between Lam and Croc */
 proc contents data = bed_lam_croc ;
 run;

 data modify_bed_Lam_croc ;
 retain start_lam_2 end_lam_2  ;
 set bed_lam_croc ;
 if start > 0 then
 	do ;
 	start_2 = (start - start) and end_2;
     end_2 = (end - start) ;
 	end ;
 	else if start = 0 then
 		do ;
 		start_2 = start ;
 		end_2 = end;
 		end;
  run;

  data trago.Lam_croc_bed_for_sam_compare ;
  retain commonID start_2 end_2 ;
  set modify_bed_Lam_croc ;
 rename start_2 = start  end_2= end ;
 keep commonID start_2 end_2 ;
 run;

 proc export data = trago.Lam_croc_bed_for_sam_compare
 outfile ='/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/references/Lam_croc_bed_for_sam_compare.bed'
 dbms=tab replace ;
 run;

 /* 'fix' the croc coordinates in the bed file for sam compare between Croc and Lam */
 proc contents data = bed_croc_lam ;
 run;

 data modify_bed_Croc_lam ;
 retain start_2 end_2  ;
 set bed_croc_lam ;
 if start > 0 then
 	do ;
 	start_2 = (start - start) and end_2;
     end_2 = (end - start) ;
 	end ;
 	else if start = 0 then
 		do ;
 		start_2 = start ;
 		end_2 = end;
 		end;
  run;

  data trago.Croc_lam_bed_for_sam_compare ;
  retain commonID start_2 end_2 ;
  set modify_bed_Croc_lam ;
 rename start_2 = start  end_2= end ;
 keep commonID start_2 end_2 ;
 run;

 proc export data = trago.Croc_lam_bed_for_sam_compare
 outfile ='/ufrc/barbazuk/lboat/T.lamottei_T.crocifolius/Complete_data_set/align_reads_for_samcompare/references/Croc_lam_bed_for_sam_compare.bed'
 dbms=tab replace ;
 run;


