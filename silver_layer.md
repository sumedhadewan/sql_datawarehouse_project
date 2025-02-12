# Silver layer
This layer includes data cleaning, standarization and normalization processes to prepare data for analysis.

<b>Analyzing the source </b> : Lets explore all the 6 tables in bronze layer and understand how tables are related to eachother. 
<img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/integration_model.drawio.svg"/>

Next created 6 tables in silver layer similar to bronze layer

```
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50)
);

```
<b>Data cleaning</b>
