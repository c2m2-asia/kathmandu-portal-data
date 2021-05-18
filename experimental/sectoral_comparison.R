# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/workers_data_20210429.xlsx")

# Survey data
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)

# Remove rows with NAs
workers <- workers_data %>% filter(!is.na(m_gender))

# Functions
SaveChartData <- function(DF, VARS, FILE) {
  final <- UNI.GetCountsAndProportionsSS(DF, VARS) 
  final <- final %>% 
    filter(value!=FALSE) %>% 
    select(variable, perc_of_total) %>%
    rename(label=variable, value=perc_of_total)
  IO.SaveJson(final, FILE, JSON_EXPORT_PATH)
  return(final)
}

SaveDistData <- function(DF, VAR, FILE) {
  dist <- UNI.GetCountsAndProportionsSS(DF, c(VAR))
  path <- paste0(ROOT_URL, "misc/mapping.xlsx")
  mapping <- IO.XlsSheetToDF(excel_sheets(path)[1], path) %>% select(variable, value, label_ne, label_en)
  dist_w_labels <- left_join(dist, mapping)
  IO.SaveJson(dist_w_labels, FILE, JSON_EXPORT_PATH)
}

# Code

# Assign Sector Flags
workers <- workers %>% mutate(d_occptn_exp_selling = ifelse((b_empl_occpatn_pre_covid__2 == 1 | b_empl_occpatn_pre_covid__3 == 1 | b_empl_occpatn_pre_covid__4 == 1 | b_empl_occpatn_pre_covid__5 == 1 ), T, F ) )
workers <- workers %>% mutate(d_occptn_accomodation = ifelse((b_empl_occpatn_pre_covid__10 == 1 | b_empl_occpatn_pre_covid__11 == 1 | b_empl_occpatn_pre_covid__12 == 1 | b_empl_occpatn_pre_covid__13 == 1 | b_empl_occpatn_pre_covid__14 == 1), T, F ) )
workers <- workers %>% mutate(d_occptn_travel = ifelse((b_empl_occpatn_pre_covid__6 == 1 | b_empl_occpatn_pre_covid__7 == 1 | b_empl_occpatn_pre_covid__8 == 1 | b_empl_occpatn_pre_covid__9 == 1 | b_empl_occpatn_pre_covid__15 == 1), T, F ) )
workers <- workers %>% mutate(d_occptn_othr = ifelse((b_empl_occpatn_pre_covid__16 == 1), T, F ) )



SavePropComparisonChartData <- function(DF, VAR, COMPARE_ACROSS, FILE) {

  var=VAR
  subsetBy <- COMPARE_ACROSS
  df <- DF

  # Create empty table
  final <- data.frame(label = character(),
                      value = double(),
                      total = integer())
  for(subsetColumn in subsetBy) {
    df2 <- df %>% filter((!!as.symbol(subsetColumn)) == T)
    n <- nrow(df2)
    df3 <- UNI.GetCountsAndProportionsSS(df2, var) %>% filter(value == T) %>% select(variable, perc_of_total, total) %>% rename(label=variable, value=perc_of_total) %>% mutate(label=subsetColumn, n=n)
    final <- rbind(final, df3)
  }
  IO.SaveJson(final, FILE, JSON_EXPORT_PATH)
  
  
  return(final)
  
}


compareAcross <- c("d_occptn_exp_selling", "d_occptn_accomodation",  "d_occptn_travel", "d_occptn_othr")

# Get Lost Jobs Comparison
workers <- workers %>% mutate(d_lost_job = ifelse((i_empl_covid_effects__1 == 1 | i_empl_covid_effects__2 == 1), T, F ))
workers <- workers %>% mutate(d_lost_job_but_working_now = ifelse((d_lost_job == T & (i_empl_jb_prsnt_status == 1 | i_empl_jb_prsnt_status == 2)), T, F ))
workers <- workers %>% mutate(d_lost_job_still_no_work = ifelse((d_lost_job == T & (i_empl_jb_prsnt_status != 1 & i_empl_jb_prsnt_status != 2)), T, F ))
SavePropComparisonChartData(DF = workers, 
                            VAR = "d_lost_job", 
                            COMPARE_ACROSS = compareAcross, 
                            FILE = "SectoralLostJobsProportionalSplit")



# Get Presently Employed Comparison
workers <- workers %>% mutate(d_stayed_employed = ifelse((i_empl_covid_effects__1 != 1 & i_empl_covid_effects__2 != 1), T, F ))
workers <- workers %>% mutate(d_presently_employed = ifelse((d_stayed_employed == T | d_lost_job_but_working_now == T), T, F ))

SavePropComparisonChartData(DF = workers, 
                            VAR = "d_presently_employed", 
                            COMPARE_ACROSS = compareAcross, 
                            FILE = "SectoralEmployedProportionalSplit")


# Get slary retention
workers <- workers %>% mutate(d_presently_back_to_old_salary = ifelse((i_empl_lst_date_full_salary == 2 | i_empl_lst_date_full_salary == 3 | i_empl_lst_date_full_salary == 4 | i_empl_lst_date_full_salary == 5 ), T, F ))
SavePropComparisonChartData(DF = workers, 
                            VAR = "d_presently_back_to_old_salary", 
                            COMPARE_ACROSS = compareAcross, 
                            FILE = "SectoralSalaryRetentionProportionalSplit")





# Get profession retention
workers <- workers %>% mutate(d_kept_occupation = ifelse((i_empl_jb_in_tourism_change == 2 | i_empl_jb_in_tourism_change_add == 2), T, F )) %>%  mutate(d_kept_occupation = ifelse(is.na(d_kept_occupation), F, d_kept_occupation))
SavePropComparisonChartData(DF = workers, 
                            VAR = "d_kept_occupation", 
                            COMPARE_ACROSS = compareAcross, 
                            FILE = "SectoralProfessionRetentionProportionalSplit")

# Get Alternate Income source
workers <- workers %>% mutate(d_alternate_src_income = ifelse(p_econ_altrnt_incm_src_self_fml_flg == 2, T, F))
SavePropComparisonChartData(DF = workers, 
                            VAR = "d_alternate_src_income", 
                            COMPARE_ACROSS = compareAcross, 
                            FILE = "SectoralAlternateIncomeSourceProportionalSplit")







