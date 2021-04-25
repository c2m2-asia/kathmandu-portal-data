# PATHS
ROOT_URL <- "~/projects/c2m2/kathmandu-survey/"
JSON_EXPORT_PATH <- paste0(ROOT_URL, "exports/json/")
CSV_EXPORT_PATH <- paste0(ROOT_URL, "exports/csv/")


# Separate flag variables
DIMENSIONAL_VARS <- c("gender_category",  "age_category", "edu_levl_category", "exp_category")

ID_VARS <- c("X_index", "X_uuid", "X_submission_time" )
META_VARS <- c("m_name", "m_gender",  "m_age", "m_edu_levl","m_years_of_experience", "m_phone") 
ID_AND_META_VARS <- c(ID_VARS, META_VARS)  

MS_VARS <- c("b_empl_occpatn_pre_covid",
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


SS_VARS <- c("b_empl_frml_agrmnt_status_pre_covid",
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


