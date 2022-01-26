* This do file creates a data set of children with covid before the vaccinations
* These individuals will be dropped from the working data set

use folk+trt+tulorek6varlapsi_n, clear

** Drop unidentified individuals
drop if shnro_lapsi==""

** Keep if they have had covid
keep if covid_lapsi==1

** Keep if covid has been contracted before vaccintions have started
sort paivamaaratilasto_lapsi
gen jou2=td(26dec2020)
tab jou2
keep if paivamaaratilasto<=22275

** Save
save lastencovidennen2612_n, replace