# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/business_data_20210506.xlsx")

# Survey data
businesses <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)




# Code
businesses <- businesses %>% mutate(d_is_business = T)
businesses <- businesses %>% mutate(d_shut_down = ifelse((i_econ_stop_business == 2 | i_econ_stop_business== 3), T, F))
businesses <- businesses %>% mutate(d_shut_down_temp = ifelse((i_econ_stop_business == 2), T, F))
businesses <- businesses %>% mutate(d_shut_down_perm = ifelse((i_econ_stop_business == 3), T, F))
businesses <- businesses %>% mutate(d_shut_down_never = ifelse((i_econ_stop_business == 1), T, F))
businesses <- businesses %>% mutate(d_currently_operational = ifelse((d_shut_down_never == T | d_shut_down_temp == T), T, F))

businesses <- businesses %>% mutate(d_n6m_pyng_loans = ifelse(o_expectd_problms_next_6_mnths__1 == 1, T , F))
businesses <- businesses %>% mutate(d_n6m_acqr_loans = ifelse(o_expectd_problms_next_6_mnths__2 == 1, T , F))
businesses <- businesses %>% mutate(d_n6m_pyng_tax = ifelse(o_expectd_problms_next_6_mnths__3 == 1, T , F))
businesses <- businesses %>% mutate(d_n6m_covr_op_costs = ifelse(o_expectd_problms_next_6_mnths__4 == 1, T , F))
businesses <- businesses %>% mutate(d_n6m_labr_issues = ifelse(o_expectd_problms_next_6_mnths__5 == 1, T , F))
businesses <- businesses %>% mutate(d_n6m_getng_cust = ifelse(o_expectd_problms_next_6_mnths__6 == 1, T , F))
businesses <- businesses %>% mutate(d_n6m_none = ifelse(o_expectd_problms_next_6_mnths__7 == 1, T , F))




SET <- c(
  "d_n6m_covr_op_costs",
  "d_n6m_pyng_loans",
  "d_n6m_getng_cust",
  "d_n6m_pyng_tax",
  "d_n6m_acqr_loans",
  "d_n6m_labr_issues",
  "d_n6m_none"
         )
RPRT.SaveChartData(businesses, SET, "NextSixMonthsBusinessProblemsMultiples")


businessesss <- businesses %>% filter(!is.na(n_rcvry_preferred_loan_pybck_incntv))
RPRT.SaveDistData(businessesss, "n_rcvry_preferred_loan_pybck_incntv", "MostHelpfulLoanPaybackDist")


businessesss <- businesses %>% filter(!is.na(n_rcvry_preferred_outreach_other))
RPRT.SaveDistData(businessesss, "n_rcvry_preferred_outreach_other", "PreferredOutreachAssistanceDist")

businessesss <- businesses %>% filter(!is.na(n_rcvry_preferred_tax_asstnc))
RPRT.SaveDistData(businessesss, "n_rcvry_preferred_tax_asstnc", "PreferredTaxAssistanceDist")

businessesss <- businesses %>% filter(!is.na(n_rcvry_preferred_tax_asstn_other))
RPRT.SaveDistData(businessesss, "n_rcvry_preferred_tax_asstn_other", "PreferredOpsAsstncDist")


businessesss <- businesses %>% filter(!is.na(n_rcvry_preferred_fin_source))
RPRT.SaveDistData(businessesss, "n_rcvry_preferred_fin_source", "PreferredSourceFinAssistanceDist")
nrow(businessesss) # 32

businessesss <- businesses %>% filter(!is.na(n_rcvry_preferred_fund_aprvl_incntv))
RPRT.SaveDistData(businessesss, "n_rcvry_preferred_fund_aprvl_incntv", "MostHelpfulFundsAssistanceDist")









businessesss <- businesses %>% filter(!is.na(n_rcvry_preferred_labor_asstnc))
RPRT.SaveDistData(businessesss, "n_rcvry_preferred_labor_asstnc", "PreferredLaborAssistanceDist")




# Policy Level Support

businesses <- businesses %>% mutate(d_policy_info = ifelse(n_rcvry_preferred_gov_policy__1 == 1, T , F))
businesses <- businesses %>% mutate(d_policy_reg_ports = ifelse(n_rcvry_preferred_gov_policy__2 == 1, T , F))
businesses <- businesses %>% mutate(d_policy_trsm_protectn_fund = ifelse(n_rcvry_preferred_gov_policy__3 == 1, T , F))
businesses <- businesses %>% mutate(d_policy_job_ret_fund = ifelse(n_rcvry_preferred_gov_policy__4 == 1, T , F))
businesses <- businesses %>% mutate(d_policy_fin_asst = ifelse(n_rcvry_preferred_gov_policy__5 == 1, T , F))
businesses <- businesses %>% mutate(d_policy_ryg_stkr = ifelse(n_rcvry_preferred_gov_policy__6 == 1, T , F))
businesses <- businesses %>% mutate(d_policy_skill_enhnc_trng = ifelse(n_rcvry_preferred_gov_policy__7 == 1, T , F))
businesses <- businesses %>% mutate(d_policy_tot_hhs = ifelse(n_rcvry_preferred_gov_policy__8 == 1, T , F))
businesses <- businesses %>% mutate(d_policy_other = ifelse(n_rcvry_preferred_gov_policy__9 == 1, T , F))


SET <- c(
  "d_policy_trsm_protectn_fund",
  "d_policy_fin_asst",
  "d_policy_reg_ports",
  "d_policy_info",
  "d_policy_ryg_stkr",
  "d_policy_job_ret_fund",
  "d_policy_tot_hhs",
  "d_policy_skill_enhnc_trng",
  "d_policy_other"
)
RPRT.SaveChartData(businesses, SET, "PolicySupportMultiples")

