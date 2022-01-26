* This do file creates the descriptive statistics

** Mean ages

* HWCs and spouses

use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks==0 & tartuntaennenevent==0
keep if pekoko_o!=.
summarize ika 

* Spouses
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks==0 & tartuntaennenevent_puoliso==0 & tartuntaennenevent==0
keep if pekoko_o!=.
summarize ika_puoliso
tab rokotettu if rokotettu!=. & covid1_puoliso!=.

* Children
use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks==0 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
keep if pekoko_o!=.
summarize ika_lapsi


** Total infections

* HCWs
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0
keep if pekoko_o!=.
collapse(sum) covid1, by(s)
sort covid1
count if covid1==1
tab covid1 if covid1!=.

* Spouses
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
keep if pekoko_o!=.
keep if covid1_puoliso==0 | covid1_puoliso==1
collapse(sum) covid1_puoliso, by(s)
count if covid1_puoliso==1
tab covid1_puoliso if covid1_puoliso!=.

* Children
use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0
keep if pekoko_o!=.
keep if covid1_lapsi==0 | covid1_lapsi==1
collapse(sum) covid1_lapsi, by(la)
count if covid1_lapsi==1
tab covid1_lapsi if covid1_lapsi!=.

************************************************************************************

* HCW descriptive stats for summary table 4

use collapsed_fakeday_allcontrollit_2504, clear

keep if c_timetoeventweeks==0 & tartuntaennenevent==0
keep if pekoko_o!=.

** Number and share in sample
tab occup

** Age
summarize ika if occup=="532"
summarize ika if occup=="322"
summarize ika if occup=="221"
summarize ika if occup=="226"
summarize ika if occup=="222"

** Gender
tab sukupuoli if occup=="532"
tab sukupuoli if occup=="322"
tab sukupuoli if occup=="221"
tab sukupuoli if occup=="226"
tab sukupuoli if occup=="222"

** 1st vaccine
tab rokotettu if occup=="532"
tab rokotettu if occup=="322"
tab rokotettu if occup=="221"
tab rokotettu if occup=="226"
tab rokotettu if occup=="222"

** 2nd vaccine
gen tokaannoscheck=annos_erotus!=.
tabulate tokaannoscheck occup, column


************************************************************************************

* Descriptive statistics by vaccination status for tables 2 and 3

* HWCs and spouses
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks==0 & tartuntaennenevent==0 & pekoko_o!=.

** Age
summarize ika if rokotettu==1
summarize ika if rokotettu==0
summarize ika_puoliso if rokotettu==1
summarize ika_puoliso if rokotettu==0

** Sex
tab sukupuoli if rokotettu==1
tab sukupuoli if rokotettu==0
tab sukupuoli_puoliso if rokotettu==1
tab sukupuoli_puoliso if rokotettu==0

** Group 
replace pekoko_puoliso_o=5 if pekoko_puoliso_o>5 & pekoko_puoliso_o!=.
replace syntyp2_o=11 if syntyp2_o==12
replace syntyp2_o=21 if syntyp2_o==22

** By vaccination status == 1
summarize ika if rokotettu==1
tab sukupuoli if rokotettu==1
tab pekoko_o if rokotettu==1
tab syntyp2_o if rokotettu==1
tab alue if rokotettu==1

** By vaccination status == 0
summarize ika if rokotettu==0
tab sukupuoli if rokotettu==0
tab pekoko_o if rokotettu==0
tab syntyp2_o if rokotettu==0
tab alue if rokotettu==0

* Spouse descriptive stats by vaccination status: age, gender, family size, origin, rural
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks==0 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0 & pekoko_o!=.
keep if tartuntaennenevent_puoliso==0
keep if pekoko_puoliso_o!=.

** Uniform labels for origin
replace syntyp2_puoliso_o=11 if syntyp2_puoliso_o==12
replace syntyp2_puoliso_o=21 if syntyp2_puoliso_o==22
keep if pekoko_puoliso_o!=.

** Vaccinated
summarize ika_puoliso if rokotettu==1
tab sukupuoli_puoliso if rokotettu==1
tab pekoko_puoliso_o if rokotettu==1
tab syntyp2_puoliso_o if rokotettu==1
tab alue_puoliso if rokotettu==1

** Unvaccinated
summarize ika_puoliso if rokotettu==0
tab sukupuoli_puoliso if rokotettu==0
tab pekoko_puoliso_o if rokotettu==0
tab syntyp2_puoliso_o if rokotettu==0
tab alue_puoliso if rokotettu==0


* Child descriptive stats by vaccination status: age, gender, family size, origin, rural

** Over all
use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks==0
keep if tartuntaennenevent_lapsi==0
keep if tartuntaennenevent==0
keep if pekoko_o!=.

** Age group
keep if ika_lapsi>2 & ika_lapsi<19

** Uniform labels for origin
replace syntyp2_lapsi_o=11 if syntyp2_lapsi_o==12
replace syntyp2_lapsi_o=21 if syntyp2_lapsi_o==22

** Vaccinated
summarize ika_lapsi if rokotettu==1
tab sukupuoli_lapsi if rokotettu==1
tab pekoko_lapsi_o if rokotettu==1
tab syntyp2_lapsi_o if rokotettu==1
tab alue_lapsi if rokotettu==1

** Unvaccinated
summarize ika_lapsi if rokotettu==0
tab sukupuoli_lapsi if rokotettu==0
tab pekoko_lapsi_o if rokotettu==0
tab syntyp2_lapsi_o if rokotettu==0
tab alue_lapsi if rokotettu==0

* Kids 3-12

** Child descriptive stats by vaccination status: age, gender, family size, origin, rural
use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks==0
keep if tartuntaennenevent_lapsi==0
keep if tartuntaennenevent==0
keep if pekoko_o!=.

** Age group
keep if ika_lapsi>2 & ika_lapsi<13

** Uniform labels for origin
replace syntyp2_lapsi_o=11 if syntyp2_lapsi_o==12
replace syntyp2_lapsi_o=21 if syntyp2_lapsi_o==22

** Vaccinated
summarize ika_lapsi if rokotettu==1
tab sukupuoli_lapsi if rokotettu==1
tab pekoko_lapsi_o if rokotettu==1
tab syntyp2_lapsi_o if rokotettu==1
tab alue_lapsi if rokotettu==1

** Unvaccinated
summarize ika_lapsi if rokotettu==0
tab sukupuoli_lapsi if rokotettu==0
tab pekoko_lapsi_o if rokotettu==0
tab syntyp2_lapsi_o if rokotettu==0
tab alue_lapsi if rokotettu==0

* Kids 13-18

use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks==0
keep if tartuntaennenevent_lapsi==0
keep if tartuntaennenevent==0
keep if pekoko_o!=.

** Age group
keep if ika_lapsi>12 & ika_lapsi<19

** Uniform labels for origin
replace syntyp2_lapsi_o=11 if syntyp2_lapsi_o==12
replace syntyp2_lapsi_o=21 if syntyp2_lapsi_o==22

** Vaccinated
summarize ika_lapsi if rokotettu==1
tab sukupuoli_lapsi if rokotettu==1
tab pekoko_lapsi_o if rokotettu==1
tab syntyp2_lapsi_o if rokotettu==1
tab alue_lapsi if rokotettu==1

** Unvaccinated
summarize ika_lapsi if rokotettu==0
tab sukupuoli_lapsi if rokotettu==0
tab pekoko_lapsi_o if rokotettu==0
tab syntyp2_lapsi_o if rokotettu==0
tab alue_lapsi if rokotettu==0