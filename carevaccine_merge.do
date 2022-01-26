* This do file merges the care register and vaccine register and cleans the final data

** Merge the vaccine data to visit data from the care register using the visit id
use covidrokotedata, clear
merge m:1 kaynti_id using avohilmo2020_2021new, keep(master match)

** Check the id codes for further matching in next steps
* shnro = anonymized id
replace shnro="." if shnro==""
gen idcodeok=1 
replace idcodeok=0 if shnro=="."
tab idcodeok

save covidrokotedata_avohilmomerge


