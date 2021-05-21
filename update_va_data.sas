/*comment1 */

options msglevel=i;
*options cashost="hlsrd53au.vsp.sas.com" casport=5570;
/*Start a CAS session named myses and specify the personal caslib, Casuser, as the active caslib.*/
cas myses  sessopts=(caslib=casuser);
/*If you have not already done so, use the CAS LIBNAME statement to create a CAS engine libref.*/
libname mycas cas;
/*Specify _ALL_ ASSIGN in the CASLIB statement to assign SAS librefs to existing caslibs. Assigning SAS librefs to caslibs enables you to see caslib
  names in the Libraries pane */
caslib _ALL_ assign;

data repoInfo;
 set mycas.repoinfo;
run;

%macro wd;
  %local cwd pwd;
  %let cwd = %sysget(LS_SUBCWD);
  %let pwd = %sysget(PWD);

  %if %length(%superq(cwd)) %then %superq(cwd);
  %else                           %superq(pwd);
%mend wd;

%put %wd;

libname test "%wd";
data repoInfo;
 set test.repoInfo;
run;

proc sql;
 select strip(put(max(countw(path,'/')),best.)) into :levelcount from repoInfo;
quit;

%put levelcount = &levelcount;

data repoInfo;
 set repoInfo; 
 array level $200 level1-level&levelcount ;

 format size sizekmg.;
 do i=1 to countw(path,'/');
   level[i]=scan(path,i+1,'/','m');
 end;
 
 drop i totalfilesize totalcontainersize totalversions totalsize;
run;

proc casutil;
   load data=repoInfo
   outcaslib='casuser'
   replace;
   save casdata="repoInfo" replace;
run; quit;

data mycas.repoInfo;
 set casuser.repoInfo;
run;


cas myses terminate;

/* end of program comment */
