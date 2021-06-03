library(vegan)
library(ggplot2)
library(purrr)
library(rworldmap)
library(leaflet)
library(cluster)
library(UpSetR)
library(DT)
library(mltools)
library(data.table)
# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

# Get survey data
survey_data_path <- paste0(
  ROOT_URL, 
  "raw/data/business_data_20210531_wloc.xlsx"
)

businesses <- IO.XlsSheetToDF(
  excel_sheets(survey_data_path)[1], 
  survey_data_path
)

# Create flag variable to distinguish
# permanently closed businesses
businesses <- businesses %>% 
  mutate(d_shut_down_perm = ifelse(
    (i_econ_stop_business == 3), T, F))

# Subset data to only include HHS variables
hhs_vars <- c("X_index",
              "d_shut_down_perm",
              "i_wrkfrc_size_chng_2020_v_2019",
              "i_fin_revenue_chng_2020_v_2019",
              "i_fin_savings_chng_2020_v_2019",
              "m_biz_type",
              "m_coodinates", 
              "X_m_coodinates_latitude",
              "X_m_coodinates_longitude",
              "m_name_business"
) 




# Rename columns
businesses_hhs <- businesses %>% select(all_of(hhs_vars))


colnames(businesses_hhs) <- c(
  "id",
  "perm_closed",
  "wrkfrc_chng",
  "reven_chng",
  "svngs_chng",
  "type",
  "coordinates",
  "X_m_coodinates_latitude",
  "X_m_coodinates_longitude",
  "name"
)

renamed_cols <- colnames(businesses_hhs)
businesses_hhs <- businesses_hhs %>% filter(perm_closed == F)




subset <- businesses_hhs %>% select(id, wrkfrc_chng, reven_chng, svngs_chng)
other_meta <- businesses_hhs %>% select(id, perm_closed, coordinates, X_m_coodinates_latitude, X_m_coodinates_longitude, name)

oneHot <- one_hot(as.data.table(subset))
colnames(oneHot) <- c(
  "id",
  "wrkfrc_chng_no",
  "wrkfrc_chng_75",
  "wrkfrc_chng_50",
  "wrkfrc_chng_25",
  "wrkfrc_chng_100",
  "wrkfrc_chng_incr",
  "reven_chng_no",
  "reven_chng_75",
  "reven_chng_50",
  "reven_chng_20",
  "reven_chng_100",
  "svngs_chng_75",
  "svngs_chng_50",
  "svngs_chng_25",
  "svngs_chng_25_2",
  "svngs_chng_neg"
)

data <- inner_join(oneHot, other_meta)

colnames(data)
# Subset columns of interest
data <- data %>% filter(perm_closed==F)
subs <- data %>% select(c(colnames(data)[2:17]))

# Visualize using UpsetR 
upset(subs, 
      order.by="freq", 
      main.bar.color = "#c3092b", 
      sets.bar.color = "#c3092b", 
      group.by = "degree"
)

# Convert columns to numeric values
indx <- sapply(df, is.factor)
df[indx] <- lapply(df[indx], function(x) as.numeric(as.character(x)))

# Compute distance matrix based on "jaccard" distance
dist.mat<-vegdist(
  subs,
  method="jaccard",
  binary = T
) 


# methods to assess
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

clust.res<-hclust(dist.mat, method = "ward") #agglomerative clustering using complete linkage
plot(clust.res, hang=-1, cex=0.8)


# "wrkfrc_chng_no",
# "wrkfrc_chng_75",
# "wrkfrc_chng_50",
# "wrkfrc_chng_25",
# "wrkfrc_chng_100",
# "wrkfrc_chng_incr",
# "reven_chng_no",
# "reven_chng_75",
# "reven_chng_50",
# "reven_chng_20",
# "reven_chng_100",
# "svngs_chng_75",
# "svngs_chng_50",
# "svngs_chng_25",
# "svngs_chng_25_2",
# "svngs_chng_neg"

totals <- data %>% summarise(
  n = n(),
  wrkfrc_chng_no=round(sum(as.numeric(as.character(wrkfrc_chng_no)))/n(), 2),
  wrkfrc_chng_75=round(sum(as.numeric(as.character(wrkfrc_chng_75)))/n(),2),
  wrkfrc_chng_50=round(sum(as.numeric(as.character(wrkfrc_chng_50)))/n(),2),
  wrkfrc_chng_25=round(sum(as.numeric(as.character(wrkfrc_chng_25)))/n(),2),
  wrkfrc_chng_incr=round(sum(as.numeric(as.character(wrkfrc_chng_incr)))/n(),2),
  reven_chng_no=round(sum(as.numeric(as.character(reven_chng_no)))/n(), 2),
  reven_chng_75=round(sum(as.numeric(as.character(reven_chng_75)))/n(),2),
  reven_chng_50=round(sum(as.numeric(as.character(reven_chng_50)))/n(),2),
  reven_chng_20=round(sum(as.numeric(as.character(reven_chng_20)))/n(),2),
  reven_chng_100=round(sum(as.numeric(as.character(reven_chng_100)))/n(),2),
  svngs_chng_75=round(sum(as.numeric(as.character(svngs_chng_75)))/n(),2),
  svngs_chng_50=round(sum(as.numeric(as.character(svngs_chng_50)))/n(),2),
  svngs_chng_25=round(sum(as.numeric(as.character(svngs_chng_25)))/n(),2),
  svngs_chng_25_2=round(sum(as.numeric(as.character(svngs_chng_25_2)))/n(),2),
  svngs_chng_neg=round(sum(as.numeric(as.character(svngs_chng_neg)))/n(),2)
)

datatable(totals, options = list(
  autoWidth = F
))


sub_grp <- cutree(clust.res, k = 5)
data <- cbind(data, sub_grp)
# businesses_hhs <- cbind(businesses_hhs, sub_grp)

cluster_profiles <- data %>% 
  group_by(sub_grp) %>% 
  summarise(
    n = n(),
    wrkfrc_chng_no=round(sum(as.numeric(as.character(wrkfrc_chng_no)))/n(), 2),
    wrkfrc_chng_75=round(sum(as.numeric(as.character(wrkfrc_chng_75)))/n(),2),
    wrkfrc_chng_50=round(sum(as.numeric(as.character(wrkfrc_chng_50)))/n(),2),
    wrkfrc_chng_25=round(sum(as.numeric(as.character(wrkfrc_chng_25)))/n(),2),
    wrkfrc_chng_incr=round(sum(as.numeric(as.character(wrkfrc_chng_incr)))/n(),2),
    reven_chng_no=round(sum(as.numeric(as.character(reven_chng_no)))/n(), 2),
    reven_chng_75=round(sum(as.numeric(as.character(reven_chng_75)))/n(),2),
    reven_chng_50=round(sum(as.numeric(as.character(reven_chng_50)))/n(),2),
    reven_chng_20=round(sum(as.numeric(as.character(reven_chng_20)))/n(),2),
    reven_chng_100=round(sum(as.numeric(as.character(reven_chng_100)))/n(),2),
    svngs_chng_75=round(sum(as.numeric(as.character(svngs_chng_75)))/n(),2),
    svngs_chng_50=round(sum(as.numeric(as.character(svngs_chng_50)))/n(),2),
    svngs_chng_25=round(sum(as.numeric(as.character(svngs_chng_25)))/n(),2),
    svngs_chng_25_2=round(sum(as.numeric(as.character(svngs_chng_25_2)))/n(),2),
    svngs_chng_neg=round(sum(as.numeric(as.character(svngs_chng_neg)))/n(),2)
  )

datatable(cluster_profiles, options = list(
  autoWidth = F
))
