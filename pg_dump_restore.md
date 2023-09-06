# Backup and restore data with Postgres
### 2023-09-06
### Peter R.

## pg_dump
Backup data from a Postgres database using the command line
```
cd C:\Program Files\PostgreSQL\12\bin
```

```
pg_dump -h ipaddress -p 5432 -U peterr -d db1 -t schema.tab1 -Fc > "F:\my_documents\tab1.backup"
```

If you have the privileges, you can dump/restore the whole schema

```
pg_dump -h ipaddress -p 5432 -U peterr -d db1 -n schema1 -Fc > "F:\my_documents\tab1.backup"
```

## pg_restore
Restore objects from a Postgres database using the command line

```
pg_restore -h ipaddress -p 5432 -d db1 -U peterr "F:\my_documents\tab1.backup"
```
