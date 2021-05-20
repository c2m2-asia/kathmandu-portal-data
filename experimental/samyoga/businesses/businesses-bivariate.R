# After downloading survey data from ONA, we noticed that columns have values stored as numeric codes. This code is responsible for mapping numeric values stored on ONA survey responses to their respective labels.
# Inputs: Business survey data file in XLS format and Business survey XLSform

# Libraries
library(tidyr)
library(MRCV)
library(reshape2)
library(stringr)


# Imports
source("/home/samyoga/KLL/kathmandu-portal-data/utils/functions.R")
source("/home/samyoga/KLL/kathmandu-portal-data/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/business_data_20210510.xlsx")


# Survey data
businesses_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)
# summary(workers_data$m_gender)
# summary(workers_data$b_empl_occpatn_pre_covid)
# summary(workers_data$m_years_of_experience)

# Remove rows with NAs
business <- businesses_data %>% filter(!is.na(m_name_business))


# # Create categorical variables
# workers <- workers %>% mutate(gender_category = m_gender)
# workers <- workers %>% mutate(age_category = m_age)
# workers <- workers %>% mutate(edu_levl_category = m_edu_levl)
# workers <- workers %>% mutate(exp_category = m_years_of_experience)

# Data Wrangling
MS_PREFIXES <- MS_VARS_BUSINESS
SS_VARS <- SS_VARS_BUSINESS


bivariateStatsSsMs <- BI.MultiGetPropCountsSsMs(business, MS_PREFIXES, SS_VARS)
bivariateStatsSsSs <- BI.MultiGetPropCountSsSs(business, SS_VARS)
bivariateStatsMsMs <- BI.MultiGetPropCountMsMs(business, MS_PREFIXES)

bivariateFinal <- rbind(bivariateStatsSsMs, bivariateStatsSsSs)
bivariateFinal <- rbind(bivariateFinal, bivariateStatsMsMs)


mapping <- IO.XlsSheetToDF(excel_sheets(path)[1], path) %>% select(variable, value, label_ne, label_en, variable_group)
bivariate_w_label <- left_join(bivariateFinal, mapping, by = c("x_variable"="variable", "x_value"="value"))
names(bivariate_w_label)[7:8] <- c("x_label_ne", "x_label_en")

bivariate_w_label <- left_join(bivariate_w_label, mapping, by = c("y_variable"="variable", "y_value"="value"))
names(bivariate_w_label)[10:11] <- c("y_label_ne", "y_label_en")
bivariate_w_label <- bivariate_w_label %>% select(x_variable, x_value, x_label_ne, x_label_en, y_variable, y_value, y_label_ne, y_label_en, total, perc, variable_group.y )
names(bivariate_w_label)[10:11]<-c("perc_of_total", "variable_group")

# Adding auto-increment id
bivariateFinal1 <- cbind(choice_code = 1:nrow(bivariate_w_label), bivariate_w_label) 

bivariateFinal2 <- bivariateFinal1 %>% filter(!is.na(total))

IO.SaveCsv(bivariateFinal2, "bivariateStatsExhaustive", CSV_EXPORT_PATH_BUSINESSES)

# Write to DB
DB.WriteToDb(DB.GetCon(), df = bivariateFinal2, "businesses_bivariate_stats")




