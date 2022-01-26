** This do file creates the plots for coefficients of the LPM estimations in the appendix

********************************************************************************
* Healthcare workers

clear all

** Logit
use collapsed_fakeday_allcontrollit_2504, clear
forvalues i = 2/12 {
	glm covid3 i.rokotettu i.week ika ika_nelio i.sukupuoli i.syntyp2_o i.alue i.pekoko_o i.occup_n, fam(bin) link(log) eform nolog cluster(s), if tartuntaennenevent ==0 & c_timetoeventweek == `i' 
	estimates store c_timetoeventweek_main_`i'
}

** LPM
use collapsed_fakeday_allcontrollit_2504, clear
** Turning around variable so plots will be comparable
gen rokotettu_2 = 1
replace rokotettu_2=0 if rokotettu==1
drop rokotettu 
rename rokotettu_2 rokotettu
forvalues i = 2/12 {
	reg covid3 i.rokotettu i.week ika ika_nelio i.sukupuoli i.syntyp2_o i.alue i.pekoko_o i.occup_n, cluster(s), if tartuntaennenevent ==0 & c_timetoeventweek == `i' 
	estimates store c_timetoeventweek_lin_`i'
}

** Take local averages
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==2 & tartuntaennenevent ==0
local eweek_2_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==3 & tartuntaennenevent ==0
local eweek_3_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==4 & tartuntaennenevent ==0
local eweek_4_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==5 & tartuntaennenevent ==0
local eweek_5_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==6 & tartuntaennenevent ==0
local eweek_6_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==7 & tartuntaennenevent ==0
local eweek_7_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==8 & tartuntaennenevent ==0
local eweek_8_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==9 & tartuntaennenevent ==0
local eweek_9_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==10 & tartuntaennenevent ==0
local eweek_10_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==11 & tartuntaennenevent ==0
local eweek_11_ave=r(mean)
sum covid3 if rokotettu ==1 & c_timetoeventweeks ==12 & tartuntaennenevent ==0
local eweek_12_ave=r(mean)

** Plot the coefficients
* Coefficients are transformed to relative risk reduction by transformation depending on regression type
coefplot (c_timetoeventweek_main_2, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_2, transform (1.rokotettu = ((@)/`eweek_2_ave')*100)) ///
|| (c_timetoeventweek_main_3, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_3, transform (1.rokotettu = ((@)/`eweek_3_ave')*100)) ///
|| (c_timetoeventweek_main_4, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_4, transform (1.rokotettu = ((@)/`eweek_4_ave')*100)) ///
|| (c_timetoeventweek_main_5, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_5, transform (1.rokotettu = ((@)/`eweek_5_ave')*100)) ///
|| (c_timetoeventweek_main_6, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_6, transform (1.rokotettu = ((@)/`eweek_6_ave')*100)) ///
|| (c_timetoeventweek_main_7, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_7, transform (1.rokotettu = ((@)/`eweek_7_ave')*100)) ///
|| (c_timetoeventweek_main_8, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_8, transform (1.rokotettu = ((@)/`eweek_8_ave')*100)) ///
|| (c_timetoeventweek_main_9, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_9, transform (1.rokotettu = ((@)/`eweek_9_ave')*100)) ///
|| (c_timetoeventweek_main_10, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_10, transform (1.rokotettu = ((@)/`eweek_10_ave')*100)) ///
|| (c_timetoeventweek_main_11, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_11, transform (1.rokotettu = ((@)/`eweek_11_ave')*100)) ///
|| (c_timetoeventweek_main_12, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_lin_12, transform (1.rokotettu = ((@)/`eweek_12_ave')*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
  xtitle("Follow-up week") xlabel(1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" 8 "9" 9 "10" 10 "11" 11 "12" 12 "13") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
legend(pos(5) ring(0) order(2 "Main" 4 "Linear model") on) ///
graphregion(color(white)) bgcolor(white)

********************************************************************************

* Partners

clear all

** Logit
use collapsed_fakeday_allcontrollit_2504, clear
forvalues i = 2/12 {
	glm covid3_puoliso i.rokotettu i.week ika_puoliso ika_puoliso_nelio i.sukupuoli_puoliso i.syntyp2_puoliso_o i.alue i.pekoko_o i.occup_n, fam(bin) link(log) eform nolog  cluster(s), if c_timetoeventweek == `i' & tartuntaennenevent_puoliso ==0 & tartuntaennenevent ==0
	estimates store c_timetoeventweek_sp_`i'
}

** LPM
use collapsed_fakeday_allcontrollit_2504, clear
** Turning around variable so plots will be comparable
gen rokotettu_2 = 1
replace rokotettu_2=0 if rokotettu==1
drop rokotettu 
rename rokotettu_2 rokotettu
forvalues i = 2/12 {
	reg covid3_puoliso i.rokotettu i.week ika_puoliso ika_puoliso_nelio i.sukupuoli_puoliso i.syntyp2_puoliso_o i.alue i.pekoko_o i.occup_n, cluster(s), if c_timetoeventweek == `i' & tartuntaennenevent_puoliso ==0 & tartuntaennenevent ==0
	estimates store c_timetoeventweek_sp_lin_`i'
}

** Taking local averages
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==2 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_2_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==3 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_3_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==4 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_4_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==5 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_5_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==6 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_6_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==7 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_7_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==8 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_8_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==9 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_9_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==10 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_10_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==11 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_11_ave=r(mean)
sum covid3_puoliso if rokotettu ==1 & c_timetoeventweeks ==12 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
local eweek_12_ave=r(mean)

** Plot the coefficients
* Coefficients are transformed to relative risk reduction by transformation depending on regression type
coefplot (c_timetoeventweek_sp_2, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_2, transform (1.rokotettu = ((@)/`eweek_2_ave')*100)) ///
|| (c_timetoeventweek_sp_3, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_3, transform (1.rokotettu = ((@)/`eweek_3_ave')*100)) ///
|| (c_timetoeventweek_sp_4, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_4, transform (1.rokotettu = ((@)/`eweek_4_ave')*100)) ///
|| (c_timetoeventweek_sp_5, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_5, transform (1.rokotettu = ((@)/`eweek_5_ave')*100)) ///
|| (c_timetoeventweek_sp_6, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_6, transform (1.rokotettu = ((@)/`eweek_6_ave')*100)) ///
|| (c_timetoeventweek_sp_7, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_7, transform (1.rokotettu = ((@)/`eweek_7_ave')*100)) ///
|| (c_timetoeventweek_sp_8, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_8, transform (1.rokotettu = ((@)/`eweek_8_ave')*100)) ///
|| (c_timetoeventweek_sp_9, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_9, transform (1.rokotettu = ((@)/`eweek_9_ave')*100)) ///
|| (c_timetoeventweek_sp_10, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_10, transform (1.rokotettu = ((@)/`eweek_10_ave')*100)) ///
|| (c_timetoeventweek_sp_11, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_11, transform (1.rokotettu = ((@)/`eweek_11_ave')*100)) ///
|| (c_timetoeventweek_sp_12, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_sp_lin_12, transform (1.rokotettu = ((@)/`eweek_12_ave')*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
  xtitle("Follow-up week") xlabel(1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" 8 "9" 9 "10" 10 "11" 11 "12" 12 "13") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
legend(pos(5) ring(0) order(2 "Main" 4 "Linear model") on) ///
graphregion(color(white)) bgcolor(white)


********************************************************************************


* Children 3-12

clear all

** Logit, pooled and rest
use collapsed_fakeday_allcontrollit_2504_lapset, clear
glm covid3_lapsi i.rokotettu i.week ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_lapsi_o i.occup_n, fam(bin) link(log) eform nolog cluster(s), if c_timetoeventweek>1 & c_timetoeventweek<6 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
	estimates store c_timetoeventweek_c2_2_5
forvalues i = 6/12 {
	glm covid3_lapsi i.rokotettu i.week ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_lapsi_o i.occup_n, fam(bin) link(log) eform nolog cluster(s), if c_timetoeventweek == `i' & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
	estimates store c_timetoeventweek_c2_`i'
	
}

** LPM, pooled and rest
use collapsed_fakeday_allcontrollit_2504_lapset, clear
** Turning around variable so plots will be comparable
gen rokotettu_2 = 1
replace rokotettu_2=0 if rokotettu==1
drop rokotettu 
rename rokotettu_2 rokotettu
reg covid3_lapsi i.rokotettu i.week ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_lapsi_o i.occup_n, cluster(s), if c_timetoeventweek>1 & c_timetoeventweek<6 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
	estimates store c_timetoeventweek_c2lin_2_5
forvalues i = 6/12 {
	reg covid3_lapsi i.rokotettu i.week ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_lapsi_o i.occup_n, cluster(s), if c_timetoeventweek == `i' & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
	estimates store c_timetoeventweek_c2lin_`i'
	
}

** Taking local averages
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks >=2 & c_timetoeventweeks <6 & syntymavuosi_lapsi>2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_2_5_ave=r(mean) 
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==6 & syntymavuosi_lapsi>2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_6_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==7 & syntymavuosi_lapsi>2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_7_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==8 & syntymavuosi_lapsi>2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_8_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==9 & syntymavuosi_lapsi>2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_9_ave=r(mean) 
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==10 & syntymavuosi_lapsi>2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_10_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==11 & syntymavuosi_lapsi>2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_11_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==12 & syntymavuosi_lapsi>2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_12_ave=r(mean)

** Plot the coefficients
* Coefficients are transformed to relative risk reduction by transformation depending on regression type
coefplot (c_timetoeventweek_c2_2_5, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c2lin_2_5, transform (1.rokotettu = ((@)/`eweek_2_5_ave')*100)) ///
|| (c_timetoeventweek_c2_6, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c2lin_6, transform (1.rokotettu = ((@)/`eweek_6_ave')*100)) ///
|| (c_timetoeventweek_c2_7, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c2lin_7, transform (1.rokotettu = ((@)/`eweek_7_ave')*100)) ///
|| (c_timetoeventweek_c2_8, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c2lin_8, transform (1.rokotettu = ((@)/`eweek_8_ave')*100)) ///
|| (c_timetoeventweek_c2_9, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c2lin_9, transform (1.rokotettu = ((@)/`eweek_9_ave')*100)) ///
|| (c_timetoeventweek_c2_10, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c2lin_10, transform (1.rokotettu = ((@)/`eweek_10_ave')*100)) ///
|| (c_timetoeventweek_c2_11, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c2lin_11, transform (1.rokotettu = ((@)/`eweek_11_ave')*100)) ///
|| (c_timetoeventweek_c2_12, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c2lin_12, transform (1.rokotettu = ((@)/`eweek_12_ave')*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
  xtitle("Follow-up week") xlabel(1 "2-5" 2 "6" 3 "7" 4 "8" 5 "9" 6 "10" 7 "11" 8 "12") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
legend(pos(5) ring(0) order(2 "Main" 4 "Linear model") on) ///
graphregion(color(white)) bgcolor(white)


********************************************************************************

* Children 13-18

clear all

** Logit, pooled and rest
use collapsed_fakeday_allcontrollit_2504_lapset, clear
glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_lapsi_o i.occup_n i.week, fam(bin) link(log) eform nolog cluster(s), if c_timetoeventweek>1 & c_timetoeventweek<6 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
estimates store c_timetoeventweek_c1_2_5

forvalues i = 6/12 {
	glm covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_lapsi_o i.occup_n i.week, fam(bin) link(log) eform nolog cluster(s), if c_timetoeventweek == `i' & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
	estimates store c_timetoeventweek_c1_`i'
}

** LPM, pooled and rest
use collapsed_fakeday_allcontrollit_2504_lapset, clear
** Turning around variable so plots will be comparable
gen rokotettu_2 = 1
replace rokotettu_2=0 if rokotettu==1
drop rokotettu 
rename rokotettu_2 rokotettu
reg covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_lapsi_o i.occup_n i.week, cluster(s), if c_timetoeventweek>1 & c_timetoeventweek<6 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
estimates store c_timetoeventweek_c1lin_2_5

forvalues i = 6/12 {
	reg covid3_lapsi i.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_lapsi_o i.occup_n i.week, cluster(s), if c_timetoeventweek == `i' & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
	estimates store c_timetoeventweek_c1lin_`i'
}

** Taking local averages
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks >=2 & c_timetoeventweeks <6 & syntymavuosi_lapsi<=2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_2_5_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==6 & syntymavuosi_lapsi<=2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_6_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==7 & syntymavuosi_lapsi<=2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_7_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==8 & syntymavuosi_lapsi<=2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_8_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==9 & syntymavuosi_lapsi<=2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_9_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==10 & syntymavuosi_lapsi<=2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_10_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==11 & syntymavuosi_lapsi<=2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_11_ave=r(mean)
sum covid3_lapsi if rokotettu ==1 & c_timetoeventweeks ==12 & syntymavuosi_lapsi<=2008 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
local eweek_12_ave=r(mean)

** Plot the coefficients
* Coefficients are transformed to relative risk reduction by transformation depending on regression type
coefplot (c_timetoeventweek_c1_2_5, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c1lin_2_5, transform (1.rokotettu = ((@)/`eweek_2_5_ave')*100)) ///
|| (c_timetoeventweek_c1_6, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c1lin_6, transform (1.rokotettu = ((@)/`eweek_6_ave')*100)) ///
|| (c_timetoeventweek_c1_7, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c1lin_7, transform (1.rokotettu = ((@)/`eweek_7_ave')*100)) ///
|| (c_timetoeventweek_c1_8, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c1lin_8, transform (1.rokotettu = ((@)/`eweek_8_ave')*100)) ///
|| (c_timetoeventweek_c1_9, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c1lin_9, transform (1.rokotettu = ((@)/`eweek_9_ave')*100)) ///
|| (c_timetoeventweek_c1_10, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c1lin_10, transform (1.rokotettu = ((@)/`eweek_10_ave')*100)) ///
|| (c_timetoeventweek_c1_11, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c1lin_11, transform (1.rokotettu = ((@)/`eweek_11_ave')*100)) ///
|| (c_timetoeventweek_c1_12, transform (1.rokotettu = (1-exp(@))*100)) ///
(c_timetoeventweek_c1lin_12, transform (1.rokotettu = ((@)/`eweek_12_ave')*100)) ///
, keep(1.rokotettu) bycoefs vertical ///
  xtitle("Follow-up week") xlabel(1 "2-5" 2 "6" 3 "7" 4 "8" 5 "9" 6 "10" 7 "11" 8 "12") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
legend(pos(5) ring(0) order(2 "Main" 4 "Linear model") on) ///
graphregion(color(white)) bgcolor(white)