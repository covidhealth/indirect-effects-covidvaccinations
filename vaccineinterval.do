* This do file fixes the dates and calculates the time between doses

use covidrokotedata_avohilmomerge, clear

** Create new date variable from the date where the vaccination is given, since it is in different format
split(rokote_antopvm)
generate rokotepvm = date(rokote_antopvm1, "MDY")
format rokotepvm %td
drop rokote_antopvm1 rokote_antopvm2

** This is date variable from different data, but it should match with rokote_antopvm. Let's check
split kaynti_alkoi
generate kayntipvm = date(kaynti_alkoi1, "MDY")
format kayntipvm %td
drop kaynti_alkoi1 kaynti_alkoi2
gen helpvar=1 if rokotepvm==kayntipvm & rokotepvm!=.
tab rokotepvm
tab rokotepvm if helpvar==1
* It matches for 99% of the observation

** Check duplicates
duplicates drop kaynti_id rokotepvm, force
duplicates drop kaynti_id, force

** There are two date variables, use the time variable when visit started for those whose date variable is missing
replace rokotepvm=kayntipvm if rokotepvm==.

** Generate year, month and week
gen vuosi=year(rokotepvm)
gen kuukausi=month(rokotepvm)
gen viikko=week(rokotepvm)

tab vuosi if shnrook==0
sort shnro rokotepvm

** Drop those 6816 obs who do not have id. Cannot merge them to other data sets
drop if shnrook==0

** Keep only one observation per day per person, since there can be only one vaccination per day-person. There are some persons who has more than one observation per day, but that is probably because something went wrong in vaccination (person was afraid of vaccine etc.) so they tried again later in same day.
bysort shnro rokotepvm: gen y=_n
tab y
keep if y==1

egen var=group(shnro)

** From over 6 million obs, there are about 20 which have date before 27dec2020. We will delete those, since it must be a mistake. Vaccines started 27dec2020.
g var1=td(26dec2020)

** Keep only until 25.04.2021
g var2=td(25apr2021)
keep if rokotepvm>=22276 & rokotepvm<=22395

bysort shnro: gen k=_n
order shnro rokotepvm
bysort shnro: gen erotus=rokotepvm[_n+1]-rokotepvm

** Drop those observations from person who has more than 2 obs. It is not possible since there is only two doses. 99,96% have max 2 obs.
drop if k>=3
drop erotus

bysort shnro: gen erotus=rokotepvm[_n+1]-rokotepvm
tab erotus if k==2
tab erotus if k==1
replace erotus=. if erotus<=13
* This is for 0,1% of obs. Not possible two get the second vaccine is less than two weeks

** Check
tab k
tab y

*Save
save covidrokotetut2annos_new, replace
