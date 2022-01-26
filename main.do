** This do file contains all do files associate with the analysis conducted in the paper "The indirect effect of mRNA-based COVID-19 vaccination on healthcare workers' unvaccinated household members"

*******************************************************


** DATA **

** This do file sorts the COVID-19 vaccines from the vaccine register
do vaccineregister

** This do file merges the care register (AVOHILMO) versions together and prepares it for the merge with the cleaned vaccine register with only COVID-19 vaccines
do careregister

** This do file merges the care register and vaccine register and cleans the data
do carevaccine_merge

** This do file fixes the dates, calculates the time between doses
do vaccineinterval

**This do file just keeps only one obs per person from data created in previous do file 
do vaccines1

** This do file merges health data with variables on socioeconomic characteristics producing datasets for healthcare workers, partners and children
do folk_ttr_occup

** This do file creates a data set of healthcare workers with covid before the vaccinations
do covid_info_before27122020

**This do file creates a data set of partners with covid before the vaccinations
do spouses_coronas_and_vaccinations_before_timeperiod

** This do-file creates the data set for studying direct and indirect effects of covid vaccines from the previously formed data sets 
do main_data_creation

** This do-file creates a dataset where the event it calculated from second dose
do data_creation_from_second_dose

**Children

** This do file creates a 2019 version of the family register
do familyfolk

** This do file creates a data set of children with covid before the vaccinations
do children_covid_info_before2712020

** This do file creates the data where children are matched with their parents
do children_data_first_part

** This do-file makes the data for analysis of indirect effects on children
do children_data_creation

** This do-file continues to create a dataset where the event it calculated from second dose
do children_data_creation_from_second_dose

 
*******************************************************

** ESTIMATIONS **

** This do file creates the logit estimations for the healthcare workers and the partners
do logit_main_and_spouse_estimation

* This do file creates the linear model estimations for the healthcare workers and the partners
do linear_main_and_spouse_estimation

* This do file creates the logit model estimations for children
do logit_children_estimation
 
 * This do file creates the linear model estimations for children
do linear_children_estimation

* This do file creates the logit model estimations for the healthcare workers and the partners from the second dose
do logit_main_and_spouse_estimation_2nddose

** This do file creates the logit model estimations for children from the second dose
do logit_children_estimation_from2nddose

** This do file creates the plots for coefficients of the linear probability model estimations in the appendix
do coefplots_appendix_lpm 

 
*******************************************************

** DESCRIPTIVE STATISTICS, FIGURES AND SUMMARY TABLES **

** This do file creates a table of sample sizes
do sample_sizes

** This do file creates the descriptive statistics
do descriptive_stats

* This do file shows the descriptive statistics by vaccination status
do descriptive_stats_infections

** This do file creates the summary of missing values
do missing_values

** This do file plots the cumulative share of those with two doses of those with at least one doses
do cumulative_graph_revised

** This do file plots the weekly infections
do weekly_infections

** This do file plots the relative weekly infections
do weekly_infections_relative

 
