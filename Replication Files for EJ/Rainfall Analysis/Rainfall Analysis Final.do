set matsize 11000

****************************************************************
********************FILE CALL PATHS **********************
***************************************************************

use [enter file path for "Base Five Year Panel.dta" here], clear


log using [enter file path for log file here], replace




*********************************************************
********************Preliminaries **********************
*********************************************************

xtset id fiveyear


*********************************************************
******* Create Some Variables Etc************
*********************************************************

**************************************************
****** Create Leads & Lags of Rainfall Variable*****
***************************************************

sort id fiveyear
by id: gen lag1rainfall = rainfall[_n-1]

gen lnlag1rainfall = ln(lag1rainfall)

gen pre1600=1
replace pre1600=0 if fiveyear>=1600
gen pre1600Xlnlag1rainfall=pre1600*lnlag1rainfall


gen temp=persecutions*100
drop persecutions
rename temp persecutions

*********************************************************
**************End of Preliminaries*********
*********************************************************




*************************************************************
**** Table 12: Baseline Rainfall Regressions **********
*************************************************************



*************************************************************
************ Table 12:  Regression 1  ***********
*************************************************************


eststo: quietly:    reg persecutions lnlag1rainfall popdensity if sample==1, cluster(id)


*************************************************************
************ Table 12:  Regression 2  ***********
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall popdensity i.fiveyear if sample==1, fe cluster(id)


*************************************************************
************ Table 12:  Regression 3  ***********
*************************************************************

eststo: quietly:    reg persecutions lnlag1rainfall pre1600Xlnlag1rainfall pre1600 popdensity if sample==1, cluster(id)

lincom lnlag1rainfall + pre1600Xlnlag1rainfall


*************************************************************
************ Table 12:  Regression 4  ***********
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall pre1600Xlnlag1rainfall pre1600 i.fiveyear popdensity if sample==1, fe cluster(id)

lincom lnlag1rainfall + pre1600Xlnlag1rainfall

*************************************************************
************ Table 12:  Regression 5  ***********
*************************************************************

xi: eststo: quietly: reg persecutions pre1600 lnlag1rainfall pre1600Xlnlag1rainfall i.id*pre1600 i.fiveyear popdensity if sample==1, 

lincom lnlag1rainfall + pre1600Xlnlag1rainfall

esttab, se scalars(F) k(lnlag1rainfall pre1600Xlnlag1rainfall pre1600)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear



*************************************************************
******* Table 13:  Mechanisms Using Rainfall *****************
*************************************************************

*************************************************************
************* Create Some Variables ******************
*************************************************************

sum wheat150suit if sample==1, detail
gen bad150=0
replace bad150=1 if wheat150suit>4.4775
gen bad150Xlnlag1rainfall=bad150*lnlag1rainfall

sum ajrconstraint if sample==1, detail
gen constraintmean=0
replace constraintmean=1 if ajrconstraint<1.940088
gen constraintmeanXlnlag1rainfall=constraintmean*lnlag1rainfall

sum ajrcapital if sample==1, detail
gen capitalmean=0
replace capitalmean=1 if ajrcapital<1.407124
gen capitalmeanXlnlag1rainfall=capitalmean*lnlag1rainfall

sum stateantiquity if sample==1
gen statemean=0
replace statemean=1 if stateantiquity<36.9787
gen statemeanXlnlag1rainfall=statemean*lnlag1rainfall


*************************************************************
************ Table 13:  Regression 1 *************************
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall bad150Xlnlag1rainfall popdensity if sample==1 & century<7, fe  cluster(id)

lincom lnlag1rainfall + bad150Xlnlag1rainfall


*************************************************************
************ Table 13:  Regression 2 *************************
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall bad150Xlnlag1rainfall popdensity i.fiveyear  if sample==1 & century<7, fe  cluster(id)

lincom lnlag1rainfall + bad150Xlnlag1rainfall


esttab, se scalars(F) k(lnlag1rainfall bad150Xlnlag1rainfall) star(* 0.10 ** 0.05 *** 0.01)
eststo clear




*************************************************************
************ Table 13:  Regression 3 *************************
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall statemean statemeanXlnlag1rainfall popdensity if sample==1 & century<7, fe cluster(id)

lincom lnlag1rainfall + statemeanXlnlag1rainfall


*************************************************************
************ Table 13:  Regression 4 *************************
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall statemean statemeanXlnlag1rainfall i.fiveyear popdensity if sample==1 & century<7, fe cluster(id)

lincom lnlag1rainfall + statemeanXlnlag1rainfall


esttab, se scalars(F) k(lnlag1rainfall statemean statemeanXlnlag1rainfall) star(* 0.10 ** 0.05 *** 0.01)
eststo clear



*************************************************************
************ Table 13:  Regression 5 *************************
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall constraintmean constraintmeanXlnlag1rainfall popdensity if sample==1 & century<7, fe cluster(id)

lincom lnlag1rainfall + constraintmeanXlnlag1rainfall

*************************************************************
************ Table 13:  Regression 6 *************************
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall constraintmean constraintmeanXlnlag1rainfall i.fiveyear popdensity if sample==1 & century<7, fe cluster(id)

lincom lnlag1rainfall + constraintmeanXlnlag1rainfall

*************************************************************
************ Table 13:  Regression 7 *************************
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall capitalmean capitalmeanXlnlag1rainfall popdensity if sample==1 & century<7, fe cluster(id)

lincom lnlag1rainfall + capitalmeanXlnlag1rainfall

*************************************************************
************ Table 13:  Regression 8 *************************
*************************************************************

eststo: quietly:    xtreg persecutions lnlag1rainfall capitalmean capitalmeanXlnlag1rainfall i.fiveyear popdensity if sample==1 & century<7, fe cluster(id)

lincom lnlag1rainfall + capitalmeanXlnlag1rainfall


esttab , se scalars(F) k(lnlag1rainfall constraintmean  constraintmeanXlnlag1rainfall capitalmeanXlnlag1rainfall ) star(* 0.10 ** 0.05 *** 0.01)
eststo clear







log close 





