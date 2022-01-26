* This do-file creates a dataset where the event it calculated from second dose

use daydatarokotetutkimuschildren_new, clear 

** Get the covid info for children
merge m:1 la time using lastenkoronat_new, keepusing(covid_lapsi sairaalahoito_lapsi paivamaaratilasto_lapsi id_lapsi) generate(_merge1)
drop if time<=22275
xtset la time
rename id id_paahenkilo
egen parentid=min(s), by(la)
rename s s_paahenkilo
rename parentid s

** Get the covid info
merge m:1 s time using hoitohklcovidrokotetut+ei-rokotetut_new, keepusing(covid id paivamaaratilasto sairaalahoito) generate(_merge12)
drop if _merge12==2
xtset la time

**Drop those who have vaccinated only once
egen annos_erotus=min(erotus), by (la)
gen toinenannos=1 if annos_erotus!=.
tab toinenannos
replace toinenannos=0 if toinenannos==.
tab toinenannos

** Create a variable, which gets value 1 if person is vaccinated (for each row within id)
egen kaksiannosta=max(toinenannos), by(la)
tab kaksiannosta
egen rokotettu1=max(covid_rokote_hilmo), by(s)
replace rokotettu1=0 if rokotettu1==.
tab kaksiannosta if rokotettu1==1
drop if rokotettu1==1 & kaksiannosta==0

** Create a covid variable, which gets value 1 in the panel after covid occurs. Otherwise 0.
g apucovid=covid
replace apucovid=0 if apucovid==.
egen eventcovid=min(paivamaaratilasto),by (s)
format eventcovid %td
replace covid=1 if time>=eventcovid
replace covid=0 if time<eventcovid

** Create a covid variable for children, which gets value 1 in the panel after covid occurs. Otherwise 0.
g apucovid_lapsi=covid_lapsi
replace apucovid_lapsi=0 if apucovid_lapsi==.
egen eventcovid_lapsi=min(paivamaaratilasto_lapsi),by (la)
format eventcovid_lapsi %td
replace covid_lapsi=1 if time>=eventcovid_lapsi
replace covid_lapsi=0 if time<eventcovid_lapsi

** Create event variable

** This will keep observations after the second dose
replace rokotepvm_hilmo=. if u==1
replace covid_rokote_hilmo=. if u==1

egen event=min(rokotepvm_hilmo),by (la)
format event %td

** Delete those who get covid before vaccinated, first children
bys la: gen differenssi_lapsi= event- eventcovid_lapsi
drop if differenssi_lapsi>0 & differenssi_lapsi!=.
rename eventcovid eventcovid_paahenkilo

** Healthcare worker
gen differenssi_paahenkilo= event- eventcovid_paahenkilo
drop if differenssi_paahenkilo>0 & differenssi_paahenkilo!=.
gen treat=0
replace treat=1 if time>event
order s time event treat
gen timetoevent= time-event

** Generate random event day
generate random_event_day = ///
floor((mdy(4,25,2021) - mdy(1,18,2021)+1) * runiform() + mdy(1,18,2021))
bys la: replace random_event_day = random_event_day[1]
gen time_to_fake_event = time - random_event_day
format random_event_day %td
sort la time

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
gen help1=apucovid
egen eventcovid_after_paahenkilo=min(paivamaaratilasto) if c_timetoeventweeks>0 ,by (s)
format eventcovid_after %td
replace help1=1 if time>=eventcovid_after_paahenkilo & c_timetoeventweeks>0
replace help1=0 if c_timetoeventweeks<0
egen covid3=max(help1), by (s c_timetoeventweeks)
replace covid3=0 if covid3==.

** Create all the same covid variables (covid1, covid2, covid3) for children
egen covid1_lapsi=max(apucovid_lapsi), by (la c_timetoeventweeks)
replace covid1_lapsi=0 if covid1_lapsi==.
egen covid2_lapsi=max(covid_lapsi), by (la c_timetoeventweeks)
replace covid2_lapsi=0 if covid2_lapsi==.

** Cumulative covid, so that the time starts from the event
gen apu4=apucovid_lapsi
egen eventcovid_after=min(paivamaaratilasto_lapsi) if c_timetoeventweeks>0 ,by (la)
format eventcovid_after %td
replace apu4=1 if time>=eventcovid_after & c_timetoeventweeks>0
replace apu4=0 if c_timetoeventweeks<0
egen covid3_lapsi=max(apu4), by (la c_timetoeventweeks)
replace covid3_lapsi=0 if covid3_lapsi==.
gen vuosi=year(time)

** Replace vaccination variable with zero for those who do not have a vaccination.
replace covid_rokote_hilmo=0 if covid_rokote_hilmo==.
egen annos_erotus_n=min(erotus), by (la)
egen rokotettu_n=max(covid_rokote_hilmo), by(la)
replace rokotettu_n=0 if rokotettu_n==.

** Summary statistics
bys la: gen k=_n
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
tab covid_lapsi if k==1 & rokotettu==0
tab covid_lapsi if k==1 & rokotettu==1

** Modify
destring sukup, generate(sukup_n)
egen sukupuoli=min(sukup_n), by (s)
tab sukupuoli if q==1 & rokotettu==1
tab sukupuoli if q==1 & rokotettu==0
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
rename shnro_lapsi shnro
merge m:1 shnro using jpfolk2019, keepusing(syntyv sukup kunta mkunta kuntaryhm31_12 syntyp2 pekoko_k akoko_k) generate(_merge19)
drop if _merge19==2
rename kunta kunta_lapsi
rename mkunta mkunta_lapsi
rename sukup sukup_lapsi
rename kuntaryhm31_12 kuntaryhm31_12_lapsi
rename syntyp2 syntyp2_lapsi
rename pekoko_k pekoko_k_lapsi
rename akoko_k akoko_k_lapsi

** Modify
destring sukup_lapsi, generate(sukup_lapsi_n)
egen sukupuoli_lapsi=min(sukup_lapsi_n), by (la)
tab sukupuoli_lapsi if q==1 & rokotettu==1
tab sukupuoli_lapsi if q==1 & rokotettu==0
rename syntyv syntyv_lapsi
egen syntymavuosi_lapsi=min(syntyv_lapsi), by (la)
tab syntymavuosi_lapsi if k==1
destring kunta_lapsi, generate(kunta_lapsi_n)
egen kunta_lapsi_o=min(kunta_lapsi_n), by (la)
destring mkunta_lapsi, generate(mkunta_lapsi_n)
egen mkunta_lapsi_o=min(mkunta_lapsi_n), by (la)
destring syntyp2_lapsi, generate(syntyp2_lapsi_n)
egen syntyp2_lapsi_o=min(syntyp2_lapsi_n), by (la)
egen pekoko_lapsi_o=min(pekoko_k_lapsi), by (la)
egen akoko_lapsi_o=min(akoko_k_lapsi), by (la)
destring kuntaryhm31_12_lapsi, generate(kuntaryhma_lapsi)
egen alue_lapsi=min(kuntaryhma_lapsi), by (la)

** Modify
rename shnro shnro_lapsi
rename shnro_paahenkilo shnro
sum syntymavuosi_lapsi if q==1 & rokotettu==1,d
sum syntymavuosi_lapsi if q==1 & rokotettu==0,d

** Collapse data into individual-week level
collapse week (max) treat (max) covid2 (max) covid1 (max) covid3  (max) covid1_lapsi (max) covid2_lapsi (max) covid3_lapsi (max) covid (max) apucovid (max) apucovid_lapsi (max) covid_lapsi event event1 event2 event5 event3 event4 random_event_day (max) covid_rokote_hilmo timetoeventweeks_calendar event_week week2 joulukuu_viikko tammikuu1_viikko tammikuu2_viikko helmikuu_viikko annos_erotus ammatti syntymavuosi syntymavuosi_lapsi sukupuoli sukupuoli_lapsi kunta_o kunta_lapsi_o mkunta_o mkunta_lapsi_o syntyp2_o syntyp2_lapsi_o pekoko_o pekoko_lapsi_o akoko_o akoko_lapsi_o alue alue_lapsi (max) s, by (la c_timetoeventweeks)

** Create a variable, which describes a vaccination status 
egen rokotettu=max(covid_rokote_hilmo), by(la)
replace rokotettu=0 if rokotettu==.

** Create a variable which determines time after event.
gen after=1 if c_timetoeventweeks >=0
replace after=0 if after==.

** Create a variable which determines whether a random event comes before or after covid
gen covidennen=covid1 if c_timetoeventweeks<0
gen apu1=covidennen if covidennen==1
replace apu1=0 if apu1==.
egen tartuntaennenevent=max(apu1),by (s)

** Create a variable which determines whether a random event comes before or after covid for children
gen covidennen_lapsi=covid1_lapsi if c_timetoeventweeks<0
gen apu1_lapsi=covidennen_lapsi if covidennen_lapsi==1
replace apu1_lapsi=0 if apu1_lapsi==.
egen tartuntaennenevent_lapsi=max(apu1_lapsi),by (la)

** Create age variable
gen ika=2021-syntymavuosi
gen ika_nelio=ika*ika
gen ika_lapsi=2021-syntymavuosi_lapsi
gen ika_lapsi_nelio=ika_lapsi*ika_lapsi

** Family size has missing value for those who live alone. replace missing values with one when variable akoko_k is 1 (variable describes how many persons live in the same house).
replace pekoko_o=1 if akoko_o==1
replace pekoko_o=akoko_o if pekoko_o==.
replace pekoko_lapsi_o=5 if pekoko_lapsi_o>=5 & pekoko_lapsi_o!=.
replace pekoko_o=5 if pekoko_o>=5 & pekoko_o!=.

** Code occupations from 5 digit into 3
tostring ammatti, generate(ammatti_s)
gen occup=substr(ammatti_s,1,3)
destring occup, generate(occup_n)

** Combine two non-native groups into one. syntyp2_o is a variable, which tells the origins of birth.
replace syntyp2_o=22 if syntyp2_o==21
replace syntyp2_o=11 if syntyp2_o==12
replace syntyp2_lapsi_o=11 if syntyp2_lapsi_o==12
replace syntyp2_lapsi_o=22 if syntyp2_lapsi_o==21

** Save 
save collapsed_fakeday_allcontrollit_2504_children_from2nddose,replace