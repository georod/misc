#======================================
# SAS to Postgres
#======================================

# Author: Peter R.
# Date: 2023-07-26

#------------------
# Load libraries
#------------------
library(DBI)
#library(RPostgres)
library(haven)



#------------------
# Set up file paths
#------------------

fpath10 <- "F:/my_documents/file1.sas7bdat"


#---------------------
# Read & Explore data
#---------------------

mds <- read_sas(fpath10)
dim(mds)
str(mds)
head(mds)
summary(mds)


#------------------
# Import data to PG
#------------------

readRenviron(".Renviron")

con_pg <- dbConnect(
  RPostgres::Postgres(),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD"),
  dbname = Sys.getenv("DB_DATABASE"),
  host = Sys.getenv("DB_HOST"),
  port = Sys.getenv("DB_PORT")
)


#-----------------------------
# Clean variables for Postgres
# sanitize variable names function

# make names db safe: no '.' or other illegal characters,
# all lower case and unique
dbSafeNames = function(names) {
  names = gsub('[^a-z0-9]+','_',tolower(names))
  names = make.names(names, unique=TRUE, allow_=TRUE)
  names = gsub('.','_',names, fixed=TRUE)
  names
}

colnames(mds) <- dbSafeNames(colnames(mds))

# PG object names
pgT1 <- "mds_all_v1"
pgSc1 <- "public"

# write table
dbWriteTable(con_pg, Id(schema=pgSc1, table=pgT1), mds, overwrite=T, append=F, row.names=FALSE)

#dbSendQuery(ALTER TABLE )
dbExecute(con_pg, paste0("ALTER TABLE ", pgT1," ADD CONSTRAINT ", pgT1,"_pkey ", "PRIMARY KEY (uniqno)" ) )
dbExecute(con_pg, paste0("COMMENT ON TABLE ", pgSc1, ".",pgT1, " IS 'UN deaths (2001-2014). This is a copy of file.sas7bdat. Data imported by PR on 2022-08-17. [MDS 2001-2014]'"))
dbExecute(con_pg, paste0("GRANT SELECT ON TABLE ", pgT1, " TO rduser_group, pwuser_group"))


# disconnect from the database
dbDisconnect(con_pg)
