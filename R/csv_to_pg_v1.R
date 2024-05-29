#============================================
# CSV to Postgres
#============================================
# 2022-08-17
# Peter R.


#---------------------------------
# Libraries
#---------------------------------
# Load libraries
library(DBI)
library(dplyr)
library(reshape2)
library(RPostgres)


#---------------------------------
# Directory set up
#---------------------------------

path1 <- "F:/my_documents/projects/data/"

#fileL1 <- list.files(path1, pattern= ".xlsx", full.names=TRUE)

file1 <- "Districts.csv"


#---------------------------------
# Load data
#---------------------------------
# Test to make sure the CSV loads correctly
data1 <- read.csv(paste0(path1,file1))


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


# PG object names
pgT1 <- "data1_v1"
pgSc1 <- "public"


dbWriteTable(con1,Id(schema=pgSc1, table=pgT1), d2, overwrite=T, append=F, row.names=FALSE)
#dbSendQuery(ALTER TABLE )
dbExecute(con1, paste0("ALTER TABLE ", pgT1," ADD CONSTRAINT ", pgT1,"_pkey ", "PRIMARY KEY (serial_id)" ) )
dbExecute(con1, paste0("COMMENT ON TABLE ", pgSc1, ".",pgT1, " IS 'District 2019-2021. Imported by PR on 2022-08-17. [NFHS; 2022-03-01]'"))
dbExecute(con1, paste0("GRANT SELECT ON TABLE ", pgT1, " TO rduser_group, pwuser_group"))

# disconnect from the database
dbDisconnect(con1)
