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
workers <- workers %>% mutate(d_is_worker = T)
workers <- workers %>% mutate(d_moved = ifelse(i_lvlhd_domicile_chng_self != 4, T, F))
workers <- workers %>% mutate(d_not_moved = ifelse(d_moved != T, T, F))

SET1 <- c("d_is_worker","d_moved","d_not_moved")
SaveChartData(workers, SET1, "MovementSplit")


workers <- workers %>% mutate(d_moved_temp = ifelse(((i_lvlhd_domicile_chng_self == 1)), T, F))
workers <- workers %>% mutate(d_moved_permanent = ifelse(((i_lvlhd_domicile_chng_self == 2 | i_lvlhd_domicile_chng_self == 3)), T, F))
workers <- workers %>% mutate(d_moved_permanent_neighbourhood = ifelse(((i_lvlhd_domicile_chng_self == 2 )), T, F))
workers <- workers %>% mutate(d_moved_permanent_city = ifelse(((i_lvlhd_domicile_chng_self == 3 )), T, F))
workers <- workers %>% mutate(d_moved_never = ifelse(((i_lvlhd_domicile_chng_self == 4)), T, F))

SET1 <- c("d_moved","d_moved_temp","d_moved_permanent")
SaveChartData(workers, SET1, "TempPermMigrationSplit")



workers <- workers %>% mutate(d_lost_job = ifelse((i_empl_covid_effects__1 == 1 | i_empl_covid_effects__2 == 1), T, F ))
workers <- workers %>% mutate(d_lost_job_but_working_now = ifelse((d_lost_job == T & (i_empl_jb_prsnt_status == 1 | i_empl_jb_prsnt_status == 2)), T, F ))
workers <- workers %>% mutate(d_lost_job_still_no_work = ifelse((d_lost_job == T & (i_empl_jb_prsnt_status != 1 & i_empl_jb_prsnt_status != 2)), T, F ))
workers <- workers %>% mutate(d_stayed_employed = ifelse((i_empl_covid_effects__1 != 1 & i_empl_covid_effects__2 != 1), T, F ))
workers <- workers %>% mutate(d_presently_employed = ifelse((d_stayed_employed == T | d_lost_job_but_working_now == T), T, F ))

workers <- workers %>% mutate(d_moved_temp_presently_employed = ifelse((d_moved_temp == T & d_presently_employed == T), T, F ))
workers <- workers %>% mutate(d_moved_temp_presently_not_employed = ifelse((d_moved_temp == T & d_presently_employed != T), T, F ))
SET1 <- c("d_moved_temp","d_moved_temp_presently_employed","d_moved_temp_presently_not_employed")
SaveChartData(workers, SET1, "TempEmployedSplit")

workers <- workers %>% mutate(d_moved_permanent_presently_employed = ifelse((d_moved_permanent == T & d_presently_employed == T), T, F ))
workers <- workers %>% mutate(d_moved_permanent_presently_not_employed = ifelse((d_moved_permanent == T & d_presently_employed != T), T, F ))
SET1 <- c("d_moved_permanent","d_moved_permanent_presently_employed","d_moved_permanent_presently_not_employed")
SaveChartData(workers, SET1, "PermEmployedSplit")


workers <- workers %>% mutate(d_switched_occupation = ifelse((i_empl_jb_in_tourism_change == 1 | i_empl_jb_in_tourism_change_add == 1), T, F )) %>% mutate(d_switched_occupation = ifelse(is.na(d_switched_occupation), F, d_switched_occupation))
workers <- workers %>% mutate(d_prsntly_empl_switched_occupation =  ifelse((d_switched_occupation == T & d_presently_employed == T), T, F))
workers <- workers %>% mutate(d_prsntly_empl_didnt_switch =  ifelse((d_switched_occupation == F  & d_presently_employed == T ), T, F))
SET1 <- c("d_presently_employed","d_prsntly_empl_switched_occupation","d_prsntly_empl_didnt_switch")
SaveChartData(workers, SET1, "PresentlyEmployedJobSwitchSplit")





