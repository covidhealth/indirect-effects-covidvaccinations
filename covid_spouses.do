* This do file creates a data set of partners who have covid

use folk+trt+tulorek6varpuoliso_n, clear

** Keep only identifiable partners and those with a covid infection
drop if shnro_puoliso==""
keep if covid_puoliso==1

** Merge
merge 1:m shnro_puoliso using shnroidlinkkieventstudyrokotetut+eirokotetutpuolisot_new, generate(_merge15)
keep if _merge15==3
order id paivamaaratilasto shnro covid
gen time=paivamaaratilasto
duplicates report j
sort shnro_puoliso time
bys shnro_puoliso: gen o=_n
keep if o==1

** Save
save puolisoidenkoronat_n,replace