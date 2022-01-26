* This do file plots the cumulative share of those with two doses of those with at least one doses

** Fetch main data set
use collapsed_fakeday_allcontrollit_2504, clear

** Only keep those who have been vaccinated at least once
keep if rokotettu==1

** Starting from the time of the first vaccination
keep if c_timetoeventweeks==0

** Generating a week variable for the second dose
gen secondvaccine = annos_erotus/7
 
** Convert to full weeks
replace secondvaccine=3 if secondvaccine>2 & secondvaccine<=3
replace secondvaccine=4 if secondvaccine>3 & secondvaccine<=4
replace secondvaccine=5 if secondvaccine>4 & secondvaccine<=5
replace secondvaccine=6 if secondvaccine>5 & secondvaccine<=6
replace secondvaccine=7 if secondvaccine>6 & secondvaccine<=7
replace secondvaccine=8 if secondvaccine>7 & secondvaccine<=8
replace secondvaccine=9 if secondvaccine>8 & secondvaccine<=9
replace secondvaccine=10 if secondvaccine>9 & secondvaccine<=10
replace secondvaccine=11 if secondvaccine>10 & secondvaccine<=11
replace secondvaccine=12 if secondvaccine>11 & secondvaccine<=12
replace secondvaccine=13 if secondvaccine>12 & secondvaccine<=13
replace secondvaccine=14 if secondvaccine>13 & secondvaccine<=14
replace secondvaccine=15 if secondvaccine>14 & secondvaccine<=15
drop if secondvaccine>15
tab secondvaccine

** Aggregate
collapse(sum) rokotettu, by(secondvaccine)
drop if secondvaccine==.

** Cumulative share
gen cumulative_second_vaccine = sum(rokotettu)
gen cumulative_share = (cumulative_second_vaccine/113188)*100

** Graph
graph twoway (line cumulative_share secondvaccine if secondvaccine<13, lcolor(black)), xlabel(2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12")  xtitle("Weeks after first dose", size(mediumlarge)) ytitle("Cumulative share (%) of fully vaccinated", size(mediumlarge)) graphregion(color(white)) bgcolor(white) 



