#----------------------------------------------------------------------
# Postgres to Stata
#----------------------------------------------------------------------

# Author: Peter R.
# Date: 2022-09-21

# Load libraries
library(DBI)
library(RPostgres)
library(haven)
#install.packages("svDialogs")
library(svDialogs)

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
# Load/read SFMS survey data. 
# Do one at at time
data1 <- dbReadTable(con_pg, "table1")


# data frame dimensions
dim(d1)
#str(d1)

# path & file name to write Stata file
path1 <- "F:/my_documents/projects/data/table1.dta"

# write Stata file
write_dta(
  data1,
  path1,
  version = 14,
  label = attr(d1, "label") #,
  #strl_threshold = 2045
)



# disconnect from the database
dbDisconnect(con_pg)


