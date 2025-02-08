## Bronze layer
It is a first layer and stores raw data as-is from sources. Data is ingested from CSV files into PostgreSQL database.

<b>Analyze source system</b> : As specified, focus is only the latest dataset. Historization is not required. There are 6 csv files coming from CRM and ERP systems. All csv files are fully loaded (no batch loading).

<b>Data ingestion</b>: Let's first explore the data in each csv files to identify column names and data types.
Next created database name sql_database using pgAdmin, 3 schemas followed by 6 tables under bronze schemas.

```
CREATE DATABASE sql_database
```
```
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
```
```
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50)
);

```

Using `TRUNCATE` and `COPY` command to perform bulk insert from csv files to database. This script is run on a daily basis to get a new content to data warehouse. so this is SQL code is saved as stored procedures in bronze layer.
```
TRUNCATE bronze.erp_cust_az12;

COPY bronze.erp_px_cat_g1v2(id, cat ,subcat,maintenance)
FROM '/Users/____/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
DELIMITER ','
CSV header;
```
Data quality check:
After bulk inserting, it is important to check that data has not shifted and is in the correct column.
```
SELECT count(*)
FROM bronze.erp_px_cat_g1v2;
```
```
SELECT *
FROM bronze.erp_px_cat_g1v2;
```

#### STORE PROCEDURE
1. Create a store procedure named bronze.load_bronze containing all scripts to bulk load the csv content to data warehouse.
2. Added `RAISE NOTICE` to track execution, debug issues and understand flow.
3. Catch errors using `EXCEPTION` and `WHEN others THEN` for easier debugging.
4. Track ETL duration by defining variables and assigning the start & end time using `CURRENT_TIMESTAMP` and calculating the difference in seconds.
