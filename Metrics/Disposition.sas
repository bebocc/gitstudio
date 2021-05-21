data vis;
do Subj = 1001 to 2000;
  SCR = 1;
  BL  =  Rand("Uniform") > .20; 
  
  
  C1 = ( BL and  Rand("Uniform") > .05); 
  C2 = ( C1 and  Rand("Uniform") > .10);
  C3 = ( C2 and  Rand("Uniform") > .10);
  C4 = ( C3 and  Rand("Uniform") > .15);
  
  IF BL = 0 then ScreenFail = 1; else ScreenFail = 0;
  Completed = C4;
  
  if C4 then LC = 4;
   else if C3 then LC = 3;
    else if C2 then LC = 2;
     else if C1 then LC = 1;
      else LC = 0;
  output;
end;
run;

proc format;
value dispf
  1 = 'Screen Failure'
  2 = 'Early Termination'
  3 = 'Completed';
 run;

 
 %macro vary(days);
int((-1*&days) + (&days*2)*Rand("Uniform"));
%mend;
 
data visit;
set vis;
  length SFReason DiscReason $30.;
  Screening = mdy(1,1,2014) +  %vary(365);
  IF BL then  Baseline = screening + 14 + %vary(3);
  IF C1 THEN Cycle1 = Baseline + 28 + %vary(3);
  IF C2 THEN Cycle2 = Cycle1 + 28 + %vary(3);
  IF C3 THEN Cycle3 = Cycle2 + 28 + %vary(3);
  IF C4 THEN Cycle4 = Cycle3 + 28 + %vary(3);

  if ScreenFail then Outcome = 1;
   else if completed then Outcome = 3;
    else outcome = 2;
  EarlyTerm = (outcome = 2);
   SFrand = Rand("Uniform");
   if ScreenFail then do;
     if SFrand < .05 then SFReason = 'Lost to Follow-up';
    else if SFrand < .15 then SFReason = 'Withdrew Consent';
      else if SFRand < .55 then SFReason = "Inclusion Criteria #"||put(int(Rand("Uniform")*15 +1),2.);
      else SFReason = "Exclusion Criteria #"||put(int(Rand("Uniform")*15 +1),2.);
     Reason = "Screen Failed: "||SFreason;

   end;
  
   TermRand = Rand("Uniform");
   if EarlyTerm then do;
     if TermRand < .20 then DiscReason = 'Lost to Follow-up';
    else if TermRand < .40 then DiscReason = 'Withdrew Consent';
      else if TermRand < .80 then DiscReason = "Withdrew Due to Non-Fatal AE";
      else DiscReason = "Death";
     Reason = "Discontinued: "|| DiscReason;

   end;
    
  
  If completed then Reason = "Completed Study";

  
  Disposition = put(outcome,dispf.);

  

format Screening Baseline Cycle1 Cycle2 Cycle3 Cycle4 date9.;

run;

libname metrics "&_sasws_/SAS/HLS_Pharma/Cardiology/Files/XMB111/Metrics";

PROC SQL;
CREATE TABLE metrics.Disposition AS
SELECT INT(RAND("UNIFORM")*10 +11) AS SiteID "Site Number"
       ,subj as SubjectID "Subject ID"
      ,Screening as ScreeningDate format = date9.
      ,Baseline as BaselineDate format = date9.      
      ,Cycle1 as Cycle1Date format = date9.   
      ,Cycle2 as Cycle2Date format = date9.   
      ,Cycle3 as Cycle3Date format = date9.   
      ,Cycle4 as Cycle4Date format = date9.
       ,Disposition
      ,Reason "Reason for Exiting Study"
      ,ScreenFail as ScreenFailureFlag
      ,SFReason "Screen Failure Reason"
      ,EarlyTerm "Early Termination Flag"
      ,DiscReason "Reason for Early Termination"
      ,Completed "Completed Study Flag" 
      ,BL as EnrolledFlag "Enrolled Flag"
      ,C1 as C1Flag  "Cycle 1 Flag"
      ,C2 as C2Flag  "Cycle 2 Flag"
      ,C3 as C3Flag  "Cycle 3 Flag"
      ,C4 as C4Flag  "Cycle 4 Flag"
      ,LC as LastCycle

      
FROM visit
ORDER BY SiteID, SubjectID;
QUIT;
       


