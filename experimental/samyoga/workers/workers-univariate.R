
# After downloading survey data from ONA, we noticed that columns have values stored as numeric codes. This code is responsible for mapping numeric values stored on ONA survey responses to their respective labels.
# Inputs: Workers survey data file in XLS format and Workers survey XLSform

# Libraries
library(tidyr)
library(reshape2)


# Imports
source("/home/samyoga/KLL/kathmandu-portal-data/utils/functions.R")
source("/home/samyoga/KLL/kathmandu-portal-data/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/workers_data_20210504.xlsx")




# Survey data
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)
# summary(workers_data$m_gender)
# summary(workers_data$b_empl_occpatn_pre_covid)
# summary(workers_data$m_years_of_experience)

# Remove rows with NAs
workers <- workers_data %>% filter(!is.na(m_gender))


# Separate dimensional Variables
univariateStatsForSS <- UNI.GetCountsAndProportionsSS(workers, SS_VARS)

# IO.SaveCsv(univariateStatsForSS, "univariateStats", CSV_EXPORT_PATH)
# IO.SaveJson(univariateStatsForSS, "univariateStats", JSON_EXPORT_PATH)

univariateStatsForMS <- UNI.GetCountsAndProportionsMSMultiQues(workers, MS_VARS)
allUnivariate <- rbind(univariateStatsForSS, univariateStatsForMS)#$#



path <- paste0(ROOT_URL, "misc/mapping.xlsx")
mapping <- IO.XlsSheetToDF(excel_sheets(path)[1], path) %>% select(variable, value, label_ne, label_en)
uni_w_labels <- left_join(allUnivariate, mapping)




IO.SaveCsv(uni_w_labels, "uni_w_labels", CSV_EXPORT_PATH)
IO.SaveJson(uni_w_labels, "uni_w_labels", JSON_EXPORT_PATH)


# Write to DB
DB.WriteToDb(DB.GetCon(), df = uni_w_labels, "workers_univariate_stats")
UNI.GenerateDistForEachVar(uni_w_labels)
