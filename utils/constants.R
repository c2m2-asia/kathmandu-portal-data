# PATHS
ROOT_URL <- "/home/samyoga/KLL/kathmandu-portal-data/"
JSON_EXPORT_PATH_WORKFORCES <- paste0(ROOT_URL, "exports/json/workforces")
CSV_EXPORT_PATH_WORKFORCES <- paste0(ROOT_URL, "exports/csv/workforces")
JSON_EXPORT_PATH_BUSINESSES <- paste0(ROOT_URL, "exports/json/businesses")
CSV_EXPORT_PATH_BUSINESSES <- paste0(ROOT_URL, "exports/csv/businesses")


# Separate flag variables
DIMENSIONAL_VARS <- c("gender_category",  "age_category", "edu_levl_category", "exp_category")

ID_VARS <- c("X_index", "X_uuid", "X_submission_time" )
META_VARS <- c("m_name", "m_gender",  "m_age", "m_edu_levl","m_years_of_experience", "m_phone") 
ID_AND_META_VARS <- c(ID_VARS, META_VARS)  

MS_VARS_WORKERS <- c("b_empl_occpatn_pre_covid",
             "b_empl_trsm_major_districts",
             "b_empl_trsm_org",
             "b_empl_wrk_type",
             "i_econ_covid_effects",
             "i_empl_covid_effects",
             "n_rcvry_preferred_incentives",
             "o_impct_to_self_nxt_6_mnths",
             "o_rcvry_chllng_trsm_revival",
             # "p_econ_altrnt_incm_src_self_fml",
             "p_econ_hhd_items_post_covid",
             "p_econ_hhd_items_pre_covid",
             "p_hlth_hhs_training_src",
             "p_hlth_info_covid_src"
             )


SS_VARS_WORKERS <- c("b_empl_frml_agrmnt_status_pre_covid",
                        "b_empl_had_pan_pre_covid",
                        "b_empl_wrk_sesonal_period",
                        "i_econ_incm_chng_self",
                        "i_empl_emplyr_in_tourism_change_post_covid",
                        "i_empl_emplyr_in_tourism_change_post_covid_add",
                        "i_empl_emplyr_in_tourism_prsnt_frml_agrmnt_status_add",
                        "i_empl_in_tourism_paid_tax_post_covid_add",
                        # "i_empl_jb_in_tourism_changed_to_other",
                        "i_empl_jb_prsnt_status",
                        "i_empl_lst_date_full_salary",
                        "i_hlth_covid_infectn_family",
                        "i_hlth_covid_infectn_self",
                        "i_hlth_covid_infectn_self_time",
                        "i_lvlhd_domicile_chng_self",
                        "i_lvlhd_domicile_chng_self_temp_tm_prd",
                        "i_mental_hlth_blame",
                        "i_mental_hlth_detached",
                        "i_mental_hlth_fml",
                        "i_mental_hlth_neg_think",
                        "i_mental_hlth_overconcerned",
                        "i_mental_hlth_social",
                        "i_mental_hlth_therapy",
                        "i_mental_hlth_think",
                        "m_age",
                        "m_dist_perm",
                        "m_dist_temp",
                        "m_edu_levl",
                        "m_gender",
                        "m_mun_perm",
                        "m_mun_temp",
                        "m_years_of_experience",
                        "o_econ_impact_fml_income_chng_21_v_19",
                        "o_econ_impact_how_long_months",
                        "o_empl_status_to_nrml_how_long_months",
                        "p_econ_outstndng_loans_self",
                        "p_econ_self_savings_chng_today_v_19",
                        "p_hlth_received_hhs_training_self",
                        "p_hlth_vaccinated_self",
                        "p_lvlhd_num_depndnt_fml_membrs_post_covid",
                        "p_lvlhd_num_depndnt_fml_membrs_pre_covid",
                        "p_lvlhd_num_depndnt_need_fml_membrs_post_covid"
                        
                        )



FLAG_VARS <- c(
  "b_empl_trsm_major_districts",
  "i_econ_covid_effects",
  "i_empl_covid_effects",
  "n_rcvry_preferred_incentives",
  "o_impct_to_self_nxt_6_mnths",
  "o_rcvry_chllng_trsm_revival",
  "p_econ_altrnt_incm_src_self_fml",
  "p_econ_hhd_items_post_covid",
  "p_econ_hhd_items_pre_covid",
  "p_hlth_hhs_training_src",
  "p_hlth_info_covid_src"
)

# Separate non flag variables 
NON_FLAG_VARS <- c(
  "i_econ_incm_chng_self",
  "i_empl_change_post_covid",
  "i_empl_emplyr_change_post_covid",
  "i_empl_jb_prsnt_status",
  "i_empl_lst_date_full_salary",
  "i_hlth_covid_infectn_family",
  "i_hlth_covid_infectn_self",
  "i_lvlhd_domicile_chng_fml",
  "i_lvlhd_domicile_chng_self",
  "o_econ_impact_fml_income_chng_21_v_19",
  "o_econ_impact_how_long_months",
  "o_empl_status_to_nrml_how_long_months",
  "o_impct_has_assets_for_addtnl_loan",
  "p_econ_outstndng_loans_self",
  "p_econ_self_savings_chng_today_v_19",
  "p_hlth_received_hhs_training_self",
  "p_hlth_vaccinated_self",
  "p_lvlhd_lrnd_new_skills"
)

SS_VARS_BUSINESS <- c("i_econ_stop_business",
                      "i_econ_stop_business_how_lng",
                      # "i_covid_effect_business_rnk1",
                      # "i_covid_effect_business_rnk2",
                      # "i_covid_effect_business_rnk3",
                      "i_fin_effect_other",
                      "b_n_emplyes_pre_covid",
                      "i_wrkfrc_size_chng_2020_v_2019",
                      "i_fin_revenue_chng_2020_v_2019",
                      "i_fin_savings_chng_2020_v_2019",
                      "p_dedictd_covid_desk",
                      "n_rcvry_preferred_loan_pybck_incntv",
                      "n_rcvry_preferred_fund_aprvl_incntv",
                      "n_rcvry_preferred_fin_source",
                      "n_rcvry_preferred_tax_asstnc",
                      "n_rcvry_preferred_tax_asstn_other",
                      "n_rcvry_preferred_labor_asstnc",
                      "n_rcvry_preferred_outreach_other",
                      "o_do_u_know_of_gov_schemes",
                      "o_covid_how_long_it_last",
                      "o_econ_impact_revenue_chng_21_v_19",
                      "o_econ_impact_wrkfrc_chng_21_v_19",
                      "o_rcvry_biggest_support",
                      "o_perm_stop_biz_future_retrn_trsm_biz",
                      "o_perm_stop_biz_start_new_job",
                      # "m_name_business",
                      "m_biz_type",
                      "m_biz_years_in_operation"
)

MS_VARS_BUSINESS <- c(
                      "i_covid_effect_business",
                      "i_wrkfrc_actn_during_covid",
                      "i_fin_effect_loan_avlblty",
                      "i_fin_effect_asset_lqdty",
                      "i_fin_effect_cost_invstmnt",
                      "i_geog_effect_loc_chng",
                      "i_fin_effct_eqty_ownrshp",
                      "b_services_offered_pre_covid",
                      "b_services_offered_post_covid",
                      "p_hlth_hhs_measures",
                      "p_hlth_safety_measures",
                      # "p_recvry_strategic_actions_internl"
                      # "p_recvry_strategic_actions_externl",
                      "n_rcvry_preferred_gov_policy",
                      "o_expectd_problms_next_6_mnths",
                      "o_how_efctv_gov_schemes",
                      # "r_gov_scheme_which_how_efctv",
                      "o_rcvry_biggest_diffclties",
                      "o_perm_stop_biz_start_new",
                      "o_perm_stop_biz_new_biz_trsm_sector",
                      "o_perm_stop_biz_new_biz_which",
                      "o_perm_stop_biz_start_new_job_trsm_sector",
                      "o_perm_stop_biz_new_job_sector",
                      "m_biz_unn_membrshps"
)

