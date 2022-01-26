* This do file plots the share of weekly infections for treatment and control groups as well as the share of cases per week

***********************************************************

* Healthcare workers
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0
keep if pekoko_o!=.
gen identifier=1
tabulate covid3 rokotettu if c_timetoeventweeks==12, column
save hcw, replace

** Weekly sample size
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0
keep if pekoko_o!=.
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)
save hcw, replace

** Keep t=0 and no previous infections, all info
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0
keep if pekoko_o!=.

** Aggregate
collapse(sum) covid3, by(c_timetoeventweeks rokotettu)

** Generate groups for unvaccinate and vaccinated, censor cells with less than five observations
gen covid_vaxd= covid3 if rokotettu==1
replace covid_vaxd=0 if covid_vaxd<5
gen covid_nonvaxd = covid3 if rokotettu==0
replace covid_nonvaxd=0 if covid_nonvaxd<5

** Get weekly sample size
merge m:1 c_timetoeventweeks rokotettu using hcw, keep(master match)

** Calculate shares
drop _merge
gen weekly_share_nonvaxd = (covid_nonvaxd / identifier)*100 if rokotettu==0
gen weekly_share_vaxd = (covid_vaxd / identifier)*100 if rokotettu==1

** Make table with shares by group and week
export excel using "relative_infections_by_group_week_21221.xlsx", sheet("HCW") replace

** Graph
graph bar (sum) weekly_share_nonvaxd weekly_share_vaxd if c_timetoeventweeks<13, over(c_timetoeventweeks) ysc(r(0 1.2)) ylabel(0 (0.2) 1.2) bar(1, color("black") lcolor("black")) bar(2, color("white") lcolor("black")) legend(label(1 "Unvaccinated") label(2 "Vaccinated")) ytitle("Share (%) of infections") b1title("Follow-up week", size(medsmall)) graphregion(color(white)) title("a", position(11)) 

***********************************************************

* Spouses

** Weekly sample size
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent_puoliso==0 & tartuntaennenevent==0
keep if pekoko_o!=.
keep if covid1_puoliso==0 | covid1_puoliso==1
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)
save spouses, replace

** Keep t=0 and no previous infections
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent_puoliso==0 & tartuntaennenevent==0
keep if pekoko_o!=.

** Aggregate
collapse(sum) covid3_puoliso, by(c_timetoeventweeks rokotettu)

** Generate groups for unvaccinate and vaccinated, censor cells with less than five observations
gen covid_vaxd= covid3_puoliso if rokotettu==1
replace covid_vaxd=0 if covid_vaxd<5
gen covid_nonvaxd = covid3_puoliso if rokotettu==0
replace covid_nonvaxd=0 if covid_nonvaxd<5

** Get weekly sample size
merge m:1 c_timetoeventweeks rokotettu using spouses, keep(master match)

** Calculate shares
drop _merge
gen weekly_share_nonvaxd = (covid_nonvaxd / identifier)*100 if rokotettu==0
gen weekly_share_vaxd = (covid_vaxd / identifier)*100 if rokotettu==1

** Make table with shares by group and week
export excel using "relative_infections_by_group_week_21221.xlsx", sheet("Spouses") replace

** Graph
graph bar (sum) weekly_share_nonvaxd weekly_share_vaxd if c_timetoeventweeks<13, over(c_timetoeventweeks) ysc(r(0 1.2)) ylabel(0 (0.2) 1.2) bar(1, color("black") lcolor("black")) bar(2, color("white") lcolor("black")) legend(label(1 "Unvaccinated") label(2 "Vaccinated")) ytitle("Share of infections") b1title("Follow-up week", size(medsmall)) graphregion(color(white)) title("b", position(11)) 

***********************************************************

* Children 3-12

** Weekly sample size
use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
keep if pekoko_o!=.
keep if ika_lapsi>2 & ika_lapsi<13
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)
save kids312, replace

** Keep t=0 and no previous infections
use collapsed_fakeday_allcontrollit_2504_lapset, clear
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

** Get weekly sample size
merge m:1 c_timetoeventweeks rokotettu using kids312, keep(master match)

** Calculate shares
drop _merge
gen weekly_share_nonvaxd = (covid_nonvaxd / identifier)*100 if rokotettu==0
gen weekly_share_vaxd = (covid_vaxd / identifier)*100 if rokotettu==1

** Make table with shares by group and week
export excel using "relative_infections_by_group_week_21221.xlsx", sheet("Kids 3-12")

** Graph
graph bar (sum) weekly_share_nonvaxd weekly_share_vaxd if c_timetoeventweeks<13, over(c_timetoeventweeks) ysc(r(0 1)) ylabel(0 (0.2) 1) bar(1, color("black") lcolor("black")) bar(2, color("white") lcolor("black")) legend(label(1 "Unvaccinated") label(2 "Vaccinated")) ytitle("Share of infections") b1title("Follow-up week", size(medsmall)) title("c", position(11)) graphregion(color(white))

***********************************************************

* Children 13-18

** Weekly sample size
use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
keep if pekoko_o!=.
keep if ika_lapsi>12 & ika_lapsi<19
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)
save kids1318, replace

** Keep t=0 and no previous infections
use collapsed_fakeday_allcontrollit_2504_lapset, clear
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

** Get weekly sample size
merge m:1 c_timetoeventweeks rokotettu using kids1318, keep(master match)

** Calculate shares
drop _merge
gen weekly_share_nonvaxd = (covid_nonvaxd / identifier)*100 if rokotettu==0
gen weekly_share_vaxd = (covid_vaxd / identifier)*100 if rokotettu==1

** Make table with shares by group and week
export excel using "relative_infections_by_group_week_21221.xlsx", sheet("Kids 13-18")

** Graph
graph bar (sum) weekly_share_nonvaxd weekly_share_vaxd if c_timetoeventweeks<13, over(c_timetoeventweeks) ysc(r(0 1)) ylabel(0 (0.2) 1) bar(1, color("black") lcolor("black")) bar(2, color("white") lcolor("black")) legend(label(1 "Unvaccinated") label(2 "Vaccinated")) ytitle("Share of infections") b1title("Follow-up week", size(medsmall)) title("d", position(11)) graphregion(color(white))