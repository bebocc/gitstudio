********************************************************************************;
*** Program:        \biometrics\499\499H01\analyses_mjb\CSR\programs\prod\d1_vs.sas
*** Programmer:     Matt Becker
*** Date Created:   15Feb2010
***
*** Input :         RAW VS, Derived DM
***
*** Output:         Derived VS dataset
***
*** Purpose:        To create the derived VS dataset
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
data vs(rename=(dov=vsdtn) drop=visit);
  set &rawdata..vs;
  length domain $2 usubjid $25 vsblfl $1;
  domain='VS';
  visitnum=visit;
  usubjid=trim(left(studyid))||'-'||trim(left(site))||'-'||trim(left(randomno));
  if visitnum=0 then vsblfl='Y';
run;

proc sort data=vs;
  by usubjid;

proc sort data=&derdata..dm out=dm(keep=&demovars.);
  by usubjid;

%Macro tpose(vstest=TEMPERATURE,vstestcd=TEMP,vsorres=ORNTEMP,vsorresu=,vsseq=1,vsstresu=C);
  vstest="&vstest";
  vstestcd="&vstestcd";
  vsorres=&vsorres;
  vsseq=&vsseq;
  vsstresu="&vsstresu";
  %if &vstestcd=HT %then %do;
    if upcase(ornhtu)="IN" then vsstresn=ornht*2.54;
    else vsstresn=ornht;
	vsorresu=lowcase(ornhtu);
  %end;
  %else %if &vstestcd=WT %then %do;
    if upcase(ornwtu)="LB" then vsstresn=ornwt*0.454;
	else vsstresn=ornwt;
	vsorresu=lowcase(ornwtu);
  %end;
  %else %if &vstestcd=TEMP %then %do;
    if upcase(orntempu)="F" then vsstresn=(orntemp-32)*5/9;
	else vsstresn=orntemp;
	vsorresu=orntempu;
  %end;
  %else %do;
    vsstresn=vsorres;
	vsorresu="&vsorresu";
  %end;
  vsstresc=trim(left(vsstresn));
  output;
%Mend tpose;

data vs;
  merge vs(in=x) dm(in=y);
  by usubjid;
  length visit $20 vsdtc vstest $25 vsdy visitdy 8 vsorres vstestcd $5 vsorresu vsstresc vsstresu $15 vsseq vsstresn 8;
  if x;
  visit=put(visitnum, visitf.);
  vsdtc=put(vsdtn,yymmdd10.);
  %mstudydy(todate=vsdtn,basedate=rfstdtn,studyday=visitdy);
  vsdy=visitdy;
  %tpose(vstest=TEMPERATURE, vstestcd=TEMP, vsorres=orntemp, vsorresu=, vsseq=1, vsstresu=C);
  %tpose(vstest=%str(RESPIRATION RATE), vstestcd=RESP, vsorres=ornresp, vsorresu=%str(Breaths per minute), 
         vsseq=2, vsstresu=%str(Breaths per minute));
  %tpose(vstest=%str(SYSTOLIC BLOOD PRESSURE), vstestcd=SBP, vsorres=ornsbp, vsorresu=mmHg, vsseq=3, vsstresu=mmHg);
  %tpose(vstest=%str(DIASTOLIC BLOOD PRESSURE), vstestcd=DBP, vsorres=orndbp, vsorresu=mmHg, vsseq=4, vsstresu=mmHg);
  %tpose(vstest=%str(HEART RATE), vstestcd=HR, vsorres=ornhr, vsorresu=bpm, vsseq=5, vsstresu=bpm);
  %tpose(vstest=%str(WEIGHT), vstestcd=WT, vsorres=ornwt, vsorresu=, vsseq=6, vsstresu=kg);
  %tpose(vstest=%str(HEIGHT), vstestcd=HT, vsorres=ornht, vsorresu=cm, vsseq=7, vsstresu=cm);
run;

data baseline(rename=(vsstresn=base));
  set vs;
  keep usubjid vstestcd vsstresn;
  if vsblfl='Y';
run;

proc sort data=baseline;
  by usubjid vstestcd;
proc sort data=vs;
  by usubjid vstestcd;

data vs;
  merge vs(in=x) baseline(in=y);
  by usubjid vstestcd;
  if x;
  length chg 8;
  chg = vsstresn-base;
run;

%mimpddt(micsv=VS, miin=VS, miout=&derdata..VS, mlbl=%str(Vital Signs));
