********************************************************************************;
***
*** Program:        HLS Pharma Test1.sas
*** Programmer:     Pritesh Desai (new pgm)
*** Date Created:   31May2017
***
*** Input :         none
***
*** Output:         none
***
*** Purpose:        Assign project definitions, options, libnames and macro vars
***
*** Comments:
***
*** Software:       LSAF 4.x
***
*** Modifications:
***
*** Date       Programmer        Description
*** ---------  ----------------  --------------
***  31MAY2017  PD 					Test1
********************************************************************************;
*** Adding new comment;

proc printto log= "F:/SAS/Files/HLS_Pharma/Cardiology/Files/XMB113/Log/Test_1.log";
	 run;

proc printto print= "F:/SAS/Files/HLS_Pharma/Cardiology/Files/XMB113/Output/Listings/Test_1.lst";
	 run;
	 
proc print data=sdtm.dm(obs=10);
	run;
	
proc printto;
	 run;
