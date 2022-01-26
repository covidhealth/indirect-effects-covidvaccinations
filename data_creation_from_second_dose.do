**This do-file creates a dataset where the event it calculated from second dose

use daydatarokotetutkimus_new, clear 
xtset s time

** Drop those who have vaccinated only once
egen annos_erotus=min(erotus), by (s)
gen toinenannos=1 if annos_erotus!=.
tab toinenannos
replace toinenannos=0 if toinenannos==.
tab toinenannos

** Create a variable, which gets value 1 if person is vaccinated (for each row within id)
egen kaksiannosta=max(toinenannos), by(s)
tab kaksiannosta
egen rokotettu=max(covid_rokote_hilmo), by(s)
replace rokotettu=0 if rokotettu==.
tab kaksiannosta if rokotettu==1
drop if rokotettu==1 & kaksiannosta==0

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

** This will keep observations after the second dose
replace rokotepvm_hilmo=. if c==1
replace covid_rokote_hilmo=. if c==1
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
floor((mdy(4,25,2021) - mdy(1,18,2021)+1) * runiform() + mdy(1,18,2021))
bys s: replace random_event_day = random_event_day[1]
gen time_to_fake_event = time - random_event_day
format random_event_day %td
sort s time

** Fake-event from the beginning of our time period. This is for robustness check
gen fake_event_joulukuu=td(27dec2020)
format fake_event_joulukuu %td

** Time to event in weeks**
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
gen event2=event_week
replace event2=tammikuu1_viikko if event_week==.
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
gen vuosi=year(time)

** Replace vaccination variable with zero for those who do not have a vaccination.
replace covid_rokote_hilmo=0 if covid_rokote_hilmo==.

** Create a variable which describes the amount of days between the first and the second dose.
egen annos_erotus_n=min(erotus), by (s)
egen rokotettu_n=max(covid_rokote_hilmo), by(s)
replace rokotettu_n=0 if rokotettu_n==.

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

** Modify
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

** Renames
rename syntyv syntyv_paahenkilo
rename sukup sukup_paahenkilo
rename shnro shnro_paahenkilo
rename kunta kunta_paahenkilo
rename mkunta mkunta_paahenkilo
rename syntyp2 syntyp2_paahenkilo
rename pekoko_k pekoko_k_paahenkilo
rename akoko_k akoko_k_paahenkilo
rename kuntaryhm31_12 kuntaryhm31_12_paahenkilo

** Renames
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

** Modify
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

** Renames
rename shnro shnro_puoliso
rename shnro_paahenkilo shnro
sum syntymavuosi_puoliso if k==1 & rokotettu==1,d
sum syntymavuosi_puoliso if k==1 & rokotettu==0,d

** Collapse data into individual-week level
collapse week (max) treat (max) covid2 (max) covid1 (max) covid3  (max) covid1_puoliso (max) covid2_puoliso (max) covid3_puoliso (max) covid (max) apucovid (max) apucovid_puoliso (max) covid_puoliso event event1 event2 event5 event3 event4 random_event_day (max) covid_rokote_hilmo timetoeventweeks_calendar event_week week2 joulukuu_viikko tammikuu1_viikko tammikuu2_viikko helmikuu_viikko annos_erotus ammatti syntymavuosi syntymavuosi_puoliso sukupuoli sukupuoli_puoliso kunta_o kunta_puoliso_o mkunta_o mkunta_puoliso_o syntyp2_o syntyp2_puoliso_o pekoko_o pekoko_puoliso_o akoko_o akoko_puoliso_o alue alue_puoliso , by (s c_timetoeventweeks)

** Create a variable, which describes a vaccination status (again)
egen rokotettu=max(covid_rokote_hilmo), by(s)
replace rokotettu=0 if rokotettu==.

** Create a variable which determines time after event.
gen after=1 if c_timetoeventweeks >=0
replace after=0 if after==.

** Create a variable which determines whether a random event comes before or after covid
gen covidennen=covid1 if c_timetoeventweeks<0
gen apu1=covidennen if covidennen==1
replace apu1=0 if apu1==.
egen tartuntaennenevent=max(apu1),by (s)


** Family size has missing value for those who live alone. replace missing values with one when variable akoko_k is 1 (variable describes how many persons live in the same house).
replace pekoko_o=1 if akoko_o==1
replace pekoko_o=akoko_o if pekoko_o==.
replace pekoko_o=5 if pekoko_o>=5 & pekoko_o!=.

** Code occupations from 5 digit into 3
tostring ammatti, generate(ammatti_s)
gen occup=substr(ammatti_s,1,3)
destring occup, generate(occup_n)

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

** Combine two non-native groups into one. syntyp2_o is a variable, which tells the origins of birth.
replace syntyp2_o=22 if syntyp2_o==21
replace syntyp2_o=11 if syntyp2_o==12
replace syntyp2_puoliso_o=11 if syntyp2_puoliso_o==12
replace syntyp2_puoliso_o=22 if syntyp2_puoliso_o==21

** There are 28 individuals who has spouse from another register, but family size is 1. We drop those form the analysis
replace covid3_puoliso=. if pekoko_o==1 & covid3_puoliso!=.

save collapsed_fakeday_allcontrollit_2504_from2nddose,replace