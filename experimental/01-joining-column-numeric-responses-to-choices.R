# After downloading survey data from ONA, we noticed that columns have alues stored as numeric codes. This code is responsible for mapping numeric values stored on ONA survey responses to their respective labels.
# Inputs: Workers survey data file in XLS format and Workers survey XLSform

# Libraries
library(tidyr)

library(reshape2)
# Imports
source("C:/Users/arogy/projects/kathmandu-portal-data/utils/functions.R")
source("C:/Users/arogy/projects/kathmandu-portal-data/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/workers_data_20210418_v5.xlsx")




# Survey data
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)
# summary(workers_data$m_gender)
# summary(workers_data$b_empl_occpatn_pre_covid)
# summary(workers_data$m_years_of_experience)

# Remove rows with NAs
workers <- workers_data %>% filter(!is.na(m_gender))


# Create categorical variables
workers <- workers %>% mutate(gender_category = m_gender)
workers <- workers %>% mutate(age_category = m_age)
workers <- workers %>% mutate(edu_levl_category = m_edu_levl)
workers <- workers %>% mutate(exp_category = m_years_of_experience)



# Separate dimensional Variables
univariateStatsForSS <- UNI.GetCountsAndProportionsSS(workers, DIMENSIONAL_VARS)

IO.SaveCsv(univariateStatsForSS, "univariateStats", CSV_EXPORT_PATH)
IO.SaveJson(univariateStatsForSS, "univariateStats", JSON_EXPORT_PATH)

colnames(workers)

multiselect_prefixes = c(
  "o_impct_to_self_nxt_6_mnths", 
  "o_rcvry_chllng_trsm_revival", 
  "b_empl_occpatn_pre_covid","o_rcvry_chllng_trsm_revival",
  "b_empl_trsm_org", "b_empl_trsm_major_districts","n_rcvry_preferred_incentives", "p_hlth_info_covid_src","p_hlth_hhs_training_src", "p_econ_hhd_items_post_covid", "p_econ_hhd_items_pre_covid","i_econ_covid_effects", "i_empl_covid_effects", "i_empl_jb_in_tourism_changed_to_add", "i_empl_jb_prsnt_status_prtl_switch_new_sctr"
  )
univariateStatsForMS <- UNI.GetCountsAndProportionsMSMultiQues(workers, multiselect_prefixes)
allUnivariate <- rbind(univariateStatsForSS, univariateStatsForMS)#$#

IO.SaveCsv(allUnivariate, "univariateStats", CSV_EXPORT_PATH)
# IO.SaveJson(univariateStatsForSS, "univariateStats", JSON_EXPORT_PATH)

