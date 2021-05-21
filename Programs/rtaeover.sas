********************************************************************************;
*** Program:        \biometrics\499\499H01\analyses_mjb\CSR\programs\prod\rtaeover.sas
*** Programmer:     Matt Becker
*** Date Created:   12Feb2010
***
*** Input :         Derived DM, Derived AE
***
*** Output:         Overall Treatment-Emergent AE summary table (in-text)
***
*** Purpose:        To create the overall treatment-emergent AE summary table (in-text)
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
  value orderf 1="Subjects with AE`{super a}, n (%)"
               2="Subj. with Trt Rel. AE`{super b}, n (%)"
			   3="Subj. Disc. due to AE, n (%)"
			   4="AEs per Subject"
			   5="AEs per Subject Year`{super c}"
			   6="Max. Severity`{super d} of AEs, n (%)"
			   7="Total Number of AEs"
			   8="Total # of Trt Rel. AEs`{super b}"
			   9="Subjects with SAE, n (%)"
			  10="Subjects with Trt Related SAE`{super b}, n (%)"
			  11="SAEs per Subject"
			  12="SAEs per Subject Year`{super c}"
			  13="Total Number of SAEs"
			  14="Total # of Trt Rel. SAEs`{super b}";
run;

%macro rtaeover(tcond=, up_limit=17, itprogid=taeover1);

data ae(keep=usubjid aenone aetrtrel aedecod subjyr aetoxgr aeser atrt q_safeas counter sae_counter);
  set &derdata..ae(where=(q_safeas='Y' and q_bcond ne 'Y'));
  &tcond;
  if aedecod ne '' then counter=1;
  else counter=0;
  if aeser='Y' then sae_counter=1;
  else sae_counter=0;
  output;
  if atrt in(2,3,4) then do;
    atrt=5;
	output;
  end;
  atrt=6;
  output;
run;

data dm(keep=atrt usubjid dsdecodn);
  set &derdata..dm(where=(q_safeas='Y'));
  &tcond;
  output;
  if atrt in(2,3,4) then do;
    atrt=5;
	output;
  end;
  atrt=6;
  output;

proc sort data=dm;
  by atrt usubjid;

proc sort data=ae;
  by atrt usubjid;

data ae;
  merge ae(in=x) dm(in=y);
  by atrt usubjid;
  if y and not x then put "Subject in DM but not in AE" usubjid=;
  *if x;
run;

%mtottrt(cond=%str(if q_safeas='Y';) &tcond);

%*** Subjects with an AE;
proc sort data=ae out=ae1 nodupkey;
  by atrt usubjid aenone;

%mfreq(mfdata=ae1, mfout=ae1stats, mfcntvar=aenone, mforder=1, mfwhere=(aenone ne 'Y'));

%*** Subjects with Trt Related AE;
proc sort data=ae out=ae2 nodupkey;
  by atrt usubjid aetrtrel;
  where aetrtrel='Y';

%mfreq(mfdata=ae2, mfout=ae2stats, mfcntvar=aetrtrel, mforder=2, mfwhere=(aetrtrel ne 'Y'));

%*** Subjects who discontinued due to AE;
proc sort data=ae out=ae3 nodupkey;
  by atrt usubjid dsdecodn;
  where dsdecodn=1;

%mfreq(mfdata=ae3, mfout=ae3stats, mfcntvar=dsdecodn, mforder=3, mfwhere=(dsdecodn=1));

%*** AEs per subject;
proc sort data=ae out=ae4;
  by atrt usubjid;

proc summary data=ae4;
  class atrt usubjid subjyr;
  var counter;
  output out=ae4_2(where=(_type_=7)) sum=numae;
run;

%mss(msdata=ae4_2, msout=ae4stats, msvar=numae, msstats=n median range, msprec=1, msorder=4);

%*** AEs per subject year;
data ae4_2;
  set ae4_2;
  length snumae 8;
  snumae=numae/subjyr;
run;

%mss(msdata=ae4_2, msout=ae5stats, msvar=snumae, msstats=n median range, msprec=1, msorder=5);

%*** Max severity of AEs;
proc sort data=ae out=ae6;
  by atrt usubjid aetoxgr;

data ae6;
  set ae6;
  by atrt usubjid aetoxgr;
  if last.usubjid then do;
    output;
	aetoxgr=0;
	output;
  end;
run;

%mfreq(mfdata=ae6, mfout=ae6stats, mfcntvar=aetoxgr, mforder=6, mffmt=aesev, mfwhere=(aetoxgr>.));

%*** Total number of AEs;
%mfreq(mfdata=ae, mfout=ae7stats, mfcntvar=counter, mforder=7, mfwhere=(aedecod ne ''), mfperc=N);

%*** Total Number of Trt Related AEs;
%mfreq(mfdata=ae, mfout=ae8stats, mfcntvar=counter, mforder=8, mfwhere=(aedecod ne '' and aetrtrel='Y'), mfperc=N);

%*** Subjects with an SAE;
proc sort data=ae out=ae9 nodupkey;
  by atrt usubjid;
  where aeser='Y';

%mfreq(mfdata=ae9, mfout=ae9stats, mfcntvar=counter, mforder=9, mfwhere=(aenone ne 'Y'));

%*** Subjects with Trt Related SAE;
proc sort data=ae out=ae10 nodupkey;
  by atrt usubjid;
  where aetrtrel='Y' and aeser='Y';

%mfreq(mfdata=ae10, mfout=ae10stats, mfcntvar=aetrtrel, mforder=10, mfwhere=(aetrtrel ne 'Y'));

%*** SAEs per subject;
proc sort data=ae out=ae11;
  by atrt usubjid;

proc summary data=ae11;
  class atrt usubjid subjyr;
  var sae_counter;
  output out=ae11_2(where=(_type_=7)) sum=numae;
run;

%mss(msdata=ae11_2, msout=ae11stats, msvar=numae, msstats=n median range, msprec=1, msorder=11);

%*** SAEs per subject year;
data ae12_2;
  set ae11_2;
  length snumae 8;
  snumae=numae/subjyr;
run;

%mss(msdata=ae12_2, msout=ae12stats, msvar=snumae, msstats=n median range, msprec=1, msorder=12);

%*** Total number of SAEs;
%mfreq(mfdata=ae, mfout=ae13stats, mfcntvar=counter, mforder=13, mfwhere=(aedecod ne '' and aeser='Y'), mfperc=N);

%*** Total Number of Trt Related SAEs;
%mfreq(mfdata=ae, mfout=ae14stats, mfcntvar=counter, mforder=14, mfwhere=(aedecod ne '' and aetrtrel='Y' and aeser='Y'), mfperc=N);

data final;
  set ae1stats(drop=sorder perc) ae2stats(drop=sorder perc) ae3stats(drop=sorder perc) ae4stats ae5stats 
      ae6stats ae7stats(drop=sorder) ae8stats(drop=sorder) ae9stats(drop=sorder perc)
      ae10stats(drop=sorder perc) ae11stats ae12stats ae13stats(drop=sorder) ae14stats(drop=sorder);
  length page 4;
  array trtout(5) trt1 trt2 trt3 trt4 trt6;
  if order in(4,5,11,12) then do i=1 to 5;
    if text="n" and trtout(i)='' then trtout(i)="       0";
	else if text="Median" and trtout(i)='' then trtout(i)="       0.00";
	else if text="Min, Max" and trtout(i)='' then trtout(i)="      0.0, 0.0";
  end;
  if text="n" or aetoxgr=0 then do i=1 to 5;
    trtout(i)='';
  end;
  page=1;
/*
  if order<=12 then page=1;
  else page=2;
*/
run;

proc sort data=final;
  by page order sorder;

data final;
  set final;
  by page order sorder;
  length firstcol $50;
  if first.order then firstcol=put(order,orderf.);
  else if ^first.order and text ne '' then firstcol="  "||trim(left(text));
  else firstcol='';
run;

%mtitle2(progid=&itprogid, orient=P);

proc report data=final headline headskip nowindows split='|' missing spacing=1 style(header)=[protectspecialchars=off];
  column  page order sorder firstcol ("Age Group (years) \brdrb\brdrs" trt1 trt2 trt3 trt4) trt6;
  define page /order noprint;
  define order /order noprint;
  define sorder /order noprint;
  define firstcol /" " style={asis=on just=l cellwidth=18%};
  define trt1 / "     0 - 2 |     (N=&pop1)" style={cellwidth=10% asis=on pretext="\tqdec\tx450 "};
  define trt2 / "     3 - 6 |     (N=&pop2)" style={cellwidth=10% asis=on pretext="\tqdec\tx450 "};
  define trt3 / "     7 - 11 |     (N=&pop3)" style={cellwidth=10% asis=on pretext="\tqdec\tx450 "};
  define trt4 / "     12 - &up_limit |     (N=&pop4)" style={cellwidth=10% asis=on pretext="\tqdec\tx450 "};
  define trt6 / "     Total |     (N=&pop6)" style={cellwidth=10% asis=on pretext="\tqdec\tx450 "};
  break after page / page;
  compute before order;
    line " ";
  endcomp;
run;

ods rtf close;
ods listing;

%mpageof;
%mend rtaeover;
%rtaeover(tcond=, itprogid=taeover1);
%rtaeover(tcond=%str(if age<17), up_limit=16, itprogid=taeover2);
