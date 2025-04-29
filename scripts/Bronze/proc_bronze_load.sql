/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE Bronze.load_bronze
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch DATETIME, @end_batch DATETIME;

    BEGIN TRY
        PRINT '-------------------------------';
        PRINT 'Loading Data in Bronze Layer';
        PRINT '-------------------------------';

        -- Start full batch timer
        SET @start_batch = GETDATE();

        -- CRM Tables
        PRINT 'Loading CRM Tables';
        PRINT '-------------------------------';

        -- Cust_Info
        PRINT 'Loading Cust_Info';
        SET @start_time = GETDATE();
        TRUNCATE TABLE Bronze.crm_cust_info;
        BULK INSERT Bronze.crm_cust_info
        FROM 'C:\Users\NAVIN\OneDrive\Desktop\SQL Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Data Inserted into Bronze.crm_cust_info';
        PRINT 'Loadtime: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';

        -- prd_Info
        PRINT 'Loading prd_Info';
        SET @start_time = GETDATE();
        TRUNCATE TABLE Bronze.crm_prd_info;
        BULK INSERT Bronze.crm_prd_info
        FROM 'C:\Users\NAVIN\OneDrive\Desktop\SQL Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Data Inserted into Bronze.crm_prd_info';
        PRINT 'Loadtime: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';

        -- Sales Details
        PRINT 'Loading Bronze.crm_sales_details';
        SET @start_time = GETDATE();
        TRUNCATE TABLE Bronze.crm_sales_details;
        BULK INSERT Bronze.crm_sales_details
        FROM 'C:\Users\NAVIN\OneDrive\Desktop\SQL Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Data Inserted into Bronze.crm_sales_details';
        PRINT 'Loadtime: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';

        -- ERP Tables
        PRINT 'Loading ERP Tables';
        PRINT '====================================';

        -- ERP Cust AZ12
        PRINT 'Loading Bronze.erp_cust_az12';
        SET @start_time = GETDATE();
        TRUNCATE TABLE Bronze.erp_cust_az12;
        BULK INSERT Bronze.erp_cust_az12
        FROM 'C:\Users\NAVIN\OneDrive\Desktop\SQL Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Data Inserted into Bronze.erp_cust_az12';
        PRINT 'Loadtime: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';

        -- ERP LOC A101
        PRINT 'Loading Bronze.erp_loc_a101';
        SET @start_time = GETDATE();
        TRUNCATE TABLE Bronze.erp_loc_a101;
        BULK INSERT Bronze.erp_loc_a101
        FROM 'C:\Users\NAVIN\OneDrive\Desktop\SQL Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Data Inserted into Bronze.erp_loc_a101';
        PRINT 'Loadtime: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';

        -- ERP PX CAT G1V2
        PRINT 'Loading Bronze.erp_px_cat_g1v2';
        SET @start_time = GETDATE();
        TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
        BULK INSERT Bronze.erp_px_cat_g1v2
        FROM 'C:\Users\NAVIN\OneDrive\Desktop\SQL Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Data Inserted into Bronze.erp_px_cat_g1v2';
        PRINT 'Loadtime: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';

        -- End full batch timer
        SET @end_batch = GETDATE();
        PRINT '--------------------------------------------';
        PRINT 'Total Load Time: ' + CAST(DATEDIFF(SECOND, @start_batch, @end_batch) AS VARCHAR) + ' seconds';
        PRINT '--------------------------------------------';

    END TRY
    BEGIN CATCH
        PRINT 'Error Occurred During Loading Bronze Layer';
        PRINT 'Error Message: ' + ERROR_MESSAGE();

        -- Capture end time even on failure
        SET @end_batch = GETDATE();
        PRINT 'Total Load Time (before failure): ' + CAST(DATEDIFF(SECOND, @start_batch, @end_batch) AS VARCHAR) + ' seconds';
    END CATCH;
END;
