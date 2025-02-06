# SQL data warehouse project


Objective of this project is divided into two parts:

1. Building data warehouse (Data engineering) : Developing modern data warehouse to consolidate sales data using PostgresSQL covering data architecture, designing ETL pipelines, data modeling.
2. Analytics & reporting: Creating SQL-based reports for actional insights with key business metrics, enabling stakeholder on strategic decision-making.
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

![GitHub Logo](https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/Untitled%20Diagram.drawio(2).svg)




