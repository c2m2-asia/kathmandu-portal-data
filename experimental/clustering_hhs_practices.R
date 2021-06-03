# https://uc-r.github.io/hc_clustering

# Imports
source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

library(mltools)
library(data.table)
library(UpSetR)
# Parameters
survey_data_path <- paste0(ROOT_URL, "raw/data/business_data_20210506.xlsx")

# Survey data
businesses <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)

businesses <- businesses %>% mutate(d_shut_down = ifelse((i_econ_stop_business == 2 | i_econ_stop_business== 3), T, F))
businesses <- businesses %>% mutate(d_shut_down_temp = ifelse((i_econ_stop_business == 2), T, F))
businesses <- businesses %>% mutate(d_shut_down_perm = ifelse((i_econ_stop_business == 3), T, F))
businesses <- businesses %>% mutate(d_shut_down_never = ifelse((i_econ_stop_business == 1), T, F))


colnames(businesses)
hhs_vars <- c(
  "X_index",
  "d_shut_down_perm",
  "p_hlth_hhs_measures__1",
  "p_hlth_hhs_measures__2",
  "p_hlth_hhs_measures__3",
  "p_hlth_hhs_measures__4",
  "p_hlth_hhs_measures__5",
  "p_hlth_hhs_measures__6",
  "p_hlth_hhs_measures__7",
  "p_hlth_hhs_measures__8",
  "p_hlth_hhs_measures__9",
  "p_hlth_hhs_measures__10",
  "p_hlth_safety_measures__1",
  "p_hlth_safety_measures__2",
  "p_hlth_safety_measures__3",
  "p_hlth_safety_measures__4",
  "p_hlth_safety_measures__5",
  "p_hlth_safety_measures__6",
  "p_hlth_safety_measures__7",
  "p_hlth_safety_measures__8",
  "p_hlth_safety_measures__9",
  "p_hlth_safety_measures__10",
  "p_hlth_safety_measures__11",
  "m_biz_type",
  "m_coodinates"
) 

renamed_cols <- c(
  "id",
  "perm_closed",
  "sntzrs",
  "empl_trained",
  "thrml_scrn",
  "soc_dist",
  "cshless",
  "nobufft",
  "c19mrktg",
  "outsrc",
  "othr",
  "none",
  "infrm",
  "styhm",
  "wrkr_socdist",
  "shfts",
  "telewrk",
  "tempchecks",
  "ppe",
  "paid_sickleave",
  "insurncs",
  "wrker_other",
  "worker_none",
  "type",
  "coordinates"
)
renamed_cols
measures_var <- renamed_cols[3:12]

businesses_hhs <- businesses %>% select(hhs_vars)
colnames(businesses_hhs) <- renamed_cols
businesses_hhs<- within(businesses_hhs, coord<-data.frame(do.call('rbind', strsplit(as.character(coordinates), ' ', fixed=TRUE))))
businesses_hhs$lat <- businesses_hhs$coord[[1]]
businesses_hhs$lng <- businesses_hhs$coord[[2]]
businesses_hhs <- businesses_hhs[ ,!(colnames(businesses_hhs) == "coord")]
businesses_hhs <- businesses_hhs %>% filter(perm_closed == F)


colnames(businesses_hhs)
sub <- businesses_hhs[3:11]
colnames(sub)
oof <- one_hot(as.data.table(sub))
oof
upset(factorsNumeric(sub), order.by="freq", main.bar.color = "#995ee1", sets.bar.color = "#995ee1", group.by = "degree") 

library(vegan)
df <- businesses_hhs %>% select(c(measures_var))
asNumeric <- function(x) as.numeric(as.character(x))
factorsNumeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)],   
                                                   asNumeric))

df <- factorsNumeric(df)
df
dist.mat<-vegdist(df1,method="jaccard", binary = T) #distance matrix based on Jaccard distance
clust.res<-hclust(dist.mat) #agglomerative clustering using complete linkage
plot(clust.res, hang=-1)

# # Cut tree into 4 groups
# 
# x.grps <- cutree(clust.res, 3:10)
# x.SS <- aggregate(df1, by=list(x.grps[, 1]), function(x) sum(scale(x,
#                                                                  scale=FALSE)^2))
# x.SS
# SS <- rowSums(x.SS[, -1]) # Sum of squares for each cluster
# TSS <- sum(x.SS[, -1])  # Total (within) sum of squares
# TSS
# 
# TSS <- function(x, g) {
#   sum(aggregate(x, by=list(g), function(x) sum(scale(x, 
#                                                      scale=FALSE)^2))[, -1])
# }
# TSS.all <- apply(x.grps, 2, function(g) TSS(df1, g))
# TSS.all
# typeof(TSS.all)
# plot(TSS.all)


sub_grp <- cutree(clust.res, k = 7)
df$clusr <- sub_grp
businesses_hhs$clusr <- sub_grp

df %>% summarise(
  n = n(), 
  sntzrs=sum(as.numeric(as.character(sntzrs)))/n(),
  empl_trained=sum(as.numeric(as.character(empl_trained)))/n(),
  thrml_scrn=sum(as.numeric(as.character(thrml_scrn)))/n(),
  soc_dist=sum(as.numeric(as.character(soc_dist)))/n(),
  cshless=sum(as.numeric(as.character(cshless)))/n(),
  nobufft=sum(as.numeric(as.character(nobufft)))/n(),
  c19mrktg=sum(as.numeric(as.character(c19mrktg)))/n()
)

df %>% group_by(clusr) %>% summarise(
  n = n(), 
  sntzrs=sum(as.numeric(as.character(sntzrs)))/n(),
  empl_trained=sum(as.numeric(as.character(empl_trained)))/n(),
  thrml_scrn=sum(as.numeric(as.character(thrml_scrn)))/n(),
  soc_dist=sum(as.numeric(as.character(soc_dist)))/n(),
  cshless=sum(as.numeric(as.character(cshless)))/n(),
  nobufft=sum(as.numeric(as.character(nobufft)))/n(),
  c19mrktg=sum(as.numeric(as.character(c19mrktg)))/n()
)





library(ggplot2)
ggplot(businesses_hhs, aes(x=factor(type)))+
  geom_bar(stat="count", width=0.7, fill="steelblue")+
facet_grid(clusr ~ .)+
  scale_x_discrete(breaks=1:9,
                       labels=c("Hotel","Rest & B","Trav. Tour","Handicraft","Rafting","Trekking","Mountnring", "Shop", "Other"))+
  theme_minimal()
