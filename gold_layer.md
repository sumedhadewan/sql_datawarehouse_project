# Gold layer
This layer is where data from silver layer tables transformed into dimension and fact tables and are modelled into star schema and making it business-ready for reporting and analytics.

<b>Analyzing :</b> This step is important as it gives a big picture on business object we are going to model. First Lets explore silver layer source system and identify business objects - Sales, Product , Customer. 
<img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/integration_model.drawio_final.svg">

<b>Data integration :</b> 
Building two dimension tables and one fact table as below.

- dim_customers : Take `silver.crm_cust_info` and LEFT JOIN other two tables `silver.erp_cust_az12` and `silver.erp_loc_a101` and save it as Views in gold layer as `gold.dim_customers`. Surrogate key `customer_key` is generated as a unique identifier to each customer record in this view.

  Note that master source of customer data is CRM. Example- gender column exists in both crm and erp tables.

- dim_products : `silver.crm_prd_info` and `silver.erp_px_cat_g1v2` are joined using LEFT JOIN and saved as views in gold layer as `gold.dim_products`. Surrogate key `product_key` is generated as unique identifier for each product record in this view.

- fact_sales : `silver.crm_sales_details` are joined with `gold.dim_customers` and `gold.dim_products`using LEFT JOIN to add surrogate keys `product_key` and `customer_key`. This is to connect tables in data model using surrogate keys.

<b>Data model</b>: in a star schema, the relationship between fact and dimension is 1-to-many (1:N)

  <img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/data_model.drawio.svg">

<b>Data flow :</b>

<img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/data_flow_gold_layer.drawio.svg">
