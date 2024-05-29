#====================================
# Connecting R to Postgres
#====================================

# 2023-08-09
# Peter R.


#===============================
# Libraries
#===============================
library(DBI)
#install.packages("odbc") # This takes a while. Only needed for Method 2 below
library(odbc)


#-------------------------------------------------------------------------------
# Method 1
#Simple but unsafe way to connect to Postgres db as it exposes login details

con_pg <- dbConnect(RPostgres::Postgres(), host='', port=5432, dbname='', 
                                        user = "rp", password= "####")


#---------------------------------------------------------------------------------
# Method 2
#Better way to connect to Postgres db using DSN. You need to set up a DSN first.
# With Windows go to ODBC Data Source Administrator. Enter details including the DSN name used below

con_pg <- dbConnect(odbc::odbc(), "pg_pr")


#---------------------------------------------------------------------------------
# Method 3
# Connect to Postgres db using a password file (Password="####"; User = "rp")
# You need to create a password file first and save it in your user/home folder

passwordFile <- file.path(c(windows = Sys.getenv("USERPROFILE"),
                            unix = Sys.getenv("HOME"))[.Platform$OS.type], "pgPassword.R")
source(passwordFile)

# Connect to db
con_pg <- dbConnect(RPostgres::Postgres(), host='', port=5432, dbname='', 
                    user = User, password= Password)

#---------------------------------------------------------------------------------
# Method 4
# First create a .Renviron file and save it in you home directory. (My Documents when using Windows)
# You .Renviron file needs to have key-value pairs for each item below (e.g., DB_USER="rp", etc.). One per row.

readRenviron(".Renviron")

con_pg <- dbConnect(
  RPostgres::Postgres(),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD"),
  dbname = Sys.getenv("DB_DATABASE"),
  host = Sys.getenv("DB_HOST"),
  port = Sys.getenv("DB_PORT")
)



#----------------------------------------------------------------------------------
# Once connected you can then load data
data1 <- dbGetQuery(con_pg, "SELECT * FROM table_v1")
dim(data1)
str(data1)
head(data1)


#----------------------------------------------------------------------------------
# Close connection to db. Very good db practice
dbDisconnect(con_pg) 
