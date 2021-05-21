********************************************************************************;
*** Program:        \biometrics\499\499H01\analyses_mjb\CSR\programs\prod\rtvs.sas
*** Programmer:     Matt Becker
*** Date Created:   15Feb2010
***
*** Input :         Derived VS
***
*** Output:         Descriptive statistics for vital signs summary table
***
*** Purpose:        To create the vital signs summary table
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
  value orderf 1,6,11,16,21,26="Baseline"
               2,7,12,17,22,27="Day 2"
			   3,8,13,18,23,28="Change from Baseline to Day 2"
			   4,9,14,19,24,29="Day 29"
			   5,10,15,20,25,30="Change from Baseline to Day 29";
run;

%macro rtvs(progid=tvs1, tcond=, up_limit=17);

data vs;
  set &derdata..vs(where=(q_safeas='Y'));
  &tcond;
  output;
  if atrt in(2,3,4) then do;
    atrt=5;
	output;
  end;
  atrt=6;
  output;
run;

%mtottrt(cond=%str(if q_safeas='Y';) &tcond);

%mss(msdata=vs, msout=temp1, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=1, mswhere=(vstestcd='TEMP' and visitnum=0));
%mss(msdata=vs, msout=temp2, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=2, mswhere=(vstestcd='TEMP' and visitnum=2));
%mss(msdata=vs, msout=temp3, msvar=chg, msstats=n meansd median range, msprec=1, msorder=3, mswhere=(vstestcd='TEMP' and visitnum=2));
%mss(msdata=vs, msout=temp4, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=4, mswhere=(vstestcd='TEMP' and visitnum=29));
%mss(msdata=vs, msout=temp5, msvar=chg, msstats=n meansd median range, msprec=1, msorder=5, mswhere=(vstestcd='TEMP' and visitnum=29));

%mss(msdata=vs, msout=rr1, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=6, mswhere=(vstestcd='RESP' and visitnum=0));
%mss(msdata=vs, msout=rr2, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=7, mswhere=(vstestcd='RESP' and visitnum=2));
%mss(msdata=vs, msout=rr3, msvar=chg, msstats=n meansd median range, msprec=1, msorder=8, mswhere=(vstestcd='RESP' and visitnum=2));
%mss(msdata=vs, msout=rr4, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=9, mswhere=(vstestcd='RESP' and visitnum=29));
%mss(msdata=vs, msout=rr5, msvar=chg, msstats=n meansd median range, msprec=1, msorder=10, mswhere=(vstestcd='RESP' and visitnum=29));

%mss(msdata=vs, msout=sbp1, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=11, mswhere=(vstestcd='SBP' and visitnum=0));
%mss(msdata=vs, msout=sbp2, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=12, mswhere=(vstestcd='SBP' and visitnum=2));
%mss(msdata=vs, msout=sbp3, msvar=chg, msstats=n meansd median range, msprec=1, msorder=13, mswhere=(vstestcd='SBP' and visitnum=2));
%mss(msdata=vs, msout=sbp4, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=14, mswhere=(vstestcd='SBP' and visitnum=29));
%mss(msdata=vs, msout=sbp5, msvar=chg, msstats=n meansd median range, msprec=1, msorder=15, mswhere=(vstestcd='SBP' and visitnum=29));

%mss(msdata=vs, msout=dbp1, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=16, mswhere=(vstestcd='DBP' and visitnum=0));
%mss(msdata=vs, msout=dbp2, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=17, mswhere=(vstestcd='DBP' and visitnum=2));
%mss(msdata=vs, msout=dbp3, msvar=chg, msstats=n meansd median range, msprec=1, msorder=18, mswhere=(vstestcd='DBP' and visitnum=2));
%mss(msdata=vs, msout=dbp4, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=19, mswhere=(vstestcd='DBP' and visitnum=29));
%mss(msdata=vs, msout=dbp5, msvar=chg, msstats=n meansd median range, msprec=1, msorder=20, mswhere=(vstestcd='DBP' and visitnum=29));

%mss(msdata=vs, msout=hr1, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=21, mswhere=(vstestcd='HR' and visitnum=0));
%mss(msdata=vs, msout=hr2, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=22, mswhere=(vstestcd='HR' and visitnum=2));
%mss(msdata=vs, msout=hr3, msvar=chg, msstats=n meansd median range, msprec=1, msorder=23, mswhere=(vstestcd='HR' and visitnum=2));
%mss(msdata=vs, msout=hr4, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=24, mswhere=(vstestcd='HR' and visitnum=29));
%mss(msdata=vs, msout=hr5, msvar=chg, msstats=n meansd median range, msprec=1, msorder=25, mswhere=(vstestcd='HR' and visitnum=29));

%mss(msdata=vs, msout=wt1, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=26, mswhere=(vstestcd='WT' and visitnum=0));
%mss(msdata=vs, msout=wt2, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=27, mswhere=(vstestcd='WT' and visitnum=2));
%mss(msdata=vs, msout=wt3, msvar=chg, msstats=n meansd median range, msprec=1, msorder=28, mswhere=(vstestcd='WT' and visitnum=2));
%mss(msdata=vs, msout=wt4, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=29, mswhere=(vstestcd='WT' and visitnum=29));
%mss(msdata=vs, msout=wt5, msvar=chg, msstats=n meansd median range, msprec=1, msorder=30, mswhere=(vstestcd='WT' and visitnum=29));

/*
%mss(msdata=vs, msout=ht1, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=31, mswhere=(vstestcd='HT' and visitnum=0));
%mss(msdata=vs, msout=ht2, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=32, mswhere=(vstestcd='HT' and visitnum=2));
%mss(msdata=vs, msout=ht3, msvar=chg, msstats=n meansd median range, msprec=1, msorder=33, mswhere=(vstestcd='HT' and visitnum=2));
%mss(msdata=vs, msout=ht4, msvar=vsstresn, msstats=n meansd median range, msprec=1, msorder=34, mswhere=(vstestcd='HT' and visitnum=29));
%mss(msdata=vs, msout=ht5, msvar=chg, msstats=n meansd median range, msprec=1, msorder=35, mswhere=(vstestcd='HT' and visitnum=29));
*/
data final;
  set temp1 temp2 temp3 temp4 temp5 rr1 rr2 rr3 rr4 rr5 sbp1 sbp2 sbp3 sbp4 sbp5
      dbp1 dbp2 dbp3 dbp4 dbp5 hr1 hr2 hr3 hr4 hr5 wt1 wt2 wt3 wt4 wt5;
	  *ht1 ht2 ht3 ht4 ht5;
run;

proc sort data=final;
  by order sorder;

data final;
  set final;
  by order sorder;
  length page 4 firstcol $40 secondcol $40;
  retain page;
  if first.order then page=floor(order/5.1)+1;
  if first.order and order=1 then firstcol="Temperature (C)";
  else if first.order and order=6 then firstcol="Respiration Rate (BPM)";
  else if first.order and order=11 then firstcol="Systolic Blood Pressure (mmHg)";
  else if first.order and order=16 then firstcol="Diastolic Blood Pressure (mmHg)";
  else if first.order and order=21 then firstcol="Heart Rate (BPM)";
  else if first.order and order=26 then firstcol="Weight (kg)";
  if first.order then secondcol=put(order,orderf.);
run;

proc sort data=final;
  by page order sorder firstcol secondcol;

%mtitle(progid=&progid);

proc report data=final headline headskip nowindows split='|' missing spacing=1 style(header)=[protectspecialchars=off];
  column page order sorder firstcol secondcol text ("Age Group (years) \brdrb\brdrs" trt1 trt2 trt3 trt4 trt5) trt6;
  define page /order noprint;
  define order /order noprint;
  define sorder /order noprint;
  define firstcol / "Vital Sign" style={just=l cellwidth=8%};
  define secondcol / "Timepoint" style={just=l cellwidth=12%};
  define text/ " " style={just=l cellwidth=7%};
  define trt1 / "     0 - 2 |     (N=&pop1)" style={cellwidth=9% asis=on pretext="\tqdec\tx450 "};
  define trt2 / "     3 - 6 |     (N=&pop2)" style={cellwidth=9% asis=on pretext="\tqdec\tx450 "};
  define trt3 / "     7 - 11 |     (N=&pop3)" style={cellwidth=9% asis=on pretext="\tqdec\tx450 "};
  define trt4 / "     12 - &up_limit |     (N=&pop4)" style={cellwidth=9% asis=on pretext="\tqdec\tx450 "};
  define trt5 / "     3 - &up_limit Total |     (N=&pop5)" style={cellwidth=9% asis=on pretext="\tqdec\tx450 "};
  define trt6 / "     Total |     (N=&pop6)" style={cellwidth=9% asis=on pretext="\tqdec\tx450 "};
  break after page / page;
  compute before order;
    line " ";
  endcomp;
run;

ods rtf close;
ods listing;

%mpageof;

%mend rtvs;
%rtvs(progid=tvs1, tcond=);
%rtvs(progid=tvs2, tcond=%str(if age<17), up_limit=16);
