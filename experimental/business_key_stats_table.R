# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/business_data_20210506.xlsx")



# Survey data
businesses <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)

businesses <- businesses %>% mutate(d_is_business = T)
businesses <- businesses %>% mutate(d_shut_down = ifelse((i_econ_stop_business == 2 | i_econ_stop_business== 3), T, F))
businesses <- businesses %>% mutate(d_shut_down_temp = ifelse((i_econ_stop_business == 2), T, F))
businesses <- businesses %>% mutate(d_shut_down_perm = ifelse((i_econ_stop_business == 3), T, F))

businesses <- businesses %>% mutate(d_shut_down_never = ifelse((i_econ_stop_business == 1), T, F))

businesses <- businesses %>% mutate(d_currently_operational = ifelse((d_shut_down_never == T | d_shut_down_temp == T), T, F))
businesses <- businesses %>% mutate(i_fin_savings_chng_2020_v_2019_new = ifelse((i_fin_savings_chng_2020_v_2019 == 4 | i_fin_savings_chng_2020_v_2019 == 5), as.integer(9), as.integer(i_fin_savings_chng_2020_v_2019)))
businesses$i_fin_savings_chng_2020_v_2019_new <- businesses$i_fin_savings_chng_2020_v_2019_new + 1
# MapDistToLabel <- function(dist) {
#   path <- paste0(ROOT_URL, "misc/mapping.xlsx")
#   mapping <- IO.XlsSheetToDF(excel_sheets(path)[1], path) %>% select(variable, value, label_ne, label_en)
#   dist_w_labels <- left_join(dist, mapping)
#   print(dist_w_labels)
#   return(dist_w_labels)
# }
# 
# 
# dist <- UNI.GetCountsAndProportionsSS(DF = businesses, INPUTVARS = dims)
# dlabel <- MapDistToLabel(dist)
#   
# function (df, var)   {
#   df  <- df %>% select(!!as.symbol(var))
# }
#   
# 
# businesses %>% mutate(d_shut_down_perm = ifelse((i_econ_stop_business == 3), T, F))

RPRT.SaveDistData(businesses, "m_biz_years_in_operation", "AllBusinessYearsInOpSplit")
RPRT.SaveDistData(businesses, "m_biz_type", "AllBusinessTypeInOpSplit")
RPRT.SaveDistData(businesses, "b_n_emplyes_pre_covid", "AllBusinessEmployeesInOpSplit")


closed_businesses <- businesses %>% filter(d_shut_down_perm == T)
RPRT.SaveDistData(closed_businesses, "m_biz_years_in_operation", "ClosedBusinessYearsInOpSplit")
RPRT.SaveDistData(closed_businesses, "m_biz_type", "ClosedBusinessTypeInOpSplit")
RPRT.SaveDistData(closed_businesses, "b_n_emplyes_pre_covid", "ClosedBusinessEmployeesInOpSplit")
RPRT.SaveDistData(closed_businesses,"i_fin_savings_chng_2020_v_2019_new" ,"ClosedBusinessSavingsChangeDist")
RPRT.SaveDistData(closed_businesses,"i_fin_revenue_chng_2020_v_2019" ,"ClosedBusinessRevenueChangeDist")
# RPRT.SaveDistData(closed_businesses, "i_econ_stop_business_how_lng", "ClosedBusinessOperationsTempShutDownDurationSplit")




temp_businesses <- businesses %>% filter(d_shut_down_temp == T)
RPRT.SaveDistData(temp_businesses, "m_biz_years_in_operation", "TempCloseBusinessYearsInOpSplit")
RPRT.SaveDistData(temp_businesses, "m_biz_type", "TempCloseBusinessTypeInOpSplit")
RPRT.SaveDistData(temp_businesses, "b_n_emplyes_pre_covid", "TempCloseBusinessEmployeesInOpSplit")
RPRT.SaveDistData(temp_businesses,"i_fin_savings_chng_2020_v_2019_new" ,"TempClosedBusinessSavingsChangeDist")
RPRT.SaveDistData(temp_businesses,"i_fin_revenue_chng_2020_v_2019" ,"TempClosedBusinessRevenueChangeDist")
RPRT.SaveDistData(temp_businesses, "i_econ_stop_business_how_lng", "TempClosedBusinessOperationsTempShutDownDurationSplit")
RPRT.SaveDistData(temp_businesses,"i_wrkfrc_size_chng_2020_v_2019" ,"TempClosedBusinessWorkforceChangeDist")

businesses %>% filter(d_shut_down_perm == T) %>% group_by(m_biz_years_in_operation) %>% summarise(n = n())


never_closed_businesses <- businesses %>% filter(d_shut_down_never == T)
RPRT.SaveDistData(never_closed_businesses, "m_biz_years_in_operation", "NeverCloseBusinessYearsInOpSplit")
RPRT.SaveDistData(never_closed_businesses, "m_biz_type", "NeverCloseBusinessTypeInOpSplit")
RPRT.SaveDistData(never_closed_businesses, "b_n_emplyes_pre_covid", "NeverCloseBusinessEmployeesInOpSplit")

RPRT.SaveDistData(never_closed_businesses,"i_fin_savings_chng_2020_v_2019_new" ,"NeverClosedBusinessSavingsChangeDist")
RPRT.SaveDistData(never_closed_businesses,"i_fin_revenue_chng_2020_v_2019" ,"NeverClosedBusinessRevenueChangeDist")
RPRT.SaveDistData(never_closed_businesses, "i_econ_stop_business_how_lng", "NeverClosedBusinessOperationsTempShutDownDurationSplit")
RPRT.SaveDistData(never_closed_businesses,"i_wrkfrc_size_chng_2020_v_2019" ,"NeverClosedBusinessWorkforceChangeDist")





currently_running_businesses <- businesses %>% filter(d_currently_operational == T)
RPRT.SaveDistData(currently_running_businesses,"i_fin_savings_chng_2020_v_2019_new" ,"CurrntlyRunBusinessSavingsChangeDist")
RPRT.SaveDistData(currently_running_businesses,"i_fin_revenue_chng_2020_v_2019" ,"CurrntlyRunBusinessRevenueChangeDist")
RPRT.SaveDistData(currently_running_businesses, "i_econ_stop_business_how_lng", "CurrntlyRunBusinessOperationsTempShutDownDurationSplit")
RPRT.SaveDistData(currently_running_businesses,"i_fin_revenue_chng_2020_v_2019" ,"CurrntlyRunClosedBusinessRevenueChangeDist")
