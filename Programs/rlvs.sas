********************************************************************************;
*** Program:        \biometrics\499\499H01\analyses_mjb\CSR\programs\prod\rlvs.sas
*** Programmer:     Matt Becker
*** Date Created:   01Apr2010
***
*** Input :         SDTM DM, STDM VS
***
*** Output:         Listing 15:  Vital Signs
***
*** Purpose:        To create the listing of vital signs
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
proc sort data=sdtm.vs out=vs;
  by usubjid visit vsdtc vsdy;

proc transpose data=vs out=transvs;
  by usubjid visit vsdtc vsdy;
  var vsstresn;
  id vstestcd;
run;

proc sort data=sdtm.dm out=dm(keep=usubjid age);
  by usubjid;

data vs;
  merge transvs(in=x) dm(in=y);
  by usubjid;
  if x;
run;

proc sort data=vs;
  by usubjid vsdy;

data vs;
  set vs;
  by usubjid vsdy;
  length bp $25;
  page=int(_n_/22)+1;
  if ornsbp ne . then bp=trim(left(put(ornsbp,3.)));
  if orndbp ne . then bp=trim(left(bp))||'/'||trim(left(put(orndbp,3.)));
run;

%mcase(inds=vs, exceptl=%str('USUBJID','VSDTC'));

%mtitle(progid=lvs);

proc report data=vs headline headskip nowindows split='|' missing spacing=2;
  column page usubjid age visit vsdy ornht ornwt ornresp bp ornhr;
  define page / order noprint;
  define usubjid / order width=10 'Subject' style={just=left cellwidth=5%};
  define age / order 'Age|(Years)' format=4.1 style={just=center cellwidth=7%};
  define visit / display 'Visit' style={just=left cellwidth=15%};
  define vsdy / display 'Study Day' format=3. style={just=left cellwidth=7%};
  define ornht / display 'Height|(cm)' format=3. style={just=left cellwidth=4%};
  define ornwt / display 'Weight|(kg)' format=3. style={just=left cellwidth=4%};
  define ornresp / display 'Respiratory Rate|(bpm)' format=3. style={just=left cellwidth=11%};
  define bp / display 'Blood Pressure (mmHg)|Systolic/Diastolic' style={just=left cellwidth=15%};
  define ornhr / display 'Heart Rate|(bpm)' format=3. style={just=left cellwidth=11%};
  break after page / page;
  compute before usubjid;
    line " ";
  endcomp;
run;

ods rtf close;
ods listing;

%mpageof;
