#=========================================
# Excel to Postgres 
#=========================================
# 2022-11-09
# Peter R.

# Note: this version does not provide good PG data types
# using DBI default data types


#===============================
# Directory set up
#===============================

path1 <- "F:/my_documents/projects/"


#===============================
# Libraries
#===============================

library("readxl")
#install.packages("openxlsx")
#library(openxlsx)

#install.packages("xlsx")
#library("xlsx")

library(DBI)

library(dplyr)

#install.packages("zoo")
library(zoo)


#-----------------------
# Read data
#-----------------------

fileL1 <- list.files(path1, pattern= ".xlsx", full.names=TRUE)

#file1 <- "DataMap Phase1.xlsx"

df1L1 <- list()

df1L1[[1]] <- read_excel(fileL1[1], sheet=3, col_names=TRUE) # One sheet only


#----------------------------------------------------
# A problem seems to be that read_excel and other readers read in the data from excel as numeric
# One solution is to cast the values as integer manually
#df1L2 <-  read_excel(fileL1[1], sheet=3, col_names=TRUE) #
#df1L2$survey_year <- as.integer(df1L2$survey_year)
#df1L2$age_cat <- as.integer(df1L2$age_cat)

# Ref
# https://stackoverflow.com/questions/3476782/check-if-the-number-is-integer
# test integer

# testInteger <- function(x){
#   test <- all.equal(x, as.integer(x), check.attributes = FALSE)
#   if(test == TRUE){ return(TRUE) }
#   else { return(FALSE) }
# }
#----------------------------------------------------


#----------------------------------------
# Clean variables for Postgres
# sanitize variable names function
#----------------------------------------
# Make names db safe: no '.' or other illegal characters,
# all lower case and unique
dbSafeNames = function(names) {
  names = gsub('[^a-z0-9]+','_',tolower(names))
  names = make.names(names, unique=TRUE, allow_=TRUE)
  names = gsub('.','_',names, fixed=TRUE)
  names
}


#-----------------------
# Connect to Postgres db 
#-----------------------

readRenviron(".Renviron")

con_pg <- dbConnect(
  RPostgres::Postgres(),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD"),
  dbname = Sys.getenv("DB_DATABASE"),
  host = Sys.getenv("DB_HOST"),
  port = Sys.getenv("DB_PORT")
)


#-----------------------
# Write tables in a loop
#-----------------------

for (i in 1:length(df1L1)) {
  
  # SQL-standardize field names  
  colnames(df1L1[[i]]) = dbSafeNames(colnames(df1L1[[i]]))
  
  # Add serial id, unique row identifier
  df1L1[[i]]$sid <- 1:nrow(df1L1[[i]])
  
  # Note: data types could be better. I created the PG object first
  dbWriteTable(con_pg, name=c('public', pg_tabs[i]), value=df1L1[[i]], append=TRUE, overwrite=FALSE, row.names=F)
  
  # add primary key
  #dbExecute(con_pg, paste0("ALTER TABLE ", pg_tabs[i]," ADD CONSTRAINT ", pg_tabs[i],"_pkey ", "PRIMARY KEY (sid)" ) )
  
  # create time stamp
  createDate <-Sys.Date()
  
  # Table comments
  dbExecute(con_pg,  paste0('COMMENT ON TABLE ' , pg_tabs[i], ' IS ', '\'', 'Data from 2001 to 2018. Data imported by PR on ', createDate,'. [UN; 2022-10-26]', '\'', ';') )
  
}


# disconnect from the database
dbDisconnect(con_pg)


# Reference
# https://readxl.tidyverse.org/

