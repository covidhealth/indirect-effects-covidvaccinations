* This do file creates the linear model estimations for children

clear 

use collapsed_fakeday_allcontrollit_2504_children, clear

* Kids 3-12

** Regressions
forvalues i = 2/12 {
	reg covid3_lapsi i.b1.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week i.occup_n, cluster(s), if  tartuntaennenevent_lapsi ==0 & tartuntaennenevent ==0 & c_timetoeventweek == `i' & syntymavuosi_lapsi>2008
	estimates store c_timetoeventweek`i'
}

** Local averages
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==2 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s2_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==3 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s3_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==4 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s4_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==5 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s5_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==6 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s6_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==7 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s7_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==8 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s8_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==9 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s9_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==10 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s10_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==11 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s11_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==12 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi>2008
local eweek_s12_ave=r(mean)

** Plot
coefplot (c_timetoeventweek2, transform (0.rokotettu = ((@)/`eweek_s2_ave')*100 )) ///
|| (c_timetoeventweek3, transform (0.rokotettu =  ((@)/`eweek_s3_ave')*100)) ///
|| (c_timetoeventweek4, transform (0.rokotettu =  ((@)/`eweek_s4_ave')*100)) ///
|| (c_timetoeventweek5, transform (0.rokotettu =  ((@)/`eweek_s5_ave')*100)) ///
|| (c_timetoeventweek6, transform (0.rokotettu =  ((@)/`eweek_s6_ave')*100)) ///
|| (c_timetoeventweek7, transform (0.rokotettu =  ((@)/`eweek_s7_ave')*100)) ///
|| (c_timetoeventweek8, transform (0.rokotettu =  ((@)/`eweek_s8_ave')*100)) ///
|| (c_timetoeventweek9, transform (0.rokotettu =  ((@)/`eweek_s9_ave')*100)) ///
|| (c_timetoeventweek10, transform (0.rokotettu = ((@)/`eweek_s10_ave')*100)) ///
|| (c_timetoeventweek11, transform (0.rokotettu =  ((@)/`eweek_s11_ave')*100)) ///
|| (c_timetoeventweek12, transform (0.rokotettu = ((@)/`eweek_s12_ave')*100)) ///
, keep(0.rokotettu) bycoefs vertical ///
xlabel(1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" 8 "9" 9 "10" 10 "11" 11 "12") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)


**********************************************************************************************

* Kids 13-18

** Regressions
forvalues i = 2/12 {
	reg covid3_lapsi i.b1.rokotettu ika_lapsi ika_lapsi_nelio i.sukupuoli_lapsi i.syntyp2_lapsi_o i.alue i.pekoko_o i.week, cluster(s), if  tartuntaennenevent_lapsi ==0 & tartuntaennenevent ==0 & c_timetoeventweek == `i' & syntymavuosi_lapsi>2008
	estimates store c_timetoeventweek`i'
	
}

** Local averages
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==2 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s2_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==3 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s3_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==4 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s4_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==5 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s5_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==6 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s6_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==7 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s7_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==8 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s8_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==9 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s9_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==10 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s10_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==11 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s11_ave=r(mean)
sum covid3_lapsi if rokotettu ==0 & c_timetoeventweeks ==12 & tartuntaennenevent_lapsi==0 & tartuntaennenevent ==0 & syntymavuosi_lapsi<=2008
local eweek_s12_ave=r(mean)


** Plot
coefplot (c_timetoeventweek2, transform (0.rokotettu = ((@)/`eweek_s2_ave')*100 )) ///
|| (c_timetoeventweek3, transform (0.rokotettu =  ((@)/`eweek_s3_ave')*100)) ///
|| (c_timetoeventweek4, transform (0.rokotettu =  ((@)/`eweek_s4_ave')*100)) ///
|| (c_timetoeventweek5, transform (0.rokotettu =  ((@)/`eweek_s5_ave')*100)) ///
|| (c_timetoeventweek6, transform (0.rokotettu =  ((@)/`eweek_s6_ave')*100)) ///
|| (c_timetoeventweek7, transform (0.rokotettu =  ((@)/`eweek_s7_ave')*100)) ///
|| (c_timetoeventweek8, transform (0.rokotettu =  ((@)/`eweek_s8_ave')*100)) ///
|| (c_timetoeventweek9, transform (0.rokotettu =  ((@)/`eweek_s9_ave')*100)) ///
|| (c_timetoeventweek10, transform (0.rokotettu = ((@)/`eweek_s10_ave')*100)) ///
|| (c_timetoeventweek11, transform (0.rokotettu =  ((@)/`eweek_s11_ave')*100)) ///
|| (c_timetoeventweek12, transform (0.rokotettu = ((@)/`eweek_s12_ave')*100)) ///
, keep(0.rokotettu) bycoefs vertical ///
xlabel(1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" 8 "9" 9 "10" 10 "11" 11 "12") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)

