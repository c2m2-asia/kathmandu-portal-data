# After downloading survey data from ONA, we noticed that columns have values stored as numeric codes. This code is responsible for mapping numeric values stored on ONA survey responses to their respective labels.
# Inputs: Business survey data file in XLS format and Business survey XLSform

# Libraries
library(tidyr)
library(MRCV)
library(reshape2)
library(stringr)
library(rgdal)

# Imports
source("/home/samyoga/KLL/kathmandu-portal-data/utils/functions.R")
source("/home/samyoga/KLL/kathmandu-portal-data/utils/constants.R")

# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/business_data_20210510.xlsx")

# Survey data
businesses_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)

# Remove rows without coordinates
business <- businesses_data %>% filter(!is.na(m_coodinates))

# Data Wrangling
MS_PREFIXES <- MS_VARS_BUSINESS
SS_VARS <- SS_VARS_BUSINESS
# SS_VARS_FINAL <- c(SS_VARS, "m_name_business") 
COORDINATES <- COORDINATES_BUSINESSES
# biz_name <- c("m_name_business")

# Create empty table
countsTable <- data.frame(value = factor(),
                          total = double(),
                          variable = character())

generateCounts <- function(variable_name, df, summarydf) {
  table <- table(df[, variable_name])
  output <- as.data.frame(table)
  # print(output)
  output$variable <- variable_name
  colnames(output) <- c('value', 'selected_value', 'variable')
  # summary(output)
  summarydf <-  rbind(summarydf, output)
  return(summarydf)
}

heatmapStats <- ddply(business, .(m_name_business), function(d.sub) {
  variables <- SS_VARS
  for (item in variables) {
    # proportionsTable <- generateProportions(item, d.sub, proportionsTable)
    countsTable <- generateCounts(item, d.sub, countsTable)
  }
  # countsAndProportions <-
  #   inner_join(proportionsTable, countsTable) %>% select(variable, value, total, perc_of_total)
  return(countsTable)
})

# Replace NAN with 0
heatmapStats[is.na(heatmapStats)] <- 0

# Separate dimensional Variables
univariateBusinessStatsForSS <- UNI.GetCountsAndProportionsSS(business, SS_VARS)

univariateBusinessStatsForMS <- UNI.GetCountsAndProportionsMSMultiQues(business, MS_PREFIXES)
allUnivariate <- rbind(univariateBusinessStatsForSS, univariateBusinessStatsForMS)

path <- paste0(ROOT_URL, "misc/mapping_business.xlsx")
mapping <- IO.XlsSheetToDF(excel_sheets(path)[1], path) %>% select(variable, value, label_en, label_ne, choice_code, variable_group)
uni_w_labels <- left_join(allUnivariate, mapping)
heatmap_w_labels <- left_join(heatmapStats, mapping) %>% select(-choice_code, -variable_group)

heatmap_w_labels2 <- heatmap_w_labels[heatmap_w_labels$selected_value != 0, ] %>% select(-selected_value)

# subsetting data by coordinates
coordinatesBusiness <- business[ , c("m_name_business", "m_coodinates_latitude", "m_coodinates_longitude")]

heatmap_merge_labels <- merge(heatmap_w_labels2, coordinatesBusiness, by="m_name_business", all = T)

heatmap_merge_labels$m_coordinates <- paste(heatmap_merge_labels$m_coodinates_latitude, heatmap_merge_labels$m_coodinates_longitude, sep=",")

heatmap_final <- heatmap_merge_labels %>% 
  group_by(m_name_business, value, variable) %>%
  summarise(m_coordinates = toString(unique(m_coordinates)))
