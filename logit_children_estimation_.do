* This do file creates the logit model estimations for children

clear 

* Kids overall 

use collapsed_fakeday_allcontrollit_2504_children, clear

** Regression pooled for weeks 2-5
glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek>1 & c_timetoeventweek<6 
estimates store c_timetoeventweek2

** Regressions for weeks from 6 and on
forvalues i = 6/12 {
	glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek == `i'
	estimates store c_timetoeventweek`i'
	
}

** Plot
coefplot (c_timetoeventweek2, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek6, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek7, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek8, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek9, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek10, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek11, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek12, transform (1.rokotettu = (1-exp(@))*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
xlabel(1 "2-5" 2 "6" 3 "7" 4 "8" 5 "9" 6 "10" 7 "11" 8 "12") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)


**********************************************************************************************

* Aged 3-12

** Regression pooled for weeks 2-5
glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek>1 & c_timetoeventweek<6 & syntymavuosi_lapsi>2008
estimates store c_timetoeventweek2

** Regressions for weeks from 6 and on
forvalues i = 6/12 {
	glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek == `i' & syntymavuosi_lapsi>2008
	estimates store c_timetoeventweek`i'
	
}

** Plot
coefplot (c_timetoeventweek2, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek6, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek7, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek8, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek9, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek10, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek11, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek12, transform (1.rokotettu = (1-exp(@))*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
xlabel(1 "2-5" 2 "6" 3 "7" 4 "8" 5 "9" 6 "10" 7 "11" 8 "12") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)


**********************************************************************************************

* Aged 13-18

** Regression pooled for weeks 2-5
glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek>1 & c_timetoeventweek<6 & syntymavuosi_lapsi<=2008
estimates store c_timetoeventweek2

** Regressions for weeks from 6 and on
forvalues i = 6/12 {
	glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent==0 & tartuntaennenevent_lapsi==0 & c_timetoeventweek == `i' & syntymavuosi_lapsi<=2008
	estimates store c_timetoeventweek`i'
	
}

** Plot
coefplot (c_timetoeventweek2, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek6, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek7, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek8, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek9, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek10, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek11, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek12, transform (1.rokotettu = (1-exp(@))*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
xlabel(1 "2-5" 2 "6" 3 "7" 4 "8" 5 "9" 6 "10" 7 "11" 8 "12") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)
