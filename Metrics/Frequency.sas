

libname metrics "&_sasws_/SAS/HLS_Pharma/Cardiology/Files/XMB111/Metrics";


proc printto print="&_sasws_/SAS/HLS_Pharma/Cardiology/Files/XMB111/Metrics/FreqReport.txt" NEW ; run;
proc freq data=metrics.disposition;
table siteID*disposition;
run;
proc printto print=print;
 run;