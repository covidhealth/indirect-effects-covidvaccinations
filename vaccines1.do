use "W:\health_new\Salo\Vaccinatios\new\covidrokotetut2annos_new.dta",clear 
tab k
keep if k==1
save "W:\health_new\Salo\Vaccinatios\new\rokotteet1_new.dta", replace
