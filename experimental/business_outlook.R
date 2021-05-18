# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/business_data_20210506.xlsx")

# Survey data
businesses <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)

# Code
businesses <- businesses %>% mutate(d_is_business = T)

RPRT.SaveDistData(businesses, "o_covid_how_long_it_last", "BizDisruptionLastDist")


RPRT.SaveDistData(businesses, "o_econ_impact_revenue_chng_21_v_19", "BizExpectedRevenueChangeDist")
RPRT.SaveDistData(businesses, "o_econ_impact_wrkfrc_chng_21_v_19", "BizExpectedWorkforceChangeDist")


businesses <- businesses %>% mutate(d_diff_trst_conf = ifelse(o_rcvry_biggest_diffclties__1 == 1, T , F))
businesses <- businesses %>% mutate(d_diff_und_src_market = ifelse(o_rcvry_biggest_diffclties__2 == 1, T , F))
businesses <- businesses %>% mutate(d_diff_ensure_hhs_guests = ifelse(o_rcvry_biggest_diffclties__3 == 1, T , F))
businesses <- businesses %>% mutate(d_diff_ensure_hhs_workers = ifelse(o_rcvry_biggest_diffclties__4 == 1, T , F))
businesses <- businesses %>% mutate(d_diff_shrtage_gds = ifelse(o_rcvry_biggest_diffclties__5 == 1, T , F))
businesses <- businesses %>% mutate(d_diff_shrtage_hr = ifelse(o_rcvry_biggest_diffclties__6 == 1, T , F))
businesses <- businesses %>% mutate(d_diff_shrtage_cash_flow = ifelse(o_rcvry_biggest_diffclties__7 == 1, T , F))
businesses <- businesses %>% mutate(d_diff_shrtage_add_loans = ifelse(o_rcvry_biggest_diffclties__8 == 1, T , F))
businesses <- businesses %>% mutate(d_diff_othrs = ifelse(o_rcvry_biggest_diffclties__9 == 1, T , F))

SET <- c(
  "d_diff_trst_conf",
  "d_diff_shrtage_cash_flow",
  "d_diff_shrtage_add_loans",
  "d_diff_ensure_hhs_guests",
  "d_diff_ensure_hhs_workers",
  "d_diff_und_src_market",
  "d_diff_shrtage_hr",
  "d_diff_shrtage_gds",
  "d_diff_othrs"
  
)
RPRT.SaveChartData(businesses, SET, "BizBiggestDifficultiesMultiples")



businesses <- RPRT.CorrectBiggestPriorityVar(businesses, "o_rcvry_biggest_diffclties", "o_rcvry_biggest_diffclties_rnk1")
RPRT.SaveDistData(businesses, "o_rcvry_biggest_diffclties_rnk1","BizBiggestDifficultiesRnk1Dist" )


RPRT.SaveDistData(businesses, "o_rcvry_biggest_support", "BizBiggestSupportDist")
