* This do-file creates the data set for studying direct and indirect effects of covid vaccines from the previously formed data sets 

** Open the vaccine data
use covidrokotetut2annos_new, clear
rename * *_hilmo
rename shnro_hilmo shnro
rename _merge _merge2

gen time=rokotepvm_hilmo
format time %td

gen jou6=td(27nov2020)
replace time=. if time<jou6
drop if time==.

** There are two different id numbers for each individual. The next merging gives the other id.
merge m:1 shnro using shetushnrolinkkioneshetu

** Drop those who are not vaccinated, they will be included later.
drop if _merge==2

** Get occupation info for vaccinated
merge m:1 shetu using Tulorek82020", keepusing(professioncode82020) generate(_merge4)
tostring professioncode82020, generate(professioncode82020_s)
gen occup82020= substr(professioncode82020_s,1,3)
destring occup82020, generate(occup_82020n) force

* Now everyone who has a occupation is included. Also those who does not have a vaccine.

** Keep only healthcare workers
keep if occup_82020n==226 | occup_82020n==225 | occup_82020n==221 | occup_82020n==222 | occup_82020n==322  | occup_82020n==532| time==22247
drop if professioncode82020_s=="22620" | professioncode82020_s=="22630" | professioncode82020_s=="22650" | professioncode82020_s=="22690" | professioncode82020_s=="22500" | professioncode82020_s=="53292" | professioncode82020_s=="53293" | professioncode82020_s=="53294"

* Now data includes only health care workers. Vaccinated and non-vaccinated.

** This gives the other id number for non-vaccinated
rename shnro shnro1
merge m:1 shetu using shetushnrolinkkioneshetu, keepusing(shnro) generate(_merge8)

** Drop extra individuals
drop if _merge8==2

** Drop those who have corona before the starting period
drop if shnro==""
egen s=group(shnro)
merge m:1 shnro using hoitohklcovidennen2612_n, keepusing(covid) generate(_merge13)
keep if _merge13==1
drop covid

** Get background info for individuals
merge m:1 shnro using jpfolk2019, keepusing(sukup syntyv kunta mkunta kuntaryhm31_12 syntyp2 pekoko_k akoko_k) generate(_merge5)
drop if _merge5==2

** Checking how many have vaccines
bys shnro: gen l=_n
tab l
tab covid_rokote_hilmo if l==1
tab covid_rokote_hilmo if l==2

** Next one is done because matching id variable is needed after extending the data set
preserve
keep shnro s
duplicates report shnro
duplicates report s
gen id=shnro
bys shnro: gen y=_n
keep if y==1
save shnroidlinkkieventstudyrokotetut+eirokotetut_new, replace
restore

** Create time observation for everyone because of tsfill command
g jou5=td(01jan2021)
replace time=td(01jan2021) if time==.
save basedata,replace

** Combine healthcare worker with partner. The following merged file includes only spouses who are not vaccinated and haven't had covid before our time period.
merge m:1 shnro using puolisot2019poistetturokotetut_new, keepusing(spuhnro) generate(_merge14)
drop if _merge14==2
rename spuhnro shnro_puoliso

** We need a matching variable for spouses after extending the data set
egen j=group(shnro_puoliso)
preserve
keep shnro_puoliso j
duplicates report shnro_puoliso
duplicates report j
gen id_puoliso=shnro_puoliso
save shnroidlinkkieventstudyrokotetut+eirokotetutpuolisot_new, replace
restore

** Create a variable to recognize second dose
sort shnro time
bys shnro: gen c=_n

** Extend the data to day level. Each row is individual at a specific day. This is done because we want to calculate the time from the vaccination (event) to covid (outcome)
xtset s time
order s time
tsfill, full
egen t=min(j), by (s)
rename j j2
rename t j

save maindata_firstpart, replace

** This do file creates a data set of healthcare workers who have covid
do covid_info_after26122020

** This do file creates a data set of partners who have covid
do covid_spouses

use maindata_firstpart, clear

** Get the covid info
merge m:1 s time using hoitohklcovidrokotetut+ei-rokotetut_new, keepusing(covid id paivamaaratilasto sairaalahoito) generate(_merge12)

** This will drop those covid cases which happened outside of our time period
drop if s==.
drop if time<=22252
xtset s time
tsfill, full
order shnro id s time

** Get the covid info for spouses
egen a=min(j), by (s)
rename j j3
rename a j

merge m:1 j time using puolisoidenkoronat_n, generate(_merge16)

** No extra observations
save daydatarokotetutkimus_new,replace

xtset s time

** Create a covid variable, which gets value 1 in the panel after covid occurs. Otherwise 0.
g apucovid=covid
replace apucovid=0 if apucovid==.
egen eventcovid=min(paivamaaratilasto),by (s)
format eventcovid %td
replace covid=1 if time>=eventcovid
replace covid=0 if time<eventcovid

** Drop those observations who has AstraZeneca
egen henkilollaastra=min(astra_hilmo), by (s)
tab henkilollaastra
drop if henkilollaastra==1

** Create event variable
*This will keep observations also after the second dose
replace rokotepvm_hilmo=. if c==2
replace covid_rokote_hilmo=. if c==2
egen event=min(rokotepvm_hilmo),by (s)
format event %td

** Delete those who get a covid before vaccinated
bys s: gen differenssi= event- eventcovid
drop if differenssi>0 & differenssi!=.
gen treat=0
replace treat=1 if time>event
order s time event treat
gen timetoevent= time-event

** Create a covid variable for spouses
egen eventcovid_puoliso=min(paivamaaratilasto_puoliso),by (s)
format eventcovid_puoliso %td

** Drop those spouses who had a covid before the main character got vaccinated
bys s: gen differenssi2= event- eventcovid_puoliso
replace j=. if differenssi2>0 & differenssi2!=.
replace j=. if eventcovid_puoliso<22276
replace covid_puoliso=. if j==.
g apucovid_puoliso=covid_puoliso
replace apucovid_puoliso=0 if apucovid_puoliso==. & j!=.
replace covid_puoliso=1 if time>=eventcovid_puoliso & j!=.
replace covid_puoliso=0 if time<eventcovid_puoliso & j!=.

** Generate random event day
generate random_event_day = ///
floor((mdy(4,25,2021) - mdy(12,27,2020)+1) * runiform() + mdy(12,27,2020))
bys s: replace random_event_day = random_event_day[1]
gen time_to_fake_event = time - random_event_day
format random_event_day %td
sort s time

** Fake-event from the beginning of our time period. This is for robustness checks
gen fake_event_joulukuu=td(27dec2020)
format fake_event_joulukuu %td

**Time to event in weeks**
gen week=week(time)
gen event_week=week(event)
replace event_week=0 if event_week==52
replace event_week=-1 if event_week==51
replace event_week=-2 if event_week==50
replace event_week=-3 if event_week==49
replace event_week=-4 if event_week==48
drop if event_week==-3 | event_week==-4

gen week2=week
replace week2=0 if week2==52
replace week2=-1 if week2==51
replace week2=-2 if week2==50
replace week2=-3 if week2==49
replace week2=-4 if week2==48
gen timetoeventweeks_calendar=week2-event_week

** This creates event week variable. Replace event week with random event week for non-vaccinated.
gen event1=event_week
gen random_event_week=week(random_event_day)
replace random_event_week=0 if random_event_week==52
replace random_event_week=-1 if random_event_week==51
replace random_event_week=-2 if random_event_week==50
replace random_event_week=-3 if random_event_week==49
replace random_event_week=-4 if random_event_week==48
replace event1=random_event_week if event_week==.
gen joulukuu_viikko=week(fake_event_joulukuu)
gen event5=event_week
replace event5=joulukuu_viikko if event_week==.
replace event5=0 if event5==52

** Create time to event week variable
gen c_timetoeventweeks= week2-event1

** Create variable, which gets value 1 in the same week as a covid occurs, otherwise 0. Create also a variable, which is in every period, if person has a covid, otherwise 0.
egen covid1=max(apucovid), by (s c_timetoeventweeks)
replace covid1=0 if covid1==.
egen covid2=max(covid), by (s c_timetoeventweeks)
replace covid2=0 if covid2==.

** Create cumulative covid
gen apu1=apucovid
egen eventcovid_after=min(paivamaaratilasto) if c_timetoeventweeks>0 ,by (s)
format eventcovid_after %td
replace apu1=1 if time>=eventcovid_after & c_timetoeventweeks>0
replace apu1=0 if c_timetoeventweeks<0
egen covid3=max(apu1), by (s c_timetoeventweeks)
replace covid3=0 if covid3==.

** Create all the same covid variables (covid1, covid2, covid3) for spouses
egen covid1_puoliso=max(apucovid_puoliso), by (s c_timetoeventweeks)
replace covid1_puoliso=0 if covid1_puoliso==. & j!=.
egen covid2_puoliso=max(covid_puoliso), by (s c_timetoeventweeks)
replace covid2_puoliso=0 if covid2_puoliso==. & j!=.
gen apu1_puoliso=apucovid_puoliso
egen eventcovid_puoliso_after=min(paivamaaratilasto_puoliso) if c_timetoeventweeks>0 ,by (s)
format eventcovid_puoliso_after %td
replace apu1_puoliso=1 if time>=eventcovid_puoliso_after & c_timetoeventweeks>0 & j!=.
replace apu1_puoliso=0 if c_timetoeventweeks<0 & j!=.
egen covid3_puoliso=max(apu1_puoliso), by (s c_timetoeventweeks)
replace covid3_puoliso=0 if covid3_puoliso==. & j!=.

** Create hospital admission variable
gen hosp_admis=1 if sairaalahoito=="kyllä"
tab hosp_admis
replace hosp_admis=0 if hosp_admis!=1
gen hosp_admis_puoliso=1 if sairaalahoito_puoliso=="kyllä"
replace hosp_admis_puoliso=0 if hosp_admis_puoliso!=1
replace hosp_admis_puoliso=. if j==.
tab hosp_admis_puoliso
g apusairaala=hosp_admis
replace apusairaala=0 if hosp_admis==.
egen sairaalahoito1=max(apusairaala), by (s c_timetoeventweeks)
replace sairaalahoito1=0 if sairaalahoito1==.
egen help_var=max(apusairaala), by (s)
replace help_var=0 if help_var==.
gen eventcovid_after_sairaala=eventcovid_after if help_var==1
gen apuhosp=apusairaala
replace apuhosp=1 if time>=eventcovid_after_sairaala & c_timetoeventweeks>0
replace apuhosp=0 if c_timetoeventweeks<0
egen sairaala_kumul=max(apuhosp), by (s c_timetoeventweeks)
replace sairaala_kumul=0 if sairaala_kumul==.

** Hospital admission variable for spouse. Variable gets value 1 after hospital admission, otherwise 0.
g apusairaala_puoliso=hosp_admis_puoliso
replace apusairaala_puoliso=0 if hosp_admis_puoliso==. & j!=.
egen sairaalahoito1_puoliso=max(apusairaala_puoliso), by (s c_timetoeventweeks)
replace sairaalahoito1_puoliso=0 if sairaalahoito1_puoliso==. & j!=.
egen help_var_puoliso=max(apusairaala_puoliso), by (s)
replace help_var_puoliso=0 if help_var_puoliso==. & j!=.
gen eventcovid_after_sairaala_puol=eventcovid_puoliso if help_var_puoliso==1
gen apuhosp_puoliso=apusairaala_puoliso
replace apuhosp_puoliso=1 if time>=eventcovid_after_sairaala_puol & c_timetoeventweeks>0
replace apuhosp_puoliso=0 if c_timetoeventweeks<0 & j!=.
egen sairaala_kumul_puoliso=max(apuhosp_puoliso), by (s c_timetoeventweeks)
replace sairaala_kumul_puoliso=0 if sairaala_kumul_puoliso==. & j!=.
gen vuosi=year(time)

** Replace vaccination variable with zero for those who do not have a vaccination.
replace covid_rokote_hilmo=0 if covid_rokote_hilmo==.

** Create a variable which describes the amount of days between the first and the second dose.
egen annos_erotus=min(erotus), by (s)
egen rokotettu=max(covid_rokote_hilmo), by(s)
replace rokotettu=0 if rokotettu==.

** Summary statistics
bys s: gen k=_n
egen ammatti=min(professioncode82020), by (s)
egen syntymavuosi=min(syntyv), by (s)

** We focus only for working age population
drop if syntymavuosi==2011 | syntymavuosi==2009 | syntymavuosi==2008 | syntymavuosi==2007
drop if syntymavuosi<=1946

** Summaries
tab ammatti if k==1 & rokotettu==1
tab ammatti if k==1 & rokotettu==0
sum syntymavuosi if k==1 & rokotettu==1, d
sum syntymavuosi if k==1 & rokotettu==0, d
tab covid_puoliso if k==1 & rokotettu==0
tab covid_puoliso if k==1 & rokotettu==1
destring sukup, generate(sukup_n)
egen sukupuoli=min(sukup_n), by (s)
tab sukupuoli if k==1 & rokotettu==1
tab sukupuoli if k==1 & rokotettu==0
destring kunta, generate(kunta_n)
egen kunta_o=min(kunta_n), by (s)
destring mkunta, generate(mkunta_n)
egen mkunta_o=min(mkunta_n), by (s)
destring syntyp2, generate(syntyp2_n)
egen syntyp2_o=min(syntyp2_n), by (s)
egen pekoko_o=min(pekoko_k), by (s)
egen akoko_o=min(akoko_k), by (s)
destring kuntaryhm31_12, generate(kuntaryhma)
egen alue=min(kuntaryhma), by (s)

* Renaming variables
rename syntyv syntyv_paahenkilo
rename sukup sukup_paahenkilo
rename shnro shnro_paahenkilo
rename kunta kunta_paahenkilo
rename mkunta mkunta_paahenkilo
rename syntyp2 syntyp2_paahenkilo
rename pekoko_k pekoko_k_paahenkilo
rename akoko_k akoko_k_paahenkilo
rename kuntaryhm31_12 kuntaryhm31_12_paahenkilo
rename shnro_puoliso shnro
merge m:1 shnro using jpfolk2019, keepusing(syntyv sukup kunta mkunta kuntaryhm31_12 syntyp2 pekoko_k akoko_k) generate(_merge19)
drop if _merge19==2
rename kunta kunta_puoliso
rename mkunta mkunta_puoliso
rename sukup sukup_puoliso
rename kuntaryhm31_12 kuntaryhm31_12_puoliso
rename syntyp2 syntyp2_puoliso
rename pekoko_k pekoko_k_puoliso
rename akoko_k akoko_k_puoliso
destring sukup_puoliso, generate(sukup_puoliso_n)
egen sukupuoli_puoliso=min(sukup_puoliso_n), by (s)
tab sukupuoli_puoliso if k==1 & rokotettu==1
tab sukupuoli_puoliso if k==1 & rokotettu==0
rename syntyv syntyv_puoliso
egen syntymavuosi_puoliso=min(syntyv_puoliso), by (s)
tab syntymavuosi_puoliso if k==1
destring kunta_puoliso, generate(kunta_puoliso_n)
egen kunta_puoliso_o=min(kunta_puoliso_n), by (s)
destring mkunta_puoliso, generate(mkunta_puoliso_n)
egen mkunta_puoliso_o=min(mkunta_puoliso_n), by (s)
destring syntyp2_puoliso, generate(syntyp2_puoliso_n)
egen syntyp2_puoliso_o=min(syntyp2_puoliso_n), by (s)
egen pekoko_puoliso_o=min(pekoko_k_puoliso), by (s)
egen akoko_puoliso_o=min(akoko_k_puoliso), by (s)
destring kuntaryhm31_12_puoliso, generate(kuntaryhma_puoliso)
egen alue_puoliso=min(kuntaryhma_puoliso), by (s)
rename shnro shnro_puoliso
rename shnro_paahenkilo shnro
sum syntymavuosi_puoliso if k==1 & rokotettu==1,d
sum syntymavuosi_puoliso if k==1 & rokotettu==0,d

** Drop all the extra variables

drop kaynti_id_hilmo laakeaine_hilmo laakeaine_selite_hilmo laakepakkausnro_hilmo astra_hilmo moderna_hilmo rokotteet_hilmo pfizer_hilmo asiakas_kotimaa_hilmo asiakas_postinumero_hilmo asiakas_kotikunta_hilmo asiakas_sukupuoli_hilmo palveluntuottaja_yksikko_hilmo palveluntuottaja_hilmo hoidontarve_ajankohta_hilmo hta_ammatti_hilmo hta_ammattioikeus_hilmo hta_ensikaynti_hilmo hta_kiireellisyys_hilmo hta_luonne_hilmo hta_tulos_hilmo ajanvaraus_ajankohta_hilmo ajanvaraus_varattu_hilmo ajanvaraus_ammatti_hilmo ajanvaraus_ammattioikeus_hilmo ajanvaraus_yhteystapa_hilmo kaynti_palvelumuoto_hilmo kaynti_toteuttaja_hilmo kaynti_ammattioikeus_hilmo kaynti_ammatti_hilmo kaynti_erikoisala_hilmo kaynti_ensikaynti_hilmo kaynti_luonne_hilmo _merge2


** Collapse data into individual-week level
collapse week (max) treat (max) covid2 (max) covid1 (max) covid3  (max) covid1_puoliso (max) covid2_puoliso (max) covid3_puoliso (max) covid (max) apucovid (max) apucovid_puoliso (max) covid_puoliso event event1 random_event_day (max) covid_rokote_hilmo timetoeventweeks_calendar event_week week2 joulukuu_viikko annos_erotus ammatti syntymavuosi syntymavuosi_puoliso sukupuoli sukupuoli_puoliso kunta_o kunta_puoliso_o mkunta_o mkunta_puoliso_o syntyp2_o syntyp2_puoliso_o pekoko_o pekoko_puoliso_o akoko_o akoko_puoliso_o alue alue_puoliso (max) sairaala_kumul (max) sairaala_kumul_puoliso (max) sairaalahoito1 (max) sairaalahoito1_puoliso (max) hosp_admis (max) hosp_admis_puoliso, by (s c_timetoeventweeks)

** Create a variable, which describes a vaccination status
egen rokotettu=max(covid_rokote_hilmo), by(s)
replace rokotettu=0 if rokotettu==.

** Create a variable which determines time after event
gen after=1 if c_timetoeventweeks >=0
replace after=0 if after==.

** Create a variable which determines whether a random event comes before or after covid
gen covidennen=covid1 if c_timetoeventweeks<0
gen apu1=covidennen if covidennen==1
replace apu1=0 if apu1==.
egen tartuntaennenevent=max(apu1),by (s)

** Create a variable which determines whether a random event comes before or after covid for spouse
gen covidennen_puoliso=covid1_puoliso if c_timetoeventweeks<0
gen apu1_puoliso=covidennen_puoliso if covidennen_puoliso==1
replace apu1_puoliso=0 if apu1_puoliso==.
egen tartuntaennenevent_puoliso=max(apu1_puoliso),by (s)

** Create age variable
gen ika=2021-syntymavuosi
gen ika_nelio=ika*ika
gen ika_puoliso=2021-syntymavuosi_puoliso
gen ika_puoliso_nelio=ika_puoliso*ika_puoliso

** Family size has missing value for those who live alone. Replace missing values with one when variable akoko_k is 1 (variable describes how many persons live in the same house).
replace pekoko_o=1 if akoko_o==1
replace pekoko_o=akoko_o if pekoko_o==.
replace pekoko_o=5 if pekoko_o>=5 & pekoko_o!=.

** Code occupations from 5 digit into 3
tostring ammatti, generate(ammatti_s)
gen occup=substr(ammatti_s,1,3)
destring occup, generate(occup_n)

** Combine two non-native groups into one. syntyp2_o is a variable, which tells the origins of birth.
replace syntyp2_o=22 if syntyp2_o==21
replace syntyp2_o=11 if syntyp2_o==12
replace syntyp2_puoliso_o=11 if syntyp2_puoliso_o==12
replace syntyp2_puoliso_o=22 if syntyp2_puoliso_o==21

** There are 28 individuals who has spouse from another register, but family size is 1. We drop those form the analysis
replace covid3_puoliso=. if pekoko_o==1 & covid3_puoliso!=.

** Summary statistics
bys s: gen y=_n
egen covid_ylip=max(covid), by (s)
egen covid_ylip_puoliso=max(covid_puoliso), by (s)

** Healthcare workers
asdoc tab sukupuoli if y==1 & tartuntaennenevent==0 & rokotettu==1 & covid_ylip==1 & pekoko_o!=.
asdoc tab alue if y==1 & tartuntaennenevent==0 & rokotettu==1 & covid_ylip==1 & pekoko_o!=.
asdoc tab syntyp2_o if y==1 & tartuntaennenevent==0 & rokotettu==1 & covid_ylip==1 & pekoko_o!=.
asdoc tab pekoko_o if y==1 & tartuntaennenevent==0 & rokotettu==1 & covid_ylip==1 & pekoko_o!=.
asdoc tab sukupuoli if y==1 & tartuntaennenevent==0 & rokotettu==0 & covid_ylip==1 & pekoko_o!=.
asdoc tab pekoko_o if y==1 & tartuntaennenevent==0 & rokotettu==0 & covid_ylip==1 & pekoko_o!=.
asdoc tab syntyp2_o if y==1 & tartuntaennenevent==0 & rokotettu==0 & covid_ylip==1 & pekoko_o!=.
asdoc tab alue if y==1 & tartuntaennenevent==0 & rokotettu==0 & covid_ylip==1 & pekoko_o!=.

** Partners
asdoc tab sukupuoli_puoliso if y==1 & tartuntaennenevent==0 & rokotettu==1 & covid_ylip_puoliso==1 & pekoko_o!=. & tartuntaennenevent_puoliso==0
asdoc tab pekoko_o if y==1 & tartuntaennenevent==0 & rokotettu==1 & covid_ylip_puoliso==1 & pekoko_o!=. & tartuntaennenevent_puoliso==0
asdoc tab syntyp2_puoliso_o if y==1 & tartuntaennenevent==0 & rokotettu==1 & covid_ylip_puoliso==1 & pekoko_o!=. & tartuntaennenevent_puoliso==0
asdoc tab alue if y==1 & tartuntaennenevent==0 & rokotettu==1 & covid_ylip_puoliso==1 & pekoko_o!=. & tartuntaennenevent_puoliso==0
asdoc tab sukupuoli_puoliso if y==1 & tartuntaennenevent==0 & rokotettu==0 & covid_ylip_puoliso==1 & pekoko_o!=. & tartuntaennenevent_puoliso==0
asdoc tab pekoko_o if y==1 & tartuntaennenevent==0 & rokotettu==0 & covid_ylip_puoliso==1 & pekoko_o!=. & tartuntaennenevent_puoliso==0
asdoc tab syntyp2_puoliso_o if y==1 & tartuntaennenevent==0 & rokotettu==0 & covid_ylip_puoliso==1 & pekoko_o!=. & tartuntaennenevent_puoliso==0
asdoc tab alue if y==1 & tartuntaennenevent==0 & rokotettu==0 & covid_ylip_puoliso==1 & pekoko_o!=. & tartuntaennenevent_puoliso==0

** Save
save collapsed_fakeday_allcontrollit_2504,replace