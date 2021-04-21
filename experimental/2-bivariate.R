# After downloading survey data from ONA, we noticed that columns have alues stored as numeric codes. This code is responsible for mapping numeric values stored on ONA survey responses to their respective labels.
# Inputs: Workers survey data file in XLS format and Workers survey XLSform

# Libraries
library(tidyr)
library(MRCV)
library(reshape2)
library(stringr)
# Imports
source("C:/Users/arogy/projects/kathmandu-portal-data/utils/functions.R")
source("C:/Users/arogy/projects/kathmandu-portal-data/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/workers_data_20210420.xlsx")




# Survey data
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)
# summary(workers_data$m_gender)
# summary(workers_data$b_empl_occpatn_pre_covid)
# summary(workers_data$m_years_of_experience)

# Remove rows with NAs
workers <- workers_data %>% filter(!is.na(m_gender))


# # Create categorical variables
# workers <- workers %>% mutate(gender_category = m_gender)
# workers <- workers %>% mutate(age_category = m_age)
# workers <- workers %>% mutate(edu_levl_category = m_edu_levl)
# workers <- workers %>% mutate(exp_category = m_years_of_experience)




# Data Wrangling
MS_PREFIXES <- MS_VARS
SS_VARS <- SS_VARS


bivariateStatsSsMs <- BI.MultiGetPropCountsSsMs(workers, MS_PREFIXES, SS_VARS)
bivariateStatsSsSs <- BI.MultiGetPropCountSsSs(workers, SS_VARS)
bivariateStatsMsMs <- BI.MultiGetPropCountMsMs(workers, MS_PREFIXES)

bivariateFinal <- rbind(bivariateStatsSsMs, bivariateStatsSsSs)
bivariateFinal <- rbind(bivariateFinal, bivariateStatsMsMs)
IO.SaveCsv(bivariateFinal, "bivariateStatsExhaustive", CSV_EXPORT_PATH)





