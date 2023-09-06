# Copy/import Json data to Postgres
- 2023-04-19

The following usually works in Linux but did not work in MobaXterm. The password prompt expires very quickly.
```
cat data1.json | psql -h ipaddress -p 5432 -d db1 -U peterr -W -c "COPY cvapp_sl (data) FROM STDIN;"
```

To get it to run in Windows use the following cmds. It should prompt for the password
```
cd "F:\my_documents\projects\abc_study\cghr_peter_work_from_home\cghr\covid19\data_sources\sierra_leone"

type coronavirus-app-sl-pr2.json | psql -h ipaddress -p 5432 -d db1 -U peterr -W -c "COPY cvapp_sl (data) FROM STDIN;"
```

### Notes
 - For the script to work, the json data needs to a single line file and is enclosed in square brackets [].  Line breaks will cause the execution to fail and missing [] will cause PG to import data as a different type of object which can't be parsed nicely. 
 - Make sure you have the write privileges
