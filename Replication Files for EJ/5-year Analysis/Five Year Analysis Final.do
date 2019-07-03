set matsize 10000

****************************************************************
********************FILE CALL PATHS **********************
***************************************************************

use [enter file path for "Base Five Year Panel.dta" here], clear


log using [enter file path for log file here], replace


log off


**************************************************************
****************************************************************
********************Preliminaries **********************
***************************************************************
************************************************************



************************************************************
******* Create Some Variables Etc **************************
************************************************************
sort id fiveyear
xtset id fiveyear


************************************************************
******* Multiply Dep Variables by 100 **************************
************************************************************

gen persecutions100=persecutions*100
drop persecutions
rename persecutions100 persecutions

gen expulsions100=expulsions*100
drop expulsions
rename expulsions100 expulsions

****** Create Leads & Lags of temperature Variables ***********

sort id fiveyear
by id: gen lag1temperature = temperature[_n-1]

sort id fiveyear
by id: gen lag2temperature = temperature[_n-2]

sort id fiveyear
by id: gen lag3temperature = temperature[_n-3]

sort id fiveyear
by id: gen lead1temperature = temperature[_n+1]

sort id fiveyear
by id: gen lead2temperature = temperature[_n+2]

sort id fiveyear
by id: gen lead3temperature = temperature[_n+3]


************************************************************
***** Fix Sample so Consistent with lag1temperature variable **
************************************************************

replace sample=0 if lag1temperature==.


*************************************************************
************* Create Some Variables for Interactions: *************
************* Define dummy=1 at the means of variables *************
*************************************************************



sum wheat150suit if sample==1, detail
gen lowsuitability=0
replace lowsuitability=1 if wheat150suit>4.4775
gen lowsuitXlag1temp=lowsuitability*lag1temperature

gen wheat150suitXlag1temperature=wheat150suit*lag1temperature


sum ajrconstraint if sample==1, detail
gen lowconstraint=0
replace lowconstraint=1 if ajrconstraint<1.940088
gen lowconstraintXlag1temperature=lowconstraint*lag1temperature

sum ajrcapital if sample==1, detail
gen lowcapital=0
replace lowcapital=1 if ajrcapital<1.407124
gen lowcapitalXlag1temperature=lowcapital*lag1temperature

sum stateantiquity if sample==1
gen lowantiquity=0
replace lowantiquity=1 if stateantiquity<36.9787
gen lowantiquityXlag1temperature=lowantiquity*lag1temperature



**************************************************************
****************************************************************
********************End of Preliminaries **********************
***************************************************************
************************************************************


log on




*************************************************************
******* Table 1:  Panel A:  Reduced Form:  Baseline *******************
*************************************************************



*************************************************************
************ Table 1:  Panel A:  Regression 1 *************************
*************************************************************


eststo: xi: quietly:    reg persecutions lag1temperature popdensity  plague slopeplague if sample==1,  cluster(grid)


*************************************************************
************ Table 1:  Panel A:  Regression 2 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lag1temperature popdensity  plague slopeplague if sample==1, fe cluster(grid)


*************************************************************
************ Table 1:  Panel A:  Regression 3 *************************
*************************************************************

eststo: xi: quietly:    xtivreg2 persecutions lag1temperature i.fiveyear popdensity  plague slopeplague if sample==1, fe cluster(grid) partial(i.fiveyear)


esttab, se scalars(F) k(lag1temperature)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear


*************************************************************
************ Table 1:  Panel A:  Regression 4 *************************
*************************************************************

eststo: xi: quietly:    reg expulsions lag1temperature popdensity  plague slopeplague if sample==1, cluster(grid)


*************************************************************
************ Table 1:  Panel A:  Regression 5 *************************
*************************************************************

eststo: xi: quietly:    xtreg expulsions lag1temperature popdensity  plague slopeplague if sample==1, fe cluster(grid)


*************************************************************
************ Table 1:  Panel A:  Regression 6 *************************
*************************************************************

eststo: xi: quietly:    xtivreg2 expulsions lag1temperature i.fiveyear popdensity  plague slopeplague if sample==1, fe cluster(grid) partial(i.fiveyear)

esttab, se scalars(F) k(lag1temperature)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear




*************************************************************
*** Table 1:  Panel B:  No Iberian Expulsions ********************
*************************************************************

*************************************************************
************ Table 1:  Panel B:  Regression 1 *************************
*************************************************************

eststo: xi: quietly:    reg persecutions lag1temperature popdensity plague slopeplague  if sample==1 & nat1492~=1 & nat1497~=1, cluster(grid)


*************************************************************
************ Table 1:  Panel B:  Regression 2 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lag1temperature popdensity plague slopeplague  if sample==1 & nat1492~=1 & nat1497~=1, fe cluster(grid)

*************************************************************
************ Table 1:  Panel B:  Regression 3 *************************
*************************************************************

eststo: xi: quietly:    xtivreg2 persecutions lag1temperature i.fiveyear popdensity plague slopeplague  if sample==1 & nat1492~=1 & nat1497~=1, fe cluster(grid) partial(i.fiveyear)

esttab, se scalars(F) k(lag1temperature) star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*************************************************************
************ Table 1:  Panel B:  Regression 4 *************************
*************************************************************

eststo: xi: quietly:    reg expulsions lag1temperature popdensity plague slopeplague  if sample==1 & nat1492~=1 & nat1497~=1, cluster(grid)


*************************************************************
************ Table 1:  Panel B:  Regression 5 *************************
*************************************************************

eststo: xi: quietly:    xtreg expulsions lag1temperature popdensity plague slopeplague  if sample==1 & nat1492~=1 & nat1497~=1, fe cluster(grid)

*************************************************************
************ Table 1:  Panel B:  Regression 6 *************************
*************************************************************

eststo: xi: quietly:    xtivreg2 expulsions lag1temperature i.fiveyear popdensity plague slopeplague  if sample==1 & nat1492~=1 & nat1497~=1, fe cluster(grid) partial(i.fiveyear)


esttab, se scalars(F) k(lag1temperature) star(* 0.10 ** 0.05 *** 0.01)
eststo clear







*************************************************************
******* Table 2:  Reduced Form:  Mechanisms *****************
*************************************************************



*************************************************************
************ Table 2:  Regression 1 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lag1temperature lowsuitXlag1temp popdensity plague slopeplague  if sample==1, fe  cluster(grid)

lincom lag1temperature + lowsuitXlag1temp


*************************************************************
************ Table 2:  Regression 2 *************************
*************************************************************

eststo: xi: quietly:    xtivreg2 persecutions lag1temperature lowsuitXlag1temp popdensity plague slopeplague i.fiveyear  if sample==1, fe  cluster(grid) partial(i.fiveyear)

lincom lag1temperature + lowsuitXlag1temp


esttab, se scalars(F) k(lag1temperature lowsuitXlag1temp) star(* 0.10 ** 0.05 *** 0.01)
eststo clear



*************************************************************
************ Table 2:  Regression 3 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lag1temperature lowantiquity lowantiquityXlag1temperature popdensity plague slopeplague  if sample==1, fe cluster(grid)

lincom lag1temperature + lowantiquityXlag1temperature


*************************************************************
************ Table 2:  Regression 4 *************************
*************************************************************

eststo: xi: quietly:    xtivreg2 persecutions lag1temperature lowantiquity lowantiquityXlag1temperature i.fiveyear popdensity plague slopeplague  if sample==1, fe cluster(grid) partial(i.fiveyear)

lincom lag1temperature + lowantiquityXlag1temperature

esttab, se scalars(F) k(lag1temperature lowantiquity lowantiquityXlag1temperature) star(* 0.10 ** 0.05 *** 0.01)
eststo clear


*************************************************************
************ Table 2:  Regression 5 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lag1temperature lowconstraint lowconstraintXlag1temperature popdensity plague slopeplague  if sample==1, fe cluster(grid)

lincom lag1temperature + lowconstraintXlag1temperature

*************************************************************
************ Table 2:  Regression 6 *************************
*************************************************************

eststo: xi: quietly:    xtivreg2 persecutions lag1temperature lowconstraint lowconstraintXlag1temperature i.fiveyear popdensity plague slopeplague  if sample==1, fe cluster(grid) partial(i.fiveyear)

lincom lag1temperature + lowconstraintXlag1temperature

*************************************************************
************ Table 2:  Regression 7 *************************
*************************************************************

eststo: xi: quietly:    xtreg persecutions lag1temperature lowcapital lowcapitalXlag1temperature popdensity plague slopeplague  if sample==1, fe cluster(grid)

lincom lag1temperature + lowcapitalXlag1temperature

*************************************************************
************ Table 2:  Regression 8 *************************
*************************************************************

eststo: xi: quietly:    xtivreg2 persecutions lag1temperature lowcapital lowcapitalXlag1temperature i.fiveyear popdensity plague slopeplague  if sample==1, fe cluster(grid) partial(i.fiveyear)

lincom lag1temperature + lowcapitalXlag1temperature


esttab, se scalars(F) k(lag1temperature lowconstraint  lowconstraintXlag1temperature lowcapital lowcapitalXlag1temperature ) star(* 0.10 ** 0.05 *** 0.01)
eststo clear





*************************************************************
*** Figure 4:  Effect of Temperature on Persecution Probability Over Time *****
*************************************************************

xi i.century*lag1temperature

xtreg persecutions lag1temperature _IcenXlag1t_2 _IcenXlag1t_3 _IcenXlag1t_4 _IcenXlag1t_5 _IcenXlag1t_6 _IcenXlag1t_7 i.fiveyear popdensity plague slopeplague  if sample==1, fe cluster(id)



*************************************************************
**** Table 7 (Appendix):  Five Year Descriptive Statistics *************
*************************************************************

xtsum jewishcomm50

xtsum persecutions expulsions lag1temperature lowantiquity lowsuitability lowcapital lowconstraint popdensity  if sample==1






*************************************************************
*** Table 10:  Continuous Wheat Suitability and State Antiquity ******
*************************************************************


*************************************************************
******** Table 10:  Regression 1: Continuous Wheat Suit ***********
*************************************************************

eststo: xi:  xtreg persecutions lag1temperature wheat150suitXlag1temperature popdensity plague slopeplague  if sample==1, fe  cluster(grid)

lincom lag1temperature + wheat150suitXlag1temperature


*************************************************************
******** Table 10:  Regression 2: Continuous Wheat Suit ***********
*************************************************************


eststo: xi:  xtivreg2 persecutions lag1temperature wheat150suitXlag1temperature popdensity plague slopeplague i.fiveyear  if sample==1, fe  cluster(grid) partial(i.fiveyear)

lincom lag1temperature + wheat150suitXlag1temperature


esttab, se scalars(F) k(lag1temperature wheat150suitXlag1temperature) star(* 0.10 ** 0.05 *** 0.01)
eststo clear


*************************************************************
****** Table 10:  Regression 3: Continuous State Antiquity ********
*************************************************************

*** (A) We begin by re-coding the stateantiquity variable so that it goes from 0 to 50 with 50 being the lowest antiquity and 0 being the greatest.  This will allow us to interpret it the same as the other variables. ***

sum stateantiquity if sample==1
gen newantiquity=50-stateantiquity
gen newantiquityXlag1temperature= newantiquity*lag1temperature

xi:   xtreg persecutions lag1temperature newantiquity newantiquityXlag1temperature popdensity plague slopeplague  if sample==1, fe cluster(grid)

lincom lag1temperature + newantiquityXlag1temperature


*************************************************************
****** Table 10:  Regression 4: Continuous State Antiquity ********
*************************************************************


xi:   xtivreg2 persecutions lag1temperature newantiquity newantiquityXlag1temperature i.fiveyear popdensity plague slopeplague  if sample==1, fe cluster(grid) partial(i.fiveyear)

lincom lag1temperature + newantiquityXlag1temperature



esttab, se scalars(F) k(lag1temperature newantiquity newantiquityXlag1temperature) star(* 0.10 ** 0.05 *** 0.01)
eststo clear




*************************************************************
****** Figure 6: Interaction Plot of Soil Suitability ********
*************************************************************



xtreg persecutions lag1temperature wheat150suitXlag1temperature wheat150suit popdensity plague slopeplague i.fiveyear  if sample==1, fe  cluster(grid) *************************************generate MV=(_n)replace  MV=. if _n>7*     ****************************************************************  **       Grab elements of the coefficient and variance-covariance matrix **       that are required to calculate the marginal effect and standard **       errors.                                                         **     ****************************************************************  *matrix b=e(b) matrix V=e(V) scalar b1=b[1,1] scalar b3=b[1,2]scalar b2=b[1,3]scalar varb1=V[1,1] scalar varb2=V[3,3] scalar varb3=V[2,2]scalar covb1b3=V[1,2] scalar covb2b3=V[3,2]scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3*     ****************************************************************  **       Calculate the marginal effect of X on Y for all MV values of    **       the modifying variable Z.                                       **     ****************************************************************  *gen conb=b1+b3*MV if _n<8*     ****************************************************************  **       Calculate the standard errors for the marginal effect of X on Y **       for all MV values of the modifying variable Z.                  **     ****************************************************************  *gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<8*     ****************************************************************  **       Generate upper and lower bounds of the confidence interval.     **       Specify the significance of the confidence interval.            **     ****************************************************************  *gen a=1.96*conse gen upper=conb+a gen lower=conb-a*     ****************************************************************  **       Graph the marginal effect of X on Y across the desired range of **       the modifying variable Z.  Show the confidence interval.        **     ****************************************************************  *graph twoway line conb MV,  clwidth(medium) clcolor(blue) clcolor(black) || line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of Temperature") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("", size(3)) subtitle(" " "DID Effect of Temperature on Persecution Prob. as Soil Quality Decreases" " ", size(3)) xtitle( "Soil Quality (8=lowest quality)", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Temperature", size(3)) scheme(s2mono) graphregion(fcolor(white))drop  MV conb conse a upper lower*************************************************************
****** Figure 7: Interaction Plot of State Antiquity ********
*************************************************************
xtreg persecutions lag1temperature newantiquityXlag1temperature newantiquity  i.fiveyear popdensity plague slopeplague  if sample==1, fe cluster(grid)*************************************generate MV=(_n)replace  MV=. if _n>50*     ****************************************************************  **       Grab elements of the coefficient and variance-covariance matrix **       that are required to calculate the marginal effect and standard **       errors.                                                         **     ****************************************************************  *matrix b=e(b) matrix V=e(V) scalar b1=b[1,1] scalar b3=b[1,2]scalar b2=b[1,3]scalar varb1=V[1,1] scalar varb2=V[3,3] scalar varb3=V[2,2]scalar covb1b3=V[1,2] scalar covb2b3=V[3,2]scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3*     ****************************************************************  **       Calculate the marginal effect of X on Y for all MV values of    **       the modifying variable Z.                                       **     ****************************************************************  *gen conb=b1+b3*MV if _n<51*     ****************************************************************  **       Calculate the standard errors for the marginal effect of X on Y **       for all MV values of the modifying variable Z.                  **     ****************************************************************  *gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<51*     ****************************************************************  **       Generate upper and lower bounds of the confidence interval.     **       Specify the significance of the confidence interval.            **     ****************************************************************  *gen a=1.96*conse gen upper=conb+a gen lower=conb-a*     ****************************************************************  **       Graph the marginal effect of X on Y across the desired range of **       the modifying variable Z.  Show the confidence interval.        **     ****************************************************************  *graph twoway line conb MV,  clwidth(medium) clcolor(blue) clcolor(black) || line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of Temperature") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("", size(3)) subtitle(" " "DID Effect of Temperature on Persecution Prob. as State Antiquity Decreases" " ", size(3)) xtitle( "State Antiquity (reverse scale, 50=lowest antiquity)", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Temperature", size(3)) scheme(s2mono) graphregion(fcolor(white))drop  MV conb conse a upper lower





*************************************************************
**** Table 11: Regressions Controlling for Spatial and Serial Correlation *****
*************************************************************


*************************************************************
************ Table 11:  Regression 1 *************************
*************************************************************

eststo: xi: ols_spatial_HAC persecutions lag1temperature popdensity plague slopeplague i.id if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp


*************************************************************
************ Table 11:  Regression 2 *************************
*************************************************************

eststo: xi: ols_spatial_HAC persecutions lag1temperature popdensity plague slopeplague i.id i.fiveyear if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp


*************************************************************
************ Table 11:  Regression 3 *************************
*************************************************************


eststo: xi: ols_spatial_HAC persecutions lag1temperature lowsuitXlag1temp popdensity plague slopeplague i.id if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp

lincom lag1temperature + lowsuitXlag1temp


*************************************************************
************ Table 11:  Regression 4 *************************
*************************************************************


eststo: xi: ols_spatial_HAC persecutions lag1temperature lowsuitXlag1temp popdensity plague slopeplague i.id i.fiveyear if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp

lincom lag1temperature + lowsuitXlag1temp


*************************************************************
************ Table 11:  Regression 5 *************************
*************************************************************


eststo: xi: ols_spatial_HAC persecutions lag1temperature lowantiquity lowantiquityXlag1temperature popdensity plague slopeplague i.id if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp

lincom lag1temperature + lowantiquityXlag1temperature


*************************************************************
************ Table 11:  Regression 6 *************************
*************************************************************


eststo: xi: ols_spatial_HAC persecutions lag1temperature lowantiquity lowantiquityXlag1temperature popdensity plague slopeplague i.id i.fiveyear if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp

lincom lag1temperature + lowantiquityXlag1temperature


*************************************************************
************ Table 11:  Regression 7 *************************
*************************************************************


eststo: xi: ols_spatial_HAC persecutions lag1temperature lowconstraint lowconstraintXlag1temperature popdensity plague slopeplague i.id if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp

lincom lag1temperature + lowconstraintXlag1temperature


*************************************************************
************ Table 11:  Regression 8 *************************
*************************************************************


eststo: xi: ols_spatial_HAC persecutions lag1temperature lowconstraint lowconstraintXlag1temperature popdensity plague slopeplague i.id i.fiveyear if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp

lincom lag1temperature + lowconstraintXlag1temperature


*************************************************************
************ Table 11:  Regression 9 *************************
*************************************************************


eststo: xi: ols_spatial_HAC persecutions lag1temperature lowcapital lowcapitalXlag1temperature popdensity plague slopeplague i.id if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp

lincom lag1temperature + lowcapitalXlag1temperature


*************************************************************
************ Table 11:  Regression 10 *************************
*************************************************************

eststo: xi: ols_spatial_HAC persecutions lag1temperature lowcapital lowcapitalXlag1temperature popdensity plague slopeplague i.id i.fiveyear if sample==1, lat(latitude) lon(longitude) timevar(fiveyear) panelvar(id) dist(500) lag(2) star dropvar disp

lincom lag1temperature + lowcapitalXlag1temperature




log close 





