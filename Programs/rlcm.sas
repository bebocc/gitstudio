********************************************************************************;
*** Program:        \biometrics\499\499H01\analyses_mjb\CSR\programs\prod\rlcm.sas
*** Programmer:     Matt Becker
*** Date Created:   01Apr2010
***
*** Input :         SDTM DM, STDM CM
***
*** Output:         Listing 14:  Concomitant Medications
***
*** Purpose:        To create the listing of concomitant medications
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
proc sort data=sdtm.cm out=cm;
  by usubjid;

proc sort data=sdtm.dm out=dm(keep=usubjid age);
  by usubjid;

data cm;
  merge cm(in=x) dm(in=y);
  by usubjid;
  if x;
run;

proc sort data=cm;
  by usubjid cmgrpid;

data cm;
  set cm;
  by usubjid cmgrpid;
  length cmdur 8 medname start_str stop_str $400;
  page=int(_n_/8)+1;
  if cmendtc='' and cmenrf ne '' then cmendtc=cmenrf;
  cmdur=(cmendy-cmstdy)+1;
  medname=compbl('W: '||trim(left(cmdecod))||'`-2nV: '||trim(left(cmtrt)));
  start_str='ST: '||trim(left(cmstdtc));
  if cmstdy ne '' then start_str=trim(left(start_str))||'`-2nSD: '||trim(left(cmstdy));
  stop_str='SP: '||trim(left(cmendtc));
  if cmdur ne . then stop_str=trim(left(stop_str))||'`-2nDR: '||trim(left(cmdur));
run;

%mcase(inds=cm, exceptl=%str('USUBJID','START_STR','STOP_STR'));

%mtitle(progid=lcm);

footnote1;

proc report data=cm headline headskip nowindows split='|' missing spacing=2;
  column page usubjid age cmgrpid cmspid medname cmroute start_str stop_str cmindc;
  define page / order noprint;
  define usubjid / order 'Subject' style={just=left cellwidth=6%};
  define age / order 'Age|(Years)' format=4.1 style={just=center cellwidth=7%};
  define cmgrpid / order noprint;
  define cmspid / order noprint;
  define medname / display 'W: WHO Drug Term`{super a}|V: Medication Verbatim' flow style={just=left cellwidth=35%};
  define cmroute / display 'Route of|Administration' flow style={just=left cellwidth=10%};
  define start_str / display 'ST: Start Date`{super b}|SD: Start Study Day' style={just=left cellwidth=10%};
  define stop_str / display 'SP: Stop Date|DR: Duration' style={just=left cellwidth=10%};
  define cmindc / display 'Reason' flow style={just=left cellwidth=20%};
  compute after usubjid / style=[just=left];
     line 143*'_';
  endcomp;
  compute after cmspid;
    line "  ";
  endcomp;
  compute after page / style=[just=left];
	 line "&footn1";
	 line "&footn2";
	 line " ";
	 line "&footn11";
  endcomp;
  break after page / page;
run;

ods rtf close;
ods listing;

%mpageof;
