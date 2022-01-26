* This do file creates the logit model estimations for children from the second dose

* Kids overall

clear 

use collapsed_fakeday_allcontrollit_2504_children_from2nddose, clear

** Regressions pooled for weeks 2-5
glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek>1 & c_timetoeventweek<6 
estimates store c_timetoeventweek2

** Regressions for week 6 and on
forvalues i = 6/8 {
	glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek == `i'
	estimates store c_timetoeventweek`i'
	
}

** Plot
coefplot (c_timetoeventweek2, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek6, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek7, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek8, transform (1.rokotettu = (1-exp(@))*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
xlabel(1 "2-5" 2 "6" 3 "7" 4 "8") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)


********************************************************************************

* Kids 3-12

** Regressions pooled for weeks 2-5
glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek>1 & c_timetoeventweek<6 & syntymavuosi_lapsi>2008
estimates store c_timetoeventweek2

** Regressions for week 6 and on
forvalues i = 6/8 {
	glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek == `i' & syntymavuosi_lapsi>2008
	estimates store c_timetoeventweek`i'
	
}

** Plot
coefplot (c_timetoeventweek2, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek6, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek7, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek8, transform (1.rokotettu = (1-exp(@))*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
xlabel(1 "2-5" 2 "6" 3 "7" 4 "8") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)


********************************************************************************

* Kids 13-18

** Regressions pooled for weeks 2-5
glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek>1 & c_timetoeventweek<6 & syntymavuosi_lapsi<=2008
estimates store c_timetoeventweek2

** Regressions for week 6 and on
forvalues i = 6/8 {
	glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek == `i' & syntymavuosi_lapsi<=2008
	estimates store c_timetoeventweek`i'
	
}

** Plot
coefplot (c_timetoeventweek2, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek6, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek7, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek8, transform (1.rokotettu = (1-exp(@))*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
xlabel(1 "2-5" 2 "6" 3 "7" 4 "8") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)


