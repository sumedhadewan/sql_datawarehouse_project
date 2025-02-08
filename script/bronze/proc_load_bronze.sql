/*
---------------------------------------------------------------------
Store procedure in bronze layer

Name: load_bronze

Parameters: None

Purpose: This store procedure bulk load content from csv files into tables in bronze schema.

Execute this procedure:
  CALL bronze.load_bronze()
_________________________________________________________________________________
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze ()
LANGUAGE plpgsql
AS $$

  DECLARE 
  	start_time DATE; 
  	end_time DATE;
  	load_duration INTERVAL;
  	batch_start_time DATE;
  	batch_end_time DATE;
  	batch_load_duration INTERVAL;
  BEGIN
  	RAISE NOTICE '======================';
  	RAISE NOTICE 'Loading bronze layer';
  	RAISE NOTICE '======================';
  
  	RAISE NOTICE '+++++++++++++++++++++++';
  	RAISE NOTICE 'Loading CRM tables';
  	RAISE NOTICE '+++++++++++++++++++++++';
  	
  	batch_start_time := CURRENT_TIMESTAMP;
  	
  	start_time:= CURRENT_TIMESTAMP;
  	RAISE NOTICE 'Truncating table: bronze.crm_cust_info';
  	TRUNCATE bronze.crm_cust_info;
  	
  	RAISE NOTICE 'Inserting data into: bronze.crm_cust_info';
  	COPY bronze.crm_cust_info(cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status, cst_gndr,cst_create_date)
  	FROM '/Users/sumedhadewan/Downloads/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
  	DELIMITER ','
  	CSV header;
  	end_time := CURRENT_TIMESTAMP;
  	load_duration := end_time - start_time;
  	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
  
  	start_time:= CURRENT_TIMESTAMP;
  	RAISE NOTICE 'Truncating table: bronze.crm_prd_info';
  	TRUNCATE bronze.crm_prd_info;
  	
  	RAISE NOTICE 'Inserting data into: bronze.crm_prd_info';
  	COPY bronze.crm_prd_info(prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
  	FROM '/Users/sumedhadewan/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
  	DELIMITER ','
  	CSV header;
  	end_time := CURRENT_TIMESTAMP;
  	load_duration := end_time - start_time;
  	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
  	
  	start_time:= CURRENT_TIMESTAMP;
  	RAISE NOTICE 'Truncating table: bronze.crm_sales_details';
  	TRUNCATE bronze.crm_sales_details;
  	
  	RAISE NOTICE 'Inserting data into: bronze.crm_sales_details';
  	COPY bronze.crm_sales_details(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
  	FROM  '/Users/sumedhadewan/Downloads/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
  	DELIMITER  ','
  	CSV header;
  	end_time := CURRENT_TIMESTAMP;
  	load_duration := end_time - start_time;
  	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
  
  	RAISE NOTICE '+++++++++++++++++++++++';
  	RAISE NOTICE 'Loading ERP tables';
  	RAISE NOTICE '+++++++++++++++++++++++';
  
  	start_time:= CURRENT_TIMESTAMP;
  	RAISE NOTICE 'Truncating table: bronze.erp_cust_az12';
  	TRUNCATE bronze.erp_cust_az12;
  	
  	RAISE NOTICE 'Inserting data into: bronze.erp_cust_az12';
  	COPY bronze.erp_cust_az12(cid,bdate,gen)
  	FROM '/Users/sumedhadewan/Downloads/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
  	DELIMITER  ','
  	CSV header;
  	end_time := CURRENT_TIMESTAMP;
  	load_duration := end_time - start_time;
  	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
  
  	start_time:= CURRENT_TIMESTAMP;
  	RAISE NOTICE 'Truncating table: bronze.erp_loc_a101';
  	TRUNCATE bronze.erp_loc_a101;
  	
  	RAISE NOTICE 'Inserting data into: bronze.erp_loc_a101';
  	COPY bronze.erp_loc_a101(cid,cntry)
  	FROM '/Users/sumedhadewan/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
  	DELIMITER ','
  	CSV header;
  	end_time := CURRENT_TIMESTAMP;
  	load_duration := end_time - start_time;
  	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
  
  	start_time:= CURRENT_TIMESTAMP;
  	RAISE NOTICE 'Truncating table: bronze.erp_px_cat_g1v2';
  	TRUNCATE bronze.erp_px_cat_g1v2;
  	
  	RAISE NOTICE 'Inserting data into: bronze.erp_px_cat_g1v2';
  	COPY bronze.erp_px_cat_g1v2(id, cat ,subcat,maintenance)
  	FROM '/Users/sumedhadewan/Downloads/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
  	DELIMITER ','
  	CSV header;
  	end_time := CURRENT_TIMESTAMP;
  	load_duration := end_time - start_time;
  	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
  	
  	batch_end_time := CURRENT_TIMESTAMP;
  	batch_load_duration = batch_end_time - batch_start_time;
  	RAISE NOTICE 'Loading bronze layer is completed.';
  	RAISE NOTICE '>> Batch load duration : % seconds', EXTRACT(EPOCH FROM batch_load_duration);
  	
  	EXCEPTION
    	WHEN others THEN
  		  RAISE NOTICE 'Error occured :% ',SQLERRM;

END
$$;

