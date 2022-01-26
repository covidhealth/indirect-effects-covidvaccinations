* This do file plots the weekly infections for treatment and control groups as well as the cumulative number of cases per week


***********************************************************

* Healthcare workers

use collapsed_fakeday_allcontrollit_2504, clear

** Keep at t=0 and if no previous infection and all variables available
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0
keep if pekoko_o!=.

** Aggregate
collapse(sum) covid3, by(c_timetoeventweeks rokotettu)

** Generate groups for unvaccinate and vaccinated, censor cells with less than five observations
gen covid_vaxd= covid3 if rokotettu==1
replace covid_vaxd=0 if covid_vaxd<5
gen covid_nonvaxd = covid3 if rokotettu==0
replace covid_nonvaxd=0 if covid_nonvaxd<5

** Table with infections
export excel using "infections_by_group_week_21221.xlsx", sheet("HCW")

** Graph
graph bar (sum) covid_nonvaxd covid_vaxd if c_timetoeventweeks<13, over(c_timetoeventweeks) ysc(r(0 800)) ylabel(0 (200) 800) bar(1, color("black") lcolor("black")) bar(2, color("white") lcolor("black")) legend(label(1 "Unvaccinated") label(2 "Vaccinated")) ytitle("Total number of infections") b1title("Follow-up week", size(medsmall)) graphregion(color(white)) title("a", position(11))

***********************************************************

* Spouses

use collapsed_fakeday_allcontrollit_2504, clear

** Keep at t=0 and if no previous infection and all variables available
keep if c_timetoeventweeks>=0 & tartuntaennenevent_puoliso==0 & tartuntaennenevent==0
keep if pekoko_o!=.
keep if pekoko_puoliso_o!=.

** Aggregate
collapse(sum) covid3_puoliso, by(c_timetoeventweeks rokotettu)

** Generate groups for unvaccinate and vaccinated, censor cells with less than five observations
gen covid_vaxd= covid3_puoliso if rokotettu==1
replace covid_vaxd=0 if covid_vaxd<5
gen covid_nonvaxd = covid3_puoliso if rokotettu==0
replace covid_nonvaxd=0 if covid_nonvaxd<5

** Table with infections
export excel using "infections_by_group_week_21221.xlsx", sheet("Spouses")

** Graph
graph bar (sum) covid_nonvaxd covid_vaxd if c_timetoeventweeks<13, over(c_timetoeventweeks) ysc(r(0 800)) ylabel(0 (200) 800) bar(1, color("black") lcolor("black")) bar(2, color("white") lcolor("black")) legend(label(1 "Unvaccinated") label(2 "Vaccinated")) ytitle("Total number of infections") b1title("Follow-up week", size(medsmall)) graphregion(color(white)) title("b", position(11))

***********************************************************

* Children 3-12

use collapsed_fakeday_allcontrollit_2504_lapset, clear

** Keep at t=0 and if no previous infection and all variables available
keep if c_timetoeventweeks>=0 & tartuntaennenevent_lapsi==0 & tartuntaennenevent==0
keep if pekoko_o!=.

** Age group
keep if ika_lapsi>2 & ika_lapsi<13

** Aggregate
collapse(sum) covid3_lapsi, by(c_timetoeventweeks rokotettu)

** Generate groups for unvaccinate and vaccinated, censor cells with less than five observations
gen covid_vaxd= covid3_lapsi if rokotettu==1
replace covid_vaxd=0 if covid_vaxd<5
gen covid_nonvaxd = covid3_lapsi if rokotettu==0
replace covid_nonvaxd=0 if covid_nonvaxd<5

** Table with infections
export excel using "infections_by_group_week_21221.xlsx", sheet("Kids 3-12")

** Graph
graph bar (sum) covid_nonvaxd covid_vaxd if c_timetoeventweeks<13, over(c_timetoeventweeks) ysc(r(0 400)) ylabel(0 (200) 400) bar(1, color("black") lcolor("black")) bar(2, color("white") lcolor("black")) legend(label(1 "Unvaccinated") label(2 "Vaccinated")) ytitle("Total number of infections") b1title("Follow-up week", size(medsmall)) title("c", position(11)) graphregion(color(white)) 

***********************************************************

* Children 13-18

use collapsed_fakeday_allcontrollit_2504_lapset, clear

** Keep at t=0 and if no previous infection and all variables available
keep if c_timetoeventweeks>=0 & tartuntaennenevent_lapsi==0 & tartuntaennenevent==0
keep if pekoko_o!=.

** Age group
keep if ika_lapsi>12 & ika_lapsi<19

** Aggregate
collapse(sum) covid3_lapsi, by(c_timetoeventweeks rokotettu)

** Generate groups for unvaccinate and vaccinated, censor cells with less than five observations
gen covid_vaxd= covid3_lapsi if rokotettu==1
replace covid_vaxd=0 if covid_vaxd<5
gen covid_nonvaxd = covid3_lapsi if rokotettu==0
replace covid_nonvaxd=0 if covid_nonvaxd<5

** Table with infections
export excel using "infections_by_group_week_21221.xlsx", sheet("Kids 13-18")

** Graph
graph bar (sum) covid_nonvaxd covid_vaxd if c_timetoeventweeks<13, over(c_timetoeventweeks) ysc(r(0 400)) ylabel(0 (200) 400) bar(1, color("black") lcolor("black")) bar(2, color("white") lcolor("black")) legend(label(1 "Unvaccinated") label(2 "Vaccinated")) ytitle("Total number of infections") b1title("Follow-up week", size(medsmall)) title("d", position(11)) graphregion(color(white)) 

