# SQL data warehouse project


<b>Objective</b> of this project is divided into two parts:

1. Building data warehouse (Data engineering) : Developing modern data warehouse to consolidate sales data using PostgresSQL covering data architecture, designing ETL pipelines, data modeling.
2. Analytics & reporting (Releasing soon!): Creating SQL-based reports for actional insights with key business metrics, enabling stakeholder on strategic decision-making.
   - Customer behaviour
   - Product performance
   - Sales trend

Specifications:
+ Data sources: Import data from CSV source files(ERP and CRM).
+ Data quality: Cleanse and resolve data quality issues prior to analysis.
+ Integration: Combine both sources into a single, user friendly data model designed for analytical queries.
+ Scope: Focus on latest dataset only. Historization of data is not required.
+ Documentation: Provide clear documentation of data model to support analytics team.


# Data architecture
The data architecture for this project follows Medallion architecture (bronze, silver, gold layers).

![GitHub Logo](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/Data%20architecture.svg)

More details on data layers:
||Bronze layer|Silver layer|Gold layer|
|:----:|:----------:|:----------:|:--------:|
|Definition| Raw, unprocessed data as-is from sources| clearn & standarized data | Business ready data|
|Objective| Tracebility & debugging | Prepare data for analysis|Prepare data to be consumed for reporting & analytics|
|Object type|Tables|Tables|Views|
|Load method| Full load(Truncate &insert) | Full load | None|
|Data transformation| None | Data cleaning, standardization| normalization, derived columns, data enrichment | Data integration, aggregation, business logic & rules|
|Data modelling| None(as-is)|None (as-is)|Star schema, aggregated objects, flat tables|
|Target audience| Data engineers| Data analyst, engineers|Data analyst, business users|
|Script |[Bronze](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/bronze_layer.md)|[Silver](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/silver_layer.md) | [Gold](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/gold_layer.md)|

## Data catalog : 
An organised list of data assets found in final gold layer designed to help data professional to quickly find the most appropriate data for any analytical or business purpose. 
[Here](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/data_catalog.md)


