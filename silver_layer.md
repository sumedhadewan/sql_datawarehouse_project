# Silver layer
This layer includes data cleaning, standarization and normalization processes to prepare data for analysis.

<b>Analyzing the source </b> : Only data transformation takes place in silver layer. There is data modelling so Lets create 6 tables in silver layer similar to bronze layer.


<img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/data_flow_silver_layer.drawio.svg" width="450" />

[DDL script here](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/script/silver/ddl_silver.sql)
```
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50)
);

```
<b>Data cleaning</b>:
First explore all the 6 tables in bronze layer and understand how tables are related to eachother. 
<img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/integration_model.drawio.svg"/>
