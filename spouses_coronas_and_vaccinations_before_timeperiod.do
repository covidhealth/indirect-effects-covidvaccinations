* This do file creates a data set of partners with covid before the vaccinations
* These individuals will be dropped from the working data set

use folk+trt+tulorek6varpuoliso_n, clear 

** Drop unidentifiable partners
drop if shnro_puoliso==""

** Keep if they have had covid
keep if covid_puoliso==1

** Keep those with covid before our time period has started
gen jou=td(26dec2020)
keep if paivamaaratilasto_puoliso <=22275

** Save
save puolisoidenkoronatennen2712_new,replace


** This puolisot2019 is just folkasuinliitot (population file linking partners) file where year 2019 is kept
use puolisot2019, clear
rename shnro shnro1
rename spuhnro shnro_puoliso
merge 1:1 shnro_puoliso using puolisoidenkoronatennen2712_new
drop if _merge==3
drop if _merge==2
rename shnro_puoliso shnro
merge 1:1 shnro using rokotteet1_new, keepusing(covid_rokote) generate(_merge2)
drop if _merge2==3
drop if _merge2==2
drop covid_rokote
merge 1:1 shnro using jpfolk2019, keepusing(sukup syntyv) generate(_merge3)
drop if _merge3==2
rename sukup sukup_puoliso
rename syntyv syntyv_puoliso
drop _merge3
rename shnro spuhnro
rename  shnro1 shnro
drop _merge _merge2

** Save
save puolisot2019poistetturokotetut_new, replace
