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


SaveChartDataSSQues <- function(DF, VARS, FILE) {
  final <- UNI.GetCountsAndProportionsSS(DF, VARS) 
  final <- final %>% 
    filter(value!=FALSE) %>%
    mutate(value = paste0(variable, "__",as.character(value))) %>%
    select(value, perc_of_total) %>%
    rename(label=value, value=perc_of_total)
  IO.SaveJson(final, FILE, JSON_EXPORT_PATH)
  return(final)
}


SaveDistData <- function(DF, VAR, FILE) {
  dist <- UNI.GetCountsAndProportionsSS(DF, c(VAR))
  path <- paste0(ROOT_URL, "misc/mapping.xlsx")
  mapping <- IO.XlsSheetToDF(excel_sheets(path)[1], path) %>% select(variable, value, label_ne, label_en)
  dist_w_labels <- left_join(dist, mapping)
  IO.SaveJson(dist_w_labels, FILE, JSON_EXPORT_PATH)
  return(dist_w_labels)
}


# Get multiples by sector
workers <- workers %>% mutate(d_occptn_exp_selling = ifelse((b_empl_occpatn_pre_covid__2 == 1 | b_empl_occpatn_pre_covid__3 == 1 | b_empl_occpatn_pre_covid__4 == 1 | b_empl_occpatn_pre_covid__5 == 1 ), T, F ) )
workers <- workers %>% mutate(d_occptn_travel = ifelse((b_empl_occpatn_pre_covid__6 == 1 | b_empl_occpatn_pre_covid__7 == 1 | b_empl_occpatn_pre_covid__8 == 1 | b_empl_occpatn_pre_covid__9 == 1 | b_empl_occpatn_pre_covid__15 == 1), T, F ) )
workers <- workers %>% mutate(d_occptn_accomodation = ifelse((b_empl_occpatn_pre_covid__10 == 1 | b_empl_occpatn_pre_covid__11 == 1 | b_empl_occpatn_pre_covid__12 == 1 | b_empl_occpatn_pre_covid__13 == 1 | b_empl_occpatn_pre_covid__14 == 1), T, F ) )
workers <- workers %>% mutate(d_occptn_othr = ifelse((b_empl_occpatn_pre_covid__16 == 1), T, F ) )

SET1 <- c("d_occptn_exp_selling","d_occptn_accomodation","d_occptn_travel", "d_occptn_othr")
SaveChartData(workers, SET1, "SectoralBreakdownMultiple")


SET1 <- c("m_years_of_experience")
SaveDistData(workers, "m_years_of_experience", "ExperienceBreakdownDist")


SET1 <- c("m_gender")
SaveDistData(workers, "m_gender", "GenderBreakDownDist")

SET1 <- c("m_edu_levl")
SaveDistData(workers, "m_edu_levl", "EduLevlBreakDownDist")



