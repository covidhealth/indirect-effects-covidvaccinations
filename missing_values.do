* This do file tabulates the missing values in the data

* HCWs
use collapsed_fakeday_allcontrollit_2504, clear
** Keep at t=0 and if no previous infection
keep if c_timetoeventweeks==0 & tartuntaennenevent==0
misstable summarize ika sukupuoli pekoko_o syntyp2_o alue ammatti

* Spouses
keep if c_timetoeventweeks==0 & tartuntaennenevent_puoliso==0
keep if covid_puoliso!=.
misstable summarize ika_puoliso sukupuoli_puoliso pekoko_puoliso_o syntyp2_puoliso_o alue_puoliso 

* Children
use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks==0
keep if tartuntaennenevent_lapsi==0
keep if tartuntaennenevent==0
misstable summarize ika_lapsi sukupuoli_lapsi pekoko_lapsi_o syntyp2_lapsi_o alue_lapsi 
