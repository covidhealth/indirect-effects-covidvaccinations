* This do file merges health data with variables on socioeconomic characteristics producing datasets for healthcare workers, partners and children

** Use FOLK module data 
use folk_20112019_tua_perus20tot_2, clear 
keep if vuosi==2019
save jpfolk2019, replace

** Merge using infection data
merge 1:m shnro using ttr2504_new, keep(master match)
gen covid=0
replace covid=1 if toteutunut_raportointiryhmäpuu=="Koronavirus"

** Date format
* sairauden_oireiden_alkamispäiväm = date of first symptoms
generate paivamaaraoireet = date(sairauden_oireiden_alkamispäiväm, "YMD")
format paivamaaraoireet %td
* 6 253 missing values for covid cases

* näytteenottopäivä = date of test/sample
generate paivamaaranayte = date(näytteenottopäivä, "YMD")
format paivamaaranayte %td
* 713 missing values for covid cases

* tilastointipäivä = date
generate paivamaaratilasto = date(tilastointipäivä, "YMD")
format paivamaaratilasto %td
* No missing values for covid cases
gen vuositilasto=year(paivamaaratilasto)
gen kuukausitilasto=month(paivamaaratilasto)
gen paivatilasto=day(paivamaaratilasto)
gen viikkotilasto=week(paivamaaratilasto) /// Use this with year for graphs

* ilmoituspäivä = date of registration
generate paivamaarailmoitus = date(ilmoituspäivä, "YMD")
format paivamaarailmoitus %td

** Merging with encrypted identifiers
order shnro vuositilasto kuukausitilasto
sort shnro vuositilasto kuukausitilasto
rename _merge merge
merge m:1 shnro using shetushnrolinkki, keep(master match)
rename vuosi year
rename vuositilasto vuosi
sort shetu vuosi
rename _merge merge1 

** Merging with income register
merge m:1 shetu using Tulorek82020, keepusing(professioncode82020) generate(_merge4)
drop if _merge4==2

** Modify profession codes
tostring professioncode82020, generate(professioncode82020_s)
gen occup82020= substr(professioncode82020_s,1,3)
destring occup82020, generate(occup_82020n) force
label values occup_82020n occup2
egen NcovidoccTulorek82020=count(covid & occup_82020n!=.) if covid==1, by(occup_82020n)
egen fr_occuTulorek82020=max(NcovidoccTulorek82020), by(occup_82020n)
egen NoccuTulorek82020=count(occup_82020n), by (occup_82020n)
replace occup_82020n=0 if occup_82020n==.

** Checking
gen korona=covid
bysort shnro: gen k=_n
replace k=1 if k!=1 & shnro==""
keep if k==1

** Save
save folk+trt+tulorek_new

** Save partner data
preserve
keep shnro shetu covid paivamaaratilasto sairaalahoito
rename * *_puoliso
save folk+trt+tulorek6varpuoliso_n,replace
restore

** Save child data
preserve
keep shnro shetu covid paivamaaratilasto sairaalahoito
rename * *_lapsi
save folk+trt+tulorek6varlapsi_n, replace