** This do file creates a data set of those who have covid

use folk+trt+tulorek_new,clear
sort paivamaaratilasto

** Keep healthcare workers with covid
keep if occup_82020n==226 | occup_82020n==225 | occup_82020n==221 | occup_82020n==222 | occup_82020n==322  | occup_82020n==532
keep if covid==1

** Keep only the cases in the period of interest
gen jou2=td(26dec2020)
tab jou2
drop if paivamaaratilasto<=22275

** Merge 
duplicates report shnro
merge 1:1 shnro using shnroidlinkkieventstudyrokotetut+eirokotetut_new, generate(_merge11)
keep if _merge11==3
order id paivamaaratilasto shnro covid
gen time=paivamaaratilasto

** Save
save hoitohklcovidrokotetut+ei-rokotetut_new, replace
