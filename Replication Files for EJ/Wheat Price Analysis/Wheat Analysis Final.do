set matsize 10000

****************************************************************
********************FILE CALL PATHS **********************
***************************************************************

use [enter file path for "Wheat Data Final.dta" here], clear


log using [enter file path for the log file here], replace

xtset id year



 *************************************************************

 ******* Generate Some Variables *****************

 *************************************************************

gen temp=lgrainprice*100
drop lgrainprice
rename temp lgrainprice

gen pre1600=1
replace pre1600=0 if year>=1600
gen pre1600Xtemperature=pre1600*temperature

sort id year
by id: gen lag1lgrainprice=lgrainprice[_n-1]

 *************************************************************

 **************** Descriptive Statistics *********************

 *************************************************************


xtsum lgrainprice temperature if lgrainprice~=.


*************************************************************

*********** Perform the Panel Dickey-Fuller Test ************

*************************************************************

xtunitroot fisher lgrainprice ,dfuller lags(2)



*************************************************************

************* Table 6:  Regression 1 ***********************

*************************************************************

quietly: eststo: xtreg lgrainprice temperature ,fe cluster(id)


*************************************************************

************* Table 6:  Regression 2 ***********************

*************************************************************

xi: quietly: eststo: xtreg lgrainprice temperature i.year, fe cluster(id)


*************************************************************

************* Table 6:  Regression 3 ***********************

*************************************************************

xi: quietly: eststo: xtreg lgrainprice lag1lgrainprice temperature i.year, fe cluster(id)


*************************************************************

************* Table 6:  Regression 4 ***********************

*************************************************************

quietly: eststo: xtreg lgrainprice temperature pre1600Xtemperature pre1600, fe cluster(id)

lincom temperature + pre1600Xtemperature

*************************************************************

************* Table 6:  Regression 5 ***********************

*************************************************************

xi: quietly: eststo: xtreg lgrainprice temperature pre1600Xtemperature pre1600 i.year, fe cluster(id)

lincom temperature + pre1600Xtemperature

*************************************************************

************* Table 6:  Regression 6 ***********************

*************************************************************

xi: quietly: eststo: xtreg lgrainprice temperature pre1600Xtemperature pre1600 lag1lgrainprice i.year, fe cluster(id)

lincom temperature + pre1600Xtemperature

esttab, se scalars(r2_a) k(temperature pre1600Xtemperature pre1600)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear



log close 





