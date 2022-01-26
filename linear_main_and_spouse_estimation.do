* This do file creates the linear model estimations for the healthcare workers and the partners

clear 

* Healthcare workers

use collapsed_fakeday_allcontrollit_2504, clear

** Regressions
forvalues i = 2/12 {
	reg covid3 i.b1.rokotettu i.week ika ika_nelio i.sukupuoli i.syntyp2_o i.alue i.pekoko_o i.occup_n , cluster(s), if tartuntaennenevent ==0 & c_timetoeventweek == `i' 
	estimates store c_timetoeventweek`i'
	
}

** Take local averages
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==2
local eweek_2_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==3
local eweek_3_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==4
local eweek_4_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==5
local eweek_5_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==6
local eweek_6_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==7
local eweek_7_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==8
local eweek_8_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==9
local eweek_9_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==10
local eweek_10_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==11
local eweek_11_ave=r(mean)
sum covid3 if rokotettu ==0 & c_timetoeventweeks ==12
local eweek_12_ave=r(mean)

** Plot
coefplot (c_timetoeventweek2, transform (0.rokotettu = ((@)/`eweek_2_ave')*100 )) ///
|| (c_timetoeventweek3, transform (0.rokotettu =  ((@)/`eweek_3_ave')*100)) ///
|| (c_timetoeventweek4, transform (0.rokotettu =  ((@)/`eweek_4_ave')*100)) ///
|| (c_timetoeventweek5, transform (0.rokotettu =  ((@)/`eweek_5_ave')*100)) ///
|| (c_timetoeventweek6, transform (0.rokotettu =  ((@)/`eweek_6_ave')*100)) ///
|| (c_timetoeventweek7, transform (0.rokotettu =  ((@)/`eweek_7_ave')*100)) ///
|| (c_timetoeventweek8, transform (0.rokotettu =  ((@)/`eweek_8_ave')*100)) ///
|| (c_timetoeventweek9, transform (0.rokotettu =  ((@)/`eweek_9_ave')*100)) ///
|| (c_timetoeventweek10, transform (0.rokotettu =  ((@)/`eweek_10_ave')*100)) ///
|| (c_timetoeventweek11, transform (0.rokotettu =  ((@)/`eweek_11_ave')*100)) ///
|| (c_timetoeventweek12, transform (0.rokotettu =  ((@)/`eweek_12_ave')*100)) ///
, keep(0.rokotettu) bycoefs vertical ///
xlabel(1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" 8 "9" 9 "10" 10 "11" 11 "12") xtitle("Follow-up week") ///
ytitle ("Relative risk reduction  (%)") yline(0) ///
graphregion(color(white)) bgcolor(white)

**********************************************************************************************

* Partners

clear

use collapsed_fakeday_allcontrollit_2504, clear

** Regressions 
forvalues i = 2/12 {
	reg covid3_puoliso i.b1.rokotettu i.week ika_puoliso ika_puoliso_nelio i.sukupuoli_puoliso i.syntyp2_puoliso_o i.alue i.pekoko_o i.occup_n, cluster(s), if  tartuntaennenevent_puoliso ==0 & tartuntaennenevent ==0 & c_timetoeventweek == `i' 
	estimates store c_timetoeventweek`i'
	
}

** Take local averages
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==2
local eweek_s2_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==3
local eweek_s3_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==4
local eweek_s4_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==5
local eweek_s5_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==6
local eweek_s6_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==7
local eweek_s7_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==8
local eweek_s8_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==9
local eweek_s9_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==10
local eweek_s10_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==11
local eweek_s11_ave=r(mean)
sum covid3_puoliso if rokotettu ==0 & c_timetoeventweeks ==12
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