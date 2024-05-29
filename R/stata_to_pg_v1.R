#----------------------------------------------------------------------
# Stata to Postgres
#----------------------------------------------------------------------

# Author: Peter R.
# Date: 2023-05-23


# Load libraries
library(DBI)
#library(RPostgres)
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


# Load Stata files found in folder (4 data tables)
files1 <- list.files("F:/my_documents/state_datasets", full.names = T)

data1 <- read_dta(files1[4]) # read 4th file
dim(data1)


#----------------------------------------
# Clean variables for Postgres
# sanitize variable names function
#----------------------------------------

# make names db safe: no '.' or other illegal characters,
# all lower case and unique
dbSafeNames = function(names) {
  names = gsub('[^a-z0-9]+','_',tolower(names))
  names = make.names(names, unique=TRUE, allow_=TRUE)
  names = gsub('.','_',names, fixed=TRUE)
  names
}

colnames(data1) <- dbSafeNames(colnames(data1))

# PG object names
pgT1 <- "data1_v1"
pgSc1 <- "public"


dbWriteTable(con_pg,Id(schema='public', table='data1'), data1, overwrite=T, append=F, row.names=FALSE)

#dbSendQuery(ALTER TABLE )
dbExecute(con1, paste0("ALTER TABLE ", pgT1," ADD CONSTRAINT ", pgT1,"_pkey ", "PRIMARY KEY (serial_id)" ) )
dbExecute(con1, paste0("COMMENT ON TABLE ", pgSc1, ".",pgT1, " IS 'Data 1. Imported by PR on 2022-08-17. [NFHS; 2022-03-01]'"))
dbExecute(con1, paste0("GRANT SELECT ON TABLE ", pgT1, " TO rduser_group, pwuser_group"))


# disconnect from the database
dbDisconnect(con_pg)


