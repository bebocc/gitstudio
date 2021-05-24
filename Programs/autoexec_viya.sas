********************************************************************************;
***
*** Program:        HLS Pharma autoexec.sas
*** Programmer:     Matt Becker
*** Date Created:   02FEB2014
***
*** Input :         none
***
*** Output:         none
***
*** Purpose:        Assign project definitions, options, libnames and macro vars
***
*** Comments:
***
*** Software:       SDD 4.x
***
*** Modifications:
***
*** Date       Programmer        Description
*** ---------  ----------------  --------------
***  16FEB2017  JB                  Update
********************************************************************************;
*** Adding new comment;

options nofmterr;

* two lines required to go two levels up than current program location to study root folder;
%let base_path = %substr(&_sasprogramfile,1,%sysfunc(find(&_sasprogramfile,%str(/),-%length(&_sasprogramfile)))-1);
%let base_path = %substr(&base_path,1,%sysfunc(find(&base_path,%str(/),-%length(&base_path)))-1);
%*put &base_path;

%let pathname=&base_path;
%let rootdir=&base_path;

%let ptitle1=%str(PharmaCo);
%let ptitle2=%str(PharmaCo - Compound2 - CONFIDENTIAL);

%let ddt=&pathname./Study Documents/ddt.xls;
%let sdtm=&pathname./Study Documents/sdtm.xls;

libname raw "&pathname./RawData";
libname sdtm "&pathname./SDTM";

%macro chklibs;
%if %sysfunc(libref(derived)) >0 %then %do;
  libname derived "&pathname./ADAM";
%end;

%mend chklibs;

%chklibs;

libname psmac   "&pathname./Macros" access=read;
libname fmtdata "&pathname./ADAM";
*libname library "&pathname./ADAM";

%global rawdata derdata suppkeep;
%let rawdata=raw;
%let derdata=derived;
%let suppkeep=%str(studyid rdomain usubjid idvar idvarval qnam qlabel qval qorig qeval);

%let output =&pathname./Output;
%let program=&pathname./Programs;

%*** set treatment variables used in MSS, MFREQ;
%global ovtrt tottrt;
%let ovtrt=6;
%let tottrt=6;

*** set global macro vars;
%global study studynum keepdemo draft_final trtspace demovars ps ls;
%let study=;
%let studynum=;
%let keepdemo=;
%let draft_final=FINAL;
%let trtspace=4;
%let demovars=%str(usubjid age atrt rfendtc rfendtn rfstdtn rfstdtc cnstdtn q_safeas q_immuas race sex tbsa);
%let ps=50;
%let ls=130;

options linesize=136 pagesize=50 formchar="|----|+|---+=|-/\<>*";

options mautosource mrecall missing='';
options sasautos=("&pathname" "&pathname/Macros" sasautos) fmtsearch=(fmtdata WORK);

ods path sashelp.tmplmst(read) &derdata..tplate;

%let options=mprint center ps=45 ls=132;
%let moptions=macrogen symbolgen /* mlogic */;
%let topdatef=date9.;

%let fpgfln=%str(put '\b0\f4\fs16\pard\par '; );
%let border=%str(\brdrb\brdrs);

%let ori=l;     *** landscape;

data _null_;
   daytim=put("&sysdate"d,date9.)||" "||put("&systime"t,time8.);
   call symput("nowdate", daytim);
run;