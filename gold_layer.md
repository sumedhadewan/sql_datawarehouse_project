# Gold layer
This layer is where data modelling takes place where data from silver layer tables are modelled into star schema and making it business-ready for reporting and analytics.

<b>Analyzing :</b> This step is important as it gives a big picture on business object we are going to model. First Lets explore silver layer source system and identify business objects - Sales, Product , Customer. 
<img src="https://github.com/sumedhadewan/sql_datawarehouse_project/blob/main/docs/images/integration_model.drawio_final.svg">

<b>Data integration :</b> 
- Customer : Take `silver.crm_cust_info` and left join other two tables `silver.erp_cust_az12` and `silver.erp_loc_a101`
