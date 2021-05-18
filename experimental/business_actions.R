# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/business_data_20210506.xlsx")

# Survey data
businesses <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)



# Code
businesses <- businesses %>% mutate(d_is_business = T)

businesses <- RPRT.CorrectBiggestPriorityVar(businesses,"i_covid_effect_business", "i_covid_effect_business_rnk1" )
RPRT.SaveDistData(businesses, "i_covid_effect_business_rnk1", "BizMostDamagingFactorsRnk1Dist")


businesses <- businesses%>% mutate(d_factor_red_biz =  ifelse(i_covid_effect_business__1 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_incr_cov19_cases =  ifelse(i_covid_effect_business__2 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_empl_cov19 =  ifelse(i_covid_effect_business__3 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_hr_shrtage =  ifelse(i_covid_effect_business__4 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_sup_chn_disrupt =  ifelse(i_covid_effect_business__5 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_no_accs_govt_lockdn =  ifelse(i_covid_effect_business__6 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_no_mob_govt_lockdn =  ifelse(i_covid_effect_business__7 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_fallout_partnrs =  ifelse(i_covid_effect_business__8 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_lack_of_fin =  ifelse(i_covid_effect_business__9 == 1, T, F))
businesses <- businesses%>% mutate(d_factor_other =  ifelse(i_covid_effect_business__10 == 1, T, F))

SET<- c("d_factor_red_biz", 
         "d_factor_no_mob_govt_lockdn",
                   "d_factor_no_accs_govt_lockdn",
                   "d_factor_lack_of_fin",
                   "d_factor_incr_cov19_cases",
                   "d_factor_sup_chn_disrupt",
                   "d_factor_empl_cov19",
                   "d_factor_hr_shrtage",
                   "d_factor_fallout_partnrs",
                   "d_factor_other"
                   )

RPRT.SaveChartData(businesses, SET, "BizMostDamagingFactorsMultiples")

businesses <- businesses%>% mutate(d_wa_red_temp_workers =  ifelse(i_wrkfrc_actn_during_covid__1 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_red_perm_workers =  ifelse(i_wrkfrc_actn_during_covid__2 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_red_work_hrs =  ifelse(i_wrkfrc_actn_during_covid__3 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_start_rotation_empl =  ifelse(i_wrkfrc_actn_during_covid__4 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_ask_workrs_paid_leave =  ifelse(i_wrkfrc_actn_during_covid__5 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_ask_workrs_unpaid_leave =  ifelse(i_wrkfrc_actn_during_covid__6 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_ask_workrs_work_red_pay =  ifelse(i_wrkfrc_actn_during_covid__7 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_dec_or_rem_emp_benefts =  ifelse(i_wrkfrc_actn_during_covid__8 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_other =  ifelse(i_wrkfrc_actn_during_covid__9 == 1, T, F))
businesses <- businesses%>% mutate(d_wa_none =  ifelse(i_wrkfrc_actn_during_covid__10 == 1, T, F))
SET <- c(
  "d_wa_ask_workrs_unpaid_leave",
  "d_wa_red_perm_workers",
  "d_wa_red_temp_workers",
  "d_wa_red_work_hrs",
  "d_wa_dec_or_rem_emp_benefts",
  "d_wa_ask_workrs_work_red_pay",
  "d_wa_ask_workrs_paid_leave",
  "d_wa_start_rotation_empl",
  "d_wa_none",
  "d_wa_other"
)
RPRT.SaveChartData(businesses, SET, "BizWorkforceActionsMultiples")

businesses <- businesses%>% mutate(d_la_easy_take_loans =  ifelse(i_fin_effect_loan_avlblty__1 == 1, T, F))
businesses <- businesses%>% mutate(d_la_tried_cudnt_loans =  ifelse(i_fin_effect_loan_avlblty__2 == 1, T, F))
businesses <- businesses%>% mutate(d_la_diff_take_loans =  ifelse(i_fin_effect_loan_avlblty__3 == 1, T, F))
businesses <- businesses%>% mutate(d_la_diff_pay_loans =  ifelse(i_fin_effect_loan_avlblty__4 == 1, T, F))
businesses <- businesses%>% mutate(d_la_other =  ifelse(i_fin_effect_loan_avlblty__5 == 1, T, F))
businesses <- businesses%>% mutate(d_la_none =  ifelse(i_fin_effect_loan_avlblty__6 == 1, T, F))


SET <- c(
  "d_la_easy_take_loans",
  "d_la_tried_cudnt_loans",
  "d_la_diff_take_loans",
  "d_la_diff_pay_loans",
  "d_la_other",
  "d_la_none"
)
RPRT.SaveChartData(businesses, SET, "BizLoanActionsMultiples")

# Quick dive: loan accessibilty
businesses <- businesses %>% mutate(d_tried_taking_loans = ifelse((d_la_easy_take_loans==T | d_la_tried_cudnt_loans == T | d_la_diff_take_loans == T), T, F))
businesses <- businesses %>% mutate(d_not_tried_taking_loans = ifelse((d_tried_taking_loans == F), T, F))

SET <- c("d_is_business","d_tried_taking_loans", "d_not_tried_taking_loans")
RPRT.SaveChartData(businesses, SET, "LoanNoLoanSplit")





businesses <- businesses%>% mutate(d_assa_sold_some =  ifelse(i_fin_effect_asset_lqdty__1 == 1, T, F))
businesses <- businesses%>% mutate(d_assa_cudnt_sell_wnted_to =  ifelse(i_fin_effect_asset_lqdty__2 == 1, T, F))
businesses <- businesses%>% mutate(d_assa_rented_some =  ifelse(i_fin_effect_asset_lqdty__3 == 1, T, F))
businesses <- businesses%>% mutate(d_assa_other =  ifelse(i_fin_effect_asset_lqdty__4 == 1, T, F))
businesses <- businesses%>% mutate(d_assa_none =  ifelse(i_fin_effect_asset_lqdty__5 == 1, T, F))

SET <- c(
  "d_assa_sold_some",
  "d_assa_cudnt_sell_wnted_to",
  "d_assa_rented_some",
  "d_assa_other",
  "d_assa_none"
)
RPRT.SaveChartData(businesses, SET, "BizAssetActionsMultiples")

# Quick dive: Assest liquidity
businesses <- businesses %>% mutate(d_tried_sell_or_rent_assets = ifelse((d_assa_sold_some==T | d_assa_cudnt_sell_wnted_to == T | d_assa_rented_some == T), T, F))
businesses <- businesses %>% mutate(d_not_tried_sell_or_rent_assets = ifelse((d_tried_sell_or_rent_assets == F), T, F))

SET <- c("d_is_business","d_tried_sell_or_rent_assets", "d_not_tried_sell_or_rent_assets")
RPRT.SaveChartData(businesses, SET, "TrySellNoTrySellSplit")



businesses <- businesses%>% mutate(d_ca_cudnt_op_cost_cover =  ifelse(i_fin_effect_cost_invstmnt__1 == 1, T, F))
businesses <- businesses%>% mutate(d_ca_cancled_invstmn =  ifelse(i_fin_effect_cost_invstmnt__2 == 1, T, F))
businesses <- businesses%>% mutate(d_ca_had_made_signfct_invstments_vn2020 =  ifelse(i_fin_effect_cost_invstmnt__3 == 1, T, F))
businesses <- businesses%>% mutate(d_ca_other =  ifelse(i_fin_effect_cost_invstmnt__4 == 1, T, F))
businesses <- businesses%>% mutate(d_ca_none =  ifelse(i_fin_effect_cost_invstmnt__5 == 1, T, F))

# Quick dive: Assest liquidity
businesses <- businesses %>% mutate(d_no_vn_invstment = ifelse((d_ca_had_made_signfct_invstments_vn2020 == F), T, F))

SET <- c("d_is_business","d_ca_had_made_signfct_invstments_vn2020", "d_no_vn_invstment")
RPRT.SaveChartData(businesses, SET, "VnInvestmentSplit")



SET <- c(
  "d_ca_cudnt_op_cost_cover",
  "d_ca_cancled_invstmn",
  "d_ca_had_made_signfct_invstments_vn2020",
  "d_ca_other",
  "d_ca_none"
)
RPRT.SaveChartData(businesses, SET, "BizCostActionsMultiples")

businesses$d_ca_had_made_signfct_invstments_vn2020

businesses <- businesses%>% mutate(d_loca_moved =  ifelse(i_geog_effect_loc_chng__1 == 1, T, F))
businesses <- businesses%>% mutate(d_loca_closed_office =  ifelse(i_geog_effect_loc_chng__2 == 1, T, F))
businesses <- businesses%>% mutate(d_loca_try_but_cudnt_move =  ifelse(i_geog_effect_loc_chng__3 == 1, T, F))
businesses <- businesses%>% mutate(d_loca_other =  ifelse(i_geog_effect_loc_chng__4 == 1, T, F))
businesses <- businesses%>% mutate(d_loca_none =  ifelse(i_geog_effect_loc_chng__5 == 1, T, F))
SET <- c(
  "d_loca_moved",
  "d_loca_closed_office",
  "d_loca_try_but_cudnt_move",
  "d_loca_other",
  "d_loca_none"
)

RPRT.SaveChartData(businesses, SET, "BizLocationActionsMultiples")

# Quick dive: Assest mobility
businesses <- businesses %>% mutate(d_tried_move = ifelse((d_loca_moved==T | d_loca_try_but_cudnt_move == T), T, F))
businesses <- businesses %>% mutate(d_not_tried_move = ifelse((d_tried_move == F), T, F))


SET <- c("d_is_business","d_tried_move", "d_not_tried_move")
RPRT.SaveChartData(businesses, SET, "TryMoveNoTryMoveSplit")


businesses <- businesses %>% mutate(d_no_shut = ifelse((d_loca_closed_office == F), T, F))
SET <- c("d_is_business","d_loca_closed_office", "d_no_shut")
RPRT.SaveChartData(businesses, SET, "ShutNoShutSplit")



businesses <- businesses%>% mutate(d_equia_sold_biz =  ifelse(i_fin_effct_eqty_ownrshp__1 == 1, T, F))
businesses <- businesses%>% mutate(d_equia_try_but_cudnt_sell_biz =  ifelse(i_fin_effct_eqty_ownrshp__2 == 1, T, F))
businesses <- businesses%>% mutate(d_equia_sold_equity =  ifelse(i_fin_effct_eqty_ownrshp__3 == 1, T, F))
businesses <- businesses%>% mutate(d_equia_try_but_cudnt_sell_equity =  ifelse(i_fin_effct_eqty_ownrshp__4 == 1, T, F))
businesses <- businesses%>% mutate(d_equia_other =  ifelse(i_fin_effct_eqty_ownrshp__5 == 1, T, F))
businesses <- businesses%>% mutate(d_equia_none =  ifelse(i_fin_effct_eqty_ownrshp__6 == 1, T, F))

SET <- c(
  "d_equia_sold_biz",
  "d_equia_try_but_cudnt_sell_biz",
  "d_equia_sold_equity",
  "d_equia_try_but_cudnt_sell_equity",
  "d_equia_other",
  "d_equia_none"
)
RPRT.SaveChartData(businesses, SET, "BizEquityActionsMultiples")



# Quick dive: Equity and ownership actions
businesses <- businesses %>% mutate(d_tried_sell_equity = ifelse((d_equia_try_but_cudnt_sell_equity==T | d_equia_sold_equity == T), T, F))
businesses <- businesses %>% mutate(d_not_tried_sell_equity = ifelse((d_tried_sell_equity == F), T, F))
SET <- c("d_is_business","d_tried_sell_equity", "d_not_tried_sell_equity")
RPRT.SaveChartData(businesses, SET, "TrySellEquityOrNotSplit")


businesses <- businesses %>% mutate(d_tried_sell_biz = ifelse((d_equia_try_but_cudnt_sell_biz==T | d_equia_sold_biz == T), T, F))
businesses <- businesses %>% mutate(d_not_tried_sell_biz = ifelse((d_tried_sell_biz == F), T, F))
SET <- c("d_is_business","d_tried_sell_biz", "d_not_tried_sell_biz")
RPRT.SaveChartData(businesses, SET, "TrySellBizOrNotSplit")







businesses <- businesses%>% mutate(d_in_str_red_prod =  ifelse(p_recvry_strategic_actions_internl__1 == 1, T, F))
businesses <- businesses%>% mutate(d_in_str_incr_prod =  ifelse(p_recvry_strategic_actions_internl__2 == 1, T, F))
businesses <- businesses%>% mutate(d_in_str_diversify_prod =  ifelse(p_recvry_strategic_actions_internl__3 == 1, T, F))
businesses <- businesses%>% mutate(d_in_str_dif_biz =  ifelse(p_recvry_strategic_actions_internl__4 == 1, T, F))
businesses <- businesses%>% mutate(d_in_str_diversify_sales_chnl =  ifelse(p_recvry_strategic_actions_internl__5 == 1, T, F))
businesses <- businesses%>% mutate(d_in_str_retrain_workers =  ifelse(p_recvry_strategic_actions_internl__6 == 1, T, F))
businesses <- businesses%>% mutate(d_in_str_other =  ifelse(p_recvry_strategic_actions_internl__7 == 1, T, F))
businesses <- businesses%>% mutate(d_in_str_none =  ifelse(p_recvry_strategic_actions_internl__8 == 1, T, F))
SET <- c(
  "d_in_str_none",
  "d_in_str_red_prod",
  "d_in_str_incr_prod",
  "d_in_str_diversify_prod",
  "d_in_str_dif_biz",
  "d_in_str_diversify_sales_chnl",
  "d_in_str_retrain_workers",
  "d_in_str_other"
)
RPRT.SaveChartData(businesses, SET, "InternalStrategicActionsMultiples")




businesses <- businesses%>% mutate(d_ext_str_ng_pymnt_bnks =  ifelse(p_recvry_strategic_actions_externl__1 == 1, T, F))
businesses <- businesses%>% mutate(d_ext_str_lbbying_sprt =  ifelse(p_recvry_strategic_actions_externl__2 == 1, T, F))
businesses <- businesses%>% mutate(d_ext_str_ng_workers_unions =  ifelse(p_recvry_strategic_actions_externl__3 == 1, T, F))
businesses <- businesses%>% mutate(d_ext_str_ng_prop_owners =  ifelse(p_recvry_strategic_actions_externl__4 == 1, T, F))
businesses <- businesses%>% mutate(d_ext_str_partnr_other_bizs =  ifelse(p_recvry_strategic_actions_externl__5 == 1, T, F))
businesses <- businesses%>% mutate(d_ext_str_incr_shr_holders =  ifelse(p_recvry_strategic_actions_externl__6 == 1, T, F))
businesses <- businesses%>% mutate(d_ext_str_shre_prop_assets =  ifelse(p_recvry_strategic_actions_externl__7 == 1, T, F))
businesses <- businesses%>% mutate(d_ext_str_other =  ifelse(p_recvry_strategic_actions_externl__8 == 1, T, F))
businesses <- businesses%>% mutate(d_ext_str_none =  ifelse(p_recvry_strategic_actions_externl__9 == 1, T, F))
SET <- c(
  "d_ext_str_none",
  "d_ext_str_ng_pymnt_bnks",
  "d_ext_str_lbbying_sprt",
  "d_ext_str_ng_workers_unions",
  "d_ext_str_ng_prop_owners",
  "d_ext_str_partnr_other_bizs",
  "d_ext_str_incr_shr_holders",
  "d_ext_str_shre_prop_assets",
  "d_ext_str_other"
)
RPRT.SaveChartData(businesses, SET, "ExtStrategicActionsMultiples")


businesses <- businesses %>% mutate(d_hhs_measure_sanitizers =  ifelse(p_hlth_hhs_measures__1 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_empl_hhs_train =  ifelse(p_hlth_hhs_measures__2 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_thrmal_screening =  ifelse(p_hlth_hhs_measures__3 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_social_dist =  ifelse(p_hlth_hhs_measures__4 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_cshless_pymnts =  ifelse(p_hlth_hhs_measures__5 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_discont_buffet =  ifelse(p_hlth_hhs_measures__6 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_cov19_frndly_mrktg =  ifelse(p_hlth_hhs_measures__7 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_outsrc_serv =  ifelse(p_hlth_hhs_measures__8 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_other =  ifelse(p_hlth_hhs_measures__9 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_measure_none =  ifelse(p_hlth_hhs_measures__10 == 1, T, F))
SET <- c(
  "d_hhs_measure_sanitizers",
  "d_hhs_measure_social_dist",
  "d_hhs_measure_empl_hhs_train",
  "d_hhs_measure_thrmal_screening",
  "d_hhs_measure_cshless_pymnts",
  "d_hhs_measure_cov19_frndly_mrktg",
  "d_hhs_measure_discont_buffet",
  "d_hhs_measure_outsrc_serv",
  "d_hhs_measure_other",
  "d_hhs_measure_none"
)
RPRT.SaveChartData(businesses, SET, "HHSActionsMultiples")



businesses <- businesses %>% mutate(d_hhs_wrkr_inform =  ifelse(p_hlth_safety_measures__1 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_wrkr_sty_home =  ifelse(p_hlth_safety_measures__2 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_wrkr_soc_dist =  ifelse(p_hlth_safety_measures__3 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_wrk_shifts =  ifelse(p_hlth_safety_measures__4 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_telewrk =  ifelse(p_hlth_safety_measures__5 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_temp_checks =  ifelse(p_hlth_safety_measures__6 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_provide_ppe =  ifelse(p_hlth_safety_measures__7 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_ext_sick_leave =  ifelse(p_hlth_safety_measures__8 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_cov19_ins =  ifelse(p_hlth_safety_measures__9 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_other =  ifelse(p_hlth_safety_measures__10 == 1, T, F))
businesses <- businesses %>% mutate(d_hhs_none =  ifelse(p_hlth_safety_measures__11 == 1, T, F))
SET <- c(
  "d_hhs_wrkr_sty_home",
  "d_hhs_wrkr_inform",
  "d_hhs_wrkr_soc_dist",
  "d_hhs_provide_ppe",
  "d_hhs_temp_checks",
  "d_hhs_wrk_shifts",
  "d_hhs_cov19_ins",
  "d_hhs_ext_sick_leave",
  "d_hhs_telewrk",
  "d_hhs_other",
  "d_hhs_none"
)
RPRT.SaveChartData(businesses, SET, "HHSInwardActionsMultiples")
