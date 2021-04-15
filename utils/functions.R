library(parallel)
library(readxl)
library(RPostgreSQL)
library(plyr)
library(dplyr)

DB.GetCon <- function () {
  return(dbConnect(dbDriver("PostgreSQL"), user="c2m2", password="1234",
                   host="localhost", dbname="c2m2"))
} 

# Functions
IO.XlsSheetToDF <- function(sheet, xls_file) {
  cl <- makeCluster(detectCores() - 1)
  df <- parLapplyLB(cl, sheet, function(sheet, xls_file) {
    readxl::read_excel(xls_file, sheet = sheet)
  }, xls_file)
  df <- as.data.frame(df)
  df <- df %>% mutate_if(is.character,as.factor)
  return(df)
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