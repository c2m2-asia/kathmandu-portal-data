
# After downloading survey data from ONA, we noticed that columns have values stored as numeric codes. This code is responsible for mapping numeric values stored on ONA survey responses to their respective labels.
# Inputs: Business survey data file in XLS format and Business survey XLSform

# Libraries
library(tidyr)
library(reshape2)


# Imports
source("/home/samyoga/KLL/kathmandu-portal-data/utils/functions.R")
source("/home/samyoga/KLL/kathmandu-portal-data/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/business_data_20210510.xlsx")


# Survey data
businesses_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)

# Remove rows with NAs
business <- businesses_data %>% filter(!is.na(m_name_business))


# Separate dimensional Variables
univariateBusinessStatsForSS <- UNI.GetCountsAndProportionsSS(business, SS_VARS_BUSINESS)

# IO.SaveCsv(univariateStatsForSS, "univariateStats", CSV_EXPORT_PATH)
# IO.SaveJson(univariateStatsForSS, "univariateStats", JSON_EXPORT_PATH)

univariateBusinessStatsForMS <- UNI.GetCountsAndProportionsMSMultiQues(business, MS_VARS_BUSINESS)
allUnivariate <- rbind(univariateBusinessStatsForSS, univariateBusinessStatsForMS)#$#



path <- paste0(ROOT_URL, "misc/mapping_business.xlsx")
mapping <- IO.XlsSheetToDF(excel_sheets(path)[1], path) %>% select(variable, value, label_en, label_ne, choice_code, variable_group)
uni_w_labels <- left_join(allUnivariate, mapping)


IO.SaveCsv(uni_w_labels, "uni_w_labels", CSV_EXPORT_PATH_BUSINESSES)
IO.SaveJson(uni_w_labels, "uni_w_labels", JSON_EXPORT_PATH_BUSINESSES)


# Write to DB
DB.WriteToDb(DB.GetCon(), df = uni_w_labels, "businesses_univariate_stats")
# UNI.GenerateDistForEachVar(uni_w_labels)
