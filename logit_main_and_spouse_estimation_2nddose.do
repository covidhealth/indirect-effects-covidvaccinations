* This do file creates the logit model estimations for the healthcare workers and the partners from the second dose

clear

********************************************************************************

* Healthcare workers

use collapsed_fakeday_allcontrollit_2504_from2nddose, clear

** Regressions
forvalues i = 2/8 {
	glm covid3 i.rokotettu i.week ika ika_nelio i.sukupuoli i.syntyp2_o i.alue i.pekoko_o i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent ==0 & c_timetoeventweek == `i' 
	estimates store c_timetoeventweek`i'
	
}

** Plot
coefplot (c_timetoeventweek2, transform (1.rokotettu = (1-exp(@))*100))  ///
|| (c_timetoeventweek3, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek4, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek5, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek6, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek7, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek8, transform (1.rokotettu = (1-exp(@))*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
xlabel(1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" ) xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) yscale(range(0 100)) ///
graphregion(color(white)) bgcolor(white)


********************************************************************************

* Partners

** Regressions
forvalues i = 2/8 {
	glm covid3_puoliso i.rokotettu i.week ika_puoliso ika_puoliso_nelio i.sukupuoli_puoliso i.syntyp2_puoliso_o i.alue i.pekoko_o i.occup_n , fam(bin) link(log) eform nolog cluster(s), if c_timetoeventweek == `i' & tartuntaennenevent_puoliso ==0 & tartuntaennenevent ==0
	estimates store c_timetoeventweek`i'
	
}

** Plot
coefplot (c_timetoeventweek2, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek3, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek4, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek5, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek6, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek7, transform (1.rokotettu = (1-exp(@))*100)) ///
|| (c_timetoeventweek8, transform (1.rokotettu = (1-exp(@))*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
xlabel(1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" ) xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)




