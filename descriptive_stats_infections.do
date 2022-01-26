* This do file shows the descriptive statistics by vaccination status

* For table 6 

* HCWs
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0
keep if pekoko_o!=.

** Vaccinations
tabulate covid1 rokotettu

** Sex
tabulate sukupuoli covid1 if rokotettu==1
tabulate sukupuoli covid1 if rokotettu==0

** Family size
tabulate pekoko_o if covid1==1 & rokotettu==1
tabulate pekoko_o if covid1==1 & rokotettu==0

** Origin
tabulate syntyp2_o if covid1==1 & rokotettu==1
tabulate syntyp2_o if covid1==1 & rokotettu==0

** Region
tabulate alue if covid1==1 & rokotettu==1
tabulate alue if covid1==1 & rokotettu==0

* For table 7
tabulate covid1 occup, row

************************************************************************************

* Spouses
use collapsed_fakeday_allcontrollit_2504, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0 & tartuntaennenevent_puoliso==0
keep if pekoko_o!=.
keep if covid1_puoliso!=.

** Vaccinations
tabulate covid1_puoliso rokotettu

** Sex
tabulate sukupuoli covid1_puoliso if rokotettu==1
tabulate sukupuoli covid1_puoliso if rokotettu==0

** Family size
tabulate pekoko_o if covid1_puoliso==1 & rokotettu==1
tabulate pekoko_o if covid1_puoliso==1 & rokotettu==0

** Origin
tabulate syntyp2_puoliso_o if covid1_puoliso==1 & rokotettu==1
tabulate syntyp2_puoliso_o if covid1_puoliso==1 & rokotettu==0

** Region
tabulate alue_puoliso if covid1_puoliso==1 & rokotettu==1
tabulate alue_puoliso if covid1_puoliso==1 & rokotettu==0

************************************************************************************

* Kids over all

use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
keep if pekoko_o!=.

** Vaccinations
tabulate covid1_lapsi rokotettu

** Sex
tabulate sukupuoli covid1_lapsi if rokotettu==1
tabulate sukupuoli covid1_lapsi if rokotettu==0

** Family size
tabulate pekoko_o if covid1_lapsi==1 & rokotettu==1
tabulate pekoko_o if covid1_lapsi==1 & rokotettu==0

** Origin
tabulate syntyp2_lapsi if covid1_lapsi==1 & rokotettu==1
tabulate syntyp2_lapsi if covid1_lapsi==1 & rokotettu==0

**Region
tabulate alue_lapsi if covid1_lapsi==1 & rokotettu==1
tabulate alue_lapsi if covid1_lapsi==1 & rokotettu==0

************************************************************************************

* Kids 3-12

use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
keep if pekoko_o!=.

** Age group
keep if ika_lapsi>2 & ika_lapsi<13

** Vaccinations
tabulate covid1_lapsi rokotettu

** Sex
tabulate sukupuoli covid1_lapsi if rokotettu==1
tabulate sukupuoli covid1_lapsi if rokotettu==0

** Family size
tabulate pekoko_o if covid1_lapsi==1 & rokotettu==1
tabulate pekoko_o if covid1_lapsi==1 & rokotettu==0

** Origin
tabulate syntyp2_lapsi if covid1_lapsi==1 & rokotettu==1
tabulate syntyp2_lapsi if covid1_lapsi==1 & rokotettu==0

** Region
tabulate alue_lapsi if covid1_lapsi==1 & rokotettu==1
tabulate alue_lapsi if covid1_lapsi==1 & rokotettu==0

************************************************************************************

* Kids 13-18


use collapsed_fakeday_allcontrollit_2504_lapset, clear
keep if c_timetoeventweeks>=0 & tartuntaennenevent==0 & tartuntaennenevent_lapsi==0
keep if pekoko_o!=.

** Age group
keep if ika_lapsi>12 & ika_lapsi<19

** Vaccinations
tabulate covid1_lapsi rokotettu

** Sex
tabulate sukupuoli covid1_lapsi if rokotettu==1
tabulate sukupuoli covid1_lapsi if rokotettu==0

** Family size
tabulate pekoko_o if covid1_lapsi==1 & rokotettu==1
tabulate pekoko_o if covid1_lapsi==1 & rokotettu==0

** Origin
tabulate syntyp2_lapsi if covid1_lapsi==1 & rokotettu==1
tabulate syntyp2_lapsi if covid1_lapsi==1 & rokotettu==0

** Region
tabulate alue_lapsi if covid1_lapsi==1 & rokotettu==1
tabulate alue_lapsi if covid1_lapsi==1 & rokotettu==0
