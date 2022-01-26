* This do file merges the care register (AVOHILMO) versions together and prepares it for the merge with the cleaned vaccine register with only COVID-19 vaccines

** Merging the different updates of the care register
append "avohilmo_05052021.csv" "avohilmo_05052021.csv" "avohilmo_05052021.csv" "avohilmo_21062021.csv"

** Keep only variables (id code, birth year, start of visit and end of visit)
keep shnro kaynti_id asiakas_syntymavuosi kaynti_alkoi kaynti_loppui

** Modify visit start dates
split kaynti_alkoi
generate visitdate = date(kaynti_alkoi1, "MDY")
format visitdate %td
drop kaynti_alkoi1 kaynti_alkoi2

** Check for duplicates by visit id
duplicates drop kaynti_id visitdate, force

** Save data
save avohilmo2020_2021new