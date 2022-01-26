** This do file sorts the COVID-19 vaccines from the vaccine register

** Import the raw data on all vaccines given in Finland (vaccine register)
append "avoh_rokotus_24032021" "avoh_rokotus_05052021" "avoh_rokotus_21062021"

** Filter out the COVID-19 vaccinations

* laakeaine_selite = description of drug
* rokote_valmistenimi = name of vaccine
* rokote_lyhenne = abbreviation of vaccine
* laake_kauppanimi = name of drug

** Filtering covid vaccines
gen covid_rokote=0
replace covid_rokote =1 if drug =="J07BX03" ///
| substr(laakeaine_selite,1,3) == "Cov" ///
| substr(laakeaine_selite,1,3) == "COV" ///
| substr(laakeaine_selite,1,3) == "Cor" ///
| substr(laakeaine_selite,1,3) == "Com" ///
| substr(laakeaine_selite,1,3) == "Mod" ///
| substr(laakeaine_selite,1,3) == "MOD" ///
| substr(laakeaine_selite,1,3) == "Ast" ///
| substr(laakeaine_selite,1,3) == "AST" ///
| substr(laakeaine_selite,1,1) == "Pfi" ///
| substr(laakeaine_selite,1,3) == "PFI" ///
| substr(rokote_valmistenimi,1,3) == "Ast" ///
| substr(rokote_valmistenimi,1,3) == "AST" ///
| substr(rokote_valmistenimi,1,2) == "Co" ///
| substr(rokote_valmistenimi,1,2) == "CO" ///
| substr(rokote_valmistenimi,1,3) == "Pfi" ///
| substr(rokote_valmistenimi,1,3) == "PFI" ///
| substr(rokote_valmistenimi,1,3) == "Phi" ///
| substr(rokote_lyhenne,1,3) == "Cov" ///
| substr(rokote_lyhenne,1,3) == "COV" ///
| substr(rokote_lyhenne,1,3) == "Cor" ///
| substr(rokote_lyhenne,1,3) == "Com" ///
| substr(rokote_lyhenne,1,3) == "Mod" ///
| substr(rokote_lyhenne,1,3) == "MOD" ///
| substr(rokote_lyhenne,1,3) == "Ast" ///
| substr(rokote_lyhenne,1,3) == "AST" ///
| substr(rokote_lyhenne,1,3) == "Pfi" ///
| substr(rokote_lyhenne,1,3) == "PFI" ///
| substr(laake_kauppanimi,1,3) == "Cov" ///
| substr(laake_kauppanimi,1,3) == "COV" ///
| substr(laake_kauppanimi,1,3) == "Cor" ///
| substr(laake_kauppanimi,1,3) == "Com" ///
| substr(laake_kauppanimi,1,3) == "COM" ///
| substr(laake_kauppanimi,1,2) == "Mo" ///
| substr(laake_kauppanimi,1,2) == "MO" ///
| substr(laake_kauppanimi,1,2) == "mo" ///
| substr(laake_kauppanimi,1,3) == "Ast" ///
| substr(laake_kauppanimi,1,3) == "AST" ///
| substr(laake_kauppanimi,1,3) == "Pfi" ///
| substr(laake_kauppanimi,1,3) == "PFI"

** Removing vaccines flagged falsely as COVID-19 vaccines
replace covid_rokote=0 if laakeaine_selite=="HERPES" ///
| substr(laakeaine_selite,1,4)=="HPV1"  ///
| substr(laakeaine_selite,1,5)=="INFL1" /// 
| substr(laakeaine_selite,1,5)=="INFL2"  ///
| substr(laakeaine_selite,1,5)=="INFLU"  ///
| substr(laakeaine_selite,1,6)=="INFLU4"  ///
| substr(laakeaine_selite,1,5)=="KELTA"  ///
| substr(laakeaine_selite,1,6)=="KOLERA"  ///
| substr(laakeaine_selite,1,15)=="Pneumokokki PCV"  ///
| substr(laakeaine_selite,1,6)=="Puuta1"  ///
| substr(laakeaine_selite,1,5)=="Rota1"  

** Make a dummy variable for AstraZeneca drugs
gen astra=0
replace astra=1 if substr(laakeaine_selite,1,3) == "Ast" ///
| substr(laakeaine_selite,1,3) == "AST" ///
| substr(laakeaine_selite,1,6) == "COV-A1" ///
| substr(rokote_valmistenimi,1,3) == "Ast" ///
| substr(rokote_valmistenimi,1,3) == "AST" ///
| substr(rokote_lyhenne,1,3) == "Ast" ///
| substr(rokote_lyhenne,1,3) == "AST" ///
| substr(rokote_lyhenne,1,3) == "Zen" ///
| substr(laake_kauppanimi,1,2) == "As" ///
| substr(laake_kauppanimi,1,3) == "Ast" ///
| substr(laake_kauppanimi,1,3) == "AST" ///
| substr(laake_kauppanimi,1,3) == "ASt" ///
| substr(laake_kauppanimi,1,3) == "ATR" ///
| substr(laake_kauppanimi,1,2) == "AZ" ///
| substr(laake_kauppanimi,1,3) == "Art" ///
| substr(laake_kauppanimi,1,3) == "Aat" ///
| substr(laake_kauppanimi,1,3) == "Asd" ///
| substr(laake_kauppanimi,1,3) == "Ass" ///
| substr(laake_kauppanimi,1,3) == "Asr" ///
| substr(laake_kauppanimi,1,3) == "Zen" ///
| substr(laake_kauppanimi,1,3) == "zen" ///
| substr(laake_kauppanimi,1,3) == "ZEN"

** Check
tab astra

** Pfizer
gen pfizer=0
replace pfizer=1 if substr(laakeaine_selite,1,3) == "Com" ///
| substr(laakeaine_selite,1,1) == "Pfi" ///
| substr(laakeaine_selite,1,3) == "PFI" ///
| substr(laakeaine_selite,1,5) == "COV-P" ///
| substr(laakeaine_selite,1,3) == "COm" ///
| substr(rokote_valmistenimi,1,3) == "BIO" ///
| substr(rokote_valmistenimi,1,3) == "Bio" ///
| substr(rokote_valmistenimi,1,3) == "Com" ///
| substr(rokote_valmistenimi,1,3) == "COM" ///
| substr(rokote_valmistenimi,1,4) == "Corm" ///
| substr(rokote_valmistenimi,1,4) == "Coit" ///
| substr(rokote_valmistenimi,1,3) == "Pfi" ///
| substr(rokote_valmistenimi,1,3) == "PFI" ///
| substr(rokote_valmistenimi,1,3) == "pFI" ///
| substr(rokote_valmistenimi,1,3) == "zer" ///
| substr(rokote_valmistenimi,1,3) == "ZER" ///
| substr(rokote_valmistenimi,1,3) == "Phi" ///
| substr(rokote_lyhenne,1,4) == "Corm" ///
| substr(rokote_lyhenne,1,3) == "Com" ///
| substr(rokote_lyhenne,1,3) == "COM" ///
| substr(rokote_lyhenne,1,3) == "Pfi" ///
| substr(rokote_lyhenne,1,3) == "PFI" ///
| substr(rokote_lyhenne,1,3) == "BIO" ///
| substr(rokote_lyhenne,1,3) == "Bio" ///
| substr(laake_kauppanimi,1,4) == "Corm" ///
| substr(laake_kauppanimi,1,4) == "CORM" ///
| substr(laake_kauppanimi,1,3) == "Com" ///
| substr(laake_kauppanimi,1,3) == "COM" ///
| substr(laake_kauppanimi,1,3) == "COm" ///
| substr(laake_kauppanimi,1,3) == "COr" ///
| substr(laake_kauppanimi,1,3) == "cOM" ///
| substr(laake_kauppanimi,1,5) == "coVIR" ///
| substr(laake_kauppanimi,1,5) == "coVER" ///
| substr(laake_kauppanimi,1,3) == "Bio" ///
| substr(laake_kauppanimi,1,3) == "BIO" ///
| substr(laake_kauppanimi,1,3) == "BIo" ///
| substr(laake_kauppanimi,1,6) == "BNT162" ///
| substr(laake_kauppanimi,1,6) == "BNT132" ///
| substr(laake_kauppanimi,1,3) == "Pzi" ///
| substr(laake_kauppanimi,1,3) == "PFi" ///
| substr(laake_kauppanimi,1,3) == "pfi" ///
| substr(laake_kauppanimi,1,3) == "Pfi" ///
| substr(laake_kauppanimi,1,6) == "Covirn" ///
| substr(laake_kauppanimi,1,5) == "narty" ///
| substr(laake_kauppanimi,1,4) == "nrty" ///
| substr(laake_kauppanimi,1,4) == "nity" ///
| substr(laake_kauppanimi,1,3) == "nat" ///
| substr(laake_kauppanimi,1,3) == "zer" ///
| substr(laake_kauppanimi,1,4) == "naty" ///
| substr(laake_kauppanimi,1,4) == "NATY" ///
| substr(laake_kauppanimi,1,3) == "PFI"

** Check
tab pfizer

** Moderna
gen moderna =0
replace moderna=1 if substr(laakeaine_selite,1,3) == "Mod" ///
| substr(laakeaine_selite,1,3) == "MOD" ///
| substr(laakeaine_selite,1,3) == "MOd" ///
| substr(laakeaine_selite,1,5) == "COV-M" ///
| substr(rokote_valmistenimi,1,3) == "Mod" ///
| substr(rokote_valmistenimi,1,3) == "MOD" ///
| substr(rokote_lyhenne,1,3) == "Mod" ///
| substr(rokote_lyhenne,1,3) == "MOD" ///
| substr(laake_kauppanimi,1,2) == "Mo" ///
| substr(laake_kauppanimi,1,2) == "mo" ///
| substr(laake_kauppanimi,1,3) == "Mon" ///
| substr(laake_kauppanimi,1,3) == "Mde" ///
| substr(laake_kauppanimi,1,2) == "MO"

** Check
tab moderna

** Checking that no COVID-19 vaccines were filed under several of Pfizer, Moderna or Astra Zeneca dummies
gen vaccines_total=pfizer+moderna+astra
tab vaccines_total

** Checking there are no COVID-19 vaccines that have not been filed under any of brand dummies 
gen uncategorized=1
replace uncategorized=0 if pfizer==1 | astra==1 | moderna==1
tab uncategorized

** Modify dates
* rokote_antopvm = date of vaccination 
split(rokote_antopvm)
generate vaccinationdate_mod = date(rokote_antopvm1, "MDY")
format vaccinationdate_mod %td
drop rokote_antopvm1 rokote_antopvm2
gen year=year(vaccinationdate_mod)
gen month=month(vaccinationdate_mod)
gen week=week(vaccinationdate_mod)

** Check for duplicates
* kaynti_id = visit id
duplicates drop covid_rokote kaynti_id
duplicates drop covid_rokote vaccination_mod

** Keep only COVID-19 vaccines 
keep if covid_rokote==1

** Save 
save covidrokotedata










