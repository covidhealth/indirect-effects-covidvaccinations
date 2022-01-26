* This do file creates a data set of healthcare workers with covid before the vaccinations
* These individuals will be dropped from the working data set

use folk+trt+tulorek_new, clear 

* Keep healthcare workers
keep if occup_82020n==226 | occup_82020n==225 | occup_82020n==221 | occup_82020n==222 | occup_82020n==322  | occup_82020n==532

** Keep if they have had covid
keep if covid==1

** Covid before vaccinations have started
gen jou2=td(25dec2020)
tab jou2
keep if paivamaaratilasto<=22274

** Save
save hoitohklcovidennen2612_n
