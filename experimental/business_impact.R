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

businesses$d_shut_down_perm


SET <- c("d_is_business", "d_shut_down_temp", "d_shut_down_perm", "d_shut_down_never")
RPRT.SaveChartData(businesses, SET, "BizOperationsShutDownSplit")
# RPRT.SaveDistData(businesses, "i_econ_stop_business", "BizOperationsShutDownDist")

businesses_ss <- businesses %>% filter(d_shut_down_temp == T)
RPRT.SaveDistData(businesses_ss, "i_econ_stop_business_how_lng", "BizOperationsTempShutDownDurationSplit")

RPRT.SaveDistData(businesses,"i_fin_revenue_chng_2020_v_2019" ,"BizRevenueChangeDist")


businesses <- businesses %>% mutate(i_fin_savings_chng_2020_v_2019_new = ifelse((i_fin_savings_chng_2020_v_2019 == 4 | i_fin_savings_chng_2020_v_2019 == 5), as.integer(9), as.integer(i_fin_savings_chng_2020_v_2019)))
businesses$i_fin_savings_chng_2020_v_2019_new <- businesses$i_fin_savings_chng_2020_v_2019_new + 1
RPRT.SaveDistData(businesses,"i_fin_savings_chng_2020_v_2019_new" ,"BizSavingsChangeDist")


RPRT.SaveDistData(businesses,"i_wrkfrc_size_chng_2020_v_2019" ,"BizWorkforceChangeDist")
