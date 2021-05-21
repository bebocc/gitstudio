********************************************************************************;
*** Program:        \biometrics\499\499H01\analyses_mjb\CSR\programs\prod\rtae_hyp.sas
*** Programmer:     Matt Becker
*** Date Created:   05Feb2010
***
*** Input :         Derived AE
***
*** Output:         Hypersensitivity Adverse Events by Study Day and Preferred Term
***
*** Purpose:        To create the hypersensitivity adverse events by study day and preferred term
***
*** Comments:
***
*** Software:       SAS 9 (Windows)
***
*** Modifications:
***
*** Date       Programmer        Description
*** ---------  ----------------  --------------
***
********************************************************************************;
proc format;
  value daycat 1="Day 1"
               2="Day 1 to Day 2"
			   3="Day 1 to Day 29";
run;

%macro rtae_hyp(progid=tae_hyp1, aevar=aedecod, tcond=, up_limit=17, progcond=);

data ae;
  set &derdata..ae(where=(q_safeas='Y' and q_bcond ne 'Y' and aenone ne 'Y' and aete='Y' and aehayn='Y'));
  &tcond;
  &progcond;
  if &aevar='' then do;
    put "The following AE term has no meddra code: " usubjid= aeterm=;
    &aevar=aeterm;
  end;
  output;
  if atrt in(2,3,4) then do;
    atrt=5;
    output;
  end;
  atrt=6;
  output;
run;

%*** Assign study day categories (1, 1-2, 1-29);
data ae;
  set ae;
  if aestdy=1 then do;
    aedaycat=1;
	output;
  end;
  if 1<=aestdy<=2 then do;
    aedaycat=2;
	output;
  end;
  if 1<=aestdy<=29 then do;
    aedaycat=3;
	output;
  end;
  if aestdy>29 then put "No study day assignment (day > 29) " usubjid= aestdy= aedecod=;
run;

%mtottrt(cond=%str(if q_safeas='Y';) &tcond);

%*** Create Any Preferred Term;
data ae;
  set ae;
  output;
  if &aevar ne '' then do;
    &aevar='AAAAB';
    output;
  end;
run;

proc sort data=ae out=ae nodupkey;
  by atrt usubjid aedaycat &aevar;

%mfreq(mfdata=ae, mfout=aestats, mfby=aedaycat, mfcntvar=&aevar, mforder=1);

proc sort data=aestats;
  by aedaycat &aevar;

data final;
  set aestats;
  by aedaycat &aevar;
  length page 4;
  retain page;
  if first.&aevar then page=floor(_n_/25)+1;
  if &aevar='AAAAB' then &aevar="Any Event of Hypersensitivity`{super b}";
run;

%mnumobs(inds=final);

%macro numobs;
%if &nobs=1 %then %do;
  data final;
    set final;
    if &aevar='' then do;
      &aevar='None Reported'; trt1=''; trt2=''; trt3=''; trt4=''; trt5=''; trt6='';
    end;
  run;
%end;
%mend numobs;
%numobs;

proc sort data=final;
  by page aedaycat &aevar;

%mtitle(progid=&progid);

proc report data=final headline headskip nowindows split='|' missing spacing=1;
  column page aedaycat sorder &aevar ("Age Group (years) \brdrb\brdrs" trt1 trt2 trt3 trt4 trt5) trt6;
  define page /order noprint;
  define aedaycat /order "Study Day" format=daycat. style={just=l cellwidth=10%};
  define sorder /order noprint;
  define &aevar / "Preferred Term`{super a}" style={just=l cellwidth=30%};
  define trt1 / "     0 - 2 |     (N=&pop1)|     n (%)" style={cellwidth=8%};
  define trt2 / "     3 - 6 |     (N=&pop2)|     n (%)" style={cellwidth=8%};
  define trt3 / "     7 - 11 |     (N=&pop3)|     n (%)" style={cellwidth=8%};
  define trt4 / "     12 - &up_limit |     (N=&pop4)|     n (%)" style={cellwidth=8%};
  define trt5 / "     3 - &up_limit Total |     (N=&pop5)|     n (%)" style={cellwidth=8%};
  define trt6 / "     Total |     (N=&pop6)|     n (%)" style={cellwidth=8%};
  break after page / page;
  compute before aedaycat;
    line " ";
  endcomp;
run;

ods rtf close;
ods listing;

%mpageof;

%mend rtae_hyp;

%*** Hypersensitivity AEs by study day and Preferred Term;
%rtae_hyp(progid=tae_hyp1, tcond=);
%rtae_hyp(progid=tae_hyp2, tcond=%str(if age<17), up_limit=16);

%*** Treatment-Related AEs by SOC and Preferred Term;
%rtae_hyp(progid=tae_hyp3, tcond=, progcond=%str(if aetrtrel='Y'));
%rtae_hyp(progid=tae_hyp4, tcond=%str(if age<17), up_limit=16, progcond=%str(if aetrtrel='Y'));
