# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/workers_data_20210510.xlsx")

# Survey data
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)

# Remove rows with NAs
workers <- workers_data %>% filter(!is.na(m_gender))

# Functions


# Code
workers <- workers %>% mutate(d_is_worker = T)


workers <- RPRT.CorrectBiggestPriorityVar(workers, "n_rcvry_preferred_incentives", "n_rcvry_preferred_incentives_rnk_1")
RPRT.SaveDistData(workers, "n_rcvry_preferred_incentives_rnk_1", "NeedsRnk1Dist")

workers <- workers %>% mutate(d_need_health_training  = ifelse(n_rcvry_preferred_incentives__1 == 1, T, F))
workers <- workers %>% mutate(d_need_grants  = ifelse(n_rcvry_preferred_incentives__10 == 1, T, F))
workers <- workers %>% mutate(d_need_psych_counseling  = ifelse(n_rcvry_preferred_incentives__11 == 1, T, F))
workers <- workers %>% mutate(d_need_prof_dev_training  = ifelse(n_rcvry_preferred_incentives__2 == 1, T, F))
workers <- workers %>% mutate(d_need_new_skill_dev_opportunities  = ifelse(n_rcvry_preferred_incentives__3 == 1, T, F))
workers <- workers %>% mutate(d_need_employment_opportunities  = ifelse(n_rcvry_preferred_incentives__4 == 1, T, F))
workers <- workers %>% mutate(d_need_borrowing_discounted_rate  = ifelse(n_rcvry_preferred_incentives__5 == 1, T, F))
workers <- workers %>% mutate(d_need_special_interest_rate_discounts  = ifelse(n_rcvry_preferred_incentives__6 == 1, T, F))
workers <- workers %>% mutate(d_need_tax_discounts  = ifelse(n_rcvry_preferred_incentives__7 == 1, T, F))
workers <- workers %>% mutate(d_need_loan_period_extnsn_dfrl  = ifelse(n_rcvry_preferred_incentives__8 == 1, T, F))
workers <- workers %>% mutate(d_need_social_security  = ifelse(n_rcvry_preferred_incentives__9 == 1, T, F))
workers <- workers %>% mutate(d_need_other  = ifelse(n_rcvry_preferred_incentives__12 == 1, T, F))
workers <- workers %>% mutate(d_need_no_effect  = ifelse(n_rcvry_preferred_incentives__13 == 1, T, F))



SET1 <- c(
          "d_need_borrowing_discounted_rate",
          "d_need_grants",
          "d_need_social_security",
          "d_need_special_interest_rate_discounts", 
          "d_need_loan_period_extnsn_dfrl",
          "d_need_tax_discounts"
          )
RPRT.SaveChartData(workers, SET1, "FinancialNeedsMultiple")


SET1 <- c(
  "d_need_health_training",
  "d_need_psych_counseling"

)
RPRT.SaveChartData(workers, SET1, "HealthNeedsMultiple")



SET1 <- c(
  "d_need_social_security",
  "d_need_prof_dev_training",
  "d_need_employment_opportunities",
  "d_need_new_skill_dev_opportunities"
)
RPRT.SaveChartData(workers, SET1, "ProfessionalNeedsMultiple")
