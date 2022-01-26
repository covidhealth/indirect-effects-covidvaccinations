* This do file creates the data where children are matched with their parents

** Open ready made data set where children are combined with their parents.
set maxvar 120000
use folk_19702019_tua_laps20_1.dta, clear

** Drop over 18-year olds and those who have missing id.
drop if syntyv<=2002
drop if shnro==""
drop if kuolv!=.
keep if folk_c=="1"

** Merge children with data set, which includes covid info. This data set includes whole population.
merge 1:m shnro_lapsi using folk+trt+tulorek6varlapsi_n

** Keep only children
drop if _merge==2
drop if _merge==1
drop _merge

** Get covariates for children
rename shnro_lapsi shnro
merge 1:1 shnro using jpfolk2019, keepusing(sukup)
drop if _merge==2
drop _merge
rename shnro shnro_lapsi
rename sukup sukup_lapsi

** Keep only those who live with their parents
rename shnro_lapsi shnro
 
** Merge with data set, which gives family id (petu) for each person
merge 1:1 shnro using jpperhefolk2019, keepusing(petu)
drop if _merge==2
keep if folk_c=="1"
rename shnro shnro_lapsi
rename shnro_m shnro
rename petu petu_lapsi
rename _merge _mergelapsi

** Mothers
merge m:1 shnro using jpperhefolk2019, keepusing(petu)
drop if _merge==2
rename _merge _mergeäiti
rename petu petu_äiti
rename shnro shnro_m
rename shnro_f shnro

** Fathers
merge m:1 shnro using jpperhefolk2019, keepusing(petu)
drop if _merge==2
rename _merge _mergeisä
rename petu petu_isä
rename shnro shnro_f

** Who does the child live with
gen asuu_aitinsa=1 if petu_lapsi==petu_äiti
replace asuu_aitinsa=0 if asuu_aitinsa==.
gen asuu_isansa=1 if petu_lapsi==petu_isä
replace asuu_isansa=0 if asuu_isansa==.
replace asuu_aitinsa=0 if petu_lapsi==""
replace asuu_isansa=0 if petu_lapsi==""
drop if _mergelapsi==1
keep if asuu_aitinsa==1 | asuu_isansa==1
bysort petu_äiti: gen perhelkm_äiti=_N
bysort petu_isä: gen perhelkm_isä=_N

** Save
save jplapsivanhemmat+lastenkoronat_new ,replace