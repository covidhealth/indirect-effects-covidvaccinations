* This do file creates a table of sample sizes

**********************************************************************************************

* Healthcare workers

** Fetch data
use collapsed_fakeday_allcontrollit_2504, clear

** Keep at time of event, if no prior infection and all variables available
keep if c_timetoeventweeks>=0
keep if tartuntaennenevent==0
keep if pekoko_o!=.

** Aggregate
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)

** Export
export excel using "samplesizes_rev_31221.xlsx", sheet("Workers")

**********************************************************************************************

* Partners 

** Fetch data
use collapsed_fakeday_allcontrollit_2504, clear

** Keep at time of event, if no prior infection and all variables available
keep if c_timetoeventweeks>=0
keep if tartuntaennenevent_puoliso==0
keep if tartuntaennenevent==0
keep if pekoko_o!=.

** Aggregate
keep if covid3_puoliso==0 | covid3_puoliso==1
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)

** Export
export excel using "samplesizes_rev_31221.xlsx", sheet("Spouses covid3")

**********************************************************************************************

* Kids

** Fetch data
use collapsed_fakeday_allcontrollit_2504_lapset, clear

** Keep at time of event, if no prior infection and all variables available
keep if c_timetoeventweeks>=0
keep if tartuntaennenevent==0
keep if pekoko_o!=.

** Aggregate
keep if tartuntaennenevent_lapsi==0
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)

** Export
export excel using "samplesizes_rev_31221.xlsx", sheet("Kids")

**********************************************************************************************

* Kids 3-12

** Fetch data
use collapsed_fakeday_allcontrollit_2504_lapset, clear

** Keep at time of event, if no prior infection and all variables available
keep if c_timetoeventweeks>=0
keep if tartuntaennenevent==0
keep if pekoko_o!=.
keep if tartuntaennenevent_lapsi==0

** Age specification
keep if ika_lapsi>2 & ika_lapsi<13

** Aggregate
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)

** Export
export excel using "samplesizes_rev_31221.xlsx", sheet("Kids 3-12")

**********************************************************************************************

* Kids 13-18

** Fetch data
use collapsed_fakeday_allcontrollit_2504_lapset, clear

** Keep at time of event, if no prior infection and all variables available
keep if c_timetoeventweeks>=0
keep if tartuntaennenevent==0
keep if pekoko_o!=.
keep if tartuntaennenevent_lapsi==0

** Age specification
keep if ika_lapsi>12 & ika_lapsi<19

** Aggregate
gen identifier=1
collapse(sum) identifier, by(c_timetoeventweeks rokotettu)

** Export
export excel using "samplesizes_rev_31221.xlsx", sheet("Kids 13-18")
