set matsize 11000


use [enter file path for "Base Yearly Panel.dta" here], clear


log using [enter file path for log file here], replace


*****************************************************************************************
***For the D-inD Regressions, We Condition out Controls and Year and City Fixed Effects -- These variables are already in the replication .dta file ****
********************************************************************
********************************************************************

/*

xi: reg persecutions i.year i.id popdensity plague slopeplague  if sample==1,
predict persecutionsres, r 

xi: reg lagtemperature i.year i.id popdensity plague slopeplague  if sample==1,
predict lagtemperatureres, r 

xi: reg expulsion i.year i.id popdensity plague slopeplague  if sample==1,
predict expulsionres, r 

*/


*************************************************************
******** Multiply Dep Variables by 100  *************
*************************************************************

gen temp=persecutions*100
drop persecutions
rename temp persecutions

gen temp=persecutionsres*100
drop persecutionsres
rename temp persecutionsres

gen temp=expulsion*100
drop expulsion
rename temp expulsion

gen temp=expulsionres*100
drop expulsionres
rename temp expulsionres


*************************************************************
******** Table 3:  Baseline Using One-Year Data *************
*************************************************************


*************************************************************
************ Table 3:  Regression 1 *************************
*************************************************************


eststo: xi:  quietly:  reg persecutions lagtemperature popdensity plague slopeplague  if sample==1,  cluster(grid)


*************************************************************
************ Table 3:  Regression 2 *************************
*************************************************************

eststo: xi: quietly: xtreg persecutions lagtemperature popdensity plague slopeplague  if sample==1, fe cluster(grid)


*************************************************************
************ Table 3:  Regression 3 *************************
*************************************************************

eststo: quietly: reg persecutionsres lagtemperatureres if sample==1, cluster(grid) 


esttab, se scalars(F) k(lagtemperature lagtemperatureres)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear


*************************************************************
************ Table 3:  Regression 4 *************************
*************************************************************

eststo: xi: quietly: reg expulsion lagtemperature popdensity plague slopeplague  if sample==1, cluster(grid)


*************************************************************
************ Table 3:  Regression 5 *************************
*************************************************************

eststo: xi: quietly: xtreg expulsion lagtemperature popdensity plague slopeplague  if sample==1, fe cluster(grid)


*************************************************************
************ Table 3:  Regression 6 *************************
*************************************************************

eststo: quietly: reg expulsionres lagtemperatureres if sample==1, cluster(grid) 

esttab, se scalars(F) k(lagtemperature lagtemperatureres)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear







*************************************************************
******* Table 4:  Mechanisms Using One Year Data *****************
*************************************************************


*******************************************************************************
*******************************************************************************
**For the D-inD Regressions, We Condition out Controls and Year and City Fixed Effects -- These are already in the replication .dta file **
*******************************************************************************
*******************************************************************************

/*

sum wheat150suit if sample==1, detail
gen badwheat=0
replace badwheat=1 if wheat100suit>4.478556
gen badwheatXlagtemperature=badwheat*lagtemperature

sum ajrconstraint if sample==1, detail
gen constraintmean=0
replace constraintmean=1 if ajrconstraint<1.940088
gen constraintmeanXlagtemperature=constraintmean*lagtemperature

sum ajrcapital if sample==1, detail
gen capitalmean=0
replace capitalmean=1 if ajrcapital<1.407124
gen capitalmeanXlagtemperature=capitalmean*lagtemperature

sum stateantiquity if sample==1
gen statemean=0
replace statemean=1 if stateantiquity<36.9787
gen statemeanXlagtemperature=statemean*lagtemperature



xi: reg badwheatXlagtemperature i.year i.id popdensity plague slopeplague  if sample==1,
predict badwheatXlagtemperatureres, r 

xi: reg statemeanXlagtemperature i.year i.id popdensity plague slopeplague  if sample==1,
predict statemeanXlagtemperatureres, r 

xi: reg constraintmeanXlagtemperature i.year i.id popdensity plague slopeplague  if sample==1,
predict constraintmeanXlagtemperatureres, r 

xi: reg capitalmeanXlagtemperature i.year i.id popdensity plague slopeplague  if sample==1,
predict capitalmeanXlagtemperatureres, r

xi: reg statemean i.year i.id popdensity plague slopeplague  if sample==1,
predict statemeanres, r 

xi: reg constraintmean i.year i.id popdensity plague slopeplague  if sample==1,
predict constraintmeanres, r 

xi: reg capitalmean i.year i.id popdensity plague slopeplague  if sample==1,
predict capitalmeanres, r 


*/


*************************************************************
************ Table 4:  Regression 1 *************************
*************************************************************

eststo: xi: quietly: xtreg persecutions lagtemperature badwheatXlagtemperature popdensity plague slopeplague  if sample==1, fe  cluster(grid)

lincom lagtemperature + badwheatXlagtemperature


*************************************************************
************ Table 4:  Regression 2 *************************
*************************************************************

eststo: quietly: reg persecutionsres lagtemperatureres badwheatXlagtemperatureres if sample==1,  cluster(grid) 

lincom lagtemperatureres + badwheatXlagtemperatureres


esttab, se scalars(F) k(lagtemperature badwheatXlagtemperature lagtemperatureres badwheatXlagtemperatureres) star(* 0.10 ** 0.05 *** 0.01)
eststo clear



*************************************************************
************ Table 4:  Regression 3 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lagtemperature statemean statemeanXlagtemperature popdensity plague slopeplague  if sample==1, fe cluster(grid)

lincom lagtemperature + statemeanXlagtemperature


*************************************************************
************ Table 4:  Regression 4 *************************
*************************************************************

eststo: xi: quietly:    reg persecutionsres lagtemperatureres statemeanres statemeanXlagtemperatureres  if sample==1, cluster(grid)

lincom lagtemperatureres + statemeanXlagtemperatureres

esttab, se scalars(F) k(lagtemperature statemean statemeanXlagtemperature lagtemperatureres statemeanres statemeanXlagtemperatureres) star(* 0.10 ** 0.05 *** 0.01)
eststo clear


*************************************************************
************ Table 4:  Regression 5 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lagtemperature constraintmean constraintmeanXlagtemperature popdensity plague slopeplague  if sample==1, fe cluster(grid)

lincom lagtemperature + constraintmeanXlagtemperature

*************************************************************
************ Table 4:  Regression 6 *************************
*************************************************************

eststo: xi: quietly:    reg persecutionsres lagtemperatureres constraintmeanres constraintmeanXlagtemperatureres if sample==1,  cluster(grid) 

lincom lagtemperatureres + constraintmeanXlagtemperatureres

esttab, se scalars(F) k(lagtemperature constraintmean  constraintmeanXlagtemperature lagtemperatureres constraintmeanres  constraintmeanXlagtemperatureres) star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*************************************************************
************ Table 4:  Regression 7 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lagtemperature capitalmean capitalmeanXlagtemperature popdensity plague slopeplague  if sample==1, fe cluster(grid)

lincom lagtemperature + capitalmeanXlagtemperature

*************************************************************
************ Table 4:  Regression 8 *************************
*************************************************************

eststo: xi: quietly:    reg persecutionsres lagtemperatureres capitalmeanres capitalmeanXlagtemperatureres if sample==1, cluster(grid)

lincom lagtemperatureres + capitalmeanXlagtemperatureres


esttab, se scalars(F) k(lagtemperature capitalmean capitalmeanXlagtemperature lagtemperatureres capitalmeanres capitalmeanXlagtemperatureres ) star(* 0.10 ** 0.05 *** 0.01)
eststo clear



*************************************************************
******** Table 5:  City-Years Before/After 1600 *************
*************************************************************

*** Austria ****

count if country==1 & year<=1600 & sample==1
count if country==1 & year>=1600 & sample==1
count if country==1 & year<=1600 & sample==1 & persecutions==100
count if country==1 & year>1600 & sample==1 & persecutions==100


*** England ****

count if country==5 & year<=1600 & sample==1
count if country==5 & year>=1600 & sample==1
count if country==5 & year<=1600 & sample==1 & persecutions==100
count if country==5 & year>1600 & sample==1 & persecutions==100

*** France ****

count if country==6 & year<=1600 & sample==1
count if country==6 & year>=1600 & sample==1
count if country==6 & year<=1600 & sample==1 & persecutions==100
count if country==6 & year>1600 & sample==1 & persecutions==100


*** Germany ****

count if country==7 & year<=1600 & sample==1
count if country==7 & year>=1600 & sample==1
count if country==7 & year<=1600 & sample==1 & persecutions==100
count if country==7 & year>1600 & sample==1 & persecutions==100


*** Italy ****

count if country==9 & year<=1600 & sample==1
count if country==9 & year>=1600 & sample==1
count if country==9 & year<=1600 & sample==1 & persecutions==100
count if country==9 & year>1600 & sample==1 & persecutions==100


*** Poland ****

count if country==13 & year<=1600 & sample==1
count if country==13 & year>=1600 & sample==1
count if country==13 & year<=1600 & sample==1 & persecutions==100
count if country==13 & year>1600 & sample==1 & persecutions==100


*** Portugal ****

count if country==14 & year<=1600 & sample==1
count if country==14 & year>=1600 & sample==1
count if country==14 & year<=1600 & sample==1 & persecutions==100
count if country==14 & year>1600 & sample==1 & persecutions==100


*** Spain ****

count if country==17 & year<=1600 & sample==1
count if country==17 & year>=1600 & sample==1
count if country==17 & year<=1600 & sample==1 & persecutions==100
count if country==17 & year>1600 & sample==1 & persecutions==100


*** Switzerland ****

count if country==19 & year<=1600 & sample==1
count if country==19 & year>=1600 & sample==1
count if country==19 & year<=1600 & sample==1 & persecutions==100
count if country==19 & year>1600 & sample==1 & persecutions==100




*************************************************************
*********** Figure 3:  Placebo Regressions *************
*************************************************************

*************************************************************
****** D-in-D regressions on lag 10 up to lead 5 ************
*************************************************************

eststo: xi: quietly: xtreg persecutions templag10 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templag9 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templag8 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templag7 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templag6 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)


esttab, se scalars(F) k(templag10 templag9 templag8 templag7 templag6)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear


eststo: xi: quietly: xtreg persecutions templag5 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templag4 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templag3 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templag2 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templag1 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)


esttab, se scalars(F) k(templag5 templag4 templag3 templag2 templag1)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear


eststo: xi: quietly: xtreg persecutions templag0 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)


esttab, se scalars(F) k(templag0)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear


eststo: xi: quietly: xtreg persecutions templead1 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templead2 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templead3 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templead4 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)

eststo: xi: quietly: xtreg persecutions templead5 popdensity plague slopeplague i.year  if sample==1, fe cluster(grid)


esttab, se scalars(F) k(templead1 templead2 templead3 templead4 templead5)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear



*************************************************************
***********Table 8:  One Year Descriptive Statistics *************
*************************************************************

xtsum persecutions expulsion lagtemperature statemean badwheat capitalmean constraintmean popdensity  if sample==1



log close 






























