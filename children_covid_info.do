** This do file creates a data set of those children who have covid
use "W:\health_new\Salo\Vaccinatios\new\folk+trt+tulorek6varlapsi_n.dta", clear 

drop if shnro_lapsi==""
keep if covid_lapsi==1

** Merge
merge 1:m shnro_lapsi using "W:\health_new\Salo\Vaccinatios\new\shnroidlinkkieventstudyrokotetut+eirokotetutlapset_new.dta", generate(_merge15)
keep if _merge15==3
order id paivamaaratilasto shnro covid
gen time=paivamaaratilasto
duplicates report la
sort shnro_lapsi time
bys shnro_lapsi: gen o=_n
keep if o==1
save "W:\health_new\Salo\Vaccinatios\new\lastenkoronat_new.dta",replace