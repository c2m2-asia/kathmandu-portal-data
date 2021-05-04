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
  return(dist)
}





workers <- workers %>% mutate(d_psychologically_affected = ifelse((i_mental_hlth_think == 2 | i_mental_hlth_overconcerned == 2 | i_mental_hlth_neg_think == 2 | i_mental_hlth_blame == 2 | i_mental_hlth_social== 2 |  i_mental_hlth_detached == 2 | i_mental_hlth_fml ==2), T, F )) 
summary(workers$d_psychologically_affected)
SaveDistData(workers, "d_psychologically_affected", "PsychologicallyAffectedDist")

summary(workers$i_mental_hlth_blame)
workers$i_mental_hlth_blame <- ifelse(workers$i_mental_hlth_blame == 2, T, F)
workers$i_mental_hlth_think <- ifelse(workers$i_mental_hlth_think == 2, T, F)
workers$i_mental_hlth_detached <- ifelse(workers$i_mental_hlth_detached == 2, T, F)
workers$i_mental_hlth_fml <- ifelse(workers$i_mental_hlth_fml == 2, T, F)
workers$i_mental_hlth_neg_think <- ifelse(workers$i_mental_hlth_neg_think == 2, T, F)
workers$i_mental_hlth_social <- ifelse(workers$i_mental_hlth_social == 2, T, F)
workers$i_mental_hlth_overconcerned <- ifelse(workers$i_mental_hlth_overconcerned == 2, T, F)

SET1 <- c(
  "i_mental_hlth_think",
  "i_mental_hlth_overconcerned",
  "i_mental_hlth_neg_think",
  "i_mental_hlth_detached",
  "i_mental_hlth_fml", 
  "i_mental_hlth_blame",
  "i_mental_hlth_social"
  
)


SaveChartData(workers, SET1, "PsychosocialEffectsMultiples")


SaveDistData(workers, "i_mental_hlth_therapy", "CounselingDist")
