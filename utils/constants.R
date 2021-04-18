# PATHS
ROOT_URL <- "C:/Users/arogy/projects/kathmandu-portal-data/"
JSON_EXPORT_PATH <- paste0(ROOT_URL, "exports/json/")
CSV_EXPORT_PATH <- paste0(ROOT_URL, "exports/csv/")


# Separate flag variables
DIMENSIONAL_VARS <- c("gender_category",  "age_category", "edu_levl_category", "exp_category")




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


