# After downloading survey data from ONA, we noticed that columns have alues stored as numeric codes. This code is responsible for mapping numeric values stored on ONA survey responses to their respective labels.
# Inputs: Workers survey data file in XLS format and Workers survey XLSform

# Libraries
library(tidyr)

# Imports
source("C:/Users/arogy/projects/kathmandu-portal-data/utils/functions.R")
source("C:/Users/arogy/projects/kathmandu-portal-data/utils/constants.R")

# Parameters
survey_data_path <- "C:/Users/arogy/projects/kathmandu-portal-data/raw/data/workers_data_20210415.xlsx"



# Survey data
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)
# summary(workers_data$m_gender)
# summary(workers_data$b_empl_occpatn_pre_covid)
# summary(workers_data$m_years_of_experience)

# Remove rows with NAs
workers <- workers_data %>% filter(!is.na(m_gender))


# Create categorical variables
workers <- workers %>% mutate(gender_category = m_gender)
workers <- workers %>% mutate(occupation_pre_covid_category = b_empl_occpatn_pre_covid)
workers <- workers %>% mutate(age_category = m_age)
workers <- workers %>% mutate(edu_levl_category = m_edu_levl)
workers <- workers %>% mutate(exp_category = m_years_of_experience)

# Separate dimensional Variables
univariateStats <- PRCS.GetCountsAndProportionsSS(workers, DIMENSIONAL_VARS)

DF <- workers
VARLIST <- c("b_empl_trsm_org.1",                             
             "b_empl_trsm_org.2",                            
             "b_empl_trsm_org.3",                             
             "b_empl_trsm_org.4",                              
             "b_empl_trsm_org.5",                               
             "b_empl_trsm_org.6",                                
             "b_empl_trsm_org.7",                                 
             "b_empl_trsm_org_other")   

GROUP_BY_VAR <- ""

perc_suffix <- "_perc"
total_suffix <- "_total"


getValues  <- function(item) {
  print(item)
}

perc_labels <- lapply(VARLIST, paste0, perc_suffix)
total_labels <- lapply(VARLIST, paste0, total_suffix)
variable_labels <- lapply



for(v in VARLIST) {
  DF[v] <- as.numeric(unlist(DF[v]))
}

msParent <- DF %>%
  # group_by_at(GROUP_BY_VAR) %>%
  summarise_at(
    VARLIST,
    funs(total = sum(., na.rm = T), perc = signif((sum(., na.rm = T) / n()), digits=6))
  )


msParentPerc <- msParent %>%
  select(ends_with("perc")) %>%
  gather(
    key = value,
    value = perc_of_total
  )
msParentPerc$value <-
  mapvalues(msParentPerc$value,
            from = perc_labels,
            to = variable_labels
  )




#$#










































# # Generate Data dictionary template
# dict <-  as.data.frame(colnames(workers_data))
# dict$description <- ""
# colnames(dict) <- c("var", "description")


# xls_form <- "C:/Users/arogy/projects/kathmandu-portal-data/raw/xlsform/workersform.xlsx"
# XLS Form
# xls_form_choices<-XlsSheetToDF("choices", xls_form)
# colnames(xls_form_choices) <- c("list_name", "name", "label", "district", "choice")
# dbWriteTable(con,'workers_xls_form_choices', xls_form_choices, row.names=FALSE, overwrite = TRUE)

# PRCS.CreateFlagVariable(table = survey_data,oldVar = "p_hlth_info_covid_src", newName = "oohlala",value = )

# # Separate flag variables
# flag_vars <- c(
#   "b_empl_trsm_major_districts",
#   "i_econ_covid_effects",
#   "i_empl_covid_effects",
#   "n_rcvry_preferred_incentives",
#   "o_impct_to_self_nxt_6_mnths",
#   "o_rcvry_chllng_trsm_revival",
#   "p_econ_altrnt_incm_src_self_fml",
#   "p_econ_hhd_items_post_covid",
#   "p_econ_hhd_items_pre_covid",
#   "p_hlth_hhs_training_src",
#   "p_hlth_info_covid_src"
# )


# # Separate non flag variables 
# non_flag_vars <- c(
#   "i_econ_incm_chng_self",
#   "i_empl_change_post_covid",
#   "i_empl_emplyr_change_post_covid",
#   "i_empl_jb_prsnt_status",
#   "i_empl_lst_date_full_salary",
#   "i_hlth_covid_infectn_family",
#   "i_hlth_covid_infectn_self",
#   "i_lvlhd_domicile_chng_fml",
#   "i_lvlhd_domicile_chng_self",
#   "o_econ_impact_fml_income_chng_21_v_19",
#   "o_econ_impact_how_long_months",
#   "o_empl_status_to_nrml_how_long_months",
#   "o_impct_has_assets_for_addtnl_loan",
#   "p_econ_outstndng_loans_self",
#   "p_econ_self_savings_chng_today_v_19",
#   "p_hlth_received_hhs_training_self",
#   "p_hlth_vaccinated_self",
#   "p_lvlhd_lrnd_new_skills"
# )




