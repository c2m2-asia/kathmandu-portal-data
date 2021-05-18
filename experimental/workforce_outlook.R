# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/workers_data_20210510.xlsx")

# Survey data
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)

# Remove rows with NAs
workers <- workers_data %>% filter(!is.na(m_gender))



# Code
workers <- workers %>% mutate(d_is_worker = T)


RPRT.SaveDistData(workers, "o_econ_impact_how_long_months", "HowLongEconRecoveryDist")



workers <- workers %>% mutate(d_chllng_gain_tourst_trust  = ifelse(o_rcvry_chllng_trsm_revival__1 == 1, T, F))
workers <- workers %>% mutate(d_chllng_ensure_hhs  = ifelse(o_rcvry_chllng_trsm_revival__2 == 1, T, F))
workers <- workers %>% mutate(d_chllng_ovrcme_financial_hurdles  = ifelse(o_rcvry_chllng_trsm_revival__3 == 1, T, F))
workers <- workers %>% mutate(d_chllng_ovrcme_reduction_toursts  = ifelse(o_rcvry_chllng_trsm_revival__4 == 1, T, F))
workers <- workers %>% mutate(d_chllng_undrstd_src_market_dmd  = ifelse(o_rcvry_chllng_trsm_revival__5 == 1, T, F))
workers <- workers %>% mutate(d_chllng_othr  = ifelse(o_rcvry_chllng_trsm_revival__6 == 1, T, F))
workers <- workers %>% mutate(d_chllng_no_efct  = ifelse(o_rcvry_chllng_trsm_revival__7 == 1, T, F))

SET1 <- c(
  "d_chllng_ensure_hhs",
  "d_chllng_ovrcme_reduction_toursts",
  "d_chllng_ovrcme_financial_hurdles", 
  "d_chllng_gain_tourst_trust",
  "d_chllng_undrstd_src_market_dmd"
)
RPRT.SaveChartData(workers, SET1, "BiggestChallengesMultiple")

workers <- RPRT.CorrectBiggestPriorityVar(workers, "o_rcvry_chllng_trsm_revival", "o_rcvry_chllng_trsm_revival_rnk_1")
RPRT.SaveDistData(workers, "o_rcvry_chllng_trsm_revival_rnk_1", "BiggestChallengesRnk1Dist")

RPRT.SaveDistData(workers, "o_empl_status_to_nrml_how_long_months", "HowLongEmplymntRecoveryDist")

# o_rcvry_chllng_trsm_revival_rnk_1
