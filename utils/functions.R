library(parallel)
library(readxl)
library(RPostgreSQL)
library(plyr)
library(dplyr)
library(jsonlite)

DB.GetCon <- function () {
  return(dbConnect(dbDriver("PostgreSQL"), user="c2m2", password="1234",
                   host="localhost", dbname="c2m2"))
} 

# Functions
IO.XlsSheetToDF <- function(sheet, xls_file) {
  my_custom_name_repair <- function(nms) tolower(gsub("-", "/", nms))
  cl <- makeCluster(detectCores() - 1)
  df <- parLapplyLB(cl, sheet, function(sheet, xls_file) {
    readxl::read_excel(xls_file, sheet = sheet, .name_repair = my_custom_name_repair )
  }, xls_file)
  df <- as.data.frame(df)
  df <- df %>% mutate_if(is.character,as.factor)
  return(df)
}

IO.SaveCsv <- function(DF, NAME, PATH) {
  write.csv(DF, file = paste0(PATH, NAME, format(Sys.time(),'_%Y%m%d_%H%M%S'), ".csv"), row.names = F)
}

IO.SaveJson <- function(DF, NAME, PATH) {
  exportJSON <- toJSON(DF)
  write(exportJSON, paste0(PATH, NAME, format(Sys.time(),'_%Y%m%d_%H%M%S'), ".json"))
}

# Convert column names to DB safe names
DB.ToDbSafeNames = function(names) {
  names = gsub('[^a-z0-9]+','_',tolower(names))
  names = make.names(names, unique=TRUE, allow_=TRUE)
  names = gsub('.','_',names, fixed=TRUE)
  names
}

# Pad digits with leading zeroes
DB.PadWithZeroes <- function(df, column, length) {
  df[,column] <- str_pad(df[,column], length, pad="0")
  return (df)
}

# Convert types for columns
PRCS.TypeConverter <- function (df, numericTypes, factorTypes, integerTypes) {
  
  convertToInteger <- function(df, variable) {
    df[,variable] <- as.integer(as.character(df[,variable]))
    return(df)
  }
  
  convertToNumeric <- function(df, variable) {
    df[,variable] <- as.numeric(as.character(df[,variable]))
    return(df)
  }
  
  
  convertToFactor <- function(df, variable) {
    df[,variable] <- as.factor(df[,variable])
    return(df)
    
  }
  
  for(item in numericTypes) {
    print(item)
    df <- convertToNumeric(df, item)
    
  }
  
  for(item in factorTypes) {
    print(item)
    df <- convertToFactor(df, item)
  }
  
  for(item in integerTypes) {
    print(item)
    df <- convertToInteger(df, item)
  }
  
  return(df)  
}

# Creation of flag variables. Creates a new variable and sets it to true if any one of a group  are selected.
PRCS.CreateMultiselectTrueFlag <- function(table, oldVar, newName, value) {
  subset <- table[ , grepl( oldVar , names( table ) ) ]
  table[, newName] <- apply(subset, 1, function(r) any(r %in% c(value)))
  table[, newName] <- ifelse(table[,newName]==TRUE, as.integer(1), as.integer(0))
  return(table)
}



PRCS.GetCountsAndProportionsMSMultiQues <- function(DF, PREFIXES) {
  DF["universe"] = "u"
  countsAndProportionsTable <- data.frame( universe = character(),  value = character(), total = double(), variable = character(),perc_of_total = character())
  
  
  
  for (p in PREFIXES) {

    names <- names(DF)[ grepl( p , names( DF ) )]
    names <- names[ !grepl( "*rnk*" , names )]
    print(p)
    countsAndProportions <- PRCS.GetCountsAndProportionsMSOneQues(DF, names, CATEGORY_LABEL = toString(p), GROUP_BY_VAR = "universe")
    
    countsAndProportionsTable = rbind(countsAndProportions, countsAndProportionsTable)
    
    
  }
  
  return(countsAndProportionsTable)
  
}


PRCS.GetCountsAndProportionsMSOneQues <- function(DF, VARLIST, CATEGORY_LABEL, GROUP_BY_VAR) {
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
  
  # print(total_labels)
  
  
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
  
  dropCols <- c("universe")
  final <- final[, !(names(final) %in% dropCols)]
  return(final)
}  


PRCS.GetCountsAndProportionsSS <- function(DF, INPUTVARS) {
  # Create empty table
  proportionsTable <- data.frame(value = factor(),
                                 perc_of_total = double(),
                                 variable = character())
  
  countsTable <- data.frame(value = factor(),
                            total = double(),
                            variable = character())
  
  # Proportions and counts generator function
  generateProportions <- function(variable_name, df, summarydf) {
    table <- table(df[, variable_name])
    output <- as.data.frame(round(prop.table(table), 7))
    output$variable <- variable_name
    colnames(output) <- c('value', 'perc_of_total', 'variable')
    # summary(output)
    summarydf <-  rbind(summarydf, output)
    return(summarydf)
  }
  
  
  
  generateCounts <- function(variable_name, df, summarydf) {
    table <- table(df[, variable_name])
    output <- as.data.frame(table)
    # print(output)
    output$variable <- variable_name
    colnames(output) <- c('value', 'total', 'variable')
    # summary(output)
    summarydf <-  rbind(summarydf, output)
    return(summarydf)
  }
  
  
  univariateStats <- ddply(DF, .(), function(d.sub) {
    variables <- INPUTVARS
    for (item in variables) {
      proportionsTable <- generateProportions(item, d.sub, proportionsTable)
      countsTable <- generateCounts(item, d.sub, countsTable)
    }
    countsAndProportions <-
      inner_join(proportionsTable, countsTable) %>% select(variable, value, total, perc_of_total)
    return(countsAndProportions)
  })
  
  univariateStats <- univariateStats[-c(1)]
  return(univariateStats)
  
}


# Write DF to PGSQL table
DB.WriteToDb <- function(con, df, table_name) {
  dbWriteTable(con,table_name, df, row.names=FALSE, overwrite = TRUE)
}