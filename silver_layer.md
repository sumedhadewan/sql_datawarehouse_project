# Silver layer
This layer  takes data from bronze layer and apply transformations such as  data cleaning, standarization and normalization processes to prepare data for analysis.

<b>Analyze source system </b> : Only data transformation takes place in silver layer. There is no data modelling so lets create 6 tables in silver layer similar to bronze layer.


<img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/data_flow_silver_layer.drawio.svg" width="450" />

```
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50)
);
```
[DDL script here](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/script/silver/ddl_silver.sql)

<b>Data transformation</b>:
First explore all the 6 tables in bronze layer and understand how tables are related to eachother. This stage cover data normalization & standarization, data cleansing such as 
- removing duplicates, unwanted trailing spaces.
- data filtering
- handling missing or invalid data or outliners
- data type casting
<img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/integration_model.drawio.svg"/>

[All scripts are saved in Stored Procedure](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/script/silver/proc_load_silver)
