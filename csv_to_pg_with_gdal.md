# Import CSV to Postgres with GDAL's ogr2ogr
- Peter R., 2021-03-27

Let's assume you have a CSV file in utf8 format and you want to import it into Postgres. Run the following using the command line.

```
ogr2ogr -f PostgreSQL PG:"host=localhost user=postgres dbname=abc password=p123 port=5434" "F:\my_documents\data1.csv" -oo AUTODETECT_TYPE=YES -oo HEADERS=YES -nln data1 -lco FID=serial_id -lcp DESCRIPTION="This has clean data. Imported by Peter R. on 2021-07-12. [2021-07-12]"
```

### Notes
- Org2ogr will guess the data types
- If you do not assign a FID, ogr will automatically create one.
- The data types created may not be the optimal ones
