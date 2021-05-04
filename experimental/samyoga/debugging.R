source("~/projects/c2m2/kathmandu-survey/utils/functions.R")
source("~/projects/c2m2/kathmandu-survey/utils/constants.R")

survey_data_path <- paste0(ROOT_URL, "raw/data/workers_data_20210425.xlsx")
workers_data <- IO.XlsSheetToDF(excel_sheets(survey_data_path)[1], survey_data_path)
workers <- workers_data %>% filter(!is.na(m_gender))
names(workers)


prefixes = c("i_econ_covid_effects")



UNI.GetCountsAndProportionsMSOneQues <- function(DF, VARLIST, CATEGORY_LABEL, GROUP_BY_VAR) {
  DF["universe"] <- "u"
  perc_suffix <- "_perc"
  total_suffix <- "_total"
  
  
  getValues  <- function(item) {
    if(length(strsplit(item, split="__")[[1]]) > 1) {
      return (strsplit(item, split="__")[[1]][2])
    }
    return("Other")
  }
  
  perc_labels <- lapply(VARLIST, paste0, perc_suffix)
  total_labels <- lapply(VARLIST, paste0, total_suffix)
  variable_labels <- lapply(VARLIST, getValues)
  
  
  
  
  for(v in VARLIST) {
    DF[v] <- ifelse(DF[v] == 1,  0, 1)
    DF[v] <- as.numeric(unlist(DF[v]))
  }
  
  
  msParent <- DF %>%
    group_by_at(GROUP_BY_VAR) %>%
    summarise_at(
      VARLIST,
      funs(total = sum(., na.rm = T), perc = signif((sum(., na.rm = T) / n()), digits=6))
    )
  
  
  msParentPerc <- msParent %>%
    select(
      eval(GROUP_BY_VAR),
      ends_with("perc")) %>%
    gather(
      key = value,
      value = perc_of_total
    )
  msParentPerc$value <-
    mapvalues(msParentPerc$value,
              from = perc_labels,
              to = variable_labels
    )
  
  print(head(msParentPerc))
  
  msParentTotal <-
    msParent %>%
    select(
      eval(GROUP_BY_VAR),
      ends_with("total")) %>%
    gather(
      key = value,
      value = total, -eval(GROUP_BY_VAR)
    )
  
  msParentTotal$value <- mapvalues(msParentTotal$value,
                                   from = total_labels,
                                   to = variable_labels
  )

  
  msParentTotal$variable <- CATEGORY_LABEL
  
  
  final <- inner_join(msParentTotal, msParentPerc)
  final <- final %>% mutate(value = sapply(value, toString))
  print(head(final))
  
  dropCols <- c("universe")
  final <- final[, !(names(final) %in% dropCols)]
  return(final)
}  

UNI.GetCountsAndProportionsMSMultiQues(DF = workers, PREFIXES = prefixes)

