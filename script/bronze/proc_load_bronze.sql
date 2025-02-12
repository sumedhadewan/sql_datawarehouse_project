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
	
	batch_start_time = CURRENT_TIMESTAMP;
	start_time := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Truncating table: silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;
	RAISE NOTICE 'Inserting data into: silver.crm_cust_info';
	INSERT INTO silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
	)
	SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) cst_firstname,
		TRIM(cst_lastname) cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		ELSE 'n/a' END AS cst_marital_status, -- Normalize marital status to readable format
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'n/a' END AS cst_gndr, -- Normalize gender to readable format
		cst_create_date
	FROM
	(
		SELECT 
			*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS latest_flag
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
	 ) AS sub -- Select the latest record for each customer
	 WHERE latest_flag = 1;
	 end_time := CURRENT_TIMESTAMP;
	 load_duration := end_time - start_time;
	 RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);

	start_time:=CURRENT_TIMESTAMP;
	RAISE NOTICE 'Truncating table: silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;
	RAISE NOTICE 'Inserting data into: silver.crm_prd_info';
	INSERT INTO silver.crm_prd_info(
		prd_id,
		prd_key,
		cat_id,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT 
		prd_id,
		SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
		REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
		prd_nm,
		COALESCE(prd_cost,0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'  -- Map productive line codes to descriptive values
		END AS prd_line,
		CAST(prd_start_dt AS DATE) AS prd_start_dt,
		CAST(LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 AS DATE)as prd_end_dt	-- Calculate end date as one day before the next start date
	FROM bronze.crm_prd_info;
	end_time := CURRENT_TIMESTAMP;
	load_duration := end_time - start_time;
	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);

	start_time :=CURRENT_TIMESTAMP;
	RAISE NOTICE 'Truncating table: crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;
	RAISE NOTICE 'Inserting data into: crm_sales_details';
	INSERT INTO silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)
	SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN (sls_order_dt <=0) OR (length(cast(sls_order_dt as text)) != 8) THEN NULL
			ELSE TO_DATE(CAST(sls_order_dt AS TEXT),'YYYYMMDD') 
		END AS sls_order_dt,
		CASE WHEN (sls_ship_dt <=0) OR (length(cast(sls_ship_dt as text)) != 8) THEN NULL
			ELSE TO_DATE(CAST(sls_ship_dt AS TEXT),'YYYYMMDD') 
		END AS sls_ship_dt,
		CASE WHEN (sls_ship_dt <=0) OR (length(cast(sls_ship_dt as text)) != 8) THEN NULL
			ELSE TO_DATE(CAST(sls_ship_dt AS TEXT),'YYYYMMDD') 
		END AS sls_due_dt,
		CASE WHEN sls_sales <=0 OR sls_sales is null OR sls_sales != sls_quantity * ABS(sls_price) 
			THEN sls_quantity *sls_price 
			ELSE sls_sales 
		END AS sls_sales, -- Recalculate sales if original value is missing or incorrect
		CASE WHEN sls_quantity <=0 OR sls_quantity IS NULL 
			THEN sls_sales/sls_price 
			ELSE sls_quantity 
		END AS sls_quantity,
		CASE WHEN sls_price <= 0 or sls_price IS NULL 
			THEN sls_sales/NULLIF(sls_quantity,0) 
			ELSE sls_price -- Derive price if original value is invalid
		END AS sls_price
	FROM bronze.crm_sales_details;
	end_time:= CURRENT_TIMESTAMP;
	load_duration := end_time - start_time;
	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
	
	
	start_time := CURRENT_TIMESTAMP;
	RAISE NOTICE '+++++++++++++++++++++++';
  	RAISE NOTICE 'Loading ERP tables';
  	RAISE NOTICE '+++++++++++++++++++++++';

	RAISE NOTICE 'Truncating table: silver.erp_cust_az12';
	TRUNCATE TABLE silver.erp_cust_az12;
	RAISE NOTICE 'Inserting data into: silver.erp_cust_az12';
	INSERT INTO silver.erp_cust_az12(
		cid,
		bdate,
		gen
	)
	
	SELECT
		CASE 
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid)) 
			ELSE cid END as cid, --Removing prefix 'NAS'
		CASE WHEN bdate > current_timestamp THEN NULL
			ELSE bdate END AS bdate, -- check future birthdates
		CASE 
			WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
			ELSE 'n/a' END AS gen
	FROM bronze.erp_cust_az12;
	end_time := CURRENT_TIMESTAMP;
	load_duration := end_time - start_time;
	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);

	start_time:= CURRENT_TIMESTAMP;
	RAISE NOTICE 'Truncating table: silver.erp_loc_a101';
	TRUNCATE TABLE silver.erp_loc_a101;
	RAISE NOTICE 'Inserting data into: silver.erp_loc_a101';
	INSERT INTO silver.erp_loc_a101(
		cid,
		cntry
	)
	SELECT 
		REPLACE(cid,'-','') AS cid,
		CASE 
		WHEN UPPER(TRIM(cntry)) IN ('US','USA') THEN 'United States'
		WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry) END AS cntry -- Normalize and Handle missing or blank country codes
	FROM bronze.erp_loc_a101;
	end_time := CURRENT_TIMESTAMP;
	load_duration := end_time - start_time;
	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
	
	start_time :=CURRENT_TIMESTAMP;
	RAISE NOTICE 'Truncating table: silver.erp_px_cat_g1v2';
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	RAISE NOTICE 'Inserting data into: silver.erp_px_cat_g1v2';
	INSERT INTO silver.erp_px_cat_g1v2
	(
		id,
		cat,
		subcat,
		maintenance
	)
	SELECT 
		id,
		cat,
		subcat,
		maintenance
	FROM bronze.erp_px_cat_g1v2;
	end_time := CURRENT_TIMESTAMP;
	load_duration := end_time - start_time;
	RAISE NOTICE '>>Load duration: % seconds',EXTRACT(EPOCH FROM load_duration);
	
	batch_end_time:= CURRENT_TIMESTAMP;
	batch_load_duration := batch_end_time - batch_start_time;
	RAISE NOTICE '>> Batch load duration:% seconds',EXTRACT(EPOCH FROM batch_load_duration);

END;
$$;

