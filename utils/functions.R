library(parallel)
library(readxl)
library(RPostgreSQL)
library(plyr)
library(dplyr)
library(jsonlite)
library(reshape2)
library(tidyr)

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
  df <- df %>% mutate_if(is.double,as.factor)
  return(df)
}

IO.SaveCsv <- function(DF, NAME, PATH, dates=T) {
  if(dates == T) {
    write.csv(DF, file = paste0(PATH, NAME, format(Sys.time(),'_%Y%m%d_%H%M%S'), ".csv"), row.names = F)
  } else {
    write.csv(DF, file = paste0(PATH, NAME, ".csv"), row.names = F)
  }
  
}

MISC.GetFileName <- function(NAME, PATH) {
  return(paste0(PATH, NAME, format(Sys.time(),'_%Y%m%d_%H%M%S'), ".csv"))
}

IO.SaveJson <- function(DF, NAME, PATH, dates=T) {
  exportJSON <- toJSON(DF)
  if(dates == T) {
    write(exportJSON, paste0(PATH, NAME, format(Sys.time(),'_%Y%m%d_%H%M%S'), ".json"))
    
  } else {
    write(exportJSON, paste0(PATH, NAME, ".json"))
  }
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



PRCS.AppendLabels <- function(DF) {
  path <- paste0(ROOT_URL, "misc/mapping.xlsx")
  mapping_file <- IO.XlsSheetToDF(excel_sheets(path)[1], path)
  mapping_file$value <- as.integer(as.character(mapping_file$value))
  DF$value <- as.integer(as.character(DF$value))
  return(left_join(DF, mapping_file))
}


UNI.GetCountsAndProportionsMSMultiQues <- function(DF, PREFIXES) {
  DF["universe"] = "u"
  countsAndProportionsTable <- data.frame( universe = character(),  value = character(), total = double(), variable = character(),perc_of_total = character())
  
  
  
  for (p in PREFIXES) {

    names <- names(DF)[ grepl( p , names( DF ) )]
    names <- names[ !grepl( "*rnk*" , names )]
    names <- names[ !grepl( "*_other" , names )]
    countsAndProportions <- UNI.GetCountsAndProportionsMSOneQues(DF, names, CATEGORY_LABEL = toString(p), GROUP_BY_VAR = "universe")
    countsAndProportionsTable = rbind(countsAndProportions, countsAndProportionsTable)
    
    
  }
  
  return(countsAndProportionsTable)
  
}


PRCS.GetMultiSelectNamesFromPrefix <- function(DF, PREFIX) {
  names <- names(DF)[ grepl( PREFIX , names( DF ) )]
  names <- names[ !grepl( "*rnk*" , names )]
  names <- names[ !grepl( "*_other" , names )]
    # DF[]
  return(names)
}

PRCS.GetDistByVar <- function(DF, VAR) {
  return(DF %>% filter(variable==VAR))
}


UNI.GenerateDistForEachVar <- function(DF) {
  uVars <- unique(DF$variable)
  for(u in uVars){
    subsetDF <- PRCS.GetDistByVar(DF, u)
    IO.SaveJson(subsetDF, paste0("dist_", u), paste0(JSON_EXPORT_PATH, "/chartinput/"), dates = F)
  }
  
  
}


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


UNI.GetCountsAndProportionsSS <- function(DF, INPUTVARS) {
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

PRCS.CoerceOtherToFlag <- function(DF) {
  name <- names(DF)[ grepl( "*_other" , names( DF ) )]
  DF[name] <- ifelse(is.na(DF[name]), 0, 1)
  return(DF)
} 

PRCS.CoercetoZeroOne <- name <- function(DF) {
  
  tryCatch({
    for (name in names(DF)) {
      if(min(DF[name]) != 0) {
        DF[name] = ifelse(DF[name] == min(DF[name]), 0, 1)
      }
    }
  }, error = function(cond) {

  })
  

  return(DF)
}



BI.GetPropCountSsMs <- function(DF, SS_VAR, MS_PREFIX) {
  msVars <- PRCS.GetMultiSelectNamesFromPrefix(DF, MS_PREFIX)
  df2 <- DF[c(SS_VARS, msVars)]
  
  X <- SS_VAR
  df3 <- df2[c(X, msVars)]
  df4 <- PRCS.CoerceOtherToFlag(df3) ## Need to globalize this function
  df4[sapply(df4, is.factor)] <- lapply(df4[sapply(df4, is.factor)], 
                                        as.integer)
  df4[-1] <- PRCS.CoercetoZeroOne(df4[-1])
  df4[-1]<- lapply(df4[-1], 
                   as.logical)
  fmla <- paste0(X, "~ variable")
  contingency_wide <- recast(df4, fmla,fun=sum, id.var = 1)
  
  # Get totals
  contingency_tall <- gather(contingency_wide, y_value, total, names(contingency_wide)[2:ncol(contingency_wide)], factor_key=TRUE)
  contingency_tall$y_variable <- MS_PREFIX
  contingency_tall$y_value <- lapply(as.character(contingency_tall$y_value), function(item) {
    if(length(strsplit(item, "__")[[1]])==1) {
      return("Other")
    }
    return(strsplit(item, "__")[[1]][2])
  })
  contingency_tall$y_value <- as.factor(as.character(contingency_tall$y_value))
  colnames(contingency_tall) <- c("x_value", names(contingency_tall)[2:ncol(contingency_tall)])
  contingency_tall$x_variable <- SS_VAR
  
  # Get percentages 
  contingency_perc_wide <- contingency_wide
  contingency_perc_wide[-1] <- lapply(contingency_perc_wide[-1], function(i) i/nrow(df4)) 
  contingency_perc_tall <- gather(contingency_perc_wide, y_value, perc, names(contingency_perc_wide)[2:ncol(contingency_perc_wide)], factor_key=TRUE)
  contingency_perc_tall$y_variable <- MS_PREFIX
  contingency_perc_tall$y_value <- lapply(as.character(contingency_perc_tall$y_value), function(item) {
    # print(strsplit(item, "__")[[1]])
    
    
    if(length(strsplit(item, "__")[[1]])==1) {
        return("Other")
    }
    return(strsplit(item, "__")[[1]][2])
  })
  contingency_perc_tall$y_value <- as.factor(as.character(contingency_perc_tall$y_value))
  colnames(contingency_perc_tall) <- c("x_value", names(contingency_perc_tall)[2:ncol(contingency_perc_tall)])
  contingency_perc_tall$x_variable <- SS_VAR
  
  #Join totals and percentages
  contingency <- inner_join(contingency_tall, contingency_perc_tall)
  contingency <- contingency %>% select(x_variable, x_value, y_variable,  y_value, total, perc)
  return(contingency)
}

BI.MultiGetPropCountsSsMs <- function(DF, MS_PREFIXES, SS_VARS) {
  
  countsAndProportionsTable <- data.frame( x_variable = character(),  y_variable = character(), x_value = integer(), y_value = factor(),total=integer(), perc = double())
  
  
  for (p in MS_PREFIXES) {
    for (s in SS_VARS) {
      contingencySP <- BI.GetPropCountSsMs(DF, s, p)
      countsAndProportionsTable <- rbind(countsAndProportionsTable, contingencySP)
    }
  }
  
  
  return(countsAndProportionsTable)
}

BI.GetPropCountSsSs <- function(DF, VAR1, VAR2) {
  df2 <- DF %>% select(eval(VAR1), eval(VAR2))
  
  ct <- as.data.frame(table(df2))
  colnames(ct) <- c("x_value", "y_value", "total")
  ct$x_variable <- VAR1
  ct$y_variable <- VAR2
  
  ctp <- as.data.frame(prop.table(table(df2)))
  colnames(ctp) <- c("x_value", "y_value", "perc")
  ctp$x_variable <- VAR1
  ctp$y_variable <- VAR2
  
  ctf <- inner_join(ct, ctp)
  
  ctf <- ctf %>% select(x_variable, x_value, y_variable, y_value, total, perc)
  
  # ct_tall <- gather(ct_wide, y_value, total, names(ct_wide)[2:ncol(ct_wide)], factor_key=TRUE)
  return(ctf)
}

BI.MultiGetPropCountSsSs <- function(DF, SS_VARS) {
  countsAndProportionsTable <- data.frame( x_variable = character(),  y_variable = character(), x_value = integer(), y_value = factor(),total=integer(), perc = double())
  
  combolist <- c()
  
  
  for (p in SS_VARS) {
    for (s in SS_VARS) {
      
      if(s != p && !(paste0(s,p) %in% combolist)) {
      
        combolist[[length(combolist)+1]] <- paste0(s,p)
        combolist[[length(combolist)+2]] <- paste0(p,s)
        
        contingencySP <- BI.GetPropCountSsSs(DF, s, p)
        countsAndProportionsTable <- rbind(countsAndProportionsTable, contingencySP)
        
      }
    }
  }
  
  
  return(countsAndProportionsTable)
}




BI.GetPropCountMsMs <- function(DF, PREFIXA, PREFIXB){
  
  countsAndProportionsTable <- data.frame( x_variable = character(),  y_variable = character(), x_value = integer(), y_value = character(),total=integer(), perc = double())
  
  colSetA <- PRCS.GetMultiSelectNamesFromPrefix(DF, PREFIXA)
  colSetB <- PRCS.GetMultiSelectNamesFromPrefix(DF, PREFIXB)
  n <- nrow(DF)
  df2 <- DF[c(colSetA, colSetB)]
  df3 <- PRCS.CoerceOtherToFlag(df2) ## Need to globalize this function
  
  replaceOther <- function(i) {
    if(!grepl("*_other", i)) {
      return(i)
    }
    return (as.character(strsplit(i, "_other")[1]))
  }
  
  for(col in colSetA) {
    
    df4 <- df3[c(col, colSetB)]
    df4[sapply(df4, is.factor)] <- lapply(df4[sapply(df4, is.factor)], 
                                          as.integer)
    df4 <- PRCS.CoercetoZeroOne(df4)
    df4[-1]<- lapply(df4[-1], as.logical)
    
    fmla <- paste0(col, "~ variable")
    ct_1 <- recast(df4, fmla,fun=sum, id.var = 1)
    ct_1$variable <- col
    colnames(ct_1)[1] <- "value"
    ct_1 <- ct_1 %>% filter(value > 0)
    ct_1 <- ct_1 %>% relocate(variable,value)
    ct_tall <- gather(ct_1, y_value, total, names(ct_1)[3:ncol(ct_1)], factor_key=TRUE)
    ct_tall <- ct_tall %>% 
      select(variable, y_value, total) %>% 
      separate(variable, c("x_variable", "x_value"), "__") %>% 
      separate(y_value, c("y_variable", "y_value"), "__") %>% mutate(perc = total / n)
    
    ct_tall[is.na(ct_tall)] <- "Other"

    ct_tall$x_variable <- as.character(lapply((ct_tall$x_variable), replaceOther))
    ct_tall$y_variable <- as.character(lapply((ct_tall$y_variable), replaceOther))
    
    countsAndProportionsTable <- rbind(countsAndProportionsTable, ct_tall)
    
  }  
  
  
  return(countsAndProportionsTable)
  
}



BI.MultiGetPropCountMsMs <- function(DF, MS_PREFIXES) {
  countsAndProportionsTable <- data.frame( x_variable = character(),  y_variable = character(), x_value = integer(), y_value = factor(),total=integer(), perc = double())
  
  combolist <- c()
  
  
  for (p in MS_PREFIXES) {
    for (s in MS_PREFIXES) {
      
      if(s != p && !(paste0(s,p) %in% combolist)) {
        print(s)
        print(p)
        combolist[[length(combolist)+1]] <- paste0(s,p)
        combolist[[length(combolist)+2]] <- paste0(p,s)
        
        contingencySP <- BI.GetPropCountMsMs(DF, s, p)
        countsAndProportionsTable <- rbind(countsAndProportionsTable, contingencySP)
        
      }
    }
  }
  
  
  return(countsAndProportionsTable)
}

HeatMap.GetCountsAndProportionsSS <- function(DF, INPUTVARS) {
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
  
  
  univariateStats <- ddply(DF, .(m_name_business), function(d.sub) {
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