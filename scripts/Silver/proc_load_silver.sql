Create or ALTER   procedure [Silver].[load_silver] as
Begin
	-- ========================================
	-- Truncate and Load: silver.erp_px_cat_g1v2
	-- ========================================
	PRINT '>> Truncating silver.erp_px_cat_g1v2';
	TRUNCATE TABLE silver.erp_px_cat_g1v2;

	PRINT '>> Inserting into silver.erp_px_cat_g1v2';
	INSERT INTO silver.erp_px_cat_g1v2 (id, CAT, SUBCAT, MAINTENANCE)
	SELECT
		id,
		cat,
		subcat,
		maintenance
	FROM bronze.erp_px_cat_g1v2;

	-- ========================================
	-- Truncate and Load: silver.erp_cust_az12
	-- ========================================
	PRINT '>> Truncating silver.erp_cust_az12';
	TRUNCATE TABLE silver.erp_cust_az12;

	PRINT '>> Inserting into silver.erp_cust_az12';
	INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
	SELECT  
		CASE 
			WHEN cid LIKE 'Nas%' THEN SUBSTRING(cid, 4, LEN(cid))
			ELSE cid
		END,
		CASE 
			WHEN BDATE > GETDATE() THEN NULL
			ELSE BDATE
		END,
		CASE 
			WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			ELSE 'n/a'
		END
	FROM bronze.erp_cust_az12;

	-- ========================================
	-- Truncate and Load: silver.erp_loc_a101
	-- ========================================
	PRINT '>> Truncating silver.erp_loc_a101';
	TRUNCATE TABLE silver.erp_loc_a101;

	PRINT '>> Inserting into silver.erp_loc_a101';
	INSERT INTO silver.erp_loc_a101 (cid, cntry)
	SELECT 
		REPLACE(cid, '-', ''),
		CASE 
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
		END
	FROM bronze.erp_loc_a101;

	-- ========================================
	-- Truncate and Load: silver.crm_cust_info
	-- ========================================
	PRINT '>> Truncating silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;

	PRINT '>> Inserting into silver.crm_cust_info';
	INSERT INTO silver.crm_cust_info (
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
		TRIM(cst_firstname),
		TRIM(cst_lastname),
		CASE 
			WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			ELSE 'n/a'
		END,
		CASE 
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			ELSE 'n/a'
		END,
		cst_create_date
	FROM (
		SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
		FROM bronze.crm_cust_info
	) t
	WHERE flag_last = 1;

	-- ========================================
	-- Truncate and Load: silver.crm_sales_details
	-- ========================================
	PRINT '>> Truncating silver.crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;

	PRINT '>> Inserting into silver.crm_sales_details';
	INSERT INTO silver.crm_sales_details (
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
		CAST(sls_cust_id AS INT),
		CASE 
			WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
			ELSE CAST(sls_order_dt AS DATE)
		END,
		CASE 
			WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
			ELSE CAST(sls_ship_dt AS DATE)
		END,
		CASE 
			WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
			ELSE CAST(sls_due_dt AS DATE)
		END,
		CASE 
			WHEN TRY_CAST(sls_sales AS INT) IS NULL 
				OR TRY_CAST(sls_sales AS INT) <= 0 
				OR TRY_CAST(sls_sales AS INT) != TRY_CAST(sls_quantity AS INT) * ABS(TRY_CAST(sls_price AS INT))
			THEN TRY_CAST(sls_quantity AS INT) * ABS(TRY_CAST(sls_price AS INT))
			ELSE TRY_CAST(sls_sales AS INT)
		END,
		CAST(sls_quantity AS INT),
		CASE 
			WHEN TRY_CAST(sls_price AS INT) IS NULL 
				OR TRY_CAST(sls_price AS INT) <= 0
			THEN TRY_CAST(sls_sales AS INT) / NULLIF(TRY_CAST(sls_quantity AS INT), 0)
			ELSE TRY_CAST(sls_price AS INT)
		END
	FROM bronze.crm_sales_details;

	-- ========================================
	-- Truncate and Load: silver.crm_prd_info
	-- ========================================
	PRINT '>> Truncating silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;

	PRINT '>> Inserting into silver.crm_prd_info';
	INSERT INTO silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
		SUBSTRING(prd_key, 7, LEN(prd_key)),
		prd_nm,
		ISNULL(prd_cost, 0),
		CASE 
			WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
			WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
			WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
			WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
			ELSE 'n/a'
		END,
		prd_start_dt,
		DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
	FROM bronze.crm_prd_info;
