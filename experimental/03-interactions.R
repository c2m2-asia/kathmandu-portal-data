

library(dplyr)

library(tidyverse)  
library(broom)      
library(nnet)
##
# Import
##



source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/workers_data_20210425.xlsx")

# Survey data
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)



# Remove rows with NAs
workers <- workers_data %>% filter(!is.na(m_gender))

##
# Generate unemployment flag
##

summary(workers$i_empl_jb_prsnt_status)

# The present status.
# There are very few respondents who have left the tourism sector. There
# are even larger amounts of people who are unemployed but waiting for the tourism industry. 
# This definitely has to do with the way we approached our respondents. We went through 
# our network, and reached out to unions and associations that represent tourism workers in 
# different sectors.

workers <- workers %>% mutate(efct_unemployed = ifelse(((i_empl_jb_prsnt_status == 3) | (i_empl_jb_prsnt_status == 4) ), T, F ))



ads <- workers %>% select(m_gender, m_age, m_edu_levl, m_years_of_experience, efct_unemployed) 

ads$m_edu_levl <- relevel(ads$m_edu_levl, "2")


test <- multinom(efct_unemployed ~ ., data = ads)
test


z <- summary(test)$coefficients/summary(test)$standard.errors
z

p <- (1 - pnorm(abs(z), 0, 1))*2
p

head(fitted(test))
summary(test)
## Interpretation
# The log odds of being The log odds of being unemployed decreased by 0.55 if moving from gender="1” to gender=”2”.
# The log odds of being The log odds of being unemployed decreased significantly (greater than 7.89) if moving from m_edu_levl1 (Uneducated) to any other level.

# There is a great difference between 
summary(ads$m_edu_levl)
